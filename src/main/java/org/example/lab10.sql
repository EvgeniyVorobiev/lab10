drop table students;
drop table subjects;
drop table progress;

create tablespace lab10 LOCATION 'C:\lab10';
create database lab10base TABLESPACE lab10space;
\c lab10base;
create schema lab10;
set search_path = lab10;

create table students(
id serial not null primary key, name varchar(40) not null,
 passport_series integer not null unique , passport_number integer null null unique);

create table subjects(
id serial not null primary key, subject_name varchar(40) not null
);

create table progress(
id serial not null primary key, student_id integer, subject_id integer,
    mark integer check (mark >= 2 and mark <= 5),
constraint fkey_stud_prog foreign key(student_id) references students(id)
    on delete cascade on update cascade,
constraint fkey_stud_sub foreign key(subject_id) references subjects(id)
    on delete cascade on update cascade
);



insert into students (name, passport_series, passport_number) values ('Евгений', 666, 666);
insert into students (name, passport_series, passport_number) values ('Данила', 3232, 545675);
insert into students (name, passport_series, passport_number) values ('Виктория', 8247, 6217653);
insert into students (name, passport_series, passport_number) values ('Олег', 1126, 087876);
insert into students (name, passport_series, passport_number) values ('Гело', 6211, 677670);
insert into students (name, passport_series, passport_number) values ('Артём', 2437, 567678);
insert into students (name, passport_series, passport_number) values ('Мётра', 2237, 567978);
--insert into students (name, passport_series, passport_number) values ('Никита', 3232, 545675);

insert into subjects (subject_name) values ('Технологии программирования');
insert into subjects (subject_name) values ('Управление данными');
insert into subjects (subject_name) values ('Физическая культура');
insert into subjects (subject_name) values ('Математика');

--insert into progress (student_id, subject_id, mark) values (1, 1, 1);
insert into progress (student_id, subject_id, mark) values (1, 1, 5);
insert into progress (student_id, subject_id, mark) values (1, 2, 5);
insert into progress (student_id, subject_id, mark) values (1, 3, 5);
insert into progress (student_id, subject_id, mark) values (1, 4, 5);
insert into progress (student_id, subject_id, mark) values (2, 1, 4);
insert into progress (student_id, subject_id, mark) values (2, 2, 3);
insert into progress (student_id, subject_id, mark) values (2, 3, 5);
insert into progress (student_id, subject_id, mark) values (2, 4, 2);
insert into progress (student_id, subject_id, mark) values (3, 1, 5);
insert into progress (student_id, subject_id, mark) values (3, 2, 3);
insert into progress (student_id, subject_id, mark) values (3, 3, 5);
insert into progress (student_id, subject_id, mark) values (3, 4, 5);
insert into progress (student_id, subject_id, mark) values (4, 1, 4);
insert into progress (student_id, subject_id, mark) values (4, 2, 3);
insert into progress (student_id, subject_id, mark) values (4, 3, 3);
insert into progress (student_id, subject_id, mark) values (4, 4, 5);
insert into progress (student_id, subject_id, mark) values (5, 1, 5);
insert into progress (student_id, subject_id, mark) values (5, 2, 4);
insert into progress (student_id, subject_id, mark) values (5, 3, 2);
insert into progress (student_id, subject_id, mark) values (5, 4, 5);
insert into progress (student_id, subject_id, mark) values (6, 1, 5);
insert into progress (student_id, subject_id, mark) values (6, 2, 5);
insert into progress (student_id, subject_id, mark) values (6, 3, 5);
insert into progress (student_id, subject_id, mark) values (6, 4, 5);
insert into progress (student_id, subject_id, mark) values (7, 1, 5);
insert into progress (student_id, subject_id, mark) values (7, 2, 5);
insert into progress (student_id, subject_id, mark) values (7, 3, 5);
insert into progress (student_id, subject_id, mark) values (7, 4, 5);

select stud.name, subj.subject_name, p.mark
from students as stud
         join progress as p on stud.id = p.student_id
         join subjects as subj on p.subject_id = subj.id;

select stud.name, subj.subject_name, p.mark
from students as stud
         join progress as p on stud.id = p.student_id
         join subjects as subj on p.subject_id = subj.id where subj.subject_name = 'Физическая культура' and p.mark > 3;

select subj.subject_name ,avg(p.mark) from progress as p join subjects as subj
    on p.subject_id = subj.id where subj.subject_name = 'Управление данными'
group by subj.subject_name;

select stud.name ,avg(p.mark) from progress as p join students as stud
    on p.student_id = stud.id where stud.name = 'Евгений'
group by stud.name;

select distinct subj.subject_name from progress as p join subjects as subj
on p.subject_id = subj.id where p.mark > 2 limit 3;

create function get_avg_mark (subject varchar(40))
returns real
as $$
    DECLARE avg_mark real;
    begin
        select avg(progress.mark) into avg_mark from progress join subjects on progress.subject_id = subjects.id
        where subjects.subject_name = subject;
        return avg_mark;
    end;
    $$ language plpgsql;

--select get_avg_mark('Технологии программирования');
--select get_avg_mark('Управление данными');

select  get_avg_mark(subj.subject_name), subj.subject_name, stud.name, p.mark from students as stud
    join progress as p on stud.id = p.student_id
    join subjects as subj on p.subject_id = subj.id
group by p.mark, stud.name, subj.subject_name having (p.mark > get_avg_mark(subj.subject_name) and subj.subject_name = 'Технологии программирования')
   or (p.mark > get_avg_mark(subj.subject_name) and subj.subject_name = 'Управление данными');


select stud.name, subj.subject_name, p.mark
from students as stud
         join progress as p on stud.id = p.student_id
         join subjects as subj on p.subject_id = subj.id where p.mark > 3 group by stud.name, subj.subject_name, p.mark;

--список студентов, которые выходят на стипендию
--список студентов у которых управление данными и тп выше среднего по группе
