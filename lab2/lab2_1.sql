CREATE DATABASE Hairdresser
COLLATE Cyrillic_General_CI_AS

CREATE TABLE HairDresser (
id_hairdresser int IDENTITY(1,1) NOT NULL,
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
work_experience tinyint NOT NULL,
gender varchar(10) NOT NULL,
PRIMARY KEY  (id_hairdresser)
)
GO

CREATE TABLE Service(
id_service int IDENTITY(1,1) NOT NULL,
id_hairdresser int NOT NULL,
type varchar(50) NOT NULL,
price decimal(5,2) NOT NULL,
PRIMARY KEY  (id_service)
)
GO

CREATE TABLE ServicesPerformed(
id_servicesperformed int IDENTITY(1,1) NOT NULL,
id_hairdresser int NOT NULL,
id_service int NOT NULL,
type varchar(50) NOT NULL,
price decimal(5,2) NOT NULL,
date date NOT NULL,
evaluation tinyint NOT NULL,
PRIMARY KEY  (id_servicesperformed)
)
GO