 -- 1. Product Contribution of Sales

 SELECT p.ProductName, SUM(fis.UnitPrice * fis.OrderQty) as TotalSalesAmount
 FROM FCT_InternetSales fis
 JOIN DIM_product p ON fis.ProductSK = p.ProductSK
 GROUP BY p.ProductName
 ORDER BY SUM(fis.UnitPrice * fis.OrderQty) DESC

 SELECT p.ProductName, SUM(fss.UnitPrice * fss.OrderQty) as TotalSalesAmount
 FROM DIM_product p
 JOIN FCT_StoreSales fss ON p.ProductSK = fss.ProductSK
 GROUP BY p.ProductName
 ORDER BY SUM(fss.UnitPrice * fss.OrderQty) DESC
 
 --2. Comparison of yearly sales

 SELECT DATENAME(YYYY, OrderDate ) as OrderYear, SUM(fis.UnitPrice * fis.OrderQty) as TotalSalesAmount
 FROM FCT_InternetSales fis
 GROUP BY DATENAME(YYYY, OrderDate ) 
 ORDER BY SUM(fis.UnitPrice * fis.OrderQty) DESC 

 SELECT DATENAME(YYYY, OrderDate ) as OrderYear, SUM(fss.UnitPrice * fss.OrderQty) as TotalSalesAmount
 FROM FCT_StoreSales fss
 GROUP BY DATENAME(YYYY, OrderDate ) 
 ORDER BY SUM(fss.UnitPrice * fss.OrderQty) DESC 


 --3. Sales Promotions & Discount

SELECT p.Category as PromotionCategory, pr.ProductName,
SUM(p.DiscountPct) as DiscountPercentage,
SUM(fis.UnitPrice * fis.OrderQty) as TotalSalesAmount
FROM DIM_product pr 
JOIN FCT_InternetSales fis ON pr.ProductSK = fis.ProductSK
JOIN DIM_promotions p ON p.PromotionSK = fis.PromotionSK
GROUP BY p.Category,pr.ProductName
ORDER BY SUM(p.DiscountPct) DESC, SUM(fis.UnitPrice * fis.OrderQty)


--4. Product Sales by Geography (Country,State,City)

SELECT a.CountryRegionName AS Country,a.StateProvinceName, a.City, p.ProductName, SUM(fis.UnitPrice * fis.OrderQty) as TotalSalesAmount
FROM DIM_product p 
JOIN FCT_InternetSales fis ON p.ProductSK = fis.ProductSK
JOIN DIM_customer c ON fis.CustomerSK = c.CustomerSK
JOIN DIM_address a ON a.AddressSK = c.AddressSK
GROUP BY a.CountryRegionName,a.StateProvinceName, a.City, p.ProductName
ORDER BY SUM(fis.UnitPrice * fis.OrderQty) DESC


--5. Product Profits by Sales Territory 

SELECT p.ProductName, st.TerritoryName AS SalesTerritory,
SUM((st.SalesYTD) - (st.CostYTD)) AS Profit
FROM DIM_salesterritory st 
JOIN FCT_StoreSales fss ON st.SalesTerritorySK = fss.SalesTerritorySK
JOIN DIM_product p ON fss.ProductSK = p.ProductSK
GROUP BY p.ProductName, st.TerritoryName
ORDER BY SUM((st.SalesYTD) - (st.CostYTD)) DESC

--6. Top 5 Sales Person Ranked 

SELECT TOP 5 CONCAT(s.LastName, ', ', s.FirstName) as SalesPersonName,
SUM(s.SalesYTD) as TotalSalesAmount 
FROM DIM_salesperson s
GROUP BY s.LastName, s.FirstName
ORDER BY SUM(s.SalesYTD) DESC

--7. Top 10 Reseller (Stores) Ranked

SELECT TOP 10 s.StoreName,
SUM(fss.UnitPrice * fss.OrderQty) as TotalSalesAmount
FROM FCT_StoreSales fss JOIN
DIM_store s on s.StoreSK = fss.StoreSK
GROUP BY s.StoreName
ORDER BY SUM(fss.UnitPrice * fss.OrderQty) DESC

--8. Geography based contribution to sales

SELECT st.TerritoryName AS SalesTerritory, st.SalesGroup, a.CountryRegionName, SUM(fis.UnitPrice * fis.OrderQty) as TotalSalesAmount_Internet
FROM DIM_address a 
JOIN DIM_customer c ON a.AddressSK = c.AddressSK
JOIN FCT_InternetSales fis ON c.CustomerSK = fis.CustomerSK
JOIN DIM_salesterritory st ON fis.SalesTerritorySK = st.SalesTerritorySK
JOIN FCT_StoreSales fss ON st.SalesTerritorySK = fss.SalesTerritorySK
GROUP BY st.TerritoryName, st.SalesGroup, a.CountryRegionName
ORDER BY SUM(fis.UnitPrice * fis.OrderQty) DESC

--9. Two people-related attributes correlated to their sales

SELECT p.ProductCategoryName, p.ProductName, CONCAT(c.LastName, ', ', c.FirstName) as CustomerName, c.EmailAddress, SUM(c.TotalPurchaseYTD) AS TotalPurchaseValue, SUM(fis.UnitPrice * fis.OrderQty) as TotalSalesAmount_Internet
FROM DIM_customer c
JOIN FCT_InternetSales fis ON c.CustomerSK = fis.CustomerSK
JOIN DIM_product p ON p.ProductSK = fis.ProductSK
GROUP BY p.ProductCategoryName, p.ProductName, c.LastName, c.FirstName, c.EmailAddress
ORDER BY SUM(c.TotalPurchaseYTD) DESC, SUM(fis.UnitPrice * fis.OrderQty)


--10. Any reseller attributes (at least one) correlated to their sales

SELECT s.StoreName, s.YearOpened, SUM(s.AnnualSales) AS AnnualSales, SUM(fss.UnitPrice * fss.OrderQty) as TotalSalesAmount_Stores
FROM DIM_store s 
JOIN FCT_StoreSales fss ON s.StoreSK = fss.StoreSK
GROUP BY s.StoreName, s.YearOpened
ORDER BY SUM(s.AnnualSales), SUM(fss.UnitPrice * fss.OrderQty) DESC