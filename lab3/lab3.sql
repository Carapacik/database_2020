CREATE DATABASE injections
COLLATE Cyrillic_General_CI_AS

--1 INSERT

--  Без указания списка полей
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

--  С указанием списка полей
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) VALUES(1, 'Mels','holesterin','intramuscularly', '2020-04-04 13:00:00')
INSERT INTO Injection (type, name, contraindications, id_injectionmanufacturer, creation_date) VALUES ('intravenously', 'tuberculin', 'water', 1, '2020-04-04 13:30:00')
INSERT INTO Clinic (phone_number, address,name) VALUES (89912341245, 'Proskolskaya 28', 'Poloclinic №2')

--  С чтением значения из другой таблицы
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

--2 DELETE

--  Всех записей
DELETE DoneInjection

--  По условию
DELETE FROM Children WHERE gender = '0'

	-- Заполнение строчки для проверки удаления
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

TRUNCATE TABLE DoneInjection

--3 UPDATE

--  Всех записей
UPDATE Injection SET contraindications = 'damage to brain'

--  По условию обновляя один атрибут
UPDATE Children SET gender = '0' WHERE firstname = 'Lola'

--  По условию обновляя несколько атрибутов
UPDATE Children SET firstname = 'Gena', lastname = 'Gorin', birthdate = '2001-05-04' WHERE id_children = 3

--4 SELECT

-- С определенным набором извлекаемых атрибутов
SELECT firstname, lastname, gender FROM Children

--  Со всеми атрибутами (SELECT * FROM...)
SELECT * FROM Injection

--  С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
SELECT * FROM Children WHERE gender = '1'

--5 SELECT ORDER BY + TOP (LIMIT)

--  С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 3 * FROM Children ORDER BY birthdate ASC

--  С сортировкой по убыванию DESC
SELECT TOP 3 * FROM Children ORDER BY birthdate DESC

--  С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT TOP 3 * FROM Children ORDER BY birthdate, lastname DESC

--  С сортировкой по первому атрибуту, из списка извлекаемых
SELECT TOP 3 * FROM Children ORDER BY firstname

--6 Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME

	-- Добавляю строку для проверки
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) VALUES(1, 'Alos','holesterin','intramuscularly', '2020-04-04 13:00:00')

-- WHERE по дате
SELECT * FROM Injection WHERE creation_date = '2020-04-04 13:00:00'

--  Извлечь из таблицы не всю дату
SELECT creation_date, MONTH(creation_date) AS Month FROM Injection

--7 SELECT GROUP BY с функциями агрегации

--  MIN
SELECT firstname, MIN(birthdate) AS min_birthdate FROM Children GROUP BY firstname

--  MAX
SELECT firstname, MAX(birthdate) AS max_birthdate FROM Children GROUP BY firstname

--  AVG
SELECT firstname, AVG(id_children) AS avg_id_children FROM Children GROUP BY firstname

--  SUM
SELECT address, SUM(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address

--  COUNT
SELECT address, COUNT(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address

--8 SELECT GROUP BY + HAVING. Написать 3 любых запроса с использованием GROUP BY + HAVING

	-- Добавление строк для проверки
INSERT INTO Injection (id_injectionmanufacturer, name, contraindications, type, creation_date) 
VALUES
	(1, 'Mels','holesterin','intramuscularly', '2020-04-04 12:00:00'),
	(2, 'tuberculin','water','intramuscularly', '2020-04-04 12:00:00'),
	(1, 'tuberculin','water','intramuscularly', '2020-04-04 12:01:00');
--  Заменил запрос неимеющий смысл, на норм запрос
SELECT name, id_injectionmanufacturer FROM Injection GROUP BY name, id_injectionmanufacturer HAVING MAX(creation_date) < '2020-04-04 13:30:00.000'; 

SELECT address, SUM(id_injectionmanufacturer) AS sum_id_injectionmanufacturer FROM InjectionManufacturer GROUP BY address HAVING SUM(id_injectionmanufacturer) <= 2

SELECT firstname FROM Children GROUP BY firstname HAVING AVG(id_children) > 3

--9 SELECT JOIN

--  LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT * FROM InjectionManufacturer LEFT JOIN Injection ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer WHERE type = 'intramuscularly'

	-- Добавление строк для проверки
INSERT INTO DoneInjection (id_children, id_injection, name, type, id_clinic, creation_date) 
SELECT Child.id_children, Inj.id_injection, Inj.name, Inj.type, Clinic.id_clinic, Inj.creation_date
FROM Children AS Child, Injection AS Inj, Clinic AS Clinic

--  RIGHT JOIN. Получить такую же выборку, как и в 9.1
SELECT * FROM Injection RIGHT JOIN InjectionManufacturer ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer WHERE type = 'intramuscularly'

--  LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT InjectionManufacturer.id_injectionmanufacturer, Injection.id_injection, InjectionManufacturer.number_of_employes, DoneInjection.id_injection, DoneInjection.name
FROM
InjectionManufacturer LEFT JOIN Injection ON InjectionManufacturer.id_injectionmanufacturer = Injection.id_injectionmanufacturer LEFT JOIN DoneInjection ON Injection.id_injection = DoneInjection.id_injection
WHERE InjectionManufacturer.id_injectionmanufacturer < 3 AND number_of_employes > 140 AND DoneInjection.id_injection > 0

--  FULL OUTER JOIN двух таблиц
SELECT * FROM Children FULL OUTER JOIN DoneInjection ON DoneInjection.id_children = Children.id_children

--10 Подзапросы
	-- Добавляю строку для проверки
INSERT INTO Children VALUES('Alesha','Lastochkin','2003-09-10','0')
INSERT INTO Children VALUES('Bobik','Anatoliyev','2013-09-10','0')

--  Написать запрос с WHERE IN (подзапрос)
SELECT * FROM Children WHERE firstname IN ('Maria', 'Mila')

	-- Добавляю строку для проверки
INSERT INTO Injection (type, name, contraindications, id_injectionmanufacturer, creation_date) VALUES ('intravenously', 'automia', 'megaladon', 2, '2020-04-02 13:00:00')

--  Написать запрос SELECT atr1, atr2, (подзапрос) FROM
SELECT id_injectionmanufacturer, type, (SELECT id_injection FROM Injection WHERE creation_date < '2020-04-03 0:20:00') AS id_injection FROM Injection