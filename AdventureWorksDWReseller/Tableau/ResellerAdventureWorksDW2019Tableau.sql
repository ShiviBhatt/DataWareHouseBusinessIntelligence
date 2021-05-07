-- 1. Product Contribution of Sales

 SELECT pc.englishproductcategoryname AS ProductCategory, SUM(frs.salesamount) as SalesAmount
 FROM FactResellerSales frs
 JOIN DimProduct dp ON frs.ProductKey = dp.ProductKey
 JOIN DimProductSubcategory ps ON dp.ProductSubcategoryKey = ps.ProductSubcategoryKey
 JOIN DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
 GROUP BY pc.englishproductcategoryname
 ORDER BY SalesAmount DESC


 --- 2 . Sales Trends & Forecast (by Month)

 SELECT DATENAME(mm, OrderDate ) as OrderMonthName, SUM(frs.salesamount) as SalesAmount
 FROM FactResellerSales frs
 GROUP BY DATENAME(mm, OrderDate ) 
 ORDER BY sum( SalesAmount) DESC 


 --- 3.  Sales Promotions & Discounts

SELECT p.EnglishPromotionCategory as PromotionCategory,
p.EnglishPromotionType as PromotionType,
p.EnglishPromotionName as PromotionName,
SUM(frs.DiscountAmount) as DiscountAmount,
SUM(frs.salesamount) as SalesAmount
FROM FactResellerSales frs
JOIN DimPromotion p ON p.PromotionKey = frs.PromotionKey
WHERE p.EnglishPromotionCategory = 'Reseller'
AND p.EnglishPromotionType != 'No Discount'
GROUP BY p.EnglishPromotionCategory,p.EnglishPromotionType, p.EnglishPromotionName 
ORDER BY SUM(frs.DiscountAmount) DESC


--- 4. Product Sales by Geo

SELECT g.EnglishCountryRegionName AS Country,pc.EnglishProductCategoryName AS ProductCategory, SUM(frs.SalesAmount) AS SalesAmount
FROM DimProductCategory pc
JOIN DimProductSubcategory ps ON pc.ProductCategoryKey = ps.ProductCategoryKey
JOIN DimProduct p ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN FactResellerSales frs ON frs.ProductKey = p.ProductKey
JOIN DimReseller r ON r.ResellerKey = frs.ResellerKey
JOIN DimGeography g ON r.GeographyKey = g.GeographyKey
JOIN DimSalesTerritory st ON st.SalesTerritoryKey = g.SalesTerritoryKey
GROUP BY g.EnglishCountryRegionName,pc.EnglishProductCategoryName
ORDER BY SUM(frs.SalesAmount) DESC


--- 5. Product Profits by Sales Territory

SELECT dp.EnglishProductName AS ProductName, dst.SalesTerritoryGroup AS SalesTerritory,
SUM((frs.SalesAmount) -  (frs.TotalProductCost))AS Profit
FROM FactResellerSales frs
JOIN DimProduct dp ON dp.ProductKey = frs.ProductKey
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = frs.SalesTerritoryKey
GROUP BY dp.EnglishProductName, dst.SalesTerritoryGroup
ORDER BY Profit DESC



--- 6 . Top Salespeople ranked

SELECT top 10 
CONCAT(e.lastName, ', ', e.firstName) as EmployeeName,
SUM(frs.SalesAmount) as SalesAmount
FROM FactResellerSales frs 
JOIN DimEmployee e on e.EmployeeKey = frs.EmployeeKey
GROUP BY e.LastName, e.FirstName
ORDER BY SUM(SalesAmount) desc


--- 7 . Top Resellers (Stores) ranked

SELECT  top 10 
r.ResellerName,
SUM(frs.SalesAmount) as SalesAmount
FROM FactResellerSales frs JOIN
DimReseller r on r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName
ORDER BY SUM(SalesAmount) DESC



--- 8 Geo Contribution to Sales

SELECT dst.SalesTerritoryCountry AS Country, dst.SalesTerritoryGroup AS TerritoryGroup, dst.SalesTerritoryRegion AS Region,
SUM(frs.SalesAmount) as SalesAmount
FROM FactResellerSales frs
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = frs.SalesTerritoryKey
GROUP BY dst.SalesTerritoryCountry, dst.SalesTerritoryGroup, dst.SalesTerritoryRegion
ORDER BY SUM(SalesAmount) DESC



--- 9. Salespeople report with Sales, Profit and various person's attributes 

SELECT CONCAT(e.lastName, ', ', e.firstName) as EmployeeName, 
e.Gender,
pc.EnglishProductCategoryName AS ProductCategory, 
SUM(SalesAmount) AS SalesAmount,
SUM((frs.SalesAmount) -  (frs.TotalProductCost))AS Profit
FROM DimProductCategory pc
JOIN DimProductSubcategory ps ON pc.ProductCategoryKey = ps.ProductCategoryKey
JOIN DimProduct p ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN FactResellerSales frs ON frs.ProductKey = p.ProductKey 
JOIN DimEmployee e on e.EmployeeKey = frs.EmployeeKey
GROUP BY e.LastName, e.FirstName, e.Gender, pc.EnglishProductCategoryName
ORDER BY SUM(SalesAmount) DESC



--- 10. Resellers' report with Sales, Profit and various person's attributes 

SELECT r.ResellerName AS ResellerName, r.YearOpened, pc.EnglishProductCategoryName AS ProductCategory, SUM(SalesAmount) AS SalesAmount,
SUM((frs.SalesAmount) -  (frs.TotalProductCost))AS Profit
FROM DimProductCategory pc
JOIN DimProductSubcategory ps ON pc.ProductCategoryKey = ps.ProductCategoryKey
JOIN DimProduct p ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN FactResellerSales frs ON frs.ProductKey = p.ProductKey 
JOIN DimReseller r on r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.YearOpened, pc.EnglishProductCategoryName
ORDER BY SUM(SalesAmount) DESC