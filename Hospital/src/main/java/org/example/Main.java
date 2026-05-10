package org.example;

import java.sql.*;

public class Main {

    // ── Connection settings ───────────────────────────────────────────────────
    private static final String URL      = "jdbc:postgresql://localhost:5432/Hospital";
    private static final String USER     = "postgres";
    private static final String PASSWORD = "qwerty";

    // ── Entry point ───────────────────────────────────────────────────────────
    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {

            if (conn != null)
                System.out.println("Connected to the database!\n");
            else {
                System.out.println("Connection attempt failed!");
                return;
            }

            // ── CREATE ────────────────────────────────────────────────────────
            System.out.println("=== CREATE ===");
            addNewPatient(conn, "SSasabinaass", "SSaasdykoovass", "2006-10-24", "F","Petropavl", "87-1277-2759912", "ssfsas2@arizona.edu" );

            // ── READALL ────────────────────────────────────────────────────────
            System.out.println("=== READ ===");
            readAllPatients(conn);

            // ── READONE ────────────────────────────────────────────────────────
            System.out.println("=== READ ===");
            readPatientById(conn, 2);
            // ── READONE ────────────────────────────────────────────────────────
            readPatientByLastName(conn, "Permin");

            // ── UPDATE ────────────────────────────────────────────────────────
            System.out.println("=== UPDATE ===");
            updatePatient(conn, 2, "Kostik", "Permin", "2007-05-29", "M","Petropavl", "87077775222", "P@arizona.edu" );

            // ── DELETE ────────────────────────────────────────────────────────
            System.out.println("=== DELETE ===");
            deletePatient(conn, 3);
            readPatientById(conn, 3);


        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ── CREATE ────────────────────────────────────────────────────────────────
    public static void addNewPatient(Connection conn,
                                     String firstname,
                                     String lastname,
                                     String dateofbirth,
                                     String gender,
                                     String address,
                                     String phone,
                                     String email) throws SQLException {

        String sql = "INSERT INTO patient (firstname, lastname, dateofbirth, gender, address, phone, email) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, firstname);
            pstmt.setString(2, lastname);
            pstmt.setDate(3, java.sql.Date.valueOf(dateofbirth));            pstmt.setString(4, gender);
            pstmt.setString(5, address);
            pstmt.setString(6, phone);
            pstmt.setString(7, email);



            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()){
                    if (generatedKeys.next()) {
                        long id = generatedKeys.getLong(1);
                        System.out.println("Inserted successfully! New Patient ID:"  + id);                    }
                }
            }
        }
    }

    // ── READ (all) ────────────────────────────────────────────────────────────

    public static void readAllPatients(Connection conn) throws SQLException {
        String sql = "SELECT id, firstname, lastname, dateofbirth, gender, address, phone, email FROM patient";

        try (Statement stmt = conn.createStatement();
             ResultSet rs   = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                printPatient(rs);
                count++;
            }
            System.out.println("Total rows: " + count);
        }
    }

    // ── READ (single) ─────────────────────────────────────────────────────────
    public static void readPatientById(Connection conn, Integer id) throws SQLException {

        String sql = "SELECT id, firstname, lastname, dateofbirth, gender, address, phone, email "
                + "FROM patient WHERE id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next())
                    printPatient(rs);
                else
                    System.out.println("No Patient found with ID: " + id);
            }
        }
    }
    // ── READ (single) ─────────────────────────────────────────────────────────
    public static void readPatientByLastName(Connection conn, String lastname) throws SQLException {

        String sql = "SELECT id, firstname, lastname, dateofbirth, gender, address, phone, email "
                + "FROM patient WHERE lastname = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, lastname);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next())
                    printPatient(rs);
                else
                    System.out.println("No Patient found with lastname: " + lastname);
            }
        }
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────

    public static void updatePatient(Connection conn,
                                     Integer id,
                                     String newfirstname,
                                     String newlastname,
                                     String newdateofbirth,
                                     String newgender,
                                     String newaddress,
                                     String newphone,
                                     String newemail) throws SQLException {

        String sql = "UPDATE patient "
                + "SET firstname = ?, lastname = ?, dateofbirth = ?, gender = ?, address = ?, phone = ?, email = ? "
                + "WHERE id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newfirstname);
            pstmt.setString(2, newlastname);
            pstmt.setDate(3, java.sql.Date.valueOf(newdateofbirth));            pstmt.setString(4, newgender);
            pstmt.setString(5, newaddress);
            pstmt.setString(6, newphone);
            pstmt.setString(7, newemail);
            pstmt.setInt(8, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0)
                System.out.println("Updated patientID: " + id);
            else
                System.out.println("No Patient found with ID: " + id);
        }
    }

    // ── DELETE ────────────────────────────────────────────────────────────────
    public static void deletePatient(Connection conn, Integer id) throws SQLException {

        String sql = "DELETE FROM patient WHERE id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0)
                System.out.println("Deleted PatientID: " + id);
            else
                System.out.println("No Patient found with ID: " + id);
        }
    }

    // ── Helper ────────────────────────────────────────────────────────────────
    private static void printPatient(ResultSet rs) throws SQLException {
        System.out.printf("ID: %-10s | firstname: %-30s | lastname: %-20s |dateofbirth: %20s |gender: %-20s | address: %-20s | phone: %-20s | email: %s%n",
                rs.getInt("id"),
                rs.getString("firstname"),
                rs.getString("lastname"),
                rs.getString("dateofbirth"),
                rs.getString("gender"),
                rs.getString("address"),
                rs.getString("phone"),
                rs.getString("email"));
    }
}