/*1. Declarar 3 variables que se llamen codigo, stock y stockMinimo
respectivamente. A la variable codigo setearle un valor. Las variables stock y
stockMinimo almacenarán el resultado de las columnas de la tabla artículos
stock y stockMinimo respectivamente filtradas por el código que se
corresponda con la variable codigo.*/

create procedure stock_articulos
@codigo int,
@stock int output,
@stockMinimo int output
as
	if @codigo is null
	begin
	select 'No puso el valor del codigo'
	return
	end;
	select @stock = stock, @stockMinimo = stock_minimo
	from articulos
	where cod_articulo = @codigo

/* 2. Utilizando el punto anterior, verificar si la variable stock o stockMinimo tienen
algún valor. Mostrar un mensaje indicando si es necesario realizar reposición
de artículos o no.*/
go
alter procedure stock_articulos
@codigo int,
@stock int output,
@stockMinimo int output
as
	if @codigo is null
	begin
	select 'No puso el valor del codigo'
	return
	end;
	if @stock is null
	begin
	select 'No hay valor de stock'
	return
	end;
	if @stockMinimo is null
	begin
	select 'No hay stock minimo'
	return
	end;
	select @stock = stock, @stockMinimo = stock_minimo
	from articulos
	where cod_articulo = @codigo

/*3. Modificar el ejercicio 1 agregando una variable más donde se almacene el
precio del artículo. En caso que el precio sea menor a $500, aplicarle un
incremento del 10%. En caso de que el precio sea mayor a $500 notificar dicha
situación y mostrar el precio del artículo. */
go
--Haciendo otro metodo
declare @codigo int = 4, @precio money
select @precio = pre_unitario 
from articulos
where cod_articulo = @codigo
if @precio < 500
	begin
		update articulos
		set pre_unitario = pre_unitario*1.1
		where cod_articulo = @codigo
		select 'Precio modigicado' + str(@pre_unitario)
	end;
else
	begin
		select'Precio inferior a $500'
	end;


/* 4. Declarar dos variables enteras, y mostrar la suma de todos los números
comprendidos entre ellos. En caso de ser ambos números iguales mostrar un
mensaje informando dicha situación*/
declare @num1 int , @num2 int
if @num1>@num2 
	begin
		select 'El numero 2 no puede ser menor al numero 1'
		return
	end;

else
	begin
		declare @total int = 0
		while @num2>@num1
			begin
			set @total = @total + @num1
			set @num1 = @num1 + 1
			end;
			select @total 'Suma'
		end;

/* 5. Mostrar nombre y precio de todos los artículos. Mostrar en una tercer columna
la leyenda ‘Muy caro’ para precios mayores a $500, ‘Accesible’ para precios
entre $300 y $500, ‘Barato’ para precios entre $100 y $300 y ‘Regalado’ para
precios menores a $100.*/

go
select descripcion, pre_unitario, mensaje = 
case
	when pre_unitario>500 then 'Muy caro'
	when pre_unitario between 300 and 400 then 'Accesible'
	when pre_unitario between 100 and 300 then 'Barato'
	when pre_unitario<100 then 'Regalado'
end
from articulos


/*6. Modificar el punto 2 reemplazando el mensaje 
de que es necesario reponer artículos
por una excepción */
declare @codigo int=1, @stock int, @stockMinimo int
select @stock=stock ,@stockminimo=stock_minimo
	from articulos
	where cod_articulo=@codigo
if @stock is null or @stockMinimo is null 
	begin
		raiserror('Hay valores nulos',1,11)
	end



/* ---------- TRY CATCH -----------*/


/*1. Modificar el ejercicio 2 de la sección 1.1 reemplazando los mensajes
mostrados en consola con print, por excepciones. Verificar el comportamiento
en el SQL Server Management.
2. Modificar el ejercicio anterior agregando las cláusulas de try catch para
manejo de errores, y mostrar el mensaje capturado en la excepción con print.  */


declare @codigo int, @stock int , @stockMinimo int 
as
	try 
		begin try
		select @stock = stock, @stockMinimo = stock_minimo
		from articulos
		where cod_articulo = @codigo
		end try
	catch
		begin catch
		select 'Se produjo el siguiente error',
		error_number() 'Numero error',
		error_message() 'Error'
		end catch



/* --------   TRIGGERS       --------- */


/* 4.4: Triggers
1. Crear un desencadenador para las siguientes acciones:
a. Restar stock DESPUES de INSERTAR una VENTA
b. Para no poder modificar el nombre de algún artículo
c. Insertar en la tabla HistorialPrecio el precio anterior de un artículo si el
mismo ha cambiado
d. Bloquear al vendedor con código 4 para que no pueda registrar ventas
en el sistema.	*/

--a. Restar stock DESPUES de INSERTAR una VENTA
create trigger restar_stock_venta
on detalle_facturas
for insert
as
	declare @stock int
	select @stock=stock from articulos join inserted
		on inserted.cod_articulo=articulos.cod_articulo
	--igualo mi variable stock al stock del articulo insertado

	update articulos set stock=stock - inserted.cantidad
	from articulos join inserted
	on inserted.cod_articulo=articulos.cod_articulo
	--Modifico el stock actual restandole la cantidad vendida

go

--b. Para no poder modificar el nombre de algún artículo
create trigger no_modificar_articulo
on articulos
for update
as
	if (update (descripcion))
		begin
			raiserror('No se puede modificar el nombre del articulo',10,1)
			rollback transaction;
		end;

--c. Insertar en la tabla HistorialPrecio el precio anterior de un artículo si el
--mismo ha cambiado

go
create trigger add_historialPrecio
on articulos
for update
as
	declare @precio money
	declare @cod_articulo int
	declare @fecha datetime
	select @precio = deleted.pre_unitario, @cod_articulo=articulos.cod_articulo,
	@fecha = fecha
	from articulos join deleted on articulos.cod_articulo=deleted.cod_articulo 
		join detalle_facturas df on articulos.cod_articulo=df.cod_articulo
		join facturas f on f.nro_factura=df.nro_factura
		if update (pre_unitario)
		begin
			insert into historial_precios values (@cod_articulo,@precio,@fecha,getdate())
		end;

select * from historial_precios