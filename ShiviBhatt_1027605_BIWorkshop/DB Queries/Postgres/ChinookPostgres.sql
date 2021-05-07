--- 1. Total Sales
Select Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS TotalSales FROM "InvoiceLine";
 
--  2.  Total Sales by country

SELECT Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS Sales,
"BillingCountry", 
RANK() OVER (ORDER BY Sum("Invoice"."Total") DESC) AS RankBySales
From "Invoice"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
GROUP BY "Invoice"."BillingCountry"
ORDER BY 1 DESC

-- 3. Total Sales by country, city ,state

SELECT Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales", "BillingCountry" , "BillingCity", "BillingState" 
From "Invoice"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
WHERE "BillingState" IS NOT NULL
GROUP BY "Invoice"."BillingCountry", "Invoice"."BillingCity", "Invoice"."BillingState"
ORDER BY 1 DESC

-- 4. Total Sales by Customer

SELECT CONCAT("LastName",' , ',"FirstName")AS "CustomerName",Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales",
RANK() OVER (ORDER BY Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") DESC) AS RankBySales
FROM "Customer"
INNER JOIN "Invoice" on "Invoice"."CustomerId" = "Customer"."CustomerId"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
GROUP BY "Customer"."LastName", "Customer"."FirstName" 
ORDER BY 2 DESC

-- 5. Total Sales by Artist

SELECT "Artist"."Name" AS "Artist_Name", Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales",
RANK() OVER (ORDER BY Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") DESC) AS RankBySales
From "Artist"
INNER JOIN "Album" ON "Album"."ArtistId" = "Artist"."ArtistId"
INNER JOIN "Track" ON "Track"."AlbumId" = "Album"."AlbumId"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."TrackId" = "Track"."TrackId"
INNER JOIN "Invoice" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
Group by "Artist"."Name"
ORDER BY 2 DESC

-- 6. Total Sales by albums

SELECT "Album"."Title" AS "Album_Name", Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales" 
From "Album"
INNER JOIN "Track" ON "Track"."AlbumId" = "Album"."AlbumId"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."TrackId" = "Track"."TrackId"
INNER JOIN "Invoice" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
Group by "Album"."Title"
ORDER BY 2 DESC


-- 7. Total Sales by Sales Person(Employee)

SELECT 
CONCAT("Employee"."LastName",' , ',"Employee"."FirstName")AS "EmployeeName",
Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales" 
FROM "Employee"
INNER JOIN "Customer" ON "Employee"."EmployeeId" = "Customer"."SupportRepId"
INNER JOIN "Invoice" ON "Invoice"."CustomerId" = "Customer"."CustomerId"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
GROUP BY "Employee"."LastName", "Employee"."FirstName"

-- 8. Total tracks bought and total revenue by media type

SELECT "MediaType"."Name", COUNT("InvoiceLine"."TrackId") AS "Tracks Bought", Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales" 
From "Track"
INNER JOIN "MediaType" ON "MediaType"."MediaTypeId" = "Track"."MediaTypeId"
INNER JOIN "InvoiceLine" ON "Track"."TrackId" = "InvoiceLine"."TrackId"
INNER JOIN "Invoice" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
GROUP BY "MediaType"."Name"
ORDER BY 2 DESC;


-- 9. Total Sales by Genre

SELECT "Genre"."Name"AS "GenreName", Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS Sales 
From "Genre"
INNER JOIN "Track" ON "Track"."GenreId" = "Genre"."GenreId"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."TrackId" = "Track"."TrackId"
INNER JOIN "Invoice" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
Group by "Genre"."Name"
ORDER BY 2 DESC;


-- 10. Total Sales by Customer's Company

SELECT CONCAT("LastName",' , ',"FirstName")AS "CustomerName",
"Customer"."Company",
Sum("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice") AS "Sales" 
FROM "Customer"
INNER JOIN "Invoice" on "Invoice"."CustomerId" = "Customer"."CustomerId"
INNER JOIN "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
WHERE "Customer"."Company" IS NOT NULL
GROUP BY "Customer"."LastName", "Customer"."FirstName", "Customer"."Company"
ORDER BY 3 DESC;