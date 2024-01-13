Create Database ExcelR_Zomato_Project;

Use ExcelR_Zomato_Project;


select * from main;
select * from country;
select * from currency;
select * from date;

Alter table main modify column datekey_opening date;

Drop table main;
Drop table date;
Drop table currency;

/*KPI2*/       /*Build a Calendar Table using the Columns Datekey_Opening*/
select * from date;

/*KPI3*/       /*Convert the Average cost for 2 column into USD dollars*/
Select RestaurantName, Average_Cost_for_two, USD_Rate, Average_Cost_for_two*USD_Rate as Average_Cost_for_two_in_USD 
from main as m join currency as c on m.currency = c.currency 
where Average_Cost_for_two is not null group by RestaurantName,Average_Cost_for_two,USD_rate;

/*KPI4*/       /*Find the Numbers of Resturants based on City and Country*/
select countryname, city, count(restaurantname) as restaurant_count from main as m join country as co on m.countrycode = co.countryid 
where countryname is not null group by countryname, city order by restaurant_count desc;

/*KPI5*/       /*Numbers of Resturants opening based on Year , Quarter , Month*/
select Year,Month,Quarter,count(RestaurantName) as No_of_Restaurants_opening from main m join date d on m.Datekey_Opening = d.date group by year,month,quarter;
select Year,count(RestaurantName) as No_of_Restaurants_opening from main m join date d on m.Datekey_Opening = d.date group by year;
select Month,count(RestaurantName) as No_of_Restaurants_opening from main m join date d on m.Datekey_Opening = d.date group by month;
select Quarter,count(RestaurantName) as No_of_Restaurants_opening from main m join date d on m.Datekey_Opening = d.date group by quarter;

/*KPI6*/       /*Count of Resturants based on Average Ratings*/
select count(RestaurantName), avg(rating) from main ;
select Rating, count(RestaurantName) as Count_of_restaurants from main group by rating order by rating asc;

/*KPI7*/       /*Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets*/
select Price_range as Buckets, count(restaurantname) as No_of_Restaurants from main group by Price_Range;

/*KPI8*/       /*Percentage of Resturants based on "Has_Table_booking*/
SELECT 
    COUNT(*) AS Total_Restaurants,
    COUNT(CASE WHEN has_table_booking = 'No' THEN 1 END) AS Restaurants_Without_Booking,
    COUNT(CASE WHEN has_table_booking = 'Yes' THEN 1 END) AS Restaurants_With_Booking,
    (COUNT(CASE WHEN has_table_booking = 'Yes' THEN 1 END) / COUNT(*) * 100) AS Percentage_With_Table_Booking
FROM main;

/*KPI9*/       /*Percentage of Resturants based on "Has_Online_delivery*/
SELECT 
    COUNT(*) AS Total_Restaurants,
    COUNT(CASE WHEN has_online_delivery = 'No' THEN 1 END) AS Without_onlinedelivery,
    COUNT(CASE WHEN has_online_delivery = 'Yes' THEN 1 END) AS With_onlinedelivery,
    (COUNT(CASE WHEN has_online_delivery = 'Yes' THEN 1 END) / COUNT(*) * 100) AS per_with_onlinedelivery
FROM main;

/*KPI10*/      /*Cuisines and voting*/
Select distinct Cuisines, Votes from main where votes <> 0 order by votes desc;
Select distinct Cuisines, Votes from main where votes <> 0 order by votes asc;




