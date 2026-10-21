-- ============================================
-- VISITAS SFERA - Remanejamento regional
-- Cole no SQL Editor do Supabase e clique Run
-- ============================================
-- As lojas de Três Rios (GALERIA 21484 e QUIOSQUE 3 RIOS 21486)
-- passam da supervisão da CANTIERI para a MAFORTES.

UPDATE lojas
SET supervisora_id = (SELECT id FROM supervisoras WHERE nome_curto = 'MAFORTES')
WHERE codigo IN ('21484', '21486');

-- Conferência (opcional): deve mostrar as 2 lojas agora sob Juliana Mafortes
SELECT l.codigo, l.nome, l.cidade, s.nome AS supervisora
FROM lojas l
JOIN supervisoras s ON s.id = l.supervisora_id
WHERE l.codigo IN ('21484', '21486');
