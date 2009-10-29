Syntax
======

* C - reate
* R - etrieve
* U - pdate
* D - elete

Creating tables to store data:

    create table people (id int, name text ...)

Putting data in tables:

    insert into people (name....) VALUES('Mat')

Changing the data:

    update people set can_drink = true where age > 21

Removing data:

    delete from people where age > 120

Reporting on/retrieving data:

    select * from people where name = 'Mat'
    select count(*) from people where name like 'Mat%'
    select age, count(*) as age_count from people group by age
    select substr(name, 4) as abbreviated_name from people;

Relationships
=============

Normally OOP systems have parents that contain information about the children.

    class Parent {
      Child[] children = ...
    }

Relational systems have the reverse, children contain information about their parents.

    create table parents (id int, ...)
    create table children (id int, parent_id int, ...)

Three common relationships between tables

         1 -------------------------------> 1
    (belongs_to)                        (has_one)
    
       1 <-------------------------------- many
    (has_many)                         (belongs_to)
    
       many <-------------||--------------> many
    (has_many)  (belongs_to/belongs_to)  (has_many)

What's the common term in all 3 relationships?

Joining
=======

Let's you put data from two tables in each row. There are a number of different joins, but the only
one I ever remember or use is "left outer".
