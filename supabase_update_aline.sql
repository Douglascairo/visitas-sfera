-- ============================================
-- VISITAS SFERA - Troca de supervisora (Patricia -> Aline)
-- Cole no SQL Editor do Supabase e clique Run
-- ============================================
-- Contexto: Patricia Baleixo saiu em 22/10/2026 (foi para a Hering).
-- Aline Campos assumiu a mesma regional (todas as lojas da Patricia).

-- 1) Cadastra a Aline Campos (email em MINÚSCULAS para o login funcionar)
INSERT INTO supervisoras (nome, nome_curto, email, ativo)
VALUES ('Aline Campos', 'ALINE', 'aline.campos@franquiasboticario.com', true)
ON CONFLICT (email) DO NOTHING;

-- 2) Transfere TODAS as lojas da Patricia para a Aline
UPDATE lojas
SET supervisora_id = (SELECT id FROM supervisoras WHERE nome_curto = 'ALINE')
WHERE supervisora_id = (SELECT id FROM supervisoras WHERE nome_curto = 'PATRICIA');

-- 3) Desativa a Patricia (sai dos filtros e relatórios; histórico dela é preservado)
UPDATE supervisoras SET ativo = false WHERE nome_curto = 'PATRICIA';

-- ============================================
-- Conferência (opcional): Aline ativa com as lojas; Patricia inativa com 0 lojas
-- ============================================
SELECT s.nome, s.nome_curto, s.ativo, COUNT(l.id) AS qtd_lojas
FROM supervisoras s
LEFT JOIN lojas l ON l.supervisora_id = s.id
WHERE s.nome_curto IN ('ALINE', 'PATRICIA')
GROUP BY s.nome, s.nome_curto, s.ativo
ORDER BY s.nome_curto;
