/* Super em Ação — Service Worker (network-first)
 * Objetivo: as supervisoras SEMPRE recebem a versão nova quando estão online,
 * sem precisar limpar cache. O cache serve só como reserva para offline.
 *
 * Como funciona:
 *  - Navegações e arquivos do próprio site: tenta a REDE primeiro; se cair,
 *    usa o que estiver guardado (offline).
 *  - Chamadas externas (Supabase, fontes, CDNs): passam direto, sem cache.
 *
 * Ao publicar uma mudança grande, basta subir o número do CACHE abaixo
 * (ex.: v3) para limpar a reserva offline antiga. Como é network-first,
 * quem está online já pega o novo mesmo sem bumpar.
 */
const CACHE = 'super-em-acao-v3';

// Arquivos essenciais para o app abrir offline (best-effort).
const CORE = [
  './',
  'index.html',
  'app.html',
  'coordenador.html',
  'css/style.css',
  'js/supabase.js',
  'img/sfera-logo.png',
  'img/mascote-sfera.png',
  'manifest.json'
];

self.addEventListener('install', (event) => {
  self.skipWaiting(); // nova versão assume o controle o quanto antes
  event.waitUntil(
    caches.open(CACHE).then((c) => Promise.allSettled(CORE.map((u) => c.add(u))))
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('fetch', (event) => {
  const req = event.request;

  // Só cuidamos de GET do próprio site. Resto (POST, Supabase, fontes, CDN) passa direto.
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;

  // Páginas (HTML): busca SEMPRE fresco da rede (sem cache HTTP), p/ garantir a versão nova.
  const isDoc = req.mode === 'navigate' || (req.headers.get('accept') || '').includes('text/html');
  const netReq = isDoc ? new Request(req.url, { cache: 'no-store' }) : req;

  // NETWORK-FIRST: tenta a rede; atualiza o cache; se falhar, usa o cache.
  event.respondWith(
    fetch(netReq)
      .then((res) => {
        if (res && res.ok) {
          const copy = res.clone();
          caches.open(CACHE).then((c) => c.put(req, copy)).catch(() => {});
        }
        return res;
      })
      .catch(() =>
        caches.match(req).then((hit) => hit || caches.match('index.html'))
      )
  );
});
