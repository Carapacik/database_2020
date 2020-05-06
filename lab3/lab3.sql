CREATE DATABASE injections
COLLATE Cyrillic_General_CI_AS

--1 INSERT
INSERT INTO Children 
VALUES
	('Alex','Dehunt','2005-05-05','0'),
	('Maria','Sanders','2004-04-05','1'),
	('Lola','Ops','2006-12-12','1'),
	('Mila','Gorina','2005-12-12','1');

INSERT INTO InjectionManufacturer 
VALUES
	('VOS','Moscow, Krasnoameyskaya 20,', 89991235656, 145),
	('MEM','Moscow, Krasnoameyskaya 19,', 89991235655, 160);
--
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) VALUES(1, 'Mels','holesterin','intramuscularly', '2020-04-04 13:00:00')
INSERT INTO Injection (type, name, contraindications, id_injectionmanufacturer, creation_date) VALUES ('intravenously', 'tuberculin', 'water', 1, '2020-04-04 13:30:00')
INSERT INTO Clinic (phone_number, address,name) VALUES (89912341245, 'Proskolskaya 28', 'Poloclinic №2')
--
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

--2 DELETE
DELETE DoneInjection
--
DELETE FROM Children WHERE gender = '0'
--
	--Заполнение строчки для проверки удаления
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

TRUNCATE TABLE DoneInjection

--3 UPDATE
UPDATE Injection SET contraindications = 'damage to brain'
--
UPDATE Children SET gender = '0' WHERE firstname = 'Lola'
--
UPDATE Children SET firstname = 'Gena', lastname = 'Gorin', birthdate = '2001-05-04' WHERE id_children = 3

--4 SELECT
SELECT firstname, lastname, gender FROM Children
--
SELECT * FROM Injection
--
SELECT * FROM Children WHERE gender = '1'

--5 SELECT ORDER BY + TOP (LIMIT)
SELECT TOP 3 * FROM Children ORDER BY birthdate ASC
--
SELECT TOP 3 * FROM Children ORDER BY birthdate DESC
--
SELECT TOP 3 * FROM Children ORDER BY birthdate, lastname DESC
--
SELECT TOP 3 * FROM Children ORDER BY firstname

--6 Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
	--Добавляю строку дял проверки
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) VALUES(1, 'Alos','holesterin','intramuscularly', '2020-04-04 13:00:00')

SELECT * FROM Injection WHERE creation_date = '2020-04-04 13:00:00'
--
SELECT creation_date, MONTH(creation_date) AS Month FROM Injection

--7 SELECT GROUP BY с функциями агрегации
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
--Заменил запрос неимеющий смысл, на норм запрос
SELECT name, id_clinic, COUNT(id_children) AS childrens_count FROM DoneInjection GROUP BY name, id_clinic HAVING name = 'Alos' OR name = 'tuberculin'; 
--
SELECT address, SUM(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address HAVING SUM(id_injectionmanufacturer) <= 2
--
SELECT firstname FROM Children GROUP BY firstname HAVING AVG(id_children) > 3

--9 SELECT JOIN
SELECT * FROM InjectionManufacturer LEFT JOIN Injection ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer WHERE type = 'intramuscularly'
--
	--Добавление строк для проверки
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

--Как в 9.1 только RIGHT JOIN
SELECT * FROM Injection RIGHT JOIN InjectionManufacturer ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer WHERE type = 'intramuscularly'
--
SELECT InjectionManufacturer.id_injectionmanufacturer, Injection.id_injection, InjectionManufacturer.number_of_employes, DoneInjection.id_injection, DoneInjection.name
FROM
InjectionManufacturer LEFT JOIN Injection ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer LEFT JOIN DoneInjection ON Injection.id_injection = DoneInjection.id_injection
WHERE InjectionManufacturer.id_injectionmanufacturer < 3 AND number_of_employes > 140 AND DoneInjection.id_injection > 0
--
SELECT * FROM Children FULL OUTER JOIN DoneInjection ON DoneInjection.id_children = Children.id_children

--10 Подзапросы
	--Добавление строк для наглядности
INSERT INTO Children VALUES('Alesha','Lastochkin','2003-09-10','0')
INSERT INTO Children VALUES('Bobik','Anatoliyev','2013-09-10','0')

SELECT * FROM Children WHERE firstname IN ('Maria', 'Mila')
--
	--Добавление строк для наглядности
INSERT INTO Injection (type, name, contraindications, id_injectionmanufacturer, creation_date) VALUES ('intravenously', 'automia', 'megaladon', 2, '2020-04-02 13:00:00')
SELECT id_injectionmanufacturer, type, (SELECT id_injection FROM Injection WHERE creation_date < '2020-04-03 0:20:00') AS id_injection FROM Injection