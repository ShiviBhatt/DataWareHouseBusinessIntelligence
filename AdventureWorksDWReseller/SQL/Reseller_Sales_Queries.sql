-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------1. Product Hierarchy----------------------------------------------------------------

WITH CTE_Sales AS(
select 
RANK() OVER(ORDER BY SUM(frs.SalesAmount) desc) 'Rank by Sales',
dp.EnglishProductName 'Product',
dpc.EnglishProductCategoryName 'Category',
dpsc.EnglishProductSubcategoryName 'Sub-Category',
dp.ModelName 'Model Name',
SUM(frs.SalesAmount) 'Sales',
SUM(DiscountAmount) 'Discount Amounts',
SUM(TotalProductCost) 'Product Cost',
SUM(SalesAmount - TotalProductCost) 'Profit',
SUM(OrderQuantity) 'Quantity Ordered',
COUNT(SalesOrderNumber) 'Number of Orders',
AVG(SalesAmount) 'Average Order Size'
from 
dbo.FactResellerSales frs join DimProduct dp
on frs.ProductKey = dp.ProductKey 
join DimProductSubcategory dpsc
on dp.ProductSubcategoryKey = dpsc.ProductSubcategoryKey
join DimProductCategory dpc
on dpsc.ProductCategoryKey = dpc.ProductCategoryKey
group by dp.EnglishProductName, dpc.EnglishProductCategoryName, dpsc.EnglishProductSubcategoryName, dp.ModelName)

SELECT 
[Rank by Sales], Product,  Category,  [Sub-Category], [Model Name],
FORMAT(Sales, 'C', 'en-us') 'Total Sales',
FORMAT([Discount Amounts], 'C', 'en-us') 'Discount Amounts',
FORMAT([Product Cost], 'C', 'en-us') 'Product Cost',
FORMAT(Profit, 'C', 'en-us') Profit,
[Quantity Ordered],
[Number of Orders],
FORMAT([Average Order Size], 'C', 'en-us')'Average Order Size'
FROM CTE_Sales

-----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------1.2 Top 10----------------------------------------------------------------

USE AdventureWorksDW2019;
WITH CTE_Sales AS (
SELECT Top 10
dpsc.EnglishProductSubcategoryName 'Product Subcategory Name', 
dpc.EnglishProductCategoryName 'Product Category Name',
DENSE_RANK() OVER(ORDER BY SUM(SalesAmount) desc,SUM(SalesAmount - TotalProductCost) ) 'Sales Rank',
SUM(SalesAmount) 'Sales',
SUM(SalesAmount - TotalProductCost) 'Profit'
FROM dbo.FactResellerSales frs JOIN DimProduct dp
ON frs.ProductKey = dp.ProductKey
JOIN DimProductSubcategory dpsc
ON dp.ProductSubcategoryKey = dpsc.ProductSubcategoryKey
JOIN DimProductCategory dpc
ON dpsc.ProductCategoryKey = dpc.ProductCategoryKey
and dpc.EnglishProductCategoryName IN ('Bikes','Accessories')
group by dpc.EnglishProductCategoryName, dpsc.EnglishProductSubcategoryName
)
SELECT 
[Product Category Name],
[Product Subcategory Name],
[Sales Rank],
FORMAT(Sales, 'C', 'en-us') 'Total Sales',
FORMAT(Profit, 'C', 'en-us') 'Product Cost'
FROM CTE_Sales

-----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------1.3 Bottom 10 ---------------------------------------------------------

