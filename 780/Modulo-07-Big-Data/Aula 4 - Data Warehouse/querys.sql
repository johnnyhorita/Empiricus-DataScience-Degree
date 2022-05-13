
insert into Northwind_DW.dbo.[Order Details]
select * from dbo.[Order Details]


insert into Northwind_DW.dbo.[Orders]
select * from dbo.[Orders]


select * from Categories
select * from Customers
select * from Employees
select * from [dbo].[EmployeeTerritories]
select * from [dbo].[Order Details]
select * from [dbo].[Orders]
select * from [dbo].[Products]
select * from [dbo].[Region]
select * from [dbo].[Shippers]
select * from [dbo].[Suppliers]
select * from [dbo].[Territories]

## Análises com Apache Spark
--1 - Quais são os três produtos MENOS vendidos?
select	productID, count(od.productID) as 'qtd'
from		[dbo].[Order Details] od
inner join	[dbo].[Orders] o
		on	o.OrderID = od.OrderID
group by od.ProductID
order by 2, 1

--2 - Quais são os cinco clientes que mais compras fizeram?
select	o.CustomerID, count(o.CustomerID) as 'qtd'
from		Orders o 
inner join	Customers c 
		on	o.CustomerID = c.CustomerID
group by o.CustomerID
order by 2 desc

--3 - Quais são os cinco clientes com maior total de vendas?
select	--od.*,
		--od.OrderID,
		e.EmployeeID
		--,e.LastName + ', ' + e.FirstName as 'Employee'
		--,(od.UnitPrice * od.Quantity) as 'Total_Product'
		--,convert(money, ((od.UnitPrice * od.Quantity) * (od.Discount))) as 'Discount_Value'
		,convert(decimal(18,2), sum((od.UnitPrice * od.Quantity) * (1 - od.Discount))) as Total_Orders
		--,sum(convert(money, ((od.UnitPrice * od.Quantity) * (1 - od.Discount)))) as 'Total_Order'
from		[dbo].[Order Details] od
inner join	[dbo].[Orders] o
		on	o.OrderID = od.OrderID
inner join	Employees e 
		on	o.EmployeeID = e.EmployeeID
group by e.EmployeeID
order by 2 desc


--4 - Qual o melhor funcionário do último mês registrado? (total de vendas)
-- verifica os anos
select distinct DATEPART(year, OrderDate) from [dbo].[Orders] order by 1

--verifica a maior data dos anos
select max(OrderDate) from [dbo].[Orders] where DATEPART(year, OrderDate) = 1996
select max(OrderDate) from [dbo].[Orders] where DATEPART(year, OrderDate) = 1997
select max(OrderDate) from [dbo].[Orders] where DATEPART(year, OrderDate) = 1998

select	--od.*,
		--od.OrderID,
		e.EmployeeID
		--,e.LastName + ', ' + e.FirstName as 'Employee'
		--,(od.UnitPrice * od.Quantity) as 'Total_Product'
		--,convert(money, ((od.UnitPrice * od.Quantity) * (od.Discount))) as 'Discount_Value'
		,convert(decimal(18,2), sum((od.UnitPrice * od.Quantity) * (1 - od.Discount))) as Total_Orders
		--,sum(convert(money, ((od.UnitPrice * od.Quantity) * (1 - od.Discount)))) as 'Total_Order'
from		[dbo].[Order Details] od
inner join	[dbo].[Orders] o
		on	o.OrderID = od.OrderID
inner join	Employees e 
		on	o.EmployeeID = e.EmployeeID
where	o.OrderDate between ('1996-12-01') and ('1996-12-31')
group by e.EmployeeID
order by 2 desc

select	--od.*,
		--od.OrderID,
		e.EmployeeID
		--,e.LastName + ', ' + e.FirstName as 'Employee'
		--,(od.UnitPrice * od.Quantity) as 'Total_Product'
		--,convert(money, ((od.UnitPrice * od.Quantity) * (od.Discount))) as 'Discount_Value'
		,convert(decimal(18,2), sum((od.UnitPrice * od.Quantity) * (1 - od.Discount))) as Total_Orders
		--,sum(convert(money, ((od.UnitPrice * od.Quantity) * (1 - od.Discount)))) as 'Total_Order'
from		[dbo].[Order Details] od
inner join	[dbo].[Orders] o
		on	o.OrderID = od.OrderID
inner join	Employees e 
		on	o.EmployeeID = e.EmployeeID
where	o.OrderDate between ('1997-12-01') and ('1997-12-31')
group by e.EmployeeID
order by 2 desc

select	--od.*,
		--od.OrderID,
		e.EmployeeID
		--,e.LastName + ', ' + e.FirstName as 'Employee'
		--,(od.UnitPrice * od.Quantity) as 'Total_Product'
		--,convert(money, ((od.UnitPrice * od.Quantity) * (od.Discount))) as 'Discount_Value'
		,convert(decimal(18,2), sum((od.UnitPrice * od.Quantity) * (1 - od.Discount))) as Total_Orders
		--,sum(convert(money, ((od.UnitPrice * od.Quantity) * (1 - od.Discount)))) as 'Total_Order'
from		[dbo].[Order Details] od
inner join	[dbo].[Orders] o
		on	o.OrderID = od.OrderID
inner join	Employees e 
		on	o.EmployeeID = e.EmployeeID
where	o.OrderDate between ('1998-05-01') and ('1998-05-31')
group by e.EmployeeID
order by 2 desc



--5 - Quais as regiões com menos clientes cadastrados?
select e.*, t.*, r.*
from		[dbo].[Employees] e
inner join	[dbo].[EmployeeTerritories] et
		on	et.EmployeeID = e.EmployeeID
inner join	[dbo].[Territories] t
		on	t.TerritoryID = et.TerritoryID
inner join	[dbo].[Region] r
		on	r.RegionID = t.RegionID

select e.city, e.Region, e.country, et.TerritoryID, c.city, c.Region, c.Country
from [dbo].[Employees] e
inner join	[dbo].[EmployeeTerritories] et
		on	et.EmployeeID = e.EmployeeID

inner join	Customers c
		on	c.city = e.city
		and c.country = e.Country
where c.region is not null

select * from [dbo].[Employees] where Region is null

select * from [EmployeeTerritories] 
where EmployeeID in (5,6,7,9)


select city, Region, country from Customers


select	SupplierID, count(SupplierID)
from		Products p
group by p.SupplierID


select	s.CompanyName , count(p.SupplierID) as 'Qtd_Product'
from		Products p
inner join	Suppliers s
		on	s.SupplierID = p.SupplierID
group by s.CompanyName
order by 2 desc


select * from [dbo].[Order Subtotals] ORDER BY 1
select * from [dbo].[Orders Qry]
select * from [dbo].[Products Above Average Price]

select * from [dbo].[Summary of Sales by Quarter]