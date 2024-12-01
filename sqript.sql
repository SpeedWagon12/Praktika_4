- public.patient определение

-- Drop table

-- DROP TABLE patient;

CREATE TABLE patient (
	id_patient smallserial NOT NULL,
	last_name varchar NULL,
	first_name varchar NULL,
	patronymic varchar NULL,
	date_birth date NULL,
	address varchar NULL,
	CONSTRAINT patient_pk PRIMARY KEY (id_patient)
);

-- Permissions

ALTER TABLE patient OWNER TO postgres;
GRANT ALL ON TABLE patient TO postgres;


-- public.specialization_doctors определение

-- Drop table

-- DROP TABLE specialization_doctors;

CREATE TABLE specialization_doctors (
	id_specialization smallserial NOT NULL,
	specialization varchar NULL,
	CONSTRAINT specialization_doctors_pk PRIMARY KEY (id_specialization)
);

-- Permissions

ALTER TABLE specialization_doctors OWNER TO postgres;
GRANT ALL ON TABLE specialization_doctors TO postgres;


-- public.doctors определение

-- Drop table

-- DROP TABLE doctors;

CREATE TABLE doctors (
	id_doctors smallserial NOT NULL,
	last_name varchar NULL,
	first_name varchar NULL,
	patronymic varchar NULL,
	id_specialization int2 NOT NULL,
	CONSTRAINT doctors_pk PRIMARY KEY (id_doctors),
	CONSTRAINT doctors_specialization_doctors_fk FOREIGN KEY (id_specialization) REFERENCES specialization_doctors(id_specialization) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE doctors OWNER TO postgres;
GRANT ALL ON TABLE doctors TO postgres;


-- public.reception определение

-- Drop table

-- DROP TABLE reception;

CREATE TABLE reception (
	id_reception smallserial NOT NULL,
	id_patient int2 NOT NULL,
	id_doctors int2 NOT NULL,
	date_reception timestamp NULL,
	price_reception numeric NULL,
	percentage_salary numeric NULL,
	salary numeric NULL,
	CONSTRAINT reception_pk PRIMARY KEY (id_reception),
	CONSTRAINT reception_doctors_fk FOREIGN KEY (id_doctors) REFERENCES doctors(id_doctors) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT reception_patient_fk FOREIGN KEY (id_patient) REFERENCES patient(id_patient) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table Triggers
-- DROP FUNCTION public.salary_check();

CREATE OR REPLACE FUNCTION public.salary_check()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin 
	new.salary = new.price_reception * (new.percentage_salary/100) * 0.87;
return new;
end;
$function$
;

-- Permissions

ALTER FUNCTION public.salary_check() OWNER TO postgres;
GRANT ALL ON FUNCTION public.salary_check() TO postgres;
create trigger salary_trigger before
insert
    or
update
    on
    public.reception for each row execute function salary_check();

-- Permissions

ALTER TABLE reception OWNER TO postgres;
GRANT ALL ON TABLE reception TO postgres;
INSERT INTO public.doctors (id_doctors,last_name,first_name,patronymic,id_specialization) VALUES
	 (25,'Чушкина','Ника','Генадьевна',1),
	 (26,'Попадосиков','Кирилл','Александрович',10),
	 (27,'Никитин','Олег','Олегович',5),
	 (28,'Горький','Виктор','Михайлович',8),
	 (29,'Сладкий','Иван','Тимурович',2),
	 (30,'Компотов','Данил','Андреевич',4),
	 (31,'Картаева','Карина','Викторовна',9),
	 (32,'Украинова','Афродита','Алексеевна',3),
	 (33,'Дедушкина','Галина','Николаевна',6),
	 (34,'Гречкова','Елизавета','Адреевна',7);
INSERT INTO public.patient (id_patient,last_name,first_name,patronymic,date_birth,address) VALUES
	 (2,'Дмитриев','Динар','Кириллович','2006-07-16','ул.Пушкина'),
	 (3,'Барсуков','Софья','Александровна','2006-12-23','ул.Мира'),
	 (4,'Бобиков','Тимофей','Папиков','2006-03-12','ул.Комсомольская'),
	 (5,'Грейпфрутов','Никита','Адександрович','2008-04-15','ул.Куйбышева'),
	 (6,'Панин','Павел','Генадьевич','2005-05-21','ул.Татарстана'),
	 (7,'Андреев','Павел','Николаевич','2002-09-03','ул.Энгельса'),
	 (8,'Базарова','Дарья','Старославовна','2005-06-18','ул.Шоссейная'),
	 (9,'Пчелкина','Татьяна','Рустамовна','2007-10-18','ул.Комарова'),
	 (10,'Молодикова','Виктория','Станиславовна','2003-10-17','ул.Есенина'),
	 (11,'Бибибулин','Инсаф','Назарович','2004-01-19','ул.Коралева');
INSERT INTO public.reception (id_reception,id_patient,id_doctors,date_reception,price_reception,percentage_salary,salary) VALUES
	 (10,2,25,'1999-02-02 00:00:00',23333,5,1014.9855000000000000000000),
	 (11,6,32,'2022-01-11 00:00:00',20000,4,696.0000000000000000000000),
	 (12,5,30,'2022-11-03 00:00:00',21000,9,1644.3000000000000000000000),
	 (13,9,27,'2023-11-07 00:00:00',19000,5,826.5000000000000000000000),
	 (14,3,26,'2019-10-10 00:00:00',12222,7,744.3198000000000000000000),
	 (15,8,31,'2011-01-12 00:00:00',25000,4,870.0000000000000000000000),
	 (16,7,28,'2020-11-30 00:00:00',10000,5,435.0000000000000000000000),
	 (17,4,33,'2024-10-03 00:00:00',20000,3,522.0000000000000000000000),
	 (18,10,29,'2022-11-11 00:00:00',15000,6,783.0000000000000000000000),
	 (19,11,34,'2015-12-22 00:00:00',10000,45,3915.0000000000000000000000);
INSERT INTO public.specialization_doctors (id_specialization,specialization) VALUES
	 (2,'Хирург'),
	 (3,'Педиатор'),
	 (5,'Диетолог'),
	 (7,'Ортопед'),
	 (9,'Стоматолог'),
	 (10,'Кардиолог'),
	 (1,'Очкодонт'),
	 (4,'Галинололог'),
	 (6,'Невролог'),
	 (8,'Педаголог');
