Create Database ExcelR_SQL_Project;

Use ExcelR_SQL_Project;

Drop Table olist_orders_dataset;

Select * from olist_orders_dataset;
Select * from olist_customers_dataset;
Select * from olist_order_payments_dataset;
Select * from olist_order_reviews_dataset;
Select * from olist_products_dataset;
Select * from olist_order_items_dataset;


/*KPI1*/
SELECT
  kpi1.Day_End,
  ROUND(kpi1.Total_pmt / (SELECT SUM(payment_value) FROM olist_order_payments_dataset) * 100,2) AS perc_pmtvalue
FROM
  (SELECT
    ord.Day_End,
    SUM(pmt.payment_value) AS Total_pmt
  FROM
    olist_order_payments_dataset AS pmt
  JOIN
    (SELECT DISTINCT(order_id),
            CASE WHEN WEEKDAY(order_purchase_timestamp) IN (5, 6) THEN 'Weekend'
                 ELSE 'Weekday' END AS Day_End
     FROM olist_orders_dataset) AS ord
  ON
    ord.order_id = pmt.order_id
  GROUP BY
    ord.Day_End) AS kpi1;
    
   
/*KPI2*/
select pmt.payment_type, count(pmt.order_id)
as Total_orderds from olist_order_payments_dataset as pmt join
(select distinct ord.order_id, rw.review_score from olist_orders_dataset as ord
join olist_order_reviews_dataset rw on ord.order_id=rw.order_id where review_score=5) as rw5
on pmt.order_id =rw5.order_id group by pmt.payment_type order by Total_orderds desc;   


/*KPI3*/
select c.product_category_name, avg(datediff(a.order_delivered_customer_date,a.order_purchase_timestamp)) as Avg_days 
from olist_orders_dataset a join olist_order_items_dataset b join  olist_products_dataset c on a.order_id=b.order_id and b.product_id=c.product_id
where c.product_category_name= "pet_shop";

/*KPI4*/
#KPI 4A

select cust.customer_city, round(avg(pmt_price.price),0) as avg_price
from olist_customers_dataset as cust
join (select pymnt.customer_id, pymnt.payment_value, item.price from olist_order_items_dataset as item join
(select ord.order_id, ord.customer_id, pmt.payment_value from olist_orders_dataset as ord
join olist_order_payments_dataset as pmt on ord.order_id= pmt.order_id) as pymnt
on item.order_id = pymnt.order_id) as pmt_price on cust.customer_id=pmt_price.customer_id where cust.customer_city
="sao paulo";

/#KPI 4B/
select cust.customer_city,round(avg(pmt.payment_value),0) as avg_payment_value
from olist_customers_dataset cust inner join olist_orders_dataset ord
on cust.customer_id= ord.customer_id inner join 
olist_order_payments_dataset as pmt on ord.order_id= pmt.order_id 
where customer_city = "sao paulo"; 


/*KPI5*/
select rw.review_score,
round(avg(datediff(ord.order_delivered_customer_date, ord.order_purchase_timestamp)),0)
as avg_shipping_days
from olist_orders_dataset as ord join olist_order_reviews_dataset rw on
rw.order_id=ord.order_id group by rw.review_score order by rw.review_score; 





