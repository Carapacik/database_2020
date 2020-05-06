USE [injections]
GO

CREATE TABLE Children (
id_children int IDENTITY(1,1) NOT NULL,
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
birthdate date NOT NULL,
gender tinyint NOT NULL,
PRIMARY KEY  (id_children)
)
GO

CREATE TABLE Injection (
id_injection int IDENTITY(1,1) NOT NULL,
id_injectionmanufacturer int NOT NULL,
name varchar(50) NOT NULL,
contraindications varchar(50) NOT NULL,
type varchar(50) NOT NULL,
creation_date datetime NOT NULL,
PRIMARY KEY (id_injection)
)
GO

CREATE TABLE DoneInjection (
id_doneinjection int IDENTITY(1,1) NOT NULL,
id_children int NOT NULL,
id_injection int NOT NULL,
id_clinic int NOT NULL,
name varchar(50) NOT NULL,
type varchar(50) NOT NULL,
creation_date datetime NOT NULL,
PRIMARY KEY (id_doneinjection)
)
GO

CREATE TABLE Clinic (
id_clinic int IDENTITY(1,1) NOT NULL,
name varchar(50) NOT NULL,
address varchar(50) NOT NULL,
phone_number decimal(12) NOT NULL,
PRIMARY KEY (id_clinic)
)
GO

CREATE TABLE InjectionManufacturer(
id_injectionmanufacturer int IDENTITY(1,1) NOT NULL,
name varchar(50) NOT NULL,
address varchar(50) NOT NULL,
phone_number decimal(12) NOT NULL,
number_of_employes smallint NOT NULL,
PRIMARY KEY (id_injectionmanufacturer)
)
GO

ALTER TABLE DoneInjection 
ADD FOREIGN KEY (id_injection) REFERENCES Injection (id_injection);

ALTER TABLE DoneInjection 
ADD FOREIGN KEY (id_clinic) REFERENCES Clinic (id_clinic);

ALTER TABLE DoneInjection 
ADD FOREIGN KEY (id_children) REFERENCES Children (id_children);

ALTER TABLE Injection 
ADD FOREIGN KEY (id_injectionmanufacturer) REFERENCES InjectionManufacturer (id_injectionmanufacturer);