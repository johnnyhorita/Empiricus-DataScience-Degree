-- 1
\COPY geo from 'D:\sandboxes\github\johnnyhorita\empiricus-datascience-degree\780\Modulo-03-Banco-de-Dados\20210922_aula07\bases\geo.csv' DELIMITER ',' CSV HEADER;

-- 2
\COPY produtos (fabricante, categoria, segmento, produto, id_produto, fabricante_id) from 'D:\sandboxes\github\johnnyhorita\empiricus-datascience-degree\780\Modulo-03-Banco-de-Dados\20210922_aula07\bases\produtos.csv' DELIMITER ',' CSV HEADER;

-- 3
\COPY vendas from 'D:\sandboxes\github\johnnyhorita\empiricus-datascience-degree\780\Modulo-03-Banco-de-Dados\20210922_aula07\bases\vendas.csv' DELIMITER ',' CSV HEADER;


DROP TABLE sales;
DROP TABLE products;
DROP TABLE fabricante;
DROP TABLE geo;

select max(LENGTH(city)), max(LENGTH(state)), max(LENGTH(region)), max(LENGTH(district)) from geo

CREATE TABLE IF NOT EXISTS fabricante (manufacturerID INTEGER NOT NULL, manufacturer VARCHAR(100) NOT NULL, CONSTRAINT fabricante_pk PRIMARY KEY (manufacturerID));
CREATE TABLE IF NOT EXISTS products (productID INTEGER NOT NULL, category VARCHAR(100) NOT NULL, segment VARCHAR(100) NOT NULL, product VARCHAR(100) NOT NULL, manufacturerID INTEGER NOT NULL, CONSTRAINT produtos_pk PRIMARY KEY (productID));
CREATE TABLE IF NOT EXISTS geo (zip INTEGER NOT NULL, city VARCHAR(50) NOT NULL, state VARCHAR(2) NOT NULL, region VARCHAR(10) NOT NULL, district VARCHAR(20) NOT NULL, CONSTRAINT geo_pk PRIMARY KEY (zip));
CREATE TABLE IF NOT EXISTS sales (saleid INTEGER NOT NULL, date DATE NOT NULL, units INTEGER NOT NULL, revenue NUMERIC(10,2) NOT NULL, zip INTEGER NOT NULL, productID INTEGER NOT NULL, CONSTRAINT vendas_pk PRIMARY KEY (saleid));

ALTER TABLE products ADD CONSTRAINT fabricante_produtos_fk FOREIGN KEY (manufacturerID) REFERENCES fabricante (manufacturerID) ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
ALTER TABLE sales ADD CONSTRAINT produtos_vendas_fk FOREIGN KEY (productID) REFERENCES products (productID) ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
ALTER TABLE sales ADD CONSTRAINT geo_vendas_fk FOREIGN KEY (zip) REFERENCES geo (zip) ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;


CREATE TABLE geo (
    zip INT PRIMARY KEY,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    regiao VARCHAR(100) NOT NULL,
    distrito VARCHAR(100) NOT NULL
);


DROP TABLE vendas;
DROP TABLE produtos;
DROP TABLE geo;


CREATE TABLE produtos (
    id_produto INT PRIMARY KEY,
    produto VARCHAR(100) NOT NULL,
    segmento VARCHAR(100) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    fabricante_id INT NOT NULL,
    fabricante VARCHAR(100) NOT NULL
);

CREATE TABLE vendas (
    id_venda INT PRIMARY KEY,
    id_produto INT NOT NULL,
    data DATE NOT NULL,
    zip INT NOT NULL,
    quantidade INT NOT NULL,
    receita DECIMAL(14,2) NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produtos (id_produto),
    FOREIGN KEY (zip) REFERENCES geo (zip)
);



 SELECT 
    produtos.categoria, 
    produtos.segmento,
    SUM(vendas.receita)
  FROM vendas
  INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
  GROUP BY GROUPING SETS ((produtos.categoria), (produtos.segmento)) 
  ORDER BY 1;
  
  
SELECT 
	produtos.categoria, 
	produtos.segmento,
	SUM(vendas.receita)
