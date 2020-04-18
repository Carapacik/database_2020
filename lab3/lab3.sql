CREATE DATABASE ChildrenInjection
COLLATE Cyrillic_General_CI_AS

CREATE TABLE Children (
id_children int IDENTITY(1,1) NOT NULL,
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
birthdate date NOT NULL,
gender varchar(10) NOT NULL,
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

--1 INSERT
INSERT INTO Children VALUES('Alex','Dehunt','2005-05-05','male')
INSERT INTO Children VALUES('Maria','Sanders','2004-04-05','female')
INSERT INTO Children VALUES('Lola','Ops','2006-12-12','female')
INSERT INTO Children VALUES('Mila','Gorina','2005-12-12','female')
INSERT INTO InjectionManufacturer VALUES('VOS','Moscow, Krasnoameyskaya 20,', 89991235656, 145)
INSERT INTO InjectionManufacturer VALUES('MEM','Moscow, Krasnoameyskaya 19,', 89991235655, 160)
--
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) VALUES(1, 'Mels','holesterin','intramuscularly', '2020-04-04 13:00:00')
INSERT INTO Injection (type, name, contraindications, id_injectionmanufacturer, creation_date) VALUES ('intravenously', 'tuberculin', 'water', 1, '2020-04-04 13:30:00')
INSERT INTO Clinic (phone_number, address,name) VALUES (89912341245, 'Proskolskaya 28', 'Poloclinic �2')
--
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic



--2 DELETE
DELETE DoneInjection
--
DELETE FROM Children WHERE gender = 'male'
--
	--���������� ������� ��� �������� ��������
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

TRUNCATE TABLE DoneInjection

--3 UPDATE
UPDATE Injection SET contraindications = 'damage to brain'
--
UPDATE Children SET gender = 'male' WHERE firstname = 'Lola'
--
UPDATE Children SET firstname = 'Gena', lastname = 'Gorin', birthdate = '2001-05-04' WHERE id_children = 3

--4 SELECT
SELECT firstname, lastname, gender FROM Children
--
SELECT * FROM Injection
--
SELECT * FROM Children WHERE gender = 'female'

--5 SELECT ORDER BY + TOP (LIMIT)
SELECT TOP 3 * FROM Children ORDER BY birthdate ASC
--
SELECT TOP 3 * FROM Children ORDER BY birthdate DESC
--
SELECT TOP 3 * FROM Children ORDER BY birthdate, lastname DESC
--
SELECT TOP 3 * FROM Children ORDER BY firstname

--6 ������ � ������. ����������, ����� ���� �� ������ ��������� ������� � ����� DATETIME
	--�������� ������ ��� ��������
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) VALUES(1, 'Alos','holesterin','intramuscularly', '2020-04-04 13:00:00')

SELECT * FROM Injection WHERE creation_date = '2020-04-04 13:00:00'
--
SELECT creation_date, MONTH(creation_date) FROM Injection

--7 SELECT GROUP BY � ��������� ���������
SELECT firstname, MIN(birthdate) AS min_birthdate FROM Children GROUP BY firstname
--
SELECT firstname, MAX(birthdate) AS max_birthdate FROM Children GROUP BY firstname
--
SELECT firstname, AVG(id_children) AS avg_id_children FROM Children GROUP BY firstname
--
SELECT address, SUM(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address
--
SELECT address, COUNT(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address

--8 SELECT GROUP BY + HAVING
SELECT firstname FROM Children GROUP BY firstname HAVING MAX(id_children) > 2
--
SELECT address, SUM(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address HAVING SUM(id_injectionmanufacturer) <= 2
--
SELECT firstname FROM Children GROUP BY firstname HAVING AVG(id_children) > 3

--9 SELECT JOIN
SELECT * FROM InjectionManufacturer LEFT JOIN Injection ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer WHERE type = 'intramuscularly'
--
	--���������� ����� ��� ��������
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

SELECT * FROM Children RIGHT JOIN DoneInjection ON Children.id_children = DoneInjection.id_children WHERE type = 'intramuscularly'
--
SELECT InjectionManufacturer.id_injectionmanufacturer, Injection.id_injection, InjectionManufacturer.number_of_employes, DoneInjection.id_injection, DoneInjection.name
FROM
InjectionManufacturer LEFT JOIN Injection ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer LEFT JOIN DoneInjection ON Injection.id_injection = DoneInjection.id_injection
WHERE InjectionManufacturer.id_injectionmanufacturer < 3 AND number_of_employes > 140 AND DoneInjection.id_injection > 0
--
SELECT * FROM Children FULL OUTER JOIN DoneInjection ON DoneInjection.id_children = Children.id_children

--10 ����������
	--���������� ����� ��� �����������
INSERT INTO Children VALUES('Alesha','Lastochkin','2003-09-10','male')
INSERT INTO Children VALUES('Bobik','Anatoliyev','2013-09-10','male')

SELECT * FROM Children WHERE firstname IN ('Maria', 'Mila')
--
	--���������� ����� ��� �����������
INSERT INTO Injection (type, name, contraindications, id_injectionmanufacturer, creation_date) VALUES ('intravenously', 'automia', 'megaladon', 2, '2020-04-02 13:00:00')
SELECT id_injectionmanufacturer, type, (SELECT id_injection FROM Injection WHERE creation_date < '2020-04-03 0:20:00') AS id_injection FROM Injection