USE Project_DDS_DB;
GO

IF NOT EXISTS (SELECT 1 FROM Dim_Time)
BEGIN
    ;WITH T AS (
        SELECT CAST(0 AS INT) AS n
        UNION ALL
        SELECT n + 1 FROM T WHERE n < 1439   -- 0..1439 = 1440 phút
    )
    INSERT INTO Dim_Time ([Hour], [Minute], Part_of_day)
    SELECT
        n / 60 AS [Hour],           -- 0..23
        n % 60 AS [Minute],         -- 0..59
        CASE 
            WHEN n / 60 BETWEEN 0  AND 5  THEN N'Night'      -- hoặc N'Đêm'
            WHEN n / 60 BETWEEN 6  AND 11 THEN N'Morning'    -- hoặc N'Sáng'
            WHEN n / 60 BETWEEN 12 AND 17 THEN N'Afternoon'  -- hoặc N'Chiều'
            ELSE N'Evening'                                   -- hoặc N'Tối'
        END AS Part_of_day
    FROM T
    OPTION (MAXRECURSION 0);
END
ELSE
BEGIN
    PRINT N'Dim_Time đã có dữ liệu, không insert thêm.';
END;
GO

