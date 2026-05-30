-- CREATE DATABASE IF NOT EXISTS healthsync;
-- USE healthsync;

DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS MedicalRecords;
DROP TABLE IF EXISTS Allergies;
DROP TABLE IF EXISTS Users;

-- Consolidated Users table supporting both Patient and Doctor roles
CREATE TABLE Users (
    username VARCHAR(50) NOT NULL PRIMARY KEY, -- Holds 12-digit Unique HealthSync ID for Patient or Custom Username for Doctor
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL,
    last_name VARCHAR(50) NOT NULL,
    name VARCHAR(150) DEFAULT NULL, -- Computed or directly stored name
    dob DATE DEFAULT NULL,
    gender VARCHAR(20) DEFAULT NULL,
    blood_group VARCHAR(10) DEFAULT NULL,
    mobile VARCHAR(20) DEFAULT NULL,
    street VARCHAR(100) DEFAULT NULL,
    city VARCHAR(50) DEFAULT NULL,
    state VARCHAR(50) DEFAULT NULL,
    zipcode VARCHAR(10) DEFAULT NULL,
    address VARCHAR(255) DEFAULT NULL, -- Composite address
    aadhaar VARCHAR(20) DEFAULT NULL,
    insurance VARCHAR(50) DEFAULT NULL,
    guardian_name VARCHAR(100) DEFAULT NULL,
    guardian_mobile VARCHAR(20) DEFAULT NULL,
    emergency_contact VARCHAR(20) DEFAULT NULL,
    user_type VARCHAR(20) NOT NULL DEFAULT 'patient', -- 'patient' or 'doctor'
    nmr_id VARCHAR(50) DEFAULT NULL, -- National Medical Register ID for doctors only
    profile_photo MEDIUMBLOB DEFAULT NULL
);

-- Allergies Table
CREATE TABLE Allergies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    allergy_name VARCHAR(100) NOT NULL,
    description TEXT,
    severity VARCHAR(20) NOT NULL, -- 'Safe', 'Moderate', 'Critical'
    FOREIGN KEY (user_id) REFERENCES Users(username) ON DELETE CASCADE
);

-- Medical Records Table
CREATE TABLE MedicalRecords (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    diagnosis VARCHAR(150) NOT NULL,
    attending_doctor VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    description TEXT,
    case_sheet MEDIUMBLOB,
    case_sheet_type VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(username) ON DELETE CASCADE
);

-- Prescriptions Table
CREATE TABLE Prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    diagnosis VARCHAR(150) NOT NULL,
    prescribed_date DATE NOT NULL,
    prescribed_by VARCHAR(100) NOT NULL,
    medicines TEXT NOT NULL,
    quantity VARCHAR(50) NOT NULL,
    prescription_file MEDIUMBLOB,
    file_type VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(username) ON DELETE CASCADE
);

-- Insert Sample Doctor Account
INSERT INTO Users (username, password, first_name, last_name, name, mobile, user_type, nmr_id) 
VALUES ('doctor1', 'doctor123', 'John', 'Doe', 'Dr. John Doe', '9876543210', 'doctor', 'NMR-998877');

-- Insert Sample Patient Account (12-digit Unique Health ID)
INSERT INTO Users (username, password, first_name, middle_name, last_name, name, dob, gender, blood_group, mobile, street, city, state, zipcode, address, aadhaar, insurance, guardian_name, guardian_mobile, emergency_contact, user_type) 
VALUES ('123456789012', 'patient123', 'Jane', 'Marie', 'Smith', 'Jane Marie Smith', '1995-08-15', 'Female', 'O-Negative', '9988776655', '101 Medical Way', 'Mumbai', 'Maharashtra', '400001', '101 Medical Way, Mumbai, Maharashtra, 400001', '9988-7766-5544', 'INS-776655-J', 'Robert Smith', '8877665544', '8877665544', 'patient');

-- Insert Sample Allergies for Patient
INSERT INTO Allergies (user_id, allergy_name, description, severity) 
VALUES ('123456789012', 'Penicillin', 'Triggers severe anaphylactic shock and hives.', 'Critical');
INSERT INTO Allergies (user_id, allergy_name, description, severity) 
VALUES ('123456789012', 'Peanuts', 'Causes swelling, shortness of breath, and rashes.', 'Critical');
INSERT INTO Allergies (user_id, allergy_name, description, severity) 
VALUES ('123456789012', 'Lactose', 'Leads to mild stomach upset and bloating.', 'Safe');

-- Insert Sample Medical Records
INSERT INTO MedicalRecords (user_id, diagnosis, attending_doctor, date, description) 
VALUES ('123456789012', 'Acute Appendicitis', 'Dr. Rajesh Kumar', '2023-04-10', 'Patient presented with sudden lower-right quadrant pain. Successful emergency appendectomy completed.');

-- Insert Sample Prescriptions
INSERT INTO Prescriptions (user_id, diagnosis, prescribed_date, prescribed_by, medicines, quantity) 
VALUES ('123456789012', 'Appendectomy Recovery Pain', '2023-04-12', 'Dr. Rajesh Kumar', 'Ibuprofen 400mg (10 Tablets) - 1 tablet after meals', '5 Days');
