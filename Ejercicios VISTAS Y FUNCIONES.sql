--LABORATORIO EJERCICIOS UNIDAD 3
/*1 Crear vista clientes con los datos... */

create view vista_clientes
as	
	select c.ape_cliente + ' ' + c.nom_cliente 'Cliente',
	b.barrio 'Barrio', c.calle + str(c.altura) 'Direccion'
	from clientes c join barrios b on c.cod_barrio=b.cod_barrio

select * from vista_clientes


/*2. Cree una vista que liste la fecha, la factura, el código y nombre del
vendedor, el artículo, la cantidad e importe, para lo que va del año. 
Rotule como FECHA,NRO_FACTURA, CODIGO_VENDEDOR, NOMBRE_VENDEDOR, ARTICULO,
CANTIDAD, IMPORTE.*/
go
create view detalle_anio
as
	select fecha, f.nro_factura, v.nom_vendedor 'Vendedor', a.descripcion 'Articulo',
	cantidad , cantidad*df.pre_unitario 'IMPORTE'
	from facturas f join detalle_facturas df on df.nro_factura= f.nro_factura
	join vendedores v on f.cod_vendedor=v.cod_vendedor
	join articulos a on df.cod_articulo=a.cod_articulo
	where year(f.fecha)=year(getdate());

select * from detalle_anio


/* 3. Modifique la vista creada en el punto anterior, agréguele la condición de que
solo tome el mes pasado (mes anterior al actual) y que también muestre la
dirección del vendedor. */
go
alter view detalle_anio
as
	select fecha, f.nro_factura, v.nom_vendedor 'Vendedor',
	v.calle + str(v.altura) 'Direccion',a.descripcion 'Articulo',
	cantidad , cantidad*df.pre_unitario 'IMPORTE'
	from facturas f join detalle_facturas df on df.nro_factura= f.nro_factura
	join vendedores v on f.cod_vendedor=v.cod_vendedor
	join articulos a on df.cod_articulo=a.cod_articulo
	where year(f.fecha)=year(getdate())
	and datediff(MONTH,fecha,GETDATE())=1;
	
select * from detalle_anio


/*4. Consulta las vistas según el siguiente detalle:
a. Llame a la vista creada en el punto anterior pero filtrando por importes
inferiores a $120.
b. Llame a la vista creada en el punto anterior filtrando para el vendedor
Miranda.
c. Llama a la vista creada en el punto 4 filtrando para los importes
menores a 10.000.*/

select * from detalle_anio
where IMPORTE<120

select * from detalle_anio
where Vendedor like '%Miranda'

select * from detalle_anio
where importe < 10000

/* 5. Elimine las vistas creadas en el punto 3 */

drop view detalle_anio



/* FUNCIONES */
/* Cree las siguientes funciones:
a. Hora: una función que les devuelva la hora del sistema en el formato
HH:MM:SS (tipo carácter de 8).

/* HORA */
go
create function f_hora()
returns varchar(8)
as
begin
declare @hora varchar (8)
set @hora= CONVERT(varchar(8),convert(time,getdate()))
return @hora
end;

go 
select dbo.f_hora()


/* b. Fecha: una función que devuelva la fecha en el formato AAAMMDD (en
carácter de 8), a partir de una fecha que le ingresa como parámetro
(ingresa como tipo fecha). */

go
alter function f_fecha(@f datetime)
returns varchar(12)
as
begin
	declare @fecha varchar(12)
	set @fecha = format(@f,'yyyy/MM/dd')
	return @fecha
end;

select dbo.f_fecha(getdate())


/* c. Dia_Habil: función que devuelve si un día es o no hábil (considere
como días no hábiles los sábados y domingos). Debe devolver 1
(hábil), 0 (no hábil)  */

create function f_diaHabil(@dia varchar(10))
returns int
as
begin
	return
		case
			when @dia = 'Lunes' then 1
			when @dia = 'Martes' then 1
			when @dia = 'Miercoles' then 1
			when @dia = 'Jueves' then 1
			when @dia = 'Viernes' then 1
			when @dia = 'Sabado' then 0
			when @dia = 'Domingo' then 0
		end;
end;

select dbo.f_diaHabil('papa')


--2. Utilizando el punto anterior, verificar si la variable stock o stockMinimo tienen
--algún valor. Mostrar un mensaje indicando si es necesario realizar reposición
--de artículos o no.

go
alter function fuction_Articulos
(@codigo int)
returns varchar(100) 
begin
	declare @stock int,
		    @stock_minimo int
  	select @stock = stock, @stock_minimo = stock_minimo
	from articulos
	where cod_articulo = @codigo
		if(@stock is null)
			BEGIN 
				Return 'No se ah registrado ningun stock'
			end
		else if (@stock = 0)
			begin 
				return 'Debe reponer stock'
			end
return 'El stock es de' + str(@stock)
end;

select dbo.fuction_Articulos(6)