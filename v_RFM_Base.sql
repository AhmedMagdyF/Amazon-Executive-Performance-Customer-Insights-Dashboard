USE Amazon;
GO
CREATE VIEW v_RFM_Base AS
SELECT
    c.CustomerKey,
    c.CustomerName,
    DATEDIFF(
        DAY,
        MAX(o.OrderDate),
        (SELECT MAX(OrderDate) FROM FactOrder) )AS Recency,
        COUNT(DISTINCT o.OrderID) AS Frequency,
        SUM(o.TotalAmount) AS Monetary
FROM FactOrder o
JOIN DimCustomer c
ON o.CustomerKey = c.CustomerKey
WHERE o.OrderStatus = 'Delivered'
GROUP BY c.CustomerKey,c.CustomerName;
