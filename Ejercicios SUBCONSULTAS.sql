--SUBCONSULTAS


/*1. Se solicita un listado de artículos cuyo precio es inferior al promedio de
precios de todos los artículos. */
select cod_articulo,descripcion,pre_unitario
from articulos
where pre_unitario<(select avg(pre_unitario)
						from articulos)

/*2.Emitir un listado de los artículos que no fueron vendidos este año. En ese
listado solo incluir aquellos cuyo precio unitario del artículo oscile entre
50 y 100. */
select a.cod_articulo 'Codigo', descripcion 'Articulo'
from articulos a
where a.cod_articulo not in (select a.cod_articulo
					from articulos a join detalle_facturas df on a.cod_articulo=df.cod_articulo
					join facturas f on f.nro_factura=df.nro_factura
					where year(fecha) = year(getdate()))
and a.pre_unitario between 50 and 100


/*3.Genere un reporte con los clientes que vinieron más de 2 veces el año
pasado. */
select c.cod_cliente , c.ape_cliente+' '+c.nom_cliente 'Cliente'
from clientes c
where c.cod_cliente in (select f.cod_cliente
				from facturas f
				where year(fecha)=year(getdate())-1
				group by f.cod_cliente
				having count (*)>2)

/*4. Se quiere saber qué clientes no vinieron entre el 
12/12/2015 y el 13/7/2020 */

select c.cod_cliente 'Cod. Cliente', c.ape_cliente+' '+c.nom_cliente 'Cliente'
from clientes c 
where c.cod_cliente not in (select cod_cliente
						from facturas
						where fecha between '12/12/2015' and '13/07/2020')


/*5. Listar los datos de las facturas de los clientes que solo vienen a comprar
en febrero es decir que todas las veces que vienen a comprar haya sido
en el mes de febrero (y no otro mes) */

select nro_factura , fecha , f.cod_cliente
from facturas f join clientes c on c.cod_cliente=f.cod_cliente
where 2=all(select month(fecha)
			from facturas f1
			where f1.cod_cliente=c.cod_cliente)

--FILTRA LAS FECHAS EN LAS QUE EL CODIGO DE CLIENTE HIZO LAS COMPRAS
--LUEGO SI ESE CLIENTE COMPRO NO SOLAMENTE EN EL MES 2 no devuelve la fila.


/*6. Mostrar los datos de las facturas para los casos en que por año se hayan
hecho menos de 9 facturas. */

select nro_factura, f.cod_cliente 'Codigo Cliente' , f.cod_vendedor 'Codigo Vendedor'
from facturas f
where year(fecha) in (select year(fecha)
			from facturas
			group by year(fecha)
			having count(nro_factura)<9)

--Otra manera

select nro_factura, f.cod_cliente 'Codigo Cliente' , f.cod_vendedor 'Codigo Vendedor'
from facturas f
where 9 > (select count(nro_factura)
			from facturas f1
			where year(f1.fecha)=year(f.fecha))


/*7. Emitir un reporte con las facturas cuyo importe total haya sido superior a
1.500 (incluir en el reporte los datos de los artículos vendidos y los
importes).  */
select f.nro_factura, (cantidad*pre_unitario) 'Importe'
from facturas f join detalle_facturas df on df.nro_factura=f.nro_factura
where 1500< (select sum(cantidad*pre_unitario)
			from detalle_facturas df1
			where df1.nro_factura = f.nro_factura)


--8. Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6.
--Muestre solamente el nombre del vendedor.

select v.nom_vendedor+' '+v.ape_vendedor 'Vendedor'
from vendedores v 
where not exists (select f.nro_factura
		from facturas f 
		where f.cod_cliente not in (1,6) and v.cod_vendedor=f.cod_vendedor)

--9. Listar los datos de los artículos que superaron el promedio del Importe de ventas de $ 1.000.

select a.cod_articulo , a.descripcion
from articulos a
where 1000> (select avg(cantidad*pre_unitario)
			from detalle_facturas df
			where df.cod_articulo=a.cod_articulo)


			where df.cod_articulo=a.cod_articulo)

/* 10. ¿Qué artículos nunca se vendieron? Tenga además en cuenta que su
nombre comience con letras que van de la “d” a la “p”. Muestre solamente la descripción del artículo.
*/
select a.descripcion
from articulos a
where not exists (select df.cod_articulo
				from detalle_facturas df
				where df.cod_articulo=a.cod_articulo)
and a.descripcion like '[d-p]%'


/* 11. Listar número de factura, fecha y cliente para los casos en que ese cliente
haya sido atendido alguna vez por el vendedor de código 3. */
select nro_factura
from facturas f
where 3= any (select f1.cod_vendedor
				from facturas f1
				where f1.cod_cliente=f.cod_cliente)
/*La subconsulta hace una lista de vendedores donde comparo el cliente de la factura superior */


/*12. Listar número de factura, fecha, artículo, cantidad e importe para los
casos en que todas las cantidades (de unidades vendidas de cada
artículo) de esa factura sean superiores a 40.
													*/
select f.nro_factura, fecha, fecha, descripcion, cantidad*d.pre_unitario importe
from detalle_facturas d join facturas f on d.nro_factura=f.nro_factura
join articulos a on a.cod_articulo=d.cod_articulo
where 40<all (select cantidad
				from detalle_facturas df1
				where df1.nro_factura=f.nro_factura)

/*USAMOS ANY O ALL CUANDO LA CONSULTA VA A DEVOLVER MUCHAS FILAS, NO CUANDO TENEMOS COMPARACIONES SIMPLES*/
/*O sea si tenemos un numero solo,no podemos compararlo a una cantidad multiple de filas, o agregamos un any/all o
una funcion sumaria*/
