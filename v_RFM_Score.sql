USE Amazon;
GO
CREATE VIEW v_RFM_Score AS 
SELECT
     CustomerKey,
    CustomerName,
    Recency,
    Frequency,
    Monetary,
    NTILE(5) OVER(ORDER BY Recency ASC) AS R_Score,
    NTILE(5) OVER(ORDER BY Frequency DESC) AS F_Score,
    NTILE(5) OVER(ORDER BY Monetary DESC) AS M_Score
FROM v_RFM_Base;
GO