-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = ON;

-- Import Data into Books Table
LOAD DATA LOCAL INFILE 'C:/Users/8916/OneDrive/Documents/Desktop/sql project/Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock);

-- Import Data into Customers Table
LOAD DATA LOCAL INFILE 'C:/Users/8916/OneDrive/Documents/Desktop/sql project/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Customer_ID, Name, Email, Phone, City, Country);

-- Import Data into Orders Table
LOAD DATA LOCAL INFILE 'C:/Users/8916/OneDrive/Documents/Desktop/sql project/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);

use onlinebookstore;
-- 1) Retrieve all books in the "Fiction" genre:

select * from books
where Genre='Fantasy';

-- 2) Find books published after the year 1950:
select * from books
where Published_Year>1950;

-- 3) List all customers from the Canada:
select * from customers
where country='Canada';

-- 4) Show orders placed in November 2023:
select * from orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select	sum(stock) from books;

-- 6) Find the details of the most expensive book:
select * from books 
order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders
where Quantity<=1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where Total_Amount>20;

-- 9) List all genres available in the Books table:
select distinct(Genre) 
from books;

-- 10) Find the book with the lowest stock:
select * from books 
order by Stock
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_Amount) as revenu
 from orders;

-- 1) Retrieve the total number of books sold for each genre:
select b.genre, sum(o.quantity) as 'total no of books'
from orders o
join books b on o.Book_ID=b.Book_ID
group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;

-- 4) Find the most frequently ordered book:
select b.book_id,b.title,count(o.order_id) as orders 
from orders o
join books b on o.Book_ID=b.Book_ID
group by b.Book_ID,b.Title
order by orders desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select genre, price from books
where Genre='fantasy'
order by price desc
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
select b.Author,sum(o.quantity) as total_quantity
from orders o
join books b on o.book_id=b.Book_ID
group by b.Author;

-- 7) List the cities where customers who spent over $30 are located:
select c.city, o.total_amount
from orders o
join customers c on o.Customer_ID=c.Customer_ID
where o.Total_Amount>30;

-- 8) Find the customer who spent the most on orders:
select c.name , sum(o.total_amount) as most_orderd
from orders o
join customers c on o.Customer_ID=c.Customer_ID
group by c.name
order by most_orderd desc
limit 1;



