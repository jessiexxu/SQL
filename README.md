# SQL
Querying and managing data

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
