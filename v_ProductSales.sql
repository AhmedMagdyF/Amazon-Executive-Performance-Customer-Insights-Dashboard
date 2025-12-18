USE Amazon;
GO
CREATE VIEW v_ProductSales AS
SELECT 
    p.ProductKey,
    p.ProductName,
    p.Category,
    p.Brand,
    SUM(o.TotalAmount) AS TotalRevenue,
    SUM(o.Quantity) AS TotalQuantitySold,
    AVG(o.Discount) AS AvgDiscountRate
FROM FactOrder o
JOIN DimProducts p 
ON o.ProductKey = p.ProductKey
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductKey,p.ProductName,p.Category,p.Brand;
GO
