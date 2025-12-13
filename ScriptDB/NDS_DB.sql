IF DB_ID('Project_NDS_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Project_NDS_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Project_NDS_DB;
END
GO

CREATE DATABASE Project_NDS_DB;
GO
USE Project_NDS_DB;
GO

IF OBJECT_ID('NDS_Flight', 'U') IS NOT NULL DROP TABLE NDS_Flight;
IF OBJECT_ID('NDS_Airport', 'U') IS NOT NULL DROP TABLE NDS_Airport;
IF OBJECT_ID('NDS_Airline', 'U') IS NOT NULL DROP TABLE NDS_Airline;
IF OBJECT_ID('NDS_Reason', 'U') IS NOT NULL DROP TABLE NDS_Reason;
GO


CREATE TABLE NDS_Airport (
    IATA_Code CHAR(3) PRIMARY KEY,
    Airport_Name VARCHAR(200) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    Created DATETIME NULL,
    Modified DATETIME NULL
);

CREATE TABLE NDS_Airline (
    IATA_Code CHAR(2) PRIMARY KEY,
    Airline_Name VARCHAR(200) NOT NULL,
    Created DATETIME NULL,
    Modified DATETIME NULL
);

CREATE TABLE NDS_Reason (
    Reason_Type CHAR(1) PRIMARY KEY,
    Reason_Name VARCHAR(100) NOT NULL,
    Created DATETIME NULL,
    Modified DATETIME NULL
);

CREATE TABLE NDS_Flight (
    Flight_ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    Source_ID INT NULL,
    Date DATE NOT NULL,
    Flight_number VARCHAR(10),
    Tail_number VARCHAR(20),

    Airline CHAR(2) NOT NULL,
    Origin_Airport CHAR(3) NOT NULL,
    Dest_Airport CHAR(3) NOT NULL,

    Scheduled_departure CHAR(5) NULL,
    Departure_delay INT NULL,
    Taxi_out INT NULL,
    Wheels_off CHAR(5) NULL,
    Scheduled_time INT NULL,
    Air_time INT NULL,
    Wheels_on CHAR(5) NULL,
    Taxi_in INT NULL,
    Scheduled_arrival CHAR(5) NULL,
    Arrival_delay INT NULL,
    Diverted_Flag BIT NULL,
    Canceled_Flag BIT NULL,
    Canceled_Reason CHAR(1) NULL,
    Air_system_delay INT NULL,
    Security_delay INT NULL,
    Airline_delay INT NULL,
    Late_aircraft_delay INT NULL,
    Weather_delay INT NULL,

    Created DATETIME NULL,
    Modified DATETIME NULL,

    CONSTRAINT FK_Flight_Airline FOREIGN KEY (Airline) REFERENCES NDS_Airline(IATA_Code),
    CONSTRAINT FK_Flight_Origin FOREIGN KEY (Origin_Airport) REFERENCES NDS_Airport(IATA_Code),
    CONSTRAINT FK_Flight_Dest FOREIGN KEY (Dest_Airport) REFERENCES NDS_Airport(IATA_Code),
    CONSTRAINT FK_Flight_Reason FOREIGN KEY (Canceled_Reason) REFERENCES NDS_Reason(Reason_Type),
    CONSTRAINT NK_Flight UNIQUE (Date, Flight_number, Scheduled_departure, Origin_Airport, Dest_Airport, Source_ID)
);


INSERT INTO NDS_Reason (Reason_Type, Reason_Name, Created)
VALUES 
('A', 'Airline/Carrier', GETDATE()),
('B', 'Weather', GETDATE()),
('C', 'National Air System', GETDATE()),
('D', 'Security', GETDATE());


select * from NDS_Airline;
select * from NDS_Airport;
select * from NDS_Reason;
select * from NDS_Flight;


