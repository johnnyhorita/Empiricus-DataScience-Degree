--Na tabela Customers:
--1) Gere uma relação com os nomes dos clientes, suas cidades e países, em ordem alfabética de nome.
select contact_name, city, country from customers order by contact_name asc;

--Na tabela Products:
--1) Quantos são os produtos que são da CategoryID 2?
select count(product_id) AS "ct_product" from products where category_id = 2

--2) Quantos produtos com SupplierID idêntico ao CategoryID e que custam mais do que 10?
select supplier_id, category_id, count(*) AS "ct_product" from products where unit_price > 10 group by supplier_id, category_id order by 1

--3) Liste todos os nomes de produtos, suas *"Units"* e seus respectivos preços distintos que pertecem às categorias 1, 2 e 7.
select product_name, unit_price, units_in_stock, units_on_order from products where category_id in (1,2,7)

--4) Liste os 5 primeiros nomes de produtos que começam com "A" ou tenham "h" no meio do nome. Retorne em português os nomes das colunas.
select 	product_id as "produto_id",
		product_name as "produto_nome",
		supplier_id as "fornecedor_id",
		category_id as "categoria_id",
		quantity_per_unit as "quantidade_por_unidade",
		unit_price as "unidade_preço",
		units_in_stock as "unidades_em_estoque",
		units_on_order as "unidades_na_ordem",
		reorder_level as "nível_de_ordenacao",
		discontinued as "descontinuado"
from products where product_name like 'a%' or product_name like '%h%' limit 5

--5) Dê a média de preços de todos os produtos das categorias entre 1 e 5. Arredonde para 1 casa decimal.
select ROUND(CAST(sum(unit_price)/count(unit_price) AS DECIMAL), 1) as "avg_price" from products where category_id between 1 and 5

--6) Liste a média de preços e a quantidade de produtos distintos por SupplierID; ordene pela média de preço, do maior para o menor, e só mostre os 5 primeiros.
select supplier_id, count(supplier_id) as "ct_products", ROUND(CAST(sum(unit_price)/count(unit_price) AS DECIMAL), 2) as "avg_price"  from products group by supplier_id order by 3 desc

--Na tabela Orders:
--1) Liste o top 3 de funcionários com mais vendas no primeiro trimestre de 1996.
select min(required_date) from orders where required_date between '1996-01-01' and '1996-12-31'

select o.employee_id, e.first_name || ' ' || e.last_name as "employee_name", count(o.order_id) as "ct_order"
from orders o 
inner join employees e 
on e.employee_id = o.employee_id 
where o.order_date between '1996-01-01' and '1996-03-31'
group by o.employee_id, e.first_name || ' ' || e.last_name
order by 3 desc
limit 3

--2) Liste os clientes com mais pedidos - mas somente aqueles que tiverem a partir de 2 pedidos. Corte explicitamente os clientes que compraram de funcionários sem ID.
select customer_id, count(order_id) as "ct_order" from orders group by customer_id having count(order_id) >= 2 order by 2 desc

--Na tabela de Suppliers:
--1) Conte todos os diferentes fornecedores por país. Agrupe categorizando os países em 'Americas' (se o país for USA, Brazil ou Canada) e 'Outros' senão. Detalhe, estamos buscando aqueles cujo DDD não comece com o dígito 1.
-- simple select
select case 
			when country in ('USA', 'Brazil', 'Canada') then 'Americas' 
			else 'Outros' 
		end as "Americas", 
		count(supplier_id) as "ct_supplier" 
from 	suppliers 
where phone not like '(1%'
group by case 
			when country in ('USA', 'Brazil', 'Canada') then 'Americas' 
			else 'Outros' 
		end 

-- sub select
select tb.americas, sum(tb.ct_supplier) 
from 
(
select case 
			when country in ('USA', 'Brazil', 'Canada') then 'Americas' 
			else 'Outros' 
		end as "americas",
		count(supplier_id) as "ct_supplier" 
from 	suppliers 
where phone not like '(1%'
group by country
) tb
group by tb.americas

-- common table expressions
with tb (americas, ct_supplier) as
(
select case 
			when country in ('USA', 'Brazil', 'Canada') then 'Americas' 
			else 'Outros' 
		end as "americas",
		count(supplier_id) as "ct_supplier" 
from 	suppliers 
where phone not like '(1%'
group by country
)
select americas, sum(ct_supplier)
from tb
group by americas


--2) Existe alguma cidade com mais de um código de área de telefone?
select city, substring(phone,strpos(phone, '('), strpos(phone, ')')) as "code_area", count(*) as "ct_code_area"
from suppliers
where phone like '(%'
group by 1, 2
having count(*) > 1
order by city asc

--3) Tome a primeira letra de cada cidade (ex. "N" para "New Orleans"). Quais são as 5 iniciais de nomes de cidades que têm mais fornecedores associados (em ordem descrescente de fornecedores/cidade)?
-- Este select não representa a quantidade de fornecedores por cidade
select upper(left(city, 1)) as "first_letter_city", count(*) as "ct_supplier_for_letter"
from suppliers 
group by 1
order by 2 desc, 1
limit 5

select upper(left(city, 1)) as "first_letter_city", city, count(city) as "ct_supplier"
from suppliers 
group by city
order by 3 desc, 1
