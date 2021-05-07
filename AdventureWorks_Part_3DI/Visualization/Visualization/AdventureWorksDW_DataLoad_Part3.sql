-- 1. What are AdventureWorks purchases (Purchase cost & quantity) by product?

 SELECT pp.ProductName, SUM(fp.OrderQty) AS PurchaseQuantity, SUM(fp.TotalDue) AS PurchaseCost
 FROM FCT_Purchases fp
 JOIN DIM_products_purchased pp ON fp.ProductPurchasedSK = pp.ProductPurchasedSK
 GROUP BY pp.ProductName 
 ORDER BY SUM(fp.TotalDue) DESC, SUM(fp.OrderQty)

--2. What types of products are purchased?

 SELECT DISTINCT pp.ProductCategoryName, pp.ProductSubcategoryName, SUM(fp.TotalDue) AS TotalPurchaseQuantity
 FROM FCT_Purchases fp
 JOIN DIM_products_purchased pp ON fp.ProductPurchasedSK = pp.ProductPurchasedSK
 WHERE pp.ProductCategoryName IS NOT NULL
 GROUP BY pp.ProductCategoryName, pp.ProductSubcategoryName
 ORDER BY SUM(fp.TotalDue) DESC


--3. What are AdventureWorks product purchases (Purchase cost & quantity) by vendor?

 SELECT DISTINCT v.VendorName, SUM(fp.OrderQty) AS TotalPurchaseQuantity, SUM(fp.TotalDue) AS PurchaseCost
 FROM FCT_Purchases fp
 JOIN DIM_vendors v ON fp.VendorSK = v.VendorSK
 GROUP BY v.VendorName
 ORDER BY SUM(fp.TotalDue) DESC, SUM(fp.OrderQty)


--4. What AdventureWorks’ employees were involved in the above purchasing and what did they purchase

 SELECT CONCAT(e.LastName, ', ', e.FirstName) as EmployeeName, pp.ProductName AS PurchasedProductName, pp.ProductCategoryName AS PurchasedProductCategory, SUM(fp.TotalDue) AS TotalPurchaseQuantity
 FROM DIM_employee e
 JOIN FCT_Purchases fp  ON fp.EmployeeSK = e.EmployeeSK
 JOIN DIM_products_purchased pp ON fp.ProductPurchasedSK = pp.ProductPurchasedSK
 WHERE pp.ProductCategoryName IS NOT NULL
 GROUP BY e.LastName, e.FirstName, pp.ProductName, pp.ProductCategoryName
 ORDER BY SUM(fp.TotalDue) DESC

--5. What vendors’ contacts were involved in the above purchasing and what did they purchase

 SELECT CONCAT(vc.LastName, ', ', vc.FirstName) as VendorContactName, pp.ProductName AS PurchasedProductName, pp.ProductCategoryName AS PurchasedProductCategory, SUM(fp.TotalDue) AS TotalPurchaseQuantity
 FROM DIM_vendorcontacts vc
 JOIN DIM_vendors v ON vc.VendorSK = v.VendorSK
 JOIN FCT_Purchases fp  ON fp.VendorSK = v.VendorSK
 JOIN DIM_products_purchased pp ON fp.ProductPurchasedSK = pp.ProductPurchasedSK
 WHERE pp.ProductCategoryName IS NOT NULL
 GROUP BY vc.LastName, vc.FirstName, pp.ProductName, pp.ProductCategoryName
 ORDER BY SUM(fp.TotalDue) DESC