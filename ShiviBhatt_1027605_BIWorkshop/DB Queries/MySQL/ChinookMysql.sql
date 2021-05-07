Use Chinook;
-- 1. Total Sales
Select SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Total Sales" FROM invoiceline;
 
-- 2. Total Sales by country

SELECT SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales",
BillingCountry, 
RANK() OVER (ORDER BY SUM(invoiceline.Quantity * invoiceline.UnitPrice) DESC) AS RankBySales
From InvoiceLine
INNER JOIN invoice on invoice.InvoiceId = invoiceline.InvoiceId
GROUP BY BillingCountry
ORDER BY 1 DESC;

/* SELECT invoice.BillingCountry, SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "TotalSales" From Invoiceline
Inner JOIN Invoice on invoice.InvoiceId = invoiceline.InvoiceId 
Group BY invoice.BillingCountry
ORDER BY 2 DESC;
*/
 
-- 3. Total Sales by country, city ,state

SELECT SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales", BillingCountry,BillingCity,BillingState 
From Invoice
Inner JOIN Invoiceline on invoice.InvoiceId = invoiceline.InvoiceId 
Where BillingState IS NOT NULL
GROUP BY BillingCountry, BillingCity, BillingState
ORDER BY 1 DESC;

-- 4. Total Sales by Customer

SELECT FirstName,LastName, SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales",
RANK() OVER (ORDER BY SUM(invoiceline.Quantity * invoiceline.UnitPrice) DESC) AS RankBySales
FROM Customer
INNER JOIN Invoice on Invoice.CustomerId = Customer.CustomerId
INNER JOIN Invoiceline on invoice.InvoiceId = invoiceline.InvoiceId
GROUP BY FirstName, LastName
ORDER BY 3 DESC;

-- 5.  Total Sales by Artist

SELECT Artist.Name, SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales",
RANK() OVER (ORDER BY SUM(invoiceline.Quantity * invoiceline.UnitPrice) DESC) AS RankBySales
From Artist
INNER JOIN Album ON Album.ArtistId = Artist.ArtistId
INNER JOIN Track ON Track.AlbumId = Album.AlbumId
INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
INNER JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
Group by Artist.Name
ORDER BY 2 DESC;

-- 6. Total Sales by albums

SELECT Album.Title as "Album", SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales" From Album
INNER JOIN Track ON Track.AlbumId = Album.AlbumId
INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
INNER JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
Group by Album.Title
ORDER BY 2 DESC;


-- 7. Total Sales by Sales Person (Employee)

SELECT CONCAT(Employee.LastName, ', ', Employee.FirstName) as "Sales Person", 
SUM(unitprice * quantity) AS Total_Sales
FROM InvoiceLine
INNER JOIN Invoice on InvoiceLine.InvoiceId = Invoice.InvoiceId
INNER JOIN Customer on Invoice.CustomerId = Customer.CustomerId
INNER JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
GROUP BY CONCAT(Employee.LastName, ', ', Employee.FirstName)
Order by SUM(unitprice * quantity) DESC;


-- 8. Total tracks bought and total revenue by media type

SELECT MediaType.Name, COUNT(InvoiceLine.TrackId) AS "Tracks Bought", SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales" From Track
INNER JOIN  MediaType ON MediaType.MediaTypeId = Track.MediaTypeId
INNER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
INNER JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY MediaType.Name
ORDER BY 2 DESC;


-- 9. Total Sales by Genre

SELECT Genre.Name as "Genre", SUM(invoiceline.Quantity * invoiceline.UnitPrice) AS "Sales" From Genre
INNER JOIN Track ON Track.GenreId = GENRE.GenreId
INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
INNER JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
Group by Genre.Name
ORDER BY 2 DESC;


-- 10.  Total Sales by Customer's Company


 SELECT CONCAT(Customer.LastName, ', ', Customer.FirstName) AS "Customer Name", Company,
 SUM(unitprice * quantity) AS Sales
 FROM InvoiceLine
 JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
 JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
 WHERE Company IS NOT NULL
 GROUP BY CONCAT(Customer.LastName, ', ', Customer.FirstName), Company
 Order BY 3 desc;
