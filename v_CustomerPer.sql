USE Amazon;
GO
CREATE VIEW V_CustomerPerformance AS 
    SELECT
        c.CustomerKey,
        c.CustomerName,
        c.City,
        c.State,
        c.Country,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        SUM(o.TotalAmount) AS TotalRevenue,
        AVG(o.TotalAmount) AS AvgOrderValue
    FROM FactOrder o
    JOIN DimCustomer c 
    ON o.CustomerKey = c.CustomerKey
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY c.CustomerKey,c.CustomerName,c.City,c.Country,c.State;
GO
