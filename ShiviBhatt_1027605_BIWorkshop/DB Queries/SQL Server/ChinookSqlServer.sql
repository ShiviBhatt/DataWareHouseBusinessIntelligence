--1. Total sales

SELECT SUM(unitprice * quantity) AS Total_Sales FROM InvoiceLine

--2. Total sales $ by country –ranked (or at least sorted largest to smallest)

Select Rank() over (ORDER BY SUM(unitprice * quantity) desc) 'Rank',
Invoice.BillingCountry,
SUM(unitprice * quantity) AS Total_Sales
from InvoiceLine
JOIN Invoice on InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY Invoice.BillingCountry

--3. Total sales $ by country, state & city

SELECT Invoice.BillingCountry, Invoice.BillingState,
Invoice.BillingCity, SUM(unitprice * quantity) AS Total_Sales
FROM InvoiceLine
JOIN Invoice on InvoiceLine.InvoiceId = Invoice.InvoiceId
Where BillingState IS NOT NULL
GROUP BY Invoice.BillingCountry, Invoice.BillingState, Invoice.BillingCity
Order by SUM(unitprice * quantity) DESC;

--4 Total sales $ by customer (a person with last name & first name) –ranked (or at least sorted largest to smallest)

 SELECT Rank() over (ORDER BY SUM(unitprice * quantity) desc) 'Rank',
 CONCAT(Customer.LastName, ', ', Customer.FirstName) AS Customer_Name,
 SUM(unitprice * quantity) AS Sales
 FROM InvoiceLine
 JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
 JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
 GROUP BY CONCAT(Customer.LastName, ', ', Customer.FirstName);

 --5. Total sales by artist – ranked

 SELECT RANK() over (ORDER BY SUM(Invoiceline.UnitPrice * Quantity) DESC) 'Rank',
 Artist.ArtistId, Artist.Name,SUM(Invoiceline.UnitPrice * Quantity) AS Sales
 FROM InvoiceLine
 JOIN Track ON InvoiceLine.TrackId = Track.TrackId
 JOIN Album ON Track.AlbumId = Album.AlbumId
 JOIN Artist ON Album.ArtistId = Artist.ArtistId
 GROUP BY Artist.ArtistId, Artist.Name


  SELECT top 10 RANK() over (ORDER BY SUM(Invoiceline.UnitPrice * Quantity) DESC) 'Rank',
 Artist.ArtistId, Artist.Name,SUM(Invoiceline.UnitPrice * Quantity) AS Sales
 FROM InvoiceLine
 JOIN Track ON InvoiceLine.TrackId = Track.TrackId
 JOIN Album ON Track.AlbumId = Album.AlbumId
 JOIN Artist ON Album.ArtistId = Artist.ArtistId
 GROUP BY Artist.ArtistId, Artist.Name


 --6. Total sales by albums

 SELECT Album.Title, SUM(Invoiceline.UnitPrice*Quantity) AS Total_Sales
 FROM InvoiceLine
 JOIN Track ON InvoiceLine.TrackId = Track.TrackId
 JOIN Album ON Track.AlbumId = Album.AlbumId
 Group BY Album.Title
 order by SUM(Invoiceline.UnitPrice*Quantity) desc;


--7. Total sales by sales person (employee)

SELECT CONCAT(Employee.LastName, ', ', Employee.FirstName),
SUM(unitprice * quantity) AS Total_Sales
FROM InvoiceLine
JOIN Invoice on InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Customer on Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
GROUP BY CONCAT(Employee.LastName, ', ', Employee.FirstName)
Order by SUM(unitprice * quantity) DESC;

--8. Total tracks bought and total revenue by media type

SELECT MediaType.Name,SUM(Invoiceline.UnitPrice * quantity) AS Total_Revenue,
SUM(quantity) AS Tracks_Bought
FROM Invoiceline
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN MediaType ON MediaType.MediaTypeID = Track.MediaTypeID
Group BY MediaType.Name
Order BY SUM(Invoiceline.UnitPrice * quantity) desc;



 --9. Total Sales by Genre

SELECT Genre.Name,SUM(Invoiceline.UnitPrice * quantity) AS Total_Revenue
FROM Invoiceline
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre ON Genre.GenreId = Track.GenreId
Group BY Genre.Name
Order BY SUM(Invoiceline.UnitPrice * quantity) desc;


--10. Total Sales by Company

 SELECT CONCAT(Customer.LastName, ', ', Customer.FirstName) AS Customer_Name, [Company],
 SUM(unitprice * quantity) AS Sales
 FROM InvoiceLine
 JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
 JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
 WHERE Company IS NOT NULL
 GROUP BY CONCAT(Customer.LastName, ', ', Customer.FirstName), [Company]
 Order BY SUM(unitprice * quantity) desc;