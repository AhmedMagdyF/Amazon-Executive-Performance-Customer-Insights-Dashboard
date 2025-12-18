USE Amazon;
GO
BEGIN TRY
    BEGIN TRANSACTION;
        CREATE TABLE DimCustomer (
        CustomerKey INT IDENTITY (1,1) PRIMARY KEY,
        CustomerID NVARCHAR (50) NOT NULL UNIQUE,
        CustomerName NVARCHAR (50)  NULL,
        City NVARCHAR (50),
        State NVARCHAR (50),
        Country NVARCHAR (100),
        );

        CREATE UNIQUE NONCLUSTERED INDEX IX_DimCustomer_CustomerID
        ON DimCustomer (CustomerID);
        
        WITH CustomerCTE AS (
            SELECT
                 TRIM(CustomerID) AS CustomerID,
                 TRIM (CustomerName) AS CustomerName,
                 TRIM(City) AS City,
                 TRIM(State) AS State,
                 TRIM(Country) AS Country,
                 ROW_NUMBER()
                    OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS row_num
             FROM Amazon_Clean
             WHERE CustomerID IS NOT NULL
             )
        
        INSERT INTO DimCustomer (
        CustomerID,CustomerName,City,State,Country
        )

        SELECT 
            CustomerID,CustomerName,City,State,Country
            
        FROM CustomerCTE
        WHERE row_num =1;
        
        SELECT TOP (10)* FROM DimCustomer;
    COMMIT TRANSACTION;
    PRINT 'DimCustomer table created and populated successfully'
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
       ROLLBACK TRANSACTION;
       PRINT 'Error during DimCustomer creation/population.';
       THROW;
END CATCH
GO

