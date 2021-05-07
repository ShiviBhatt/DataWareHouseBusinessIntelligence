USE AdventureWorksDW_Part_3
/*
What are AdventureWorks purchases (Purchase cost & quantity) by product?
*/
select dp.ProductName,
	   fp.OrderQty,
	   sum(fp.TotalDue) as 'Total Purchases' 
from   AdventureWorksDW_Part_3.dbo.FCT_Purchases fp inner join AdventureWorksDW_Part_3.dbo.DIM_products_purchased dp
on fp.ProductPurchasedSK = dp.ProductPurchasedSK
group by dp.ProductName, fp.OrderQty

/*
What types of products are purchased?
*/

SELECT dp.ProductName,
	   dp.ProductCategoryName,
	   dp.ProductSubcategoryName,
	   SUM(TotalDue) as 'Total Purchases' 
from   AdventureWorksDW_Part_3.dbo.FCT_Purchases fp inner join AdventureWorksDW_Part_3.dbo.DIM_products_purchased dp
on fp.ProductPurchasedSK = dp.ProductPurchasedSK
group by dp.ProductName,
	   dp.ProductCategoryName,
	   dp.ProductSubcategoryName

/*
What are AdventureWorks product purchases (Purchase cost & quantity) by vendor?
*/
USE AdventureWorksDW_Part_3;
SELECT 
V.VendorName  'Vendor Name',
prod.ProductName 'Product',
SUM(TotalDue) 'Total Purchase'
FROM  DIM_vendors AS V join FCT_Purchases p ON V.BusinessEntityID = p.VendorID
JOIN DIM_productvendor dp on v.BusinessEntityID = dp.VendorID
JOIN DIM_product prod on dp.ProductID = prod.ProductID
GROUP BY V.VendorName, prod.ProductName ;

*/

SELECT 