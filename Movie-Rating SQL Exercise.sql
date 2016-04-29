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

-- Q7. For each rating that is the lowest (fewest stars) currently in the database,
-- return the reviewer name, movie title, and number of stars.

select name, title, stars
  from reviewer rv
  join rating rt on rv.rID = rt.rID
  join movie m on rt.mID = m.mID
where stars = (select min(stars) from rating);

-- Q8. List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order.

select title, avg(stars) as avg_stars
  from rating rt
  join movie m on rt.mID = m.mID
group by title
order by 2 desc, title;

-- Q9. Find the names of all reviewers who have contributed three or more ratings.

select distinct name
  from reviewer rv
  join rating rt on rv.rID = rt.rID
where rv.rID in 
     (select rID from rating
      group by rID
      having count(mID)>2);

-- Q10. Some directors directed more than one movie. For all such directors, 
-- return the titles of all movies directed by them, along with the director name. 
-- Sort by director name, then movie title.

select title, director
  from movie
where director in 
    (select director from movie 
     group by director 
     having count(mID)>1)
order by director, title;

-- Q11. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 

select * 
  from (select title, avg(stars) as avg_stars
          from rating rt
          join movie m on rt.mID = m.mID
        group by title
        order by 2 desc, title)
limit 1;

-- Q12. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.

select title, avg(stars) as avg_stars
  from rating rt
  join movie m on rt.mID = m.mID
group by title
having avg_stars >= 
    (select avg(stars) from rating 
     group by mID 
     order by 1 desc);

-- Q13. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.

select title, avg(stars) as avg_stars
  from rating rt
  join movie m on rt.mID = m.mID
group by title
having avg_stars <= 
    (select avg(stars) from rating 
     group by mID 
     order by 1);

-- Q14. For each director, return the director's name together with the title(s) of the movie(s) 
-- they directed that received the highest rating among all of their movies, and the value of that rating. 
-- Ignore movies whose director is NULL. 

select director, title, max(stars)
  from movie m
  join rating rt on m.mID = rt.mID
where director is not null
group by director;

-- Q15. Randomly select 3 movies with stars>3.

select title, stars
  from rating rt
  join movie m on rt.mID = m.mID
where stars > 3
order by random()
limit 3;

-- Q16. Add the reviewer Roger Ebert to your database, with an rID of 209. 

Insert into reviewer (rID, name)
values (209, 'Roger Ebert');

-- Q17. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 

Insert into rating (rID, mID,stars)
select reviewer.rID, movie.mID, 5
from movie
cross join reviewer
where reviewer.name='James Cameron';

-- Q18. For all movies that have an average rating of 4 stars or higher, add 25 to the release year.

Update movie
set year=year+25
where mID in
    (select mID
    from rating
    group by mID
    having avg(stars)>=4);