FROM vendas
INNER JOIN produtos 
ON vendas.id_produto = produtos.id_produto
GROUP BY produtos.categoria, produtos.segmento
ORDER BY 1;

 SELECT 
    produtos.categoria, 
    produtos.segmento,
    SUM(vendas.receita) as receita
  FROM vendas
  INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
  GROUP BY ROLLUP((produtos.categoria), (produtos.segmento)) 
  ORDER BY 1;



SELECT
	produtos.categoria,
	DENSE_RANK() OVER (
		ORDER BY produtos.categoria
	) AS my_dense_rank,
	RANK() OVER (
		ORDER BY produtos.categoria
	) AS my_rank
FROM
	produtos;





SELECT
    mes,
    receita,
    LAG(receita) OVER (ORDER BY mes) as receita_mes_anterior,
    receita/(LAG(receita) OVER (ORDER BY mes)) -1 as crescimento,
    LEAD(receita) OVER (ORDER BY mes) as receita_proximo_mes
FROM (
    SELECT
        DATE_TRUNC('month', data) as mes,
        SUM(receita)::money as receita
    FROM vendas
    GROUP BY 1
    ORDER BY 1
) t
LIMIT 10




SELECT
    vendas.id_venda,
    produtos.id_produto,
    produtos.categoria, 
    produtos.segmento,
    sum(vendas.receita::money) over (partition by produtos.categoria) as total_categoria,
    vendas.receita::money
FROM vendas
INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
ORDER BY 1
LIMIT 50;



SELECT 
    produtos.fabricante,
    produtos.categoria,
    SUM(vendas.receita)::money
  FROM vendas
  INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
  GROUP BY produtos.categoria, produtos.fabricante
  ORDER BY 1;

SELECT 
    produtos.fabricante,
    produtos.categoria,
    SUM(vendas.receita)::money
FROM vendas
INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
GROUP BY ROLLUP((produtos.fabricante), (produtos.categoria))
ORDER BY 1, 2, 3


SELECT 
    produtos.fabricante,
    produtos.categoria,
    SUM(vendas.receita)::money
FROM vendas
INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
GROUP BY CUBE((produtos.fabricante), (produtos.categoria))
ORDER BY 1, 2, 3;


select zip, min(data) from vendas
group by zip

select 
first_value(vendas.data) over (partition by vendas.zip order by vendas.data) as primeira_data
first_value(produtos.produto) over (partition by vendas.zip order by vendas.data) as primeiro_produto
from vendas v
inner join geo g
	on g.zip = v.zip




SELECT
    mes,
    receita::money,
    SUM(receita::money) OVER (PARTITION BY DATE_TRUNC('year', mes)) AS receita_total_ano,
    AVG(receita) OVER (PARTITION BY DATE_TRUNC('year', mes))::money AS receita_media_ano,
    MIN(receita) OVER (PARTITION BY DATE_TRUNC('year', mes))::money AS min,
    MAX(receita) OVER (PARTITION BY DATE_TRUNC('year', mes))::money AS max,
    COUNT(receita) OVER (PARTITION BY DATE_TRUNC('year', mes)) AS count
FROM (
SELECT
    DATE_TRUNC('month', data) as mes,
    SUM(receita) as receita
FROM vendas
GROUP BY 1
) t
ORDER BY 1
LIMIT 20




SELECT
    mes,
    receita,
    LAG(receita) OVER (ORDER BY mes) as receita_mes_anterior,
    receita/(LAG(receita) OVER (ORDER BY mes)) -1 as crescimento,
    LEAD(receita) OVER (ORDER BY mes) as receita_proximo_mes
FROM (
    SELECT
        DATE_TRUNC('month', data) as mes,
        SUM(receita)::money as receita
    FROM vendas
    GROUP BY 1
    ORDER BY 1
) t
LIMIT 10




SELECT
    vendas.id_venda,
    produtos.id_produto,
    produtos.categoria, 
    produtos.segmento,
    sum(vendas.receita::money) over (partition by produtos.categoria) as total_categoria,
    vendas.receita::money
FROM vendas
INNER JOIN produtos 
    ON vendas.id_produto = produtos.id_produto
ORDER BY 1
LIMIT 50;
