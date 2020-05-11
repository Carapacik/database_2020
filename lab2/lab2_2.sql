CREATE DATABASE ProductsInInvoices
COLLATE Cyrillic_General_CI_AS

CREATE TABLE Product (
id_product int IDENTITY(1,1) NOT NULL,
cost decimal(7,2) NOT NULL,
name varchar(50) NOT NULL,
manufacturer varchar(50) NOT NULL,
PRIMARY KEY  (id_product)
)
GO

CREATE TABLE Invoice (
id_invoice int IDENTITY(1,1) NOT NULL,
provider varchar(50) NOT NULL,
customer varchar(50) NOT NULL,
quantity smallint NOT NULL,
date date NOT NULL,
PRIMARY KEY  (id_invoice)
)
GO

CREATE TABLE ProductsInInvoices (
id_productsininvoices int IDENTITY(1,1) NOT NULL,
id_product int NOT NULL,
id_invoice int NOT NULL,
quantity smallint NOT NULL,
date date NOT NULL,
PRIMARY KEY  (id_productsininvoices)
)
GO

ALTER TABLE ProductsInInvoices
ADD FOREIGN KEY (id_product) REFERENCES Product(id_product);

ALTER TABLE ProductsInInvoices
ADD FOREIGN KEY (id_invoice) REFERENCES Invoice (id_invoice);