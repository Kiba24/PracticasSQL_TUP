Ejercicios GROUP BY HAVING

--3. Se quiere saber en este negocio, cuanto se factura:
--a: Diariamente
--b: Mensualmente
--c: Anualmente

--a
select day(fecha) 'Dia',MONTH(fecha) 'Mes', sum(cantidad*pre_unitario) 'Facturada por dia'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
group by day(fecha),MONTH(fecha)

--b 
select MONTH(fecha) 'Mes', YEAR(fecha) 'Anio',sum(cantidad*pre_unitario) 'Facturado por mes'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
group by MONTH(fecha),YEAR(fecha)

--c 
select YEAR(fecha)'Anio', sum (cantidad*pre_unitario) 'Facturado por anio'
from facturas f join detalle_facturas df on f.nro_factura = df.nro_factura
group by YEAR(fecha)


/* 4 Emitir un listado de la cantidad de facturas confeccionadas diariamente, correspondiente
a los meses que no sean enero, julio o diciembre, Ordene por cantidad vendida*/

select count(distinct f.nro_factura) 'Cantidad vendida en el dia', 
DAY(fecha) 'dia', MONTH(fecha) 'Mes', year(fecha) 'Anio'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
group by DAY(fecha),MONTH(fecha),YEAR(fecha)
order by count(distinct f.nro_factura) desc


/* 5.Se quiere saber la cantidad y el importe promedio vendido por
fecha y cliente, para codigos de vendedor superiores a 2. 
Ordene por fecha y cliente*/
select c.cod_cliente'Cod. Cliente' , sum(cantidad) 'Cantidad', 
avg(cantidad*pre_unitario) 'Importe promedio x detalle' , fecha
from detalle_facturas df join facturas f on df.nro_factura=f.nro_factura
join clientes c on c.cod_cliente=f.cod_cliente join vendedores v on f.cod_vendedor = v.cod_vendedor
where v.cod_vendedor>2
group by fecha, c.cod_cliente
order by fecha

/* 6. Se quiere saber el importe promedio vendido y la cantidad total vendida
por fecha y articulo para codigos de cliente inferior a 3. Ordene x fecha y art*/
select c.cod_cliente 'Cod Cliente', sum(cantidad) 'Cantidad total vendida',
sum(cantidad*df.pre_unitario)/sum(cantidad) 'Promedio vendido',
avg(cantidad*df.pre_unitario) 'Promedio vendido AVG',
fecha, a.cod_articulo 'Cod. Articulo' , a.descripcion 'Articulo'
from detalle_facturas df join facturas f on f.nro_factura=df.nro_factura
join articulos a on a.cod_articulo=df.cod_articulo
join clientes c on c.cod_cliente=f.cod_cliente
where a.cod_articulo<3
group by (fecha), a.cod_articulo	

/* */
use LIBRERIA


------------------------------- HAVING ------------------------------------------
/* 1. Se necesita saber el importe total de cada factura, pero solo aquellas
donde ese importe total sea superior a 2500*/
select f.nro_factura 'Num. Factura', sum(cantidad*pre_unitario) 'Importe'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
group by f.nro_factura
having sum(cantidad*pre_unitario)>2500
order by [Num. Factura]


/*2. Se desea un listado de vendedores y sus importes de ventas del anio 2017
pero solo aquellos que vendieron menos de 17000, en dicho anio*/

select v.cod_vendedor 'Cod. Vendedor', v.ape_vendedor+' '+nom_vendedor 'Vendedor'
, sum(cantidad*pre_unitario) 'Importe de ventas'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
join vendedores v on v.cod_vendedor=f.cod_vendedor
where year(fecha)=2017
group by v.cod_vendedor,ape_vendedor+' '+v.nom_vendedor
having sum(pre_unitario*cantidad)<17000

/* 3. Se quiere saber la fecha de la primera venta, la cantidad total vendida y
el importe total vendido por vendedor para los casos en que el promedio
de la cantidad vendida sea inferior o igual a 56.*/
select min(fecha) 'Primera venta', sum(cantidad) 'Cantidad total vendida',
sum(cantidad*pre_unitario) 'Importe total vendido'
from facturas f join detalle_facturas df on df.nro_factura=f.nro_factura
join vendedores v on f.cod_vendedor=v.cod_vendedor
group by v.cod_vendedor 
having (sum(cantidad*pre_unitario)/count(*))<=56

/* 4. Se necesita un listado que informe sobre el monto máximo, mínimo y
total que gastó en esta librería cada cliente el año pasado, pero solo
donde el importe total gastado por esos clientes esté entre 300 y 800. */
select c.cod_cliente 'Cod. Cliente', c.ape_cliente+' '+c.nom_cliente 'Cliente' ,
max(cantidad*pre_unitario) 'Monto maximo invertido',
min(cantidad*pre_unitario) 'Monto minimo invertido',
sum(cantidad*pre_unitario) 'Monto total invertido'
from detalle_facturas df join facturas f on df.nro_factura=f.nro_factura
join clientes c on c.cod_cliente=f.cod_cliente
where datediff(year,fecha,GETDATE())=1
group by c.cod_cliente, c.ape_cliente+' '+c.nom_cliente
having sum(cantidad*pre_unitario) between 3000 and 8000

/* 5. Muestre la cantidad facturas diarias por vendedor; para los casos en que
esa cantidad sea 2 o más.*/
select v.cod_vendedor 'Cod. Vendedor' , v.nom_vendedor+' '+v.ape_vendedor 'Vendedor',
count(distinct nro_factura) 'Cantidad de facturas',
DAY(fecha)'DIA',MONTH(fecha)'MES',YEAR(fecha)'ANIO'
from facturas f join vendedores v on f.cod_vendedor=v.cod_vendedor
group by v.cod_vendedor, v.nom_vendedor+' '+v.ape_vendedor, DAY(fecha),MONTH(fecha),YEAR(fecha)
having count(distinct nro_factura)>=2
order by DAY(fecha),MONTH(fecha),YEAR(fecha)

/* 6. Desde la administración se solicita un reporte que muestre el precio
promedio, el importe total y el promedio del importe vendido por artículo
que no comiencen con “c”, que su cantidad total vendida sea 100 o más
o que ese importe total vendido sea superior a 700.
*/

select sum(cantidad*df.pre_unitario)/sum(cantidad) 'Precio Promedio de Articulos',
sum(cantidad*df.pre_unitario)/count(df.nro_factura) 'Promedio Importe vendido'
,sum(cantidad*a.pre_unitario) 'Importe total',
sum(cantidad) 'Cantidad total vendida',
a.descripcion 'Articulo'
from detalle_facturas df join articulos a on a.cod_articulo=df.cod_articulo
where a.descripcion not like 'C%'
group by a.cod_articulo, a.descripcion
having (sum(cantidad)>=100 or sum(cantidad*df.pre_unitario)>700)

/* 7. Muestre en un listado la cantidad total de artículos vendidos, el importe
total y la fecha de la primer y última venta por cada cliente, para lo
números de factura que no sean los siguientes: 2, 12, 20, 17, 30 y que el
promedio de la cantidad vendida oscile entre 2 y 6. */

select 
sum(cantidad) 'Cantidad de art. Vendidos',
sum (cantidad*pre_unitario) 'Importe total',
avg(cantidad) 'Promedio SIMPLE de cant. vendida'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
join clientes c on c.cod_cliente=f.cod_cliente
where df.nro_factura not in (2,12,20,17,30)
group by c.cod_cliente
having avg(cantidad) between 2 and 6

