 -- 1. Product Contribution of Sales


 select  dpc.englishproductcategoryname, SUM(frs.salesamount) as salesAmount
 from FactResellerSales frs
 JOIN DimProduct dp ON frs.ProductKey = dp.ProductKey
 JOIN DimProductSubcategory dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
 JOIN DimProductCategory dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
 GROUP BY dpc.englishproductcategoryname
 ORDER BY salesAmount DESC


 -- 2 . Sales Trends & Forecast (by Month)

 select DATENAME(mm, OrderDate ) as OrderMonthName, SUM(frs.salesamount) as salesAmount
 from FactResellerSales frs
 Group by DATENAME(mm, OrderDate ) 
 Order by  sum( SalesAmount) desc 


--- 3.  Sales Promotions & Discounts
Select
dp.EnglishPromotionCategory as PromotionCategory,
dp.EnglishPromotionType as PromotionType,
dp.EnglishPromotionName as PromotionName,
SUM(frs.DiscountAmount) as DiscountAmount
from FactResellerSales frs
JOIN DimPromotion dp ON dp.PromotionKey = frs.PromotionKey
WHERE dp.EnglishPromotionCategory = 'Reseller'
AND dp.EnglishPromotionType != 'No Discount'
Group By dp.EnglishPromotionCategory,dp.EnglishPromotionType, dp.EnglishPromotionName 
ORDER BY SUM(frs.DiscountAmount) DESC

--- 4. Product Sales by Geo
Select 
dp.EnglishProductName as Product,
SUM(frs.SalesAmount) as SalesAmount,
dst.SalesTerritoryGroup
from FactResellerSales frs
JOIN DimProduct dp ON frs.ProductKey = dp.ProductKey
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = frs.SalesTerritoryKey
GROUP BY 
dp.EnglishProductName, 
dst.SalesTerritoryGroup
ORDER BY SUM(frs.SalesAmount) DESC

-- 5 .Product Profits by Sales Territory

Select 
dp.EnglishProductName,
dst.SalesTerritoryGroup,
SUM((frs.SalesAmount) -  (frs.TotalProductCost))AS Profit
from FactResellerSales frs
JOIN DimProduct dp ON dp.ProductKey = frs.ProductKey
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = frs.SalesTerritoryKey
Group By 
dp.EnglishProductName,
dst.SalesTerritoryGroup
ORDER BY Profit DESC




-- 6 . Top Salespeople ranked
select top 10
CONCAT(de.lastName, ', ', de.firstName) as EmployeeName,
SUM(frs.SalesAmount) as SalesAmount
from FactResellerSales frs 
JOIN DimEmployee de on de.EmployeeKey = frs.EmployeeKey
Group By de.LastName, de.FirstName
Order By SUM(SalesAmount) desc



-- 7 . Top Resellers (Stores) ranked
select top 10
dr.ResellerName,
SUM(frs.SalesAmount) as SalesAmount
from FactResellerSales frs JOIN
DimReseller dr on dr.ResellerKey = frs.ResellerKey
Group By dr.ResellerName
Order By SUM(SalesAmount) desc


-- 8 Geo Contribution to Sales

Select 
CONCAT(dst.SalesTerritoryCountry,'-',
dst.SalesTerritoryGroup,'-',
dst.SalesTerritoryRegion) AS GEO,
CONCAT('$', SUM(SalesAmount)) AS SalesAmount
from FactResellerSales frs
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = frs.SalesTerritoryKey
Group By 
dst.SalesTerritoryCountry,
dst.SalesTerritoryGroup,
dst.SalesTerritoryRegion
ORDER BY SUM(SalesAmount) DESC

--- 9 Salespeople’s report with sales, profit and various person’s attributExamples for Data Viz for 

Select
CONCAT(de.lastName, ', ', de.firstName) as EmployeeName,
SUM(de.PayFrequency) AS PayFrequency,
SUM(de.BaseRate) AS BaseRate,
SUM(de.SickLeaveHours) AS SickLeaveHours,
de.Title,
de.DepartmentName,
de.Gender,
CONCAT('$', SUM(frs.SalesAmount)) AS SalesAmount,
CONCAT('$', SUM((frs.SalesAmount) -  (frs.TotalProductCost))) AS Profit
From FactResellerSales frs
JOIN DimEmployee de ON de.EmployeeKey = frs.EmployeeKey 
GROUP BY
de.LastName,
de.firstName,
de.Title,
de.DepartmentName,
de.Gender
ORDER BY SUM(frs.SalesAmount) DESC





-- 10 : Resellers’ report with sales, profit and various person’s attributes


Select
dr.ResellerName,
dr.FirstOrderYear,
dr.OrderFrequency,
dr.bankName,
dr.BusinessType,
dst.SalesTerritoryGroup,
SUM(dr.NumberEmployees) AS TotalEmployees,
CONCAT('$', SUM(dr.AnnualRevenue)) AS AnnualRevenue,
CONCAT('$',SUM(dr.AnnualSales)) AS AnnualSales,
CONCAT('$', SUM(SalesAmount)) AS SalesAmount,
CONCAT('$', SUM((frs.SalesAmount) -  (frs.TotalProductCost))) AS Profit
from FactResellerSales frs
JOIN DimReseller dr on dr.ResellerKey = frs.ResellerKey
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = frs.SalesTerritoryKey
Group by 
dr.ResellerName,
dr.FirstOrderYear,
dr.OrderFrequency,
dr.bankName,
dr.BusinessType,
dst.SalesTerritoryGroup
Order By SUM(SalesAmount) DESC