USE AdventureWorksDW2019;
WITH CTE_Sales AS (
SELECT Top 10
dpsc.EnglishProductSubcategoryName 'Product Subcategory Name', 
dpc.EnglishProductCategoryName 'Product Category Name',
DENSE_RANK() OVER(ORDER BY SUM(SalesAmount),SUM(SalesAmount - TotalProductCost) ) 'Sales Rank',
SUM(SalesAmount) 'Sales',
SUM(SalesAmount - TotalProductCost) 'Profit'
FROM dbo.FactResellerSales frs JOIN DimProduct dp
ON frs.ProductKey = dp.ProductKey
JOIN DimProductSubcategory dpsc
ON dp.ProductSubcategoryKey = dpsc.ProductSubcategoryKey
JOIN DimProductCategory dpc
ON dpsc.ProductCategoryKey = dpc.ProductCategoryKey
and dpc.EnglishProductCategoryName IN ('Bikes','Accessories')
group by dpc.EnglishProductCategoryName, dpsc.EnglishProductSubcategoryName
)
SELECT 
[Product Category Name],
[Product Subcategory Name],
[Sales Rank],
FORMAT(Sales, 'C', 'en-us') 'Total Sales',
FORMAT(Profit, 'C', 'en-us') 'Product Cost'
FROM CTE_Sales

-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------2. Reseller Hierarchy ----------------------------------------------------------

use AdventureWorksDW2019;
WITH CTE_ResellerSales AS(
select 
dr.ResellerName 'Reseller Name',
dr.BusinessType 'Business Type',
SUM(frs.SalesAmount) 'Sales',
SUM(DiscountAmount) 'Discount Amounts',
SUM(TotalProductCost) 'Product Cost',
SUM(SalesAmount - TotalProductCost) 'Profit',
SUM(OrderQuantity) 'Quantity Ordered',
COUNT(SalesOrderNumber) 'Number of Orders',
AVG(SalesAmount) 'Average Order Size'
from 
dbo.FactResellerSales frs join dbo.DimReseller dr
ON frs.ResellerKey = dr.ResellerKey
group by dr.ResellerName, dr.BusinessType
)
SELECT 
[Reseller Name],
[Business Type],
FORMAT(Sales, 'C', 'en-us') 'Total Sales',
FORMAT([Discount Amounts], 'C', 'en-us') 'Discount Amounts',
FORMAT([Product Cost], 'C', 'en-us') 'Product Cost',
FORMAT(Profit, 'C', 'en-us') Profit,
[Quantity Ordered],
[Number of Orders],
FORMAT([Average Order Size], 'C', 'en-us')'Average Order Size'
FROM CTE_ResellerSales
ORDER BY Sales DESC

-----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------2.1 Top 10 Resellers ----------------------------------------------------

use AdventureWorksDW2019;
WITH CTE_ResellerSales AS(
select TOP 10
dr.ResellerName 'Reseller Name',
dr.BusinessType 'Business Type',
SUM(frs.SalesAmount) 'Sales',
SUM(DiscountAmount) 'Discount Amounts',
SUM(TotalProductCost) 'Product Cost',
SUM(SalesAmount - TotalProductCost) 'Profit',
SUM(OrderQuantity) 'Quantity Ordered',
COUNT(SalesOrderNumber) 'Number of Orders',
AVG(SalesAmount) 'Average Order Size'
from 
dbo.FactResellerSales frs join dbo.DimReseller dr
ON frs.ResellerKey = dr.ResellerKey
group by dr.ResellerName, dr.BusinessType
Order By Profit, Sales DESC
)
SELECT 
[Reseller Name],
[Business Type],
FORMAT(Sales, 'C', 'en-us') 'Total Sales',
FORMAT([Discount Amounts], 'C', 'en-us') 'Discount Amounts',
FORMAT([Product Cost], 'C', 'en-us') 'Product Cost',
FORMAT(Profit, 'C', 'en-us') 'Profit',
[Quantity Ordered],
[Number of Orders],
FORMAT([Average Order Size], 'C', 'en-us')'Average Order Size'
FROM CTE_ResellerSales

-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------2.2 Key Attributes of Reseller--------------------------------------------------

