--Na tabela Customers:
--1) Gere uma relação com os nomes dos clientes, suas cidades e países, em ordem alfabética de nome.
SELECT contact_name, city, country FROM customers ORDER BY contact_name ASC;

--2) Na relação do item (1), filtre pelos clientes da Alemanha, da França e da Espanha, excluindo-se os clientes que vivem nas capitais destes países.
SELECT contact_name, city, country FROM customers
WHERE
	country IN ('Germany', 'France', 'Spain') AND
	city NOT IN ('Berlin', 'Paris', 'Madrid')
ORDER BY contact_name ASC;

--Na tabela Products:
--1) Quantos são os produtos que são da CategoryID 2?
SELECT COUNT(product_id) FROM products WHERE category_id = 2

--2) Quantos produtos com SupplierID idêntico ao CategoryID e que custam mais do que 10?
SELECT COUNT(*)
FROM products
WHERE supplier_id = category_id AND unit_price > 10

--3) Liste todos os nomes de produtos, suas *"Units"* e seus respectivos preços distintos que pertecem às categorias 1, 2 e 7.
SELECT product_name, unit_price, units_in_stock, units_on_order FROM products WHERE category_id IN (1,2,7)

--4) Liste os 5 primeiros nomes de produtos que começam com "A" ou tenham "h" no meio do nome. Retorne em português os nomes das colunas.
SELECT 	
	product_id AS "produto_id",
	product_name AS "produto_nome",
	supplier_id AS "fornecedor_id",
	category_id AS "categoria_id",
	quantity_per_unit AS "quantidade_por_unidade",
	unit_price AS "unidade_preço",
	units_in_stock AS "unidades_em_estoque",
	units_on_order AS "unidades_na_ordem",
	reorder_level AS "nível_de_ordenacao",
	discontinued AS "descontinuado"
FROM products
WHERE product_name LIKE 'A%' OR product_name LIKE '%h%'
ORDER BY 1
LIMIT 5

--5) Dê a média de preços de todos os produtos das categorias entre 1 e 5. Arredonde para 1 casa decimal.
SELECT CAST(AVG(unit_price) AS DECIMAL(10, 1)) FROM products WHERE category_id BETWEEN 1 AND 5

--6) Liste a média de preços e a quantidade de produtos distintos por SupplierID; ordene pela média de preço, do maior para o menor, e só mostre os 5 primeiros.
SELECT supplier_id, COUNT(*), AVG(unit_price)
FROM products
GROUP BY supplier_id
ORDER BY 3 desc
LIMIT 5

--Na tabela Orders:
--1) Liste o top 3 de funcionários com mais vendas no primeiro trimestre de 1996.
SELECT o.employee_id, e.first_name || ' ' || e.last_name AS "employee_name", COUNT(o.order_id) AS "ct_order"
FROM orders o 
INNER JOIN employees e 
ON e.employee_id = o.employee_id 
WHERE o.order_date BETWEEN '1996-01-01' AND '1996-03-31'
GROUP BY 1, 2
ORDER BY 3 desc
LIMIT 3

--2) Liste os clientes com mais pedidos - mas somente aqueles que tiverem a partir de 2 pedidos. Corte explicitamente os clientes que compraram de funcionários sem ID.
SELECT customer_id, COUNT(order_id)
FROM orders
WHERE employee_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(order_id) >= 2
ORDER BY 2 desc

--Na tabela de Suppliers:
--1) Conte todos os diferentes fornecedores por país. Agrupe categorizando os países em 'Americas' (se o país for USA, Brazil ou Canada) e 'Outros' senão. Detalhe, estamos buscando aqueles cujo DDD não comece com o dígito 1.
SELECT 
	CASE 
		WHEN country IN ('USA', 'Brazil', 'Canada') THEN 'Americas' 
		ELSE 'Outros' 
	END AS "Americas", 
	COUNT(supplier_id) AS "ct_supplier" 
FROM suppliers 
WHERE phone NOT LIKE '(1%'
GROUP BY 1

--2) Existe alguma cidade com mais de um código de área de telefone?
SELECT city, regexp_matches(phone, E'\\(([0-9]+)', 'g'), COUNT(*)
FROM suppliers
GROUP BY 1, 2
HAVING COUNT(*) > 1
ORDER BY 1

--3) Tome a primeira letra de cada cidade (ex. "N" para "New Orleans"). Quais são AS 5 iniciais de nomes de cidades que têm mais fornecedores associados (em ordem descrescente de fornecedores/cidade)?
-- Este SELECT não representa a quantidade de fornecedores por cidade
SELECT UPER(LEFT(city, 1)) AS "first_letter_city", COUNT(*)
FROM suppliers 
GROUP BY 1
ORDER BY 2 desc
