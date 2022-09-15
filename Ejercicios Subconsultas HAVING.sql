Ejercicios Subconsultas HAVING

/*1. Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y
¿cuánto fue el importe total de las ventas que ha realizado? Mostrar estos
datos en un listado solo para los casos en que su importe promedio de
vendido sea superior al importe promedio general (importe promedio de
todas las facturas). */

select v.cod_vendedor 'Cod. Vendedor' , v.ape_vendedor+' '+v.nom_vendedor 'Vendedor', 
sum(cantidad*pre_unitario) 'Importe total vendido', min(fecha) 'Primera venta'
from vendedores v join facturas f on f.cod_vendedor = v.cod_vendedor
join detalle_facturas df on df.nro_factura=f.nro_factura
group by v.cod_vendedor , v.ape_vendedor+' '+v.nom_vendedor
having (avg(cantidad*pre_unitario)) < (select avg(cantidad*pre_unitario)
										from detalle_facturas df1)
order by 1


/* 2. Liste los montos totales mensuales facturados por cliente y además del
promedio de ese monto y el promedio de precio de artículos Todos esto
datos correspondientes a período que va desde el 1° de febrero al 30 de
agosto del 2014. Sólo muestre los datos si esos montos totales son
superiores o iguales al promedio global. */

select c.cod_cliente, c.ape_cliente+' '+c.nom_cliente 'Cliente' ,  month(fecha) 'Mes',
sum(cantidad*pre_unitario) 'Monto total menesual', avg(cantidad*pre_unitario) 'Promedio total Mensual'
from detalle_facturas df join facturas f on f.nro_factura=df.nro_factura
join clientes c on c.cod_cliente=f.cod_cliente
--where fecha between '01/02/2014' and '30/09/2014'
group by month(fecha) , c.cod_cliente, c.ape_cliente+' '+c.nom_cliente 
having avg(cantidad*pre_unitario)>= (select avg(cantidad*pre_unitario)
from detalle_facturas)
order by 1



/*3. Por cada artículo que se tiene a la venta, se quiere saber el importe
promedio vendido, la cantidad total vendida por artículo, para los casos
en que los números de factura no sean uno de los siguientes: 2, 10, 7, 13,
22 y que ese importe promedio sea inferior al importe promedio de ese
artículo. */

select a.cod_articulo 'Cod. Art', a.descripcion 'Articulo'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura
join articulos a on a.cod_articulo=df.cod_articulo
where df.nro_factura not in (2,10,7,13,22)
group by a.cod_articulo , a.descripcion
having avg(cantidad*df.pre_unitario) < (select avg(df1.cantidad*df1.pre_unitario)
											from detalle_facturas df1)