use AdventureWorksDW2019;
WITH CTE_ResellerSales AS(
select 
DENSE_RANK() OVER (PARTITION BY YEAR(frs.OrderDate) ORDER BY SUM(frs.SalesAmount) DESC) 'Sales Rank',
YEAR(frs.OrderDate) 'Sales Year',
dr.ResellerName 'Reseller Name',
dr.BusinessType 'Business Type',
SUM(dr.NumberEmployees) 'Number Of Employees',
SUM(DiscountAmount) 'Discount Amounts',
SUM(TotalProductCost) 'Product Cost',
SUM(SalesAmount - TotalProductCost) 'Profit',
SUM(OrderQuantity) 'Quantity Ordered',
COUNT(SalesOrderNumber) 'Number of Orders',
AVG(SalesAmount) 'Average Order Size',
SUM(frs.SalesAmount) 'Total Sales'
from 
dbo.FactResellerSales frs join dbo.DimReseller dr
ON frs.ResellerKey = dr.ResellerKey
group by dr.ResellerName, dr.BusinessType, YEAR(frs.OrderDate)
)
SELECT 
[Sales Rank],
[Sales Year],
[Reseller Name],
[Business Type],
[Number Of Employees],
FORMAT([Total Sales], 'C', 'en-us') 'Total Sales',
FORMAT([Discount Amounts], 'C', 'en-us') 'Discount Amounts',
FORMAT([Product Cost], 'C', 'en-us') 'Product Cost',
FORMAT(Profit, 'C', 'en-us') 'Profit',
[Quantity Ordered], [Number of Orders],
FORMAT([Average Order Size], 'C', 'en-us')'Average Order Size' 
FROM CTE_ResellerSales
WHERE [Sales Rank] between 1 and 10
ORDER BY [Sales Year]


-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------3. GEO Hierarchy ---------------------------------------------------------------

use AdventureWorksDW2019;
WITH CTE_GEOSales AS(
SELECT 
dg.EnglishCountryRegionName 'Country',
dg.StateProvinceName 'State/Province',
dg.City 'City',
SUM(SalesAmount) 'Sales',
SUM(DiscountAmount) 'Discount Amount',
SUM(TotalProductCost) 'Product Cost',
SUM(SalesAmount - TotalProductCost) 'Profit',
SUM(OrderQuantity) 'Quantity Ordered',
COUNT(SalesOrderNumber) 'Number of Orders',
AVG(SalesAmount) 'Average Order Size'
FROM dbo.FactResellerSales frs JOIN DimGeography dg
ON frs.SalesTerritoryKey = dg.SalesTerritoryKey
GROUP BY dg.EnglishCountryRegionName , dg.StateProvinceName , dg.City
)
SELECT 
Country, [State/Province], City,
FORMAT([Sales], 'C', 'en-us') 'Total Sales',
FORMAT([Discount Amount], 'C', 'en-us') 'Discount Amounts',
FORMAT([Product Cost], 'C', 'en-us') 'Product Cost',
FORMAT(Profit, 'C', 'en-us') 'Profit',
[Quantity Ordered], [Number of Orders],
FORMAT([Average Order Size], 'C', 'en-us')'Average Order Size' 
FROM CTE_GEOSales



-----------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------4. Top Sales Person--------------------------------------------------------------

use AdventureWorksDW2019;
WITH CTE_SalePerson AS(
select Top 10
(dp.FirstName+' '+dp.LastName) 'Sales Person Name',
dp.DepartmentName 'Department Name',
dp.Title 'Title',
dp.BaseRate 'Base Rates',
SUM(frs.SalesAmount) 'Total Sales'
from 
FactResellerSales frs join dbo.DimEmployee dp 
On frs.EmployeeKey = dp.EmployeeKey
AND SalesPersonFlag <> 0
GROUP BY dp.FirstName,dp.LastName, dp.DepartmentName, dp.Title,dp.BaseRate
ORDER by [Total Sales] DESC
)
SELECT
[Sales Person Name], [Department Name], Title,
FORMAT([Total Sales], 'C', 'en-us') 'Total Sales'
FROM CTE_SalePerson
-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------4.1 Sales Person Attributes-----------------------------------------------------

