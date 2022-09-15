--Emitir un listado con los clientes y los vendedores
--Union debe tener el mismo número de expresiones en sus listas de destino.


-- EJERCICIO 1
select cod_cliente 'Codigo', ape_cliente 'Apellido', nom_cliente 'Nombre', 'Cliente' 'Tipo'
from clientes
--Nombramos los campos y columnas, en la segunda no hace faltan los alias :)
union
select cod_vendedor, ape_vendedor, nom_vendedor, 'Vendedor'
from vendedores
order by [Apellido]
--Ordenados Alfabeticamente el RESULTADO FINAL
--Se ordenan por la primera sentencia


--EJERCICIO 2
select cod_cliente 'Codigo', ape_cliente 'Apellido', nom_cliente 'Nombre', [e-mail] 'Mail'
,nro_tel 'Telefono','Cliente' 'Tipo'
from clientes
where [e-mail] is not null and nro_tel is not null
--Nombramos los campos y columnas, en la segunda no hace faltan los alias :)
union
select cod_vendedor, ape_vendedor, nom_vendedor,[e-mail], nro_tel,'Vendedor'
from vendedores
where [e-mail] is not null and nro_tel is not null
order by 3,2


--EJERCICIO 3
/* . Emitir un listado donde se muestren qué artículos, clientes y vendedores hay en
la empresa. Determine los campos a mostrar y su ordenamiento.*/

select cod_cliente 'Codigo', nom_cliente 'Nombre','Cliente' 'Tipo'
from clientes
union
select cod_vendedor, nom_vendedor,'Vendedor'
from vendedores
union
select cod_articulo, descripcion , 'Articulo'
from articulos
order by Tipo


--Ejercicio 4
/* Se quiere saber las direcciones (incluido el barrio) tanto de clientes como de
vendedores. Para el caso de los vendedores, códigos entre 3 y 12. En ambos
casos las direcciones deberán ser conocidas. Rotule como NOMBRE,
DIRECCION, BARRIO, INTEGRANTE (en donde indicará si es cliente o vendedor).
Ordenado por la primera y la última columna.*/

select cod_cliente 'Codigo', ape_cliente 'Apellido', nom_cliente 'Nombre',
b.barrio 'Barrio', 'Cliente' 'Integrante'
from clientes c join barrios b on c.cod_barrio=b.cod_barrio 
where c.cod_barrio is not null
union
select cod_vendedor, ape_vendedor, nom_vendedor, b.barrio, 'Vendedor' 
from vendedores v join barrios b on v.cod_barrio=b.cod_barrio
where cod_vendedor between 3 and 12 and v.cod_barrio is not null
order by 1,5


--EJERCICIO 6
/* 6. Listar todos los artículos que están a la venta cuyo precio unitario oscile entre 10
y 50; también se quieren listar los artículos que fueron comprados por los
clientes cuyos apellidos comiencen con “M” o con “P”. */
select a.cod_articulo 'Codigo', a.descripcion 'Nombre', a.pre_unitario 'Precio' , 'Between' 'Tipo'
from articulos a join detalle_facturas df on a.cod_articulo=df.cod_articulo
	join facturas f on df.nro_factura=f.nro_factura	
where df.pre_unitario between 10 and 50
union 

select a.cod_articulo 'Codigo', a.descripcion 'Nombre', a.pre_unitario 'Precio' , 'Like'
from articulos a join detalle_facturas df on a.cod_articulo=df.cod_articulo
	join facturas f on df.nro_factura=f.nro_factura	
		join clientes c on c.cod_cliente=f.cod_cliente
where c.ape_cliente like 'M%' or c.ape_cliente like 'P%'


