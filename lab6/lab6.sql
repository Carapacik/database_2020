﻿CREATE DATABASE university
COLLATE Cyrillic_General_CI_AS

--1 Добавить внешние ключи
ALTER TABLE lesson 
ADD FOREIGN KEY (id_group) REFERENCES [group] (id_group);

ALTER TABLE student
ADD FOREIGN KEY (id_group) REFERENCES [group] (id_group);

ALTER TABLE lesson 
ADD FOREIGN KEY (id_subject) REFERENCES subject (id_subject);

ALTER TABLE lesson 
ADD FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher);

ALTER TABLE mark 
ADD FOREIGN KEY (id_lesson) REFERENCES lesson (id_lesson);

ALTER TABLE mark 
ADD FOREIGN KEY (id_student) REFERENCES student (id_student);

--2 Выдать оценки студентов по информатике если они обучаются данному
--  предмету. Оформить выдачу данных с использованием view
CREATE VIEW marks_students AS
SELECT 
	student.name,
	mark.mark
FROM mark
INNER JOIN lesson on mark.id_lesson = lesson.id_lesson
INNER JOIN student on mark.id_student = student.id_student
INNER JOIN subject on lesson.id_subject = subject.id_subject
WHERE subject.name = 'Информатика';
	
SELECT * FROM marks_students
--3 Дать информацию о должниках с указанием фамилии студента и названия предмета. 
--  Должниками считаются студенты, не имеющие оценки по предмету,
--  который ведется в группе. Оформить в виде процедуры, на входе идентификатор группы
CREATE PROCEDURE debtors
@id_group int
AS
SELECT 
	student.name,
	subject.name,
	[group].name
FROM student
INNER JOIN [group] ON [group].id_group = student.id_group
INNER JOIN lesson ON lesson.id_group = [group].id_group
INNER JOIN subject ON subject.id_subject = lesson.id_subject
LEFT JOIN mark ON mark.id_student = student.id_student AND mark.id_lesson = lesson.id_lesson
WHERE [group].id_group = @id_group
GROUP BY student.name, subject.name, [group].name
HAVING COUNT(mark.mark) = 0
ORDER BY student.name
GO

	-- Запуск процедуры
EXECUTE debtors @id_group = 1
EXECUTE debtors @id_group = 2
EXECUTE debtors @id_group = 3
EXECUTE debtors @id_group = 4

--4 Дать среднюю оценку студентов по каждому предмету для тех предметов, по
--  которым занимается не менее 35 студентов
SELECT 
	subject.name, 
	AVG(mark.mark) AS average_mark,
	COUNT (mark.mark) AS count_mark
FROM student
LEFT JOIN [group] ON student.id_group = [group].id_group
LEFT JOIN lesson ON [group].id_group = lesson.id_group
LEFT JOIN mark ON (lesson.id_lesson = mark.id_lesson AND mark.id_student = student.id_student)
LEFT JOIN [subject] ON lesson.id_subject = [subject].id_subject
GROUP BY subject.name
HAVING COUNT(DISTINCT student.id_student) >= 35;

	-- Количество студентов по предметам
SELECT 
	subject.name,
	COUNT(DISTINCT student.id_student) AS students_count
FROM student
LEFT JOIN [group] ON student.id_group = [group].id_group
LEFT JOIN lesson ON [group].id_group = lesson.id_group
LEFT JOIN mark ON (lesson.id_lesson = mark.id_lesson AND mark.id_student = student.id_student)
LEFT JOIN [subject] ON lesson.id_subject = [subject].id_subject
GROUP BY subject.name;

--5 Дать оценки студентов специальности ВМ по всем проводимым предметам с
--  указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
--  значениями NULL поля оценки
SELECT 
	mark.mark,
	[group].name,
	student.name,
	subject.name AS subject_name,
	lesson.date
FROM student
LEFT JOIN [group] ON student.id_group = [group].id_group
LEFT JOIN lesson ON lesson.id_group = [group].id_group
LEFT JOIN subject ON lesson.id_subject = subject.id_subject
LEFT JOIN mark ON (lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student)
WHERE [group].name = 'ВМ';

--6 Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД 
--  до 12.05, повысить эти оценки на 1 балл
UPDATE mark
SET mark = mark + 1
FROM mark
INNER JOIN student ON student.id_student = mark.id_student
INNER JOIN [group] ON [group].id_group = student.id_group
INNER JOIN lesson ON  lesson.id_lesson = mark.id_lesson
INNER JOIN subject ON subject.id_subject = lesson.id_subject
WHERE
	[group].name = 'ПС' AND 
	mark.mark < 5 AND 
	subject.name = 'БД' AND
	lesson.date < '2019-05-12';

--7 Добавить необходимые индексы
CREATE NONCLUSTERED INDEX [IX_lesson_id_teacher] ON [dbo].[lesson](
	[id_teacher] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_id_subject] ON [dbo].[lesson](
	[id_subject] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_id_group] ON [dbo].[lesson](
	[id_group] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_id_lesson] ON [dbo].[mark](
	[id_lesson] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_id_student] ON [dbo].[mark](
	[id_student] ASC
)

CREATE NONCLUSTERED INDEX [IX_student_id_group] ON [dbo].[student](
	[id_group] ASC
)

CREATE NONCLUSTERED INDEX [IX_group_name] ON [dbo].[group](
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_student_name] ON [dbo].[student](
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_subject_name] ON [dbo].[subject](
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_teacher_name] ON [dbo].[teacher](
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_mark] ON [dbo].[mark]
(
	[mark] ASC
)

CREATE UNIQUE NONCLUSTERED INDEX [IU_student_phone] ON [dbo].[student](
	[phone] ASC
)