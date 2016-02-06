# Movie ( mID, title, year, director ).
# Reviewer ( rID, name ).
# Rating ( rID, mID, stars, ratingDate ).

# Q1. Find the difference between the average rating of movies released 
# before 1980 and the average rating of movies released after 1980.

```
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
```
# Q2. Find the names of all reviewers who rated Gone with the Wind.

