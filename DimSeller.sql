USE Amazon;
GO
BEGIN TRY
    BEGIN TRANSACTION;
        CREATE TABLE DimSeller (
            SellerKey INT IDENTITY (1,1) PRIMARY KEY,
            SellerID NVARCHAR (50) NOT NULL UNIQUE
            );
         CREATE UNIQUE NONCLUSTERED INDEX IX_DimSeller_SellerID
         ON DimSeller (SellerID);
         INSERT INTO DimSeller ( SellerID)
         SELECT DISTINCT 
             TRIM(SellerID) AS SellerID
         FROM Amazon_Clean
         WHERE SellerID IS NOT NULL;
         SELECT TOP (10)* FROM DimSeller;
    COMMIT TRANSACTION;
    PRINT 'DimSeller is done';
END TRY
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        PRINT 'Error';
        THROW;
END CATCH
GO