USE Amazon;
GO
BEGIN TRY
    BEGIN TRANSACTION;
        CREATE TABLE DimProducts(
            ProductKey INT IDENTITY (1,1) PRIMARY KEY,
            ProductID INT NOT NULL UNIQUE,
            ProductName NVARCHAR (150),
            Category NVARCHAR (100),
            Brand NVARCHAR (50)
            );
         CREATE UNIQUE NONCLUSTERED INDEX IX_DimProducts_ProductID
         ON DimProducts (ProductID);

         WITH DimProductsCTE AS (
             SELECT
                 ProductID,TRIM(ProductName)AS ProductName,
                 TRIM(Category) AS Category, TRIM(Brand) AS Brand,
                 ROW_NUMBER()
                     OVER(PARTITION BY ProductID ORDER BY OrderDate) AS ro
             FROM Amazon_Clean
             )

        INSERT INTO DimProducts (
        ProductID,ProductName,Category,Brand
        )
        SELECT 
            ProductID,ProductName,Category,Brand
        FROM DimProductsCTE
        WHERE ro= 1;
    SELECT TOP (10)* FROM DimProducts;
    COMMIT TRANSACTION;
    PRINT 'DimProducts is done';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        PRINT 'Error';
        THROW;
END CATCH
GO