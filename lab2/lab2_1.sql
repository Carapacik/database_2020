CREATE DATABASE hairdresser
COLLATE Cyrillic_General_CI_AS

CREATE TABLE HairDresser (
id_hairdresser int IDENTITY(1,1) NOT NULL,
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
work_experience tinyint NOT NULL,
gender tinyint NOT NULL,
PRIMARY KEY  (id_hairdresser)
)
GO

CREATE TABLE Service(
id_service int IDENTITY(1,1) NOT NULL,
type varchar(50) NOT NULL,
price money NOT NULL,
PRIMARY KEY (id_service)
)
GO

CREATE TABLE ServicesPerformed(
id_servicesperformed int IDENTITY(1,1) NOT NULL,
id_hairdresser int NOT NULL,
id_service int NOT NULL,
type varchar(50) NOT NULL,
price money NOT NULL,
date date NOT NULL,
evaluation tinyint NOT NULL,
PRIMARY KEY  (id_servicesperformed)
)
GO

ALTER TABLE ServicesPerformed
ADD FOREIGN KEY (id_hairdresser) REFERENCES HairDresser(id_hairdresser);

ALTER TABLE ServicesPerformed
ADD FOREIGN KEY (id_service) REFERENCES Service (id_service);