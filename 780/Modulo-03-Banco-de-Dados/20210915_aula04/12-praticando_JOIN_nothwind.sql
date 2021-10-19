
--Obtenha uma tabela que contenha o id do pedido e o valor total do mesmo.
select order_id, cast(sum(unit_price) as decimal(10,2))
from order_details
group by order_id
order by 2 desc

--Obtenha uma lista dos 10 clientes que realizaram o maior número de pedidos, 
--bem como o número de pedidos de cada, ordenados em ordem decrescente de nº de pedidos.
select customer_id, count(order_id) from orders group by customer_id order by 2 desc limit 10


--Obtenha uma tabela que contenha o id e o valor total do pedido e o nome do cliente que o realizou.
select o.order_id, sum(d.unit_price) as "vl_order", c.company_name, c.contact_name
from 		orders o
inner join 	order_details d
		on 	d.order_id = o.order_id
inner join  products p
		on p.product_id = d.product_id
inner join 	customers c 
		on c.customer_id = o.customer_id
group by o.order_id, c.company_name, c.contact_name
order by o.order_id

-- Obtenha uma tabela que contenha o país do cliente e o valor da compra que ele realizou.
select 	--o.order_id, 
		cast(sum(d.unit_price) as decimal(10,2)) as "vl_order", c.company_name, c.contact_name, c.country
from 		orders o
inner join 	order_details d
		on 	d.order_id = o.order_id
inner join  products p
		on p.product_id = d.product_id
inner join 	customers c 
		on c.customer_id = o.customer_id
group by --o.order_id, 
		c.company_name, c.contact_name, c.country
order by c.contact_name --, o.order_id

-- Obtenha uma tabela que contenha uma lista dos países dos clientes e o valor total de compras realizadas em cada um dos países. 
--Ordene a tabela, na order descrescente, considerando o valor total de compras realizadas por país.
select cast(sum(d.unit_price) as decimal(10,2)) as "vl_order", c.country
from 		orders o
inner join 	order_details d
		on 	d.order_id = o.order_id
inner join  products p
		on p.product_id = d.product_id
inner join 	customers c 
		on c.customer_id = o.customer_id
group by c.country
order by vl_order desc

--Obtenha uma tabela com o valor médio das vendas em cada mês (ordenados do mês com mais vendas para o mês com menos vendas).
select TO_CHAR(o.order_date, 'month') AS "month_order", cast(avg(d.unit_price) as decimal(10,2)) as "avg_price" --, c.country
from 		orders o
inner join 	order_details d
		on 	d.order_id = o.order_id
inner join  products p
		on p.product_id = d.product_id
inner join 	customers c 
		on c.customer_id = o.customer_id
group by month_order
order by avg_price desc



SELECT 
	DATE_PART('month', orders.order_date) AS mes,
	SUM(order_details.unit_price * order_details.quantity) / COUNT(DISTINCT orders.order_id) AS media_receita
FROM
	order_details INNER JOIN orders
		ON orders.order_id = order_details.order_id
GROUP BY mes
ORDER BY media_receita DESC
;

SELECT
	o.order_id,
	DATE_PART('month', o.order_date) AS "mes",
	SUM(d.unit_price * d.quantity) AS "receita"
FROM
	order_details d
	INNER JOIN orders o
		ON o.order_id = d.order_id
GROUP BY o.order_id, mes


-- common table expression
with tb (order_id, mes_to_char, mes_date_part, receita) as
(
SELECT
	o.order_id,
	TO_CHAR(o.order_date, 'month')  AS "mes_to_char",
	DATE_PART('month', o.order_date) AS "mes_date_part",
	SUM(d.unit_price * d.quantity) AS "receita"
FROM
	order_details d
	INNER JOIN orders o
		ON o.order_id = d.order_id
GROUP BY o.order_id, mes_to_char, mes_date_part
)
select 	mes_date_part, 
		mes_to_char, 
		TO_CHAR(('2000-' || mes_date_part || '-01')::date, 'Month') AS nome_mes,  
		avg(receita) as "receita", 
		cast(avg(receita) as decimal(10,2)) as "receita_decimal"
from tb
group by mes_date_part, mes_to_char
order by 2 desc






SELECT
    mes,
    TO_CHAR(('2000-' || mes || '-01')::date, 'Month') AS nome_mes,
    AVG(receita)
FROM (
    SELECT
        orders.order_id,
        DATE_PART('month', orders.order_date) as mes,
        sum(order_details.unit_price * order_details.quantity) as receita
    FROM order_details
    LEFT JOIN orders ON orders.order_id = order_details.order_id
    group by
        orders.order_id,
        orders.order_date
) t
GROUP BY mes
ORDER BY 1



