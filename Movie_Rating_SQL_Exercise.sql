-- Movie ( mID, title, year, director )
-- Reviewer ( rID, name )
-- Rating ( rID, mID, stars, ratingDate )

-- Q1. Find the difference between the average rating of movies released 
-- before 1980 and the average rating of movies released after 1980.

select abs(rating_ls_1980-rating_gt_1980) as rating_diff
  from (select avg(mv_rating) as rating_ls_1980
          from movie m
          join (select mID, avg(stars) as mv_rating from rating group by mID) r
          on m.mID=r.mID
          where year<1980),
       (select avg(mv_rating) as rating_gt_1980
          from movie m
          join (select mID, avg(stars) as mv_rating from rating group by mID) r
          on m.mID=r.mID
          where year>1980); 

-- Q2. Find the names of all reviewers who rated Gone with the Wind.

select distinct name
  from reviewer rv
  join rating rt on rv.rID = rt.rID
  join movie m on rt.mID = m.mID
where title = "Gone with the Wind";

-- Q3. For any rating where the reviewer is the same as the director of the movie
-- return the reviewer name, movie title, and number of stars.

select name, title, stars
  from reviewer rv
  join rating rt on rv.rID = rt.rID
  join movie m on rt.mID = m.mID
where name = director;

-- Q4. Return all reviewer names and movie names together in a single list, alphabetized.

select name
  from reviewer
union
select title
  from movie
order by name, title;

-- Q5. Find the titles of all movies not reviewed by Chris Jackson.

select distinct title
  from movie
where mID not in 
  (select mID from rating rt
     join reviewer rv on rt.rID = rv.rID
   where name = "Chris Jackson");

-- Q6. For all pairs of reviewers such that both reviewers gave a rating
-- to the same movie, return the names of both reviewers.

select distinct rv1.name, rv2.name
  from rating rt1
  join reviewer rv1
  on rt1.rID = rv1.rID
  join rating rt2
  on rt1.mID = rt2.mID and rt1.rID <> rt2.rID
  join reviewer rv2
  on rt2.rID = rv2.rID
where rv1.name < rv2.name
order by rv1.name, rv2.name;


