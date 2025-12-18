CREATE VIEW v_RFM_Final AS
SELECT
    CustomerKey,
    CustomerName,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score , M_Score ) AS RFM_Code,
    CASE
       WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
       WHEN R_Score >= 3 AND F_Score >= 3  THEN 'Loyal Customers'
       WHEN R_Score >= 4 AND F_Score >= 2 THEN 'New Customers'
       WHEN R_Score >= 2 AND F_Score >= 3  THEN 'At Risk'
       WHEN R_Score >= 1 AND F_Score >= 1 THEN 'Lost Customers'
       ELSE 'Need Attention'
    END AS CustomerSegment
FROM  v_RFM_Score;
GO



