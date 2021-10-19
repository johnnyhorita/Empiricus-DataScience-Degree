-- 1. Obtenha uma tabela que contenha o id do pedido e o valor total do mesmo.
SELECT order_id, SUM(unit_price  * quantity - discount) as total
FROM order_details
GROUP BY order_id

-- 2. Obtenha uma lista dos 10 clientes que realizaram o maior número de pedidos, bem como o número de pedidos de cada, ordenados em ordem decrescente de nº de pedidos.
SELECT customer_id, COUNT(*) as ct_orders
FROM orders
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 10

-- 3. Obtenha uma tabela que contenha o id e o valor total do pedido e o nome do cliente que o realizou.
SELECT order_id, details.total, customers.contact_name
FROM orders
INNER JOIN (
    SELECT order_id, SUM(unit_price  * quantity - discount) as total
    FROM order_details
    GROUP BY order_id
) AS details
ON details.order_id = orders.order_id
INNER JOIN customers ON customers.customer_id = orders.customer_id

-- 4. Obtenha uma tabela que contenha o país do cliente e o valor da compra que ele realizou.
SELECT customers.country, details.total
FROM orders
INNER JOIN (
    SELECT order_id, SUM(unit_price  * quantity - discount) as total
    FROM order_details
    GROUP BY order_id
) AS details
ON details.order_id = orders.order_id
INNER JOIN customers ON customers.customer_id = orders.customer_id

-- 5. Obtenha uma tabela que contenha uma lista dos países dos clientes e o valor total de compras realizadas em cada um dos países. Ordene a tabela, na order descrescente, considerando o valor total de compras realizadas por país.
SELECT customers.country, SUM(details.total) as total
FROM orders
INNER JOIN (
    SELECT order_id, SUM(unit_price  * quantity - discount) as total
    FROM order_details
    GROUP BY order_id
) AS details
ON details.order_id = orders.order_id
INNER JOIN customers ON customers.customer_id = orders.customer_id
GROUP BY 1
ORDER BY 2 DESC

-- 6. Obtenha uma tabela com o valor médio das vendas em cada mês (ordenados do mês com mais vendas para o mês com menos vendas).
SELECT
    DATE_TRUNC('MONTH', order_date), AVG(details.total) AS average
FROM orders
INNER JOIN (
    SELECT order_id, SUM(unit_price  * quantity - discount) as total
    FROM order_details
    GROUP BY order_id
) AS details
ON details.order_id = orders.order_id
GROUP BY 1
ORDER BY COUNT(*) DESC