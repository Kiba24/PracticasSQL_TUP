--Ejercicios CONSULTAS SUMARIAS

--Ejercicio 1 Facturación total del negocio
Select COUNT(*) 'Cantidad de facturas'
from facturas

--Ejercicio 2 
/* También se quiere saber el total de la factura Nro. 236, la cantidad de
artículos vendidos, cantidad de ventas, el precio máximo y mínimo
vendido.*/
select sum(cantidad*pre_unitario) 'Importe Total',sum(cantidad) 'Cantidad Articulos',
count(*) 'Cantidad Ventas', max(pre_unitario) 'Precio Maximo' , min(pre_unitario)
'Precio Minimo'
from detalle_facturas
where nro_factura=236

--Ejercicio 3 : ¿Cuánto se facturó el año pasado?
select sum(cantidad*pre_unitario) 'Total'
from detalle_facturas,facturas
where datediff(YEAR,facturas.fecha,getdate())=1

--Ejercicio 4 | ¿Cantidad de clientes con dirección de e-mail sea conocido (no nulo)
select count(*) 'Clientes con email'
from clientes
where [e-mail] is not null

--Ejercicio 5
/* ¿Cuánto fue el monto total de la facturación de este negocio? ¿Cuántas
facturas se emitieron?*/
select sum(df.cantidad*df.pre_unitario) 'Total de facturacion',
COUNT(distinct f.nro_factura)'Cantidad de facturas emitidas'
from facturas f,detalle_facturas df


--Ejercicio 6
/* . Se necesita conocer el promedio de monto facturado por factura el año
pasado. */
select avg(pre_unitario*cantidad) 'Promedio de lo facturado el anio pasado'
from detalle_facturas,facturas
where datediff(year,fecha,getdate())=1

--Ejercicio 7
--Se quiere saber la cantidad de ventas que hizo el vendedor de código 3.
select count(cod_vendedor) 'Cantidad de Ventas hechas'
from facturas
where cod_vendedor=3

--Ejercicio 8
/* ¿Cuál fue la fecha de la primera y última venta que se realizó en este
negocio?*/
select min(fecha) 'Primer venta',
max(fecha) 'Ultima venta'
from facturas

--Ejercicio 9
/* Mostrar la siguiente información respecto a la factura nro.: 450: cantidad
total de unidades vendidas, la cantidad de artículos diferentes vendidos y
el importe total.*/