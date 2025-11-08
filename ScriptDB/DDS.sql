CREATE DATABASE DDS;
GO
USE DDS;
GO

-- Dim_Airline
IF OBJECT_ID('Dim_Airline', 'U') IS NOT NULL DROP TABLE Dim_Airline;
GO
CREATE TABLE Dim_Airline (
    Airline_ID     INT IDENTITY(1,1) PRIMARY KEY,      -- SK
    IATA_Code      CHAR(2)        NOT NULL,            -- NK
    Airline_Name   NVARCHAR(200)  NOT NULL,

    CONSTRAINT UQ_Dim_Airline_IATA UNIQUE (IATA_Code)
)

-- Dim_Airport
IF OBJECT_ID('Dim_Airport', 'U') IS NOT NULL DROP TABLE Dim_Airport;
GO
CREATE TABLE Dim_Airport (
    Airport_ID     INT IDENTITY(1,1) PRIMARY KEY,      -- SK
    IATA_Code      CHAR(3)        NOT NULL,            -- NK
    City           NVARCHAR(100)  NULL,
    State          NVARCHAR(100)  NULL,
    Country        NVARCHAR(100)  NULL,
    Latitude       DECIMAL(9,6)   NULL,
    Longitude      DECIMAL(9,6)   NULL,

    CONSTRAINT UQ_Dim_Airport_IATA UNIQUE (IATA_Code)
)

-- Dim_Date
IF OBJECT_ID('Dim_Date', 'U') IS NOT NULL DROP TABLE Dim_Date;
GO
CREATE TABLE Dim_Date (
    Date_ID     INT IDENTITY(1,1) PRIMARY KEY,         -- SK
    Full_Date   DATE           NOT NULL,               -- NK
    [Day]       TINYINT        NOT NULL,
    [Month]     TINYINT        NOT NULL,
    [Quarter]   TINYINT        NOT NULL,
    [Year]      SMALLINT       NOT NULL,
    Season      NVARCHAR(20)   NULL,
    Day_of_week TINYINT        NOT NULL,               -- 1-7
    Is_Weekend  BIT            NOT NULL,

    CONSTRAINT UQ_Dim_Date_FullDate UNIQUE (Full_Date)
)

-- Dim_Time
IF OBJECT_ID('Dim_Time', 'U') IS NOT NULL DROP TABLE Dim_Time;
GO
CREATE TABLE Dim_Time (
    Time_ID      INT IDENTITY(1,1) PRIMARY KEY,        -- SK
    [Hour]       TINYINT       NOT NULL,               -- 0-23
    [Minute]     TINYINT       NOT NULL,               -- 0-59
    Part_of_day  NVARCHAR(20)  NULL                   
)

-- Dim_Reason
IF OBJECT_ID('Dim_Reason', 'U') IS NOT NULL DROP TABLE Dim_Reason;
GO
CREATE TABLE Dim_Reason (
    Reason_ID    INT IDENTITY(1,1) PRIMARY KEY,        -- SK
    Reason_Type  NVARCHAR(20) NOT NULL,                -- Delay / Cancel
    Reason_Name  NVARCHAR(100) NOT NULL,               
    
    CONSTRAINT UQ_Dim_Reason_Type_Name UNIQUE (Reason_Type, Reason_Name)
)

-- FACT TABLE
IF OBJECT_ID('Fact_Flight', 'U') IS NOT NULL DROP TABLE Fact_Flight;
GO
CREATE TABLE Fact_Flight (
    Flight_ID          BIGINT IDENTITY(1,1) PRIMARY KEY,  -- SK 
    Depart_Date_ID     INT NOT NULL,
    Arrive_Date_ID     INT NOT NULL,
    Depart_Time_ID     INT NOT NULL,
    Arrive_Time_ID     INT NOT NULL,
    Origin_Airport_ID  INT NOT NULL,
    Dest_Airport_ID    INT NOT NULL,
    Airline_ID         INT NOT NULL,
    Flight_number      NVARCHAR(10) NULL,
    Tail_number        NVARCHAR(20) NULL,
    Total_depart_delay INT NULL,
    Total_arrive_delay INT NULL,
    Air_system_delay   INT NULL,
    Weather_delay      INT NULL,
    Late_aircraft_delay INT NULL,
    Airline_delay      INT NULL,
    Security_delay     INT NULL,
    Diverted_Flag      BIT NULL,
    Canceled_Flag      BIT NULL,
    Canceled_Reason    INT NULL    
)

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_DepartDate
    FOREIGN KEY (Depart_Date_ID)
    REFERENCES Dim_Date (Date_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_ArriveDate
    FOREIGN KEY (Arrive_Date_ID)
    REFERENCES Dim_Date (Date_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_DepartTime
    FOREIGN KEY (Depart_Time_ID)
    REFERENCES Dim_Time (Time_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_ArriveTime
    FOREIGN KEY (Arrive_Time_ID)
    REFERENCES Dim_Time (Time_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_OriginAirport
    FOREIGN KEY (Origin_Airport_ID)
    REFERENCES Dim_Airport (Airport_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_DestAirport
    FOREIGN KEY (Dest_Airport_ID)
    REFERENCES Dim_Airport (Airport_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_Airline
    FOREIGN KEY (Airline_ID)
    REFERENCES Dim_Airline (Airline_ID);

ALTER TABLE Fact_Flight  WITH CHECK
ADD CONSTRAINT FK_FactFlight_CanceledReason
    FOREIGN KEY (Canceled_Reason)
    REFERENCES Dim_Reason (Reason_ID);
GO
