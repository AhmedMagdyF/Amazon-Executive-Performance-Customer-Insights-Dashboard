USE Amazon;
GO
SELECT*
INTO Amazon_Clean
FROM Amazon;
GO

--1.Deleted duplcateted
BEGIN TRY 
    BEGIN TRANSACTION;
        WITH CTE AS (
         SELECT*,
        ROW_NUMBER() OVER(PARTITION BY OrderID,CustomerID,ProductID,Quantity,UnitPrice
           ORDER BY OrderID ) AS row_num
        FROM Amazon_Clean
         )
        DELETE FROM CTE WHERE row_num > 1;
--2.Text Cleaning
        UPDATE Amazon_Clean
        SET 
           CustomerName = TRIM(CustomerName),
           ProductName = TRIM(ProductName),
           Category = TRIM(Category),
           Brand = TRIM(Brand),
           PaymentMethod = TRIM(PaymentMethod),
           OrderStatus = TRIM(OrderStatus),
           City = TRIM(City),
           State = TRIM(State),
           Country = TRIM(Country)

        UPDATE Amazon_Clean
        SET Country = 'United States'
        WHERE Country IN ('USA','US','U.S.');

        UPDATE Amazon_Clean
        SET OrderStatus = 'Cancelled'
        WHERE OrderStatus IN ('canceled','CANCELLED');

--3.Numerice Conversion
        UPDATE Amazon_Clean
        SET 
            UnitPrice = COALESCE(TRY_CAST(UnitPrice AS DECIMAL (18,2)),0.00),
            Discount = COALESCE(TRY_CAST(Discount AS DECIMAL (18,4)),0.00),
            Tax = COALESCE(TRY_CAST(Tax AS DECIMAL (18,2)),0.00),
            ShippingCost = COALESCE(TRY_CAST( ShippingCost AS DECIMAL (18,2)),0.00),
            TotalAmount = COALESCE(TRY_CAST(TotalAmount AS DECIMAL (18,2)),0.00),
            Quantity = COALESCE (TRY_CAST(Quantity AS INT),1),
            ProductID = COALESCE(TRY_CAST(ProductID AS INT),1);
--4.Business Rules
        UPDATE Amazon_Clean
        SET Discount = 0 
        WHERE Discount < 0 OR Discount > 1 OR Discount IS NULL;

        UPDATE Amazon_Clean
        SET Quantity = 1
        WHERE Quantity IS NULL OR Quantity <=0;

    COMMIT TRANSACTION;
    PRINT 'Amazon_Clean transformation completed successfully';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;
      PRINT 'Error during Amazon_Clean transformation';
      THROW;
END CATCH
GO
--5.Modify the data types in the new table (Amazon_Clean)--
ALTER TABLE Amazon_Clean
ALTER COLUMN ProductID INT NOT NULL;
ALTER TABLE Amazon_Clean
ALTER COLUMN UnitPrice DECIMAL (18,2) NOT NULL;
ALTER TABLE Amazon_Clean
ALTER COLUMN Quantity INT NOT NULL;
ALTER TABLE Amazon_Clean
ALTER COLUMN Discount DECIMAL (18,4) NOT NULL;
ALTER TABLE Amazon_Clean
ALTER COLUMN Tax DECIMAL (18,2) NOT NULL;
ALTER TABLE Amazon_Clean
ALTER COLUMN ShippingCost DECIMAL (18,2) NOT NULL;
ALTER TABLE Amazon_Clean
ALTER COLUMN TotalAmount DECIMAL (18,2) NOT NULL;
GO
SELECT TOP (10)* FROM Amazon_Clean;
GO

