-- Create the Database (Optional)
CREATE DATABASE IF NOT EXISTS SunscreenTracker;
USE SunscreenTracker;

-- Create Location Table
CREATE TABLE Location (
    LocationID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each location',
    Postcode VARCHAR(20) NOT NULL COMMENT 'Postal code of the location',
    Suburb VARCHAR(100) NOT NULL COMMENT 'Suburb or locality name',
    State VARCHAR(50) NOT NULL COMMENT 'State where the location is situated',
    Latitude DECIMAL(10, 7) COMMENT 'Geographical latitude of the location',
    Longitude DECIMAL(10, 7) COMMENT 'Geographical longitude of the location'
) COMMENT='Stores geographic information for tracking temperature, UV index, cancer data, and sunscreen usage';

-- Create User Table
CREATE TABLE User (
    UserID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each user',
    Username VARCHAR(100) UNIQUE NOT NULL COMMENT 'Username chosen by the user',
    Email VARCHAR(255) UNIQUE NOT NULL COMMENT 'User email address for login and notifications',
    Password VARCHAR(255) NOT NULL COMMENT 'Encrypted user password'
) COMMENT='Stores user details for tracking sunscreen application and reminders';

-- Create Cancer Incidence Table
CREATE TABLE CancerIncidence (
    IncidenceID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each cancer incidence record',
    LocationID INT NOT NULL COMMENT 'Reference to the Location table',
    Year INT NOT NULL COMMENT 'Year of cancer incidence data',
    CancerType VARCHAR(100) NOT NULL COMMENT 'Type of cancer recorded',
    IncidenceRate DECIMAL(10, 2) NOT NULL COMMENT 'Rate of cancer incidence per population',
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
) COMMENT='Stores records of cancer incidence rates based on location and type';

-- Create Cancer Mortality Table
CREATE TABLE CancerMortality (
    MortalityID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each cancer mortality record',
    LocationID INT NOT NULL COMMENT 'Reference to the Location table',
    Year INT NOT NULL COMMENT 'Year of cancer mortality data',
    CancerType VARCHAR(100) NOT NULL COMMENT 'Type of cancer causing mortality',
    MortalityRate DECIMAL(10, 2) NOT NULL COMMENT 'Rate of mortality per population',
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
) COMMENT='Stores records of cancer mortality rates based on location and type';

-- Create Temperature Table
CREATE TABLE Temperature (
    TempDataID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each temperature record',
    LocationID INT NOT NULL COMMENT 'Reference to the Location table',
    Date DATE NOT NULL COMMENT 'Date of the temperature reading',
    Time TIME NOT NULL COMMENT 'Time of the temperature reading',
    Temperature DECIMAL(5, 2) NOT NULL COMMENT 'Temperature recorded in degrees Celsius',
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
) COMMENT='Stores temperature data collected for different locations';

-- Create UV Index Table
CREATE TABLE UVIndex (
    UVDataID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each UV index record',
    LocationID INT NOT NULL COMMENT 'Reference to the Location table',
    Date DATE NOT NULL COMMENT 'Date of the UV index reading',
    Time TIME NOT NULL COMMENT 'Time of the UV index reading',
    UVIndex DECIMAL(5, 2) NOT NULL COMMENT 'UV index value recorded at the given time',
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
) COMMENT='Stores UV index data collected for different locations';

-- Create Sunscreen Application Table
CREATE TABLE SunscreenApplication (
    ApplicationID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each sunscreen application entry',
    UserID INT NOT NULL COMMENT 'Reference to the User table',
    LocationID INT NOT NULL COMMENT 'Reference to the Location table',
    Date DATE NOT NULL COMMENT 'Date when sunscreen was applied',
    Time TIME NOT NULL COMMENT 'Time when sunscreen was applied',
    AmountApplied DECIMAL(5, 2) NOT NULL COMMENT 'Amount of sunscreen applied in milliliters',
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
) COMMENT='Records sunscreen application details by users';

