-- Create the database
CREATE DATABASE health_wellness_tracker;

-- Use the database
USE health_wellness_tracker;

-- --- Tables ---

-- Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    contact_number VARCHAR(20) UNIQUE NOT NULL,
    address VARCHAR(255),
    email VARCHAR(100) UNIQUE
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    reason VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    CONSTRAINT chk_status CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No Show'))
);

-- Medical Records Table
CREATE TABLE MedicalRecords (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    diagnosis VARCHAR(255) NOT NULL,
    treatment VARCHAR(255) NOT NULL,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Medications Table
CREATE TABLE Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    route VARCHAR(50)
);

-- Prescriptions Table (Many-to-Many relationship between MedicalRecords and Medications)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT NOT NULL,
    medication_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    notes VARCHAR(255),
    FOREIGN KEY (record_id) REFERENCES MedicalRecords(record_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);

-- Lab Tests Table
CREATE TABLE LabTests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL,
    test_date DATE NOT NULL,
    results TEXT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Insurance Providers Table
CREATE TABLE InsuranceProviders (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20),
    address VARCHAR(255)
);

-- Patient Insurance Table (Many-to-Many relationship between Patients and InsuranceProviders)
CREATE TABLE PatientInsurance (
    patient_insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    provider_id INT NOT NULL,
    policy_number VARCHAR(50) NOT NULL,
    effective_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES InsuranceProviders(provider_id)
);

-- --- Stored Procedures ---
--  1. Procedure to get patient details
DELIMITER //
CREATE PROCEDURE GetPatientDetails(IN patientId INT)
BEGIN
    SELECT * FROM Patients WHERE patient_id = patientId;
END //
DELIMITER ;

-- 2. Procedure to get doctor details
DELIMITER //
CREATE PROCEDURE GetDoctorDetails(IN doctorId INT)
BEGIN
    SELECT * FROM Doctors WHERE doctor_id = doctorId;
END //
DELIMITER ;

-- 3. Procedure to create a new appointment
DELIMITER //
CREATE PROCEDURE CreateNewAppointment(
    IN patientId INT,
    IN doctorId INT,
    IN appointmentDate DATETIME,
    IN reason VARCHAR(255)
)
BEGIN
    INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason)
    VALUES (patientId, doctorId, appointmentDate, reason);
END //
DELIMITER ;

-- 4. Procedure to add a new medical record
DELIMITER //
CREATE PROCEDURE AddMedicalRecord(
    IN patientId INT,
    IN doctorId INT,
    IN appointmentId INT,
    IN diagnosis VARCHAR(255),
    IN treatment VARCHAR(255),
    IN notes TEXT
)
BEGIN
    INSERT INTO MedicalRecords (patient_id, doctor_id, appointment_id, diagnosis, treatment, notes)
    VALUES (patientId, doctorId, appointmentId, diagnosis, treatment, notes);
END //
DELIMITER ;

-- 5.  Procedure to get appointments by date range
DELIMITER //
CREATE PROCEDURE GetAppointmentsByDateRange(IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT *
    FROM Appointments
    WHERE appointment_date BETWEEN startDate AND endDate;
END //
DELIMITER ;

-- ---  Views ---
-- 1.  View to get patient appointment history
CREATE VIEW PatientAppointmentHistory AS
SELECT
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    a.appointment_id,
    a.appointment_date,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    a.reason,
    a.status
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- 2. View to get doctor's appointment schedule
CREATE VIEW DoctorAppointmentSchedule AS
SELECT
    d.doctor_id,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    a.appointment_id,
    a.appointment_date,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    a.reason,
    a.status
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id;

-- 3. View for patient's medical history
CREATE VIEW PatientMedicalHistory AS
SELECT
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    mr.record_id,
    mr.record_date,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    mr.diagnosis,
    mr.treatment,
    mr.notes
FROM Patients p
JOIN MedicalRecords mr ON p.patient_id = mr.patient_id
JOIN Doctors d ON mr.doctor_id = d.doctor_id;

-- --- Sample Data Insertion ---
-- Insert sample data into Patients
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, contact_number, address, email) VALUES
('Salmon', 'Wayne', '1990-05-15', 'Male', '123-456-7890', '123 Main St, Anytown', 'salmonwayne@gmail.com'),
('Jackline', 'Karimii', '1985-10-22', 'Female', '987-654-3210', '456 Oak Ave, Somecity', 'Jacklinekarimi@gmail.com'),
('Rob', 'Ndegwa', '2002-03-08', 'Male', '555-123-4567', '789 Pine Ln, Othertown', 'robndegwa2@gmail.com'),
('Mercy', 'Cheptri', '1998-07-11', 'Female', '111-222-3333', '246 Cedar Rd, Villagetown', 'mercycheop@gmail.com'),
('Mike', 'Daniel', '1976-12-04', 'Male', '444-555-6666', '135 Birch St, Hamletville', 'mikedaniel@gmail.com');

