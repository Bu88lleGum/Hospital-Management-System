-- 1. Departments
CREATE TABLE Department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    phone VARCHAR(20) UNIQUE
);

-- 2. Specializations
CREATE TABLE Specialization (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT
);

-- 3. Doctors
CREATE TABLE Doctor (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    specializationID INT REFERENCES Specialization(id),
    departmentID INT REFERENCES Department(id),
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(255) CHECK (email LIKE '%@%') UNIQUE
);

-- 4. Patients
CREATE TABLE Patient (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    dateOfBirth DATE CHECK (dateOfBirth <= CURRENT_DATE),
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    address TEXT,
    phone VARCHAR(20) UNIQUE,
	email VARCHAR(255) CHECK (email LIKE '%@%') UNIQUE
);

-- 5. Appointments
CREATE TABLE Appointment (
    id SERIAL PRIMARY KEY,
    appointmentDate DATE NOT NULL,
    appointmentTime TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-show')),
    doctorID INT REFERENCES Doctor(id),
    patientID INT REFERENCES Patient(id)
);

-- 6. Surgeries
CREATE TABLE Surgery (
    id SERIAL PRIMARY KEY,
    surgeryType VARCHAR(100) NOT NULL,
    surgeryDate DATE NOT NULL,
    outcome TEXT,
    doctorID INT REFERENCES Doctor(id),
    patientID INT REFERENCES Patient(id)
);

-- 7. Wards
CREATE TABLE Ward (
    id SERIAL PRIMARY KEY,
    wardNumber VARCHAR(10) NOT NULL,
    wardType VARCHAR(50) CHECK (wardType IN ('General', 'VIP', 'ICU', 'Emergency', 'Maternity')),
    capacity INT CHECK (capacity > 0)
);

-- 8. Hospitalizations
CREATE TABLE Hospitalization (
    id SERIAL PRIMARY KEY,
    checkInDate DATE NOT NULL,
    checkOutDate DATE CHECK (checkOutDate >= checkInDate),
    patientID INT REFERENCES Patient(id),
    wardID INT REFERENCES Ward(id)
);

-- 9. Medications
CREATE TABLE Medication (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    description TEXT
);

-- 10. Prescriptions
CREATE TABLE Prescription (
    id SERIAL PRIMARY KEY,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    issueDate DATE DEFAULT CURRENT_DATE,
    medicationID INT REFERENCES Medication(id),
    doctorID INT REFERENCES Doctor(id),
    patientID INT REFERENCES Patient(id)
);

-- 11. Bills
CREATE TABLE Bill (
    id SERIAL PRIMARY KEY,
    dateIssued DATE DEFAULT CURRENT_DATE,
    totalAmount DECIMAL(10,2) NOT NULL CHECK (totalAmount >= 0),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Paid', 'Partially Paid', 'Refunded')),
    patientID INT REFERENCES Patient(id)
);

-- Populate the database

INSERT INTO Department (name, location, phone) VALUES ('Cardiology', 'A-Block, 2nd Floor', '87077384290');
INSERT INTO Specialization (title, description) VALUES ('Cardiologist', 'Heart health expert');

INSERT INTO Doctor (firstName, lastName, specializationID, departmentID, phone, email) 
VALUES ('John', 'Smith', 1, 1, '87077384293', 'j@gmail.com');

INSERT INTO Patient (firstName, lastName, dateOfBirth, gender, address, phone) 
VALUES ('Konstantin', 'Permin', '2007-05-29', 'M', 'Petropavl, Pushkina 82a', '87077384292');

INSERT INTO Appointment (appointmentDate, appointmentTime, status, doctorID, patientID) VALUES
('2026-06-01', '10:00:00', 'Scheduled', 1, 1),
('2026-03-01', '10:00:00', 'Completed', 1, 1),
('2026-01-21', '10:00:00', 'Completed', 1, 1);


INSERT INTO Bill (totalAmount, status, patientID) 
VALUES (150.00, 'Pending', 1);

INSERT INTO Ward (wardNumber, wardType, capacity) 
VALUES ('101A', 'General', 4);

INSERT INTO Surgery (surgeryType, surgeryDate, outcome, doctorID, patientID)
VALUES ('Appendectomy', '2026-04-10', 'Successful', 1, 1);

INSERT INTO Hospitalization (checkInDate, checkOutDate, patientID, wardID)
VALUES ('2026-04-10', '2026-04-15', 1, 1);

INSERT INTO Medication (name, brand, description) VALUES 
('Aspirin', 'Bayer', 'Used to reduce pain, fever, or inflammation'),
('Amoxicillin', 'Amoxil', 'Antibiotic used to treat bacterial infections'),
('Lisinopril', 'Prinivil', 'Medication for high blood pressure');

INSERT INTO Prescription (dosage, frequency, issueDate, medicationID, doctorID, patientID) 
VALUES 
('500mg', 'Once daily after meal', CURRENT_DATE, 2, 1, 1), 
('100mg', 'Twice daily', CURRENT_DATE, 1, 1, 1);

-- Define INDEX  on a frequently queried column

CREATE INDEX idx_appointment_date ON Appointment(appointmentDate);

INSERT INTO Appointment (appointmentDate, appointmentTime, status, doctorID, patientID)
SELECT 
    CURRENT_DATE + (i || ' days')::interval,
    '10:00:00', 
    'Scheduled', 
    1, 
    1
FROM generate_series(1, 1000) AS i;

ANALYZE Appointment;

-- DROP INDEX IF EXISTS idx_appointment_date;

EXPLAIN ANALYZE 
SELECT * FROM Appointment 
WHERE appointmentDate = CURRENT_DATE + interval '1 day';

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename = 'appointment';


-- Later Changes

ALTER TABLE appointment 
DROP CONSTRAINT appointment_patientid_fkey,
ADD CONSTRAINT appointment_patientid_fkey 
   FOREIGN KEY (patientID) REFERENCES patient(id) ON DELETE CASCADE;

ALTER TABLE surgery 
DROP CONSTRAINT surgery_patientid_fkey,
ADD CONSTRAINT surgery_patientid_fkey 
   FOREIGN KEY (patientID) REFERENCES patient(id) ON DELETE CASCADE;
   
ALTER TABLE hospitalization 
DROP CONSTRAINT hospitalization_patientid_fkey,
ADD CONSTRAINT hospitalization_patientid_fkey 
   FOREIGN KEY (patientID) REFERENCES patient(id) ON DELETE CASCADE;

ALTER TABLE prescription 
DROP CONSTRAINT prescription_patientid_fkey,
ADD CONSTRAINT prescription_patientid_fkey 
   FOREIGN KEY (patientID) REFERENCES patient(id) ON DELETE CASCADE;

   
ALTER TABLE bill 
DROP CONSTRAINT bill_patientid_fkey,
ADD CONSTRAINT bill_patientid_fkey 
   FOREIGN KEY (patientID) REFERENCES patient(id) ON DELETE CASCADE;