create database db_ecomerce

use db_ecomerce;

--create table tbl_Produtos
--(
--	cd_Produto int, 
--	nm_Produto varchar(100),
--	ds_Produto varchar(200),
--	vl_Produto float
--)

--create table tbl_Clientes
--(
--	cd_Cliente int not null,
--	nm_Cliente varchar(200) not null,
--	tp_Pessoa char(1) not null
--)

--create table tbl_Pedido
--(
--	cd_Pedido int not null, 
--	dt_Solicitacao datetime not null,
--	FlagPago bit not null,
--	Tt_Pedido float not null,
--	cd_Cliente int not null
--)

--create table tbl_PedidoItem
--(
--	cd_Pedido int not null, 
--	cd_Produto int not null,
--	vl_PedidoItem float not null,
--	qt_PedidoItem int not null
--)

insert into tbl_Clientes values
(1, 'Thiago', 'F'), (2, 'Maikon', 'J'),
(3, 'Irineu', 'J'), (4, 'Jeferson', 'F');

insert tbl_Clientes values
(5, 'Markson', 'F');

select 
	nm_Cliente, 
	tp_Pessoa, 
	* 
	from tbl_Clientes;

update tbl_Clientes 
	set tp_Pessoa = 'F' 
where cd_Cliente = 2;

/* deleta tudo da tabela clientes */
delete from tbl_Clientes;

/* deleta um dado espec�fico da tabela clientes */
delete from tbl_Clientes where cd_Cliente = 2;

insert into tbl_Produtos values
(1, 'Caneta', 'Caneta azul', 1.5),
(2, 'Caderno', 'Caderno 10 mat�rias', 20.99);

insert into tbl_Pedido values
(1, getdate(), 0, 3, 7), (2, getdate(), 0, 22.49, 1);

insert into tbl_PedidoItem values
(1, 1, 3, 2), 
	(2, 2, 20.99, 1), 
(2, 1, 1.5, 1);

alter table tbl_Clientes
add dataCriacao date;

select isnull(dataCriacao, getDate()) as dataAtual, *
from tbl_Clientes;

select *,
		case
			when tp_Pessoa = 'F' then 'Pessoa f�sica'
			when tp_Pessoa = 'J' then 'Pessoa jur�dica'
			else 
				'Pessoa indefinida'
		end as TipoPessoa
from tbl_Clientes;

select *, convert(varchar, dt_Solicitacao) as dataExibicaoPad from tbl_Pedido;
select *, convert(varchar, dt_Solicitacao, 103) as dataExibicaoBr from tbl_Pedido;

/*constraint => adicionar uma regra a nossa tabela */
alter table tbl_Clientes add constraint cd_Cliente primary key(cd_Cliente);

drop table tbl_Pedido;
drop table tbl_PedidoItem;
drop table tbl_Clientes;

create table tbl_Clientes
(
	cd_Cliente int primary key identity,
	nm_Cliente varchar(200) not null,
	tp_Pessoa char(1) not null,
	dataCriacao date
)

insert into tbl_Clientes values
('Thiago', 'F', getDate()),
	('Maikon', 'J', getDate()),
		('Irineu', 'J', getDate()), 
	('Jeferson', 'F', getDate()),
('Markson', 'F', getDate());

select * from tbl_Clientes;

create table tbl_Pedido
(
	cd_Pedido int primary key identity, 
	dt_Solicitacao datetime not null,
	FlagPago bit not null,
	Tt_Pedido float not null,
	cd_Cliente int not null
)

alter table tbl_Pedido add constraint 
	cd_Cliente foreign key (cd_Cliente) 
references tbl_Clientes (cd_Cliente);

insert into tbl_Pedido values
(getdate(), 0, 3, 5), (getdate(), 0, 22.49, 1);

create table tbl_Produtos
(
	cd_Produto int primary key identity, 
	nm_Produto varchar(100),
	ds_Produto varchar(200),
	vl_Produto float
)

insert into tbl_Produtos values
('Caneta', 'Caneta azul', 1.5),
('Caderno', 'Caderno 10 matérias', 20.99);

create table tbl_PedidoItem
(
	cd_Pedido int, 
	cd_Produto int,
	vl_PedidoItem float not null,
	qt_PedidoItem int not null
	primary key(cd_Pedido, cd_Produto)
)

insert into tbl_PedidoItem values
(1, 1, 3, 2), 
	(2, 2, 20.99, 1), 
(2, 1, 1.5, 1);

alter table tbl_PedidoItem add constraint 
	cd_Pedido foreign key (cd_Pedido) 
references tbl_Pedido (cd_Pedido);

alter table tbl_PedidoItem add constraint
	cd_Produdo foreign key (cd_Produto) 
references tbl_Produtos (cd_Produto);

alter table tbl_Pedido 
add cd_Status int;

alter table tbl_Pedido 
add ds_Status varchar(50);

update tbl_Pedido 
set cd_Status = 1,
ds_Status = 'Em andamento'
where cd_Pedido = 3;

select * from tbl_Pedido;

create table tbl_Status
(
	cd_Status int primary key identity,
	ds_Status varchar(50) not null 
)

