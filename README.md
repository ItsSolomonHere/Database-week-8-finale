# Database-week-8-finale
# Health & Wellness Tracker Database

A full-featured relational database system designed to manage patient care, appointments, medical records, prescriptions, lab tests, and insurance data for a healthcare facility.

## 📘 Overview

This project provides a robust backend system using MySQL that supports:
- Patient and doctor management
- Appointment scheduling and tracking
- Medical record and prescription storage
- Lab test tracking
- Insurance provider integration
- Stored procedures for automation
- Views for efficient reporting

## 📁 Database Schema

### Entities & Tables
- **Patients**: Stores patient demographic and contact info
- **Doctors**: Stores doctor info and specializations
- **Appointments**: Tracks patient-doctor visits
- **MedicalRecords**: Records diagnoses and treatments
- **Medications**: Lists available drugs
- **Prescriptions**: Many-to-many between MedicalRecords and Medications
- **LabTests**: Results from patient diagnostic tests
- **InsuranceProviders**: Stores insurance company details
- **PatientInsurance**: Links patients to their insurance policies

### Relationships
- `1:N`: Patients ↔ Appointments, Doctors ↔ Appointments
- `1:N`: Patients ↔ MedicalRecords, Doctors ↔ MedicalRecords
- `M:N`: MedicalRecords ↔ Medications (via Prescriptions)
- `M:N`: Patients ↔ InsuranceProviders (via PatientInsurance)

## ⚙️ Features

### ✅ Constraints
- Primary keys (`PK`) and foreign keys (`FK`) implemented
- Data integrity ensured with `NOT NULL`, `UNIQUE`, and `CHECK` constraints

### 🛠️ Stored Procedures
- `GetPatientDetails(patientId)`
- `GetDoctorDetails(doctorId)`
- `CreateNewAppointment(...)`
- `AddMedicalRecord(...)`
- `GetAppointmentsByDateRange(startDate, endDate)`

### 👁️ Views
- `PatientAppointmentHistory`: Full history of a patient’s appointments
- `DoctorAppointmentSchedule`: Doctor’s upcoming schedule
- `PatientMedicalHistory`: Patient’s diagnosis and treatment log

## 🧪 Sample Data

Includes realistic sample entries for:
- 5 Patients
- 5 Doctors
- 5 Appointments
- 5 Medical Records
- 5 Medications
- 5 Prescriptions
- 5 Lab Tests
- 3 Insurance Providers
- 5 Patient-Insurance records

## 🛠️ Installation

1. Clone the repository or copy the SQL script.
2. Open your MySQL terminal or GUI tool (e.g., MySQL Workbench).
3. Run the `health_wellness_tracker.sql` file.
4. The database `health_wellness_tracker` will be created with all tables, views, procedures, and sample data.

## 📈 Use Cases

- Health clinics managing patient information
- Wellness centers offering consultations
- Backend for health management web applications

## 👨‍⚕️ Author

**Solomon Nyakwama**  
Economist & Software Engineer  
[Portfolio](https://solomons-showcase-site.lovable.app) | [LinkedIn](https://www.linkedin.com/in/solomon-nyakwama-a18847222/)

---

> “Designed with integrity, scalability, and health impact in mind.”# Database-week-8-finale
