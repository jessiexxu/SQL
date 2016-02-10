-- table 1: Highschooler ( ID, name, grade )
            -- There is a high school student with unique ID and a given first name in a certain grade.
-- table 2: Friend ( ID1, ID2 ) 
            -- The student with ID1 is friends with the student with ID2. Friendship is mutual. 
-- table 3: Likes ( ID1, ID2 ) 
            -- The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual.

-- Q1. Find the names of all students who are friends with someone named Gabriel.
select name
  from highschooler
where id in 
    (select id2 from friend 
       join highschooler on id = id1 
     where name = "Gabriel");

-- Q2. For every student who likes someone 2 or more grades younger than themselves, 
-- return that student's name and grade, and the name and grade of the student they like. 
select h1.name as name, h1.grade as grade, h2.name as like_name, h2.grade as like_grade
  from highschooler h1
  join likes on h1.id = id1
  join highschooler h2 on h2.id = id2
where h1.grade - h2.grade >=2;

-- Q3. For every pair of students who both like each other, return the name and grade of both students. 
-- Include each pair only once, with the two names in alphabetical order. 
select h1.name as name, h1.grade as grade, h2.name as like_name, h2.grade as like_grade
  from highschooler h1
  join likes on h1.id = id1
  join highschooler h2 on h2.id = id2
where h1.name < h2.name and id1 in 
    (select l1.id1 from likes l1
       join likes l2 on l1.id1 = l2.id2 and l1.id2 = l2.id1) 
order by h1.name, h2.name;

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) 
-- and return their names and grades. Sort by grade, then by name within each grade.
select name, grade
  from highschooler
where id not in 
    (select id1 from likes 
       union 
     select id2 from likes)
order by grade, name;

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes 
-- (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select h1.name as name, h1.grade as grade, h2.name as like_name, h2.grade as like_grade
  from highschooler h1
  join likes on h1.id = id1
  join highschooler h2 on h2.id = id2
where id2 not in (select id1 from likes);

-- Q6. Find names and grades of students who only have friends in the same grade. 
-- Return the result sorted by grade, then by name within each grade.

select name, grade
  from highschooler
where id not in 
    (select id1
       from highschooler h1
       join friend on h1.id = id1
       join highschooler h2 on h2.id = id2
     where h1.grade != h2.grade)
     order by grade, name;