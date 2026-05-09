# Hospital Management System 🏥

This project is a comprehensive Hospital Management System developed as part of the Database Management Systems (DBMS) curriculum. It demonstrates a dual-database approach using both Relational (PostgreSQL) and Non-Relational (MongoDB) architectures to handle medical data efficiently.

## 📝 Project Overview
The system automates core hospital operations, including patient registration, doctor assignments, appointments, surgical history, and financial billing. It balances data integrity through normalization in SQL and high-performance data retrieval through embedding in NoSQL.

## ⚙️ Business Rules
The following rules describe the core requirements of the system:
* **Departments and Staff**: The hospital is divided into departments (e.g., Cardiology, Surgery). Each doctor is assigned to exactly one department, while a department may employ many doctors.
* **Patients and Hospitalization**: Patients may be admitted to wards during treatment. Each ward has a specific type (General, VIP, ICU) and a defined capacity.
* **Surgeries**: The system tracks surgical history, including the type of surgery, date, and outcome (e.g., Successful). Each surgery is performed on one patient and led by one surgeon.
* **Prescriptions**: Doctors issue prescriptions for specific medications, including dosage and frequency.
* **Billing**: Bills are generated for services provided, tracking total amounts and payment status (Paid, Pending).

## 🏗 Database Architecture

### Relational Schema (PostgreSQL)
The relational database is designed in 3rd Normal Form (3NF) and consists of 11 tables:
1. `Department`, `Specialization`, `Doctor` — Staff management.
2. `Patient`, `Ward`, `Hospitalization` — Patient care and stay tracking.
3. `Appointment`, `Surgery` — Medical history and scheduling.
4. `Medication`, `Prescription` — Pharmacy and drug administration.
5. `Bill` — Financial records.

### NoSQL Schema (MongoDB)
A hybrid model (Embedding + Reference) is used to optimize the "Patient Profile" view:
* **Embedding**: Bills and surgery records are embedded directly within the Patient document for rapid history retrieval.
* **Validation**: Implemented using `JSON Schema` to enforce data types (e.g., `Decimal128` for currency) and mandatory fields.
* **Unique Constraints**: Unique indexes are applied to `email` and `phone` to prevent duplicate patient records.

## 🛠 Technology Stack
* **Backend**: Java 24 (JDBC)
* **Relational Database**: PostgreSQL
* **NoSQL Database**: MongoDB
* **Development Tools**: IntelliJ IDEA, Maven, Git
* **Modeling**: draw.io (ER-Diagrams)

## 🚀 Installation and Setup

1. **Database Configuration**:
   * Execute the `Hospital.sql` script in your PostgreSQL environment to create the tables.
   * Ensure the database name matches the connection string in the Java code.

2. **Java Application**:
   * Open the project in IntelliJ IDEA.
   * Update the credentials in `src/main/java/org/example/Main.java`:
     ```java
     private static final String URL      = "jdbc:postgresql://localhost:5432/Hospital";
     private static final String USER     = "postgres";
     private static final String PASSWORD = "your_password";
3. **Execution**:
  * Run the Main.java file to perform CRUD operations on the patient database.
## (👉ﾟヮﾟ)👉
* **Authors**: Konstantin Permin, Sabina Sadykova.
* **University**: M. Kozybayev North Kazakhstan University (NKU)