-- Create Sunscreen Reminders Table
CREATE TABLE SunscreenReminders (
    ReminderID INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each sunscreen reminder',
    UserID INT NOT NULL COMMENT 'Reference to the User table',
    LocationID INT NOT NULL COMMENT 'Reference to the Location table',
    LastApplicationID INT NOT NULL COMMENT 'Reference to the SunscreenApplication table',
    NextApplicationTime TIME NOT NULL COMMENT 'Scheduled time for next sunscreen application',
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE,
    FOREIGN KEY (LastApplicationID) REFERENCES SunscreenApplication(ApplicationID) ON DELETE CASCADE
) COMMENT='Stores sunscreen application reminders for users';





-- Insert data into tables for example
-- Location table
INSERT INTO Location (Postcode, Suburb, State, Latitude, Longitude) VALUES
('3000', 'Melbourne', 'Victoria', -37.8136, 144.9631),
('2000', 'Sydney', 'New South Wales', -33.8688, 151.2093),
('4000', 'Brisbane', 'Queensland', -27.4698, 153.0251),
('5000', 'Adelaide', 'South Australia', -34.9285, 138.6007),
('6000', 'Perth', 'Western Australia', -31.9505, 115.8605);


-- User table
INSERT INTO User (Username, Email, Password) VALUES
('john_doe', 'john@example.com', 'password123'),
('alice_smith', 'alice@example.com', 'alicePass!'),
('bob_jones', 'bob@example.com', 'secureBob123'),
('emma_watson', 'emma@example.com', 'emmaSecurePass'),
('liam_miller', 'liam@example.com', 'liamMiller2024');

-- CancerIncidence table
INSERT INTO CancerIncidence (LocationID, Year, CancerType, IncidenceRate) VALUES
(1, 2023, 'Skin Cancer', 120.5),
(2, 2023, 'Lung Cancer', 98.7),
(3, 2023, 'Breast Cancer', 85.2),
(4, 2023, 'Prostate Cancer', 78.4),
(5, 2023, 'Colorectal Cancer', 66.9);

-- CancerMortality Table
INSERT INTO CancerMortality (LocationID, Year, CancerType, MortalityRate) VALUES
(1, 2023, 'Skin Cancer', 45.6),
(2, 2023, 'Lung Cancer', 88.4),
(3, 2023, 'Breast Cancer', 39.2),
(4, 2023, 'Prostate Cancer', 32.1),
(5, 2023, 'Colorectal Cancer', 29.8);

-- Temperature Table
INSERT INTO Temperature (LocationID, Date, Time, Temperature) VALUES
(1, '2024-03-13', '10:00:00', 28.5),
(2, '2024-03-13', '10:00:00', 26.7),
(3, '2024-03-13', '10:00:00', 30.1),
(4, '2024-03-13', '10:00:00', 24.8),
(5, '2024-03-13', '10:00:00', 27.3);

-- UVIndex Table
INSERT INTO UVIndex (LocationID, Date, Time, UVIndex) VALUES
(1, '2024-03-13', '10:00:00', 7.5),
(2, '2024-03-13', '10:00:00', 6.8),
(3, '2024-03-13', '10:00:00', 8.2),
(4, '2024-03-13', '10:00:00', 5.6),
(5, '2024-03-13', '10:00:00', 7.1);

-- SunscreenApplication Table
INSERT INTO SunscreenApplication (UserID, LocationID, Date, Time, AmountApplied) VALUES
(1, 1, '2024-03-13', '09:30:00', 1.5),
(2, 2, '2024-03-13', '09:45:00', 1.2),
(3, 3, '2024-03-13', '10:00:00', 1.8),
(4, 4, '2024-03-13', '10:15:00', 1.4),
(5, 5, '2024-03-13', '10:30:00', 1.6);

-- SunscreenReminders Table
INSERT INTO SunscreenReminders (UserID, LocationID, LastApplicationID, NextApplicationTime) VALUES
(1, 1, 1, '11:30:00'),
(2, 2, 2, '12:00:00'),
(3, 3, 3, '12:30:00'),
(4, 4, 4, '13:00:00'),
(5, 5, 5, '13:30:00');
