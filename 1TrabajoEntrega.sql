create database sqltrabajo;
use sqltrabajo;

-- Creacion de tablas

create table Consumidores (
id int not null auto_increment PRIMARY KEY,
nombre varchar (255) NOT NULL,
apellido varchar (255) NOT NULL,
direccion varchar (255) NOT NULL
);

create table Aplicacion (
id int not null,
pedido_descripcion varchar (255) NOT NULL,
forma_pago int PRIMARY KEY,
pedidoID int,
FOREIGN KEY (pedidoID)
REFERENCES Consumidores (id)
);

create table Forma_de_pago (
id int,
tipo_pago varchar (55),
FOREIGN KEY (id)
REFERENCES Aplicacion (forma_pago)
);

create table Restaurante (
Id int,
nombrer varchar (255),
producto int PRIMARY KEY,
FOREIGN KEY (id)
REFERENCES Consumidores (id)
);

create table Productos (
id int,
tipo varchar (255),
precio int,
tipo_delivery int PRIMARY KEY,
FOREIGN KEY (id)
REFERENCES Restaurante (producto)
);

create table Delivery (
id int,
tipo varchar (255),
FOREIGN KEY (id)
REFERENCES Productos (tipo_delivery)
);

-- INSERTS --

insert into Consumidores (Id, Nombre, Apellido, Direccion) values (1, 'franco', 'gonzalez', 'derqui');
insert into Consumidores (Id, Nombre, Apellido, Direccion) values (2, 'juan', 'perez', 'francia');
insert into Consumidores (Id, Nombre, Apellido, Direccion) values (3, 'maria', 'serrano', 'florida');

insert into Aplicacion (Id, Pedido_descripcion, Forma_Pago, pedidoID) values (1, 'comida', 3, 3);
insert into Aplicacion (Id, Pedido_descripcion, Forma_Pago, pedidoID) values (2, 'helado', 1, 1);
insert into Aplicacion (Id, Pedido_descripcion, Forma_Pago, pedidoID) values (3, 'perfmueria', 4, 2);

insert into Forma_De_Pago (id, tipo_pago) values (1, 'debito');
insert into Forma_De_Pago (id, tipo_pago) values (3, 'efectivo');
insert into Forma_De_Pago (id, tipo_pago) values (4, 'transferencia');

insert into Restaurante (id, NombreR, Producto) values (1, 'antares', '2');
insert into Restaurante (id, NombreR, Producto) values (2, 'gluck', '3');
insert into Restaurante (id, NombreR, Producto) values (3, 'farmacia', '4');

insert into Productos (id, Tipo, Precio, Tipo_delivery) values (1, 'bebidas', 100, 1);
insert into Productos (id, Tipo, Precio, Tipo_delivery) values (2, 'comida', 150, 2);
insert into Productos (id, Tipo, Precio, Tipo_delivery) values (3, 'helado', 200, 3);
insert into Productos (id, Tipo, Precio, Tipo_delivery) values (4, 'perfmueria', 120, 4);

insert into Delivery (id, tipo) values (1, 'moto');
insert into Delivery (id, tipo) values (2, 'auto');
insert into Delivery (id, tipo) values (3, 'bicicleta');
insert into Delivery (id, tipo) values (4, 'retiro');

-- Creacion vistas

create view precios as
select precio from productos;

create view deliverys as
select tipo from Delivery;

create view tiposproductos as
select tipo from Productos;

create view nombresrestaurantes as
select NombreR from Restaurante;

create view pagos as
select tipo_pago from Forma_De_Pago;

-- Funciones almacenadas

-- El objetivo de la primera funcion es saber los medios de pago que acepta la aplicacion

delimiter //

create function tipopagos() returns varchar(45)
deterministic
begin
return 'efectivo,debito,credito';
end //;

select tipopagos();

-- El objetivo de la segunda funcion es saber el costo de una cena total en base a los precios dados en el set de datos, 
-- contando la comida, bebidas y helado. (Suma las 3)

delimiter //

create function totalcenas (comida int, bebidas int, helado int) returns int
deterministic
begin
declare costototal int;
set costototal= ((comida)+(bebidas)+(helado));
return costototal;
end //;

select totalcenas (100,150,200);

DELIMITER //
create procedure ordenar (orden varchar(255))
SELECT Precio from Productos
ORDER by CASE WHEN orden='ASC' THEN Precio END asc,
         CASE WHEN orden='DESC' THEN Precio END desc;
end;
//

call ordenar ('ASC');

-- Este S.P permite ordenar en orden ascendente o descendente (dependiendo el parametro 'ASC' o 'DESC') la lista de precios de la tabla productos. --

DELIMITER //
create procedure insertar (tipo varchar (55))
BEGIN
insert into Forma_De_Pago (tipo_pago) values (tipo);
END;
//

call insertar ('MercadoPago');
select * from Forma_De_Pago;

-- Este S.P permite agregar métodos de pago dentro de la columna tipo_pago

-- Creación de usuarios --

-- el 'usuario1' con contraseña 'contraseña1' solo tendrá acceso a la lectura de las tablas de la B.D.

create user 'usuario1'@'localhost' identified by 'contraseña1';

grant select on *.* to 'usuario1'@'localhost';

-- el 'usuario2' con contraseña 'contraseña2' tendra acceso a las sentencias select, insert y alter dentro de todas las tablas de la B.D.

create user 'usuario2'@'localhost' identified by 'contraseña2';

grant select, insert, alter on *.* to 'usuario2'@'localhost';

use sqltrabajo;

-- Sublenguaje TCL

-- Se crearan dos tablas nuevas (TipoAplicacion y Trabajadores ) debido a que al modificar las tablas ya hechas figura un error

create table TipoAplicacion (
id int not null auto_increment PRIMARY KEY,
Tipo varchar (255)
);

create table Trabajadores (
id int not null auto_increment PRIMARY KEY,
Nombre varchar (255)
);

START TRANSACTION;

insert into TipoAplicacion(id, Tipo) values (1, 'paginaweb');
insert into TipoAplicacion(id, Tipo) values (2, 'aplicacioncelular');
-- ROLLBACK; --
COMMIT;

START TRANSACTION;

insert into Trabajadores(id, Nombre) values (1, 'Gonzalo');
insert into Trabajadores(id, Nombre) values (2, 'Facundo');
insert into Trabajadores(id, Nombre) values (3, 'Mariano');
insert into Trabajadores(id, Nombre) values (4, 'Gaston');

SAVEPOINT lote_1_4;

insert into Trabajadores(id, Nombre) values (5, 'Simon');
insert into Trabajadores(id, Nombre) values (6, 'Tomas');
insert into Trabajadores(id, Nombre) values (7, 'Agustin');
insert into Trabajadores(id, Nombre) values (8, 'Franco');

SAVEPOINT lote_5_8;

-- Release SAVEPOINT lote_1_4;










