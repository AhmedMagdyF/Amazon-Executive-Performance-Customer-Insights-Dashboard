USE Amazon;
GO
BEGIN TRY
    BEGIN TRANSACTION;
        CREATE TABLE DimDate (
            DateKey INT PRIMARY KEY,
            Date DATE NOT NULL,
            Year INT NOT NULL,
            Month INT NOT NULL,
            MonthName NVARCHAR (50),
            Quarter INT NOT NULL,
            Day INT NOT NULL
            );
        INSERT INTO DimDate (
        DateKey,Date,Year,Month,MonthName,Quarter,Day
        )
        SELECT DISTINCT
            CAST(FORMAT(a.OrderDate,'yyyyMMdd') AS INT) AS DateKey,
            CAST(a.OrderDate AS DATE) AS Date,
            YEAR(a.OrderDate) AS Year,
            MONTH(a.OrderDate) AS Month,
            FORMAT(a.OrderDate , 'MMM') AS MonthName,
            DATEPART(qq,a.OrderDate) AS Quarter,
            DAY(a.OrderDate) AS Day
        FROM Amazon_Clean a
        WHERE a.OrderDate IS NOT NULL;
        SELECT TOP (10)* FROM DimDate;
    COMMIT TRANSACTION;
    PRINT'Dim is done';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION ;
        PRINT 'Error';
        THROW;
END CATCH
GO