-- Insert sample data into Doctors
INSERT INTO Doctors (first_name, last_name, specialization, contact_number, email) VALUES
('Bob', 'wheeler', 'Cardiology', '777-888-9999', 'bobwheeler77@gmail.com'),
('Jamie', 'Henderson', 'Pediatrics', '222-333-4444', 'Jhenderson22@gmail.com'),
('Pete', 'Ndungu', 'Dermatology', '999-000-1111', 'peterndugu@gmail.com'),
('Patty', 'Muthama', 'Neurology', '555-444-3333', 'patmu77@gmail.com'),
('Ethan', 'Matogo', 'Oncology', '888-777-6666', 'ethanmatogo@gmail.com');

-- Insert sample data into Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason, status) VALUES
(1, 1, '2024-01-10 10:00:00', 'Chest pain', 'Scheduled'),
(2, 2, '2024-01-11 14:30:00', 'Checkup', 'Scheduled'),
(3, 1, '2024-01-12 09:00:00', 'Skin rash', 'Completed'),
(1, 3, '2024-01-15 11:00:00', 'Follow-up', 'Scheduled'),
(5, 5, '2024-02-01 13:00:00', 'Consultation', 'Scheduled');

-- Insert sample data into MedicalRecords
INSERT INTO MedicalRecords (patient_id, doctor_id, appointment_id, diagnosis, treatment, notes) VALUES
(1, 1, 1, 'Angina', 'Medication, lifestyle changes', 'Patient to follow up in 1 month'),
(2, 2, 2, 'Well child visit', 'Vaccinations', 'Next visit in 6 months'),
(3, 1, 3, 'Eczema', 'Topical steroids', 'Avoid irritants'),
(1, 3, 4, 'Eczema Followup', 'Continue topical steroids', 'Monitor for infection'),
(5, 5, 5, 'Possible Cancer', 'Biopsy', 'Schedule for biopsy');

-- Insert sample data into Medications
INSERT INTO Medications (medication_name, dosage, frequency, route) VALUES
('Aspirin', '81mg', 'Once daily', 'Oral'),
('Amoxicillin', '500mg', 'Three times a day', 'Oral'),
('Hydrocortisone Cream', '1%', 'Twice daily', 'Topical'),
('Lisinopril', '10mg', 'Once daily', 'Oral'),
('Chemotherapy Drug X', '100mg/m2', 'Once every 3 weeks', 'IV');

-- Insert sample data into Prescriptions
INSERT INTO Prescriptions (record_id, medication_id, start_date, end_date, notes) VALUES
(1, 1, '2024-01-10', '2024-03-10', 'Take with food'),
(2, 2, '2024-01-11', '2024-01-18', 'Take until finished'),
(3, 3, '2024-01-12', '2024-01-20', 'Apply thinly'),
(4, 3, '2024-01-20', '2024-02-28', 'Apply thinly'),
(5, 5, '2024-02-01', NULL, 'Administer in clinic');

-- Insert sample data into LabTests
INSERT INTO LabTests (test_name, test_date, results, patient_id, doctor_id) VALUES
('CBC', '2024-01-10', 'WBC: 8000, RBC: 4.5', 1, 1),
('Blood Sugar', '2024-01-11', '100 mg/dL', 2, 2),
('Skin Biopsy', '2024-01-12', 'Inflammatory cells present', 3, 1),
('Lipid Panel', '2024-01-15', 'Cholesterol: 200 mg/dL', 1, 3),
('Tumor Markers', '2024-02-01', 'High', 5, 5);

-- Insert sample data into InsuranceProviders
INSERT INTO InsuranceProviders (provider_name, contact_number, address) VALUES
(' Jubileeinsurance', '800-123-4567', '100 Insurance Dr, Anytown'),
('SHA', '888-555-6666', '200 Harambee Ave, Nairobi'),
('CIC', '777-999-8888', '300 Moi Avenuel, Nairobi');

-- Insert sample data into PatientInsurance
INSERT INTO PatientInsurance (patient_id, provider_id, policy_number, effective_date, expiration_date) VALUES
(1, 1, 'Policy123', '2024-01-01', '2024-12-31'),
(2, 2, 'Policy456', '2024-01-15', '2025-01-14'),
(1, 3, 'Policy789', '2024-03-01', '2025-02-28'),
(4, 1, 'Policy246', '2024-02-01', '2025-01-31'),
(5, 3, 'Policy135', '2024-03-15', '2026-03-14');