insert into tbl_Status values
('Em adamento'), ('Em separação'), ('Pago'),
('Entregue a transportadora'), ('A caminho do destinatário'), ('Destinatário ausente'), 
('Entregue'), ('Carga roubada'), ('Sujeito a multa');

alter table tbl_Pedido 
drop column ds_Status; 

alter table tbl_Pedido
	add constraint cd_Status foreign key (cd_Status) 
references tbl_Status (cd_Status);

create table tbl_StatusPedidoItem
(
	cd_StatusPedidoItem int primary key identity,
	ds_Status varchar(50) not null
)

create table tbl_PedidoItemLog
(
	cd_Pedido int,
	cd_Produto int,
	cd_StatusPedidoItem int,
	dt_Movimento dateTime,
	foreign key (cd_Pedido, cd_Produto) references tbl_PedidoItem (cd_Pedido, cd_Produto),
	foreign key (cd_StatusPedidoItem) references tbl_StatusPedidoItem (cd_StatusPedidoItem)
)

insert into tbl_StatusPedidoItem values
('Em adamento'), ('Em separação'), ('Embalado');

insert into tbl_PedidoItemLog
select cd_Pedido, cd_Produto, 1, getDate() from tbl_PedidoItem;

select 
	*
	from tbl_Clientes as cli
	inner join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente;

select 
	*
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente;

select 
	*
	from tbl_Clientes as cli
	right join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente;

select 
	*
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente
	where ped.Tt_Pedido > 10;

select 
	*
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente
	and ped.Tt_Pedido > 10;

select 
	cli.nm_Cliente,
	ped.Tt_Pedido,
	case 
		when cli.tp_Pessoa = 'F' then 'Pessoa física'
		when cli.tp_Pessoa = 'J' then 'Pessoa jurídica'
		else 
			'Pessoa indefinida'
	end as TipoPessoa
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente;

/* Inner join com tabelas com chaves composta*/

select 
	*
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem;

select 
	*
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem
	where vl_PedidoItem between 3 and 30

select 
	vl_PedidoItem * qt_PedidoItem as valorTotalPorQuantidadeProd
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem

select 
	sum(vl_PedidoItem * qt_PedidoItem) as ReceitaGerada
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem

select 
	avg(vl_PedidoItem) as PrecoMedio
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem

select 
	*
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem
	inner join tbl_Produtos as prod
	on pedI.cd_Produto = prod.cd_Produto;

select
	prod.cd_Produto,
	prod.ds_Produto,
	sum (pedI.vl_PedidoItem * pedI.qt_PedidoItem) as ReceitaPorProduto
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem
	inner join tbl_Produtos as prod
	on pedI.cd_Produto = prod.cd_Produto
	group by prod.cd_Produto, prod.nm_Produto, prod.ds_Produto;

/* 
	além desses filtros podemos utilizar um where p filtrar
	contudo, o where lê linhapor linha.
*/

select
	prod.cd_Produto,
	prod.ds_Produto,
	sum (pedI.vl_PedidoItem * pedI.qt_PedidoItem) as ReceitaPorProduto
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem
	inner join tbl_Produtos as prod
	on pedI.cd_Produto = prod.cd_Produto
	group by prod.cd_Produto, prod.nm_Produto, prod.ds_Produto
	order by 3 desc;

/* 
	podemos então, utilizar o having
	pois ele lê o retorno como um todo.
*/

select
	prod.cd_Produto,
	prod.ds_Produto,
	sum (pedI.vl_PedidoItem * pedI.qt_PedidoItem) as ReceitaPorProduto
	from tbl_PedidoItem as pedI
	inner join tbl_PedidoItemLog as pedIL
	on pedI.cd_Pedido = pedIL.cd_Pedido 
	and pedI.cd_Produto = pedIL.cd_Produto
	inner join tbl_StatusPedidoItem as SPItem
	on pedIL.cd_StatusPedidoItem = SPItem.cd_StatusPedidoItem
	inner join tbl_Produtos as prod
	on pedI.cd_Produto = prod.cd_Produto
	group by prod.cd_Produto, prod.nm_Produto, prod.ds_Produto
	having sum (pedI.vl_PedidoItem * pedI.qt_PedidoItem) > 10
	order by 3 desc;

/* 
	mostrando somente aqueles clientes 
	que não possuem pedidos.
*/

select
	*
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente
	where ped.cd_Pedido is null;

/* 
	mostrando clientes que possuem pedidos 
*/

select
	*
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente
	where ped.cd_Pedido is not null;

/* 
	mostrando quantidade de pedidos realizados
	por cada cliente
*/

select 
	cli.cd_Cliente,
	cli.nm_Cliente,
	count(ped.cd_Pedido) as PedidosSolicitados
	from tbl_Clientes as cli
	left join tbl_Pedido as ped
	on cli.cd_Cliente = ped.cd_Cliente
	group by cli.cd_Cliente, cli.nm_Cliente;

select 
	* 
	from tbl_Clientes as cli, tbl_Pedido as ped
