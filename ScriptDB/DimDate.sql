USE Project_DDS_DB;
GO

IF OBJECT_ID('dbo.usp_Extend_Dim_Date', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Extend_Dim_Date;
GO

CREATE PROCEDURE dbo.usp_Extend_Dim_Date
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NeedMin DATE, @NeedMax DATE;
    DECLARE @CurMin  DATE, @CurMax  DATE;
    DECLARE @BuffDay INT = 30;  

    SELECT 
        @NeedMin = MIN([Date]),
        @NeedMax = MAX([Date])
    FROM Project_NDS_DB.dbo.NDS_Flight;  

    IF @NeedMin IS NULL OR @NeedMax IS NULL
    BEGIN
        PRINT 'No source date in NDS. Nothing to extend for Dim_Date.';
        RETURN;
    END;

    SET @NeedMin = DATEADD(DAY, -@BuffDay, @NeedMin);
    SET @NeedMax = DATEADD(DAY,  @BuffDay, @NeedMax);

    -- 2. Lấy range hiện tại Dim_Date (trong DDS)
    SELECT 
        @CurMin = MIN(Full_Date),
        @CurMax = MAX(Full_Date)
    FROM dbo.Dim_Date;

    IF @CurMax IS NULL
        SET @CurMax = DATEADD(DAY, -1, @NeedMin);

    IF @NeedMax > @CurMax
    BEGIN
        PRINT 'Extending Dim_Date to ' + CONVERT(varchar(10), @NeedMax, 120);

        ;WITH D AS (
            SELECT DATEADD(DAY, 1, @CurMax) AS Full_Date
            UNION ALL
            SELECT DATEADD(DAY, 1, Full_Date)
            FROM D
            WHERE Full_Date < @NeedMax
        )
        INSERT INTO dbo.Dim_Date (
            Full_Date, [Day], [Month], [Quarter], [Year],
            Season, Day_of_week, Is_Weekend
        )
        SELECT
            d.Full_Date,
            DAY(d.Full_Date),
            MONTH(d.Full_Date),
            DATEPART(QUARTER, d.Full_Date),
            YEAR(d.Full_Date),
            CASE 
                WHEN MONTH(d.Full_Date) IN (12,1,2)  THEN N'Winter'
                WHEN MONTH(d.Full_Date) IN (3,4,5)   THEN N'Spring'
                WHEN MONTH(d.Full_Date) IN (6,7,8)   THEN N'Summer'
                ELSE N'Autumn'
            END,
            DATEPART(WEEKDAY, d.Full_Date),
            CASE 
                WHEN DATENAME(WEEKDAY, d.Full_Date) IN 
                    (N'Saturday', N'Sunday', N'Thứ Bảy', N'Chủ Nhật')
                THEN 1 ELSE 0
            END
        FROM D
        OPTION (MAXRECURSION 0);
    END
    ELSE
    BEGIN
        PRINT 'Dim_Date already covers needed range.';
    END;
END;
GO




