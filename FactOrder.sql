USE Amazon;
GO
BEGIN TRY 
    BEGIN TRANSACTION;
        CREATE TABLE FactOrder (
            OrderKey INT IDENTITY (1,1) PRIMARY KEY, 
            OrderID NVARCHAR (50) NOT NULL UNIQUE,
            CustomerKey INT NOT NULL,
            DateKey INT NOT NULL,
            ProductKey INT NOT NULL,
            SellerKey INT NOT NULL,
            Quantity INT  ,
            UnitPrice DECIMAL (18,2),
            Discount DECIMAL (18,4),
            Tax DECIMAL (18,2),
            ShippingCost DECIMAL (18,2),
            TotalAmount DECIMAL (18,2),
            OrderDate DATE,
            PaymentMetod NVARCHAR (50),
            OrderStatus NVARCHAR (50),
            FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
            FOREIGN KEY (DateKey) REFERENCES DimDate (DateKey),
            FOREIGN KEY (ProductKey) REFERENCES DimProducts (ProductKey),
            FOREIGN KEY (SellerKey) REFERENCES DimSeller (SellerKey)
            );
        INSERT INTO FactOrder (
            OrderID,CustomerKey,DateKey,ProductKey,SellerKey,Quantity
            ,UnitPrice,Discount,Tax,ShippingCost,TotalAmount,OrderDate,
            PaymentMetod,OrderStatus
            )
        SELECT DISTINCT
            a.OrderID,c.CustomerKey,d.DateKey,p.ProductKey,s.SellerKey,a.Quantity
            ,a.UnitPrice,a.Discount,a.Tax,a.ShippingCost,a.TotalAmount,
            a.OrderDate,a.PaymentMethod,a.OrderStatus
        FROM Amazon_Clean a
        JOIN DimCustomer c 
            ON a.CustomerID = c.CustomerID
        JOIN DimDate d
            ON a.OrderDate = d.Date
        JOIN DimProducts p 
            ON a.ProductID = p.ProductID
        JOIN DimSeller s 
            ON a.SellerID = s.SellerID 
        WHERE a.OrderID IS NOT NULL;
        SELECT TOP (10)* FROM FactOrder;
    COMMIT TRANSACTION;
    PRINT 'FactOrder Table done';
END TRY
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        PRINT 'Error';
        THROW;
END CATCH
GO

