drop database if exists E_Commerce;
create database E_Commerce;
use E_Commerce;

drop table if exists Supplier;

CREATE TABLE Supplier (
    SUPP_ID integer PRIMARY KEY NOT NULL,
    SUPP_NAME varchar(50),
    SUPP_CITY varchar(50),
    SUPP_PHONE varchar(12)
);

insert into Supplier values (1,"Rajesh Retails","Delhi","1234567890");
insert into Supplier values (2,"Appario Ltd.","Mumbai","2589631470");
insert into Supplier values (3,"Knome products","Banglore","9785462315");
insert into Supplier values (4,"Bansal Retails","Kochi","8975463285");
insert into Supplier values (5,"Mittal Ltd.","Lucknow","7898456532");

desc Supplier;

drop table if exists Customer;
CREATE TABLE Customer (
    CUS_ID integer PRIMARY KEY NOT NULL,
    CUS_NAME varchar(50),
    CUS_PHONE varchar(12),
    CUS_CITY varchar(50),
    CUS_GENDER char
);

insert into Customer values (1,"AAKASH","9999999999","DELHI",'M');
insert into Customer values (2,"AMAN","9785463215","NOIDA",'M');
insert into Customer values (3,"NEHA","9999999999","MUMBAI",'F');
insert into Customer values (4,"MEGHA","9994562399","KOLKATA",'F');
insert into Customer values (5,"PULKIT","7895999999","LUCKNOW",'M');


desc Customer;

drop table if exists Category;
CREATE TABLE Category (
    CAT_ID integer PRIMARY KEY NOT NULL,
    CAT_NAME varchar(50)
);

insert into Category values(1,"BOOKS");
insert into Category values(2,"GAMES");
insert into Category values(3,"GROCERIES");
insert into Category values(4,"ELECTRONICS");
insert into Category values(5,"CLOTHES");

desc Category;

drop table if exists Product;
CREATE TABLE Product (
    PRO_ID integer PRIMARY KEY NOT NULL,
    PRO_NAME varchar(50),
    PRO_DESC varchar(50),
    CAT_ID integer REFERENCES Category (CAT_ID)
);

insert into Product values(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
insert into Product values(2,"TSHIRT","DFDFJDFJDKFD",5);
insert into Product values(3,"ROG LAPTOP","DFNTTNTNTERND",4);
insert into Product values(4,"OATS","REURENTBTOTH",3);
insert into Product values(5,"HARRY POTTER","NBEMCTHTJTH",1);

desc Product;

drop table if exists Product_Details;
CREATE TABLE Product_Details (
    PROD_ID integer PRIMARY KEY NOT NULL,
    PRO_ID integer,
    SUPP_ID integer references Supplier(SUPP_ID),
    PROD_PRICE float4,
	FOREIGN KEY (PRO_ID) REFERENCES Product (PRO_ID)
   );
    
insert into Product_Details values(1,1,2,1500);
insert into Product_Details values(2,3,5,30000);
insert into Product_Details values(3,5,1,3000);
insert into Product_Details values(4,2,3,2500);
insert into Product_Details values(5,4,1,1000);

desc Product_Details;

drop table if exists `Order`;
CREATE TABLE `order`(
	ORD_ID integer PRIMARY KEY NOT NULL,
    ORD_AMOUNT float,
    ORD_DATE	date,
    CUS_ID integer REFERENCES Customer (CUS_ID),
    PROD_ID integer REFERENCES Product (PRO_ID),
    FOREIGN KEY (PROD_ID) REFERENCES Product (PRO_ID),
    FOREIGN KEY (CUS_ID) REFERENCES Customer (CUS_ID)
);

insert into `Order` values(20,1500,'2021-10-12',3,5);
insert into `Order` values(25,30500,'2021-09-16',5,2);
insert into `Order` values(26,2000,'2021-10-05',1,1);
insert into `Order` values(30,3500,'2021-08-16',4,3);
insert into `Order` values(50,2000,'2021-10-06',2,1);

desc `order`;

drop table if exists Rating;
CREATE TABLE Rating(
	RAT_ID integer PRIMARY KEY NOT NULL,
    CUS_ID integer REFERENCES Customer (CUS_ID),
    SUPP_ID integer references Supplier(SUPP_ID),
    RAT_RATSTARS integer,
    FOREIGN KEY (SUPP_ID) REFERENCES Supplier (SUPP_ID),
    FOREIGN KEY (CUS_ID) REFERENCES Customer (CUS_ID)
);

insert into Rating values (1,2,2,4);
insert into Rating values (2,3,4,3);
insert into Rating values (3,5,1,5);
insert into Rating values (4,1,3,2);
insert into Rating values (5,4,5,4);

desc Rating;


show tables;

select * from Supplier;
select * from Category;
select * from customer;
select * from product;
select * from product_details;
select * from `order`;
Select * from Rating;

/*
3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
*/
select count(*),cus_gender from Customer c inner join `order` o where c.cus_id=o.cus_id AND o.ord_amount>=3000 group by c.cus_gender;
/*
4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
*/
select p.pro_name,o.*  from Product p,`order` o where o.prod_id= p.pro_id and o.cus_id=2;
/*
5)	Display the Supplier details who can supply more than one product.
*/
select * from supplier where supp_id in (Select supp_id from Product_details group by supp_id having count(supp_id)=2) ;
/*
6)	Find the category of the product whose order amount is minimum.
*/
select cat_id from product p where p.pro_id = (select prod_id from (select prod_id from `order` where ord_amount=(select min(ord_amount) from `order`)) as min);
/*
7)	Display the Id and Name of the Product ordered after “2021-10-05”.
*/
select pro_id,pro_name from Product inner join (select * from `order` where ord_date >'2021-10-05') as o on product.pro_id=o.prod_id;
/*
8)	Display customer name and gender whose names start or end with character 'A'.
*/
select cus_name,cus_gender from Customer where cus_name like "%A" or cus_name like "A%";
/*
9)	Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if 
rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
*/

drop procedure if exists displayRatingMessage;
DELIMITER $$
create procedure displayRatingMessage(sup_id INT)
begin
	Select s.supp_id, r.rat_ratstars,   
	Case 
		When r.rat_ratstars > 4 then	“Genuine Supplier”
		When r.rat_ratstars > 2 then	“Average Supplier”
		Else “Supplier should not be considered”
	End as ratings;
    from Supplier s , Rating r where r.supp_id=s.supp_id and s.supp_id=sup_id;
End;
DELIMITER ;

call displayRatingMessage(2);