 -- 1. Product Contribution of Sales
 use adventureworksdw;
 Select dp.ProductCategoryName, CONCAT('$',SUM(fis.LineTotal)) as SalesAmount
 from 
 adventureworksdw.FCT_InternetSales fis
 JOIN adventureworksdw.dim_product dp ON dp.ProductSK = fis.ProductSK 
 group by dp.ProductCategoryName
 ORDER BY SUM(fis.LineTotal) DESC;
 
  Select dp.ProductCategoryName, CONCAT('$',SUM(fss.LineTotal)) as SalesAmount
 from 
 adventureworksdw.FCT_StoreSales fss
 JOIN adventureworksdw.dim_product dp ON dp.ProductSK = fss.ProductSK 
 group by dp.ProductCategoryName
 ORDER BY SUM(fss.LineTotal) DESC;


 -- 2 . Comparison of Yearly Sales

 select YEAR( OrderDate ) as OrderYearName, CONCAT('$',SUM(fis.LineTotal)) as SalesAmount
 from  adventureworksdw.FCT_InternetSales fis
 Group by YEAR( OrderDate )
 Order by  SUM(fis.LineTotal) desc ;
 
 
 select YEAR( OrderDate ) as OrderYearName, CONCAT('$',SUM(fss.LineTotal)) as SalesAmount
 from  adventureworksdw.FCT_StoreSales fss
 Group by YEAR( OrderDate )
 Order by  SUM(fss.LineTotal) desc ;


--- 3.  Sales Promotions & Discounts

SELECT 	
dimprom.Description, 
dimprom.type, 
dimprom.Category,
		CONCAT('$',SUM(fis.LineTotal)) AS TotaSales,
		SUM(DiscountPct * 100) AS Discount,
		SUM((LineTotal)/100) AS 'Promotion %'
from adventureworksdw.FCT_InternetSales fis 
INNER JOIN Dim_product dp ON dp.ProductSK=fis.ProductSK
INNER JOIN DIM_promotions dimprom ON dimprom.PromotionSK = fis.PromotionSK
GROUP BY 
dimprom.Description, 
dimprom.type, 
dimprom.Category
ORDER BY SUM(fis.LineTotal) DESC;



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

--- 9 Salespeoples report with sales, profit and various persons attributExamples for Data Viz for 

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





-- 10 : Resellers report with sales, profit and various persons attributes


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