use AdventureWorksDW2019;
WITH CTE_SalePerson AS(
SELECT 
(dp.FirstName+' '+dp.LastName) 'Sales Person Name',
dp.DepartmentName 'Department Name',
dp.Title 'Title',
SUM(frs.SalesAmount) 'Total Sales',
SUM(frs.SalesAmount) - SUM(frs.TotalProductCost) 'Profit',
SUM(frs.DiscountAmount) 'Discount Amount',
SUM(frs.OrderQuantity) 'Order Quantity',
COUNT(SalesOrderNumber) 'Number of Orders'
FROM FactResellerSales frs JOIN DimEmployee dp
ON frs.EmployeeKey = dp.EmployeeKey
AND dp.SalesPersonFlag = 1
GROUP BY (dp.FirstName+' '+dp.LastName), dp.DepartmentName, dp.Title
)
SELECT
[Sales Person Name], [Department Name], Title,
FORMAT([Total Sales], 'C', 'en-us') 'Total Sales',
FORMAT([Discount Amount], 'C', 'en-us') 'Discount Amounts',
FORMAT(Profit, 'C', 'en-us') 'Profit',
[Order Quantity], [Number of Orders]
FROM CTE_SalePerson



-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------5. Impact of Sales promotoin----------------------------------------------------

USE AdventureWorksDW2019;


WITH CTE_SalesPeople AS 
(
select 
dp.EnglishPromotionName 'Promotion Name',
dp.EnglishPromotionType 'Promotion Type',
dp.EnglishPromotionCategory 'Promotion Category',
SUM(frs.SalesAmount) 'Sales',
LEAD(SUM(frs.SalesAmount),1) OVER (Partition by dp.EnglishPromotionCategory ORDER BY DATEPART(year, frs.OrderDate)) 'Lead Sales',
DATEPART(year, frs.OrderDate) as 'Years'
from FactResellerSales frs JOIN DimPromotion dp
ON frs.PromotionKey = dp.PromotionKey
group by 
dp.EnglishPromotionName ,
dp.EnglishPromotionType,
dp.EnglishPromotionCategory,
DATEPART(year, frs.OrderDate)
)
SELECT 
[Promotion Category],[Promotion Name],[Promotion Type],Years,
FORMAT([Sales], 'C', 'en-us') 'Total Sales',
FORMAT([Lead Sales], 'C', 'en-us') 'Lead Sales',
CASE 
WHEN [Lead Sales] > [Sales]  THEN 'Increase'
WHEN [Lead Sales] = [Sales]  THEN 'No Change'
WHEN [Lead Sales] < [Sales]  THEN 'Decrease'
else 'Unavailable'
END AS TRENDS
FROM CTE_SalesPeople
ORDER BY [Promotion Category]

-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------5.1 Sub Category Sales trends---------------------------------------------------

USE AdventureWorksDW2019;
WITH CTE_SubCat AS 
(
select 
dpsc.EnglishProductSubcategoryName 'Product SubCategory',
SUM(frs.SalesAmount) 'Total Sales',
LEAD(SUM(frs.SalesAmount)) OVER (PARTITION BY dpsc.EnglishProductSubcategoryName ORDER BY YEAR(frs.OrderDate)) 'Lead Sales',
YEAR(frs.OrderDate) 'Sale Year'
from 
FactResellerSales frs join DimProduct dp
on frs.ProductKey = dp.ProductKey
join DimProductSubcategory dpsc
on dpsc.ProductSubcategoryKey = dp.ProductSubcategoryKey
Group BY  frs.OrderDate, dpsc.EnglishProductSubcategoryName
)
SELECT 
[Product SubCategory], [Sale Year],
FORMAT([Total Sales], 'C', 'en-us') 'Total Sales',
FORMAT([Lead Sales], 'C', 'en-us') 'Lead Sales',
CASE 
WHEN [Lead Sales] > [Total Sales]  THEN 'Increase'
WHEN [Lead Sales] = [Total Sales]  THEN 'No Change'
WHEN [Lead Sales] < [Total Sales]  THEN 'Decrease'
else 'Unavailable'
END AS TRENDS
FROM CTE_SubCat
ORDER BY [Product SubCategory]