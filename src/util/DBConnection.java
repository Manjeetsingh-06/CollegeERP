package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — University of Lucknow ERP
 * 
 * Cloud-ready: reads DB config from environment variables.
 * Falls back to localhost defaults for local development.
 */
public class DBConnection {

    // Read from environment (Railway injects these automatically)
    private static final String DB_HOST = getEnv("DB_HOST", "localhost");
    private static final String DB_PORT = getEnv("DB_PORT", "3306");
    private static final String DB_NAME = getEnv("DB_NAME", "college_erp");
    private static final String DB_USER = getEnv("DB_USER", "root");
    private static final String DB_PASS = getEnv("DB_PASS", "Manjeet@2007");

    // Also support JDBC_URL directly (Railway MySQL plugin format)
    private static final String JDBC_URL_ENV = System.getenv("JDBC_URL");

    private static final String JDBC_URL = (JDBC_URL_ENV != null && !JDBC_URL_ENV.isEmpty())
            ? JDBC_URL_ENV
            : "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
              + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
              + "&useUnicode=true&characterEncoding=UTF-8";

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER);
            System.out.println("[DBConnection] Driver loaded: " + DRIVER);
            System.out.println("[DBConnection] Host: " + DB_HOST + ":" + DB_PORT);
            System.out.println("[DBConnection] Schema: " + DB_NAME);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ❌ MySQL JDBC Driver NOT found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
    }

    private static String getEnv(String key, String defaultVal) {
        String val = System.getenv(key);
        return (val != null && !val.trim().isEmpty()) ? val.trim() : defaultVal;
    }

    // Quick connection test
    public static void main(String[] args) {
        System.out.println("Testing DB Connection...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Connected to: " + conn.getCatalog());
            }
        } catch (SQLException e) {
            System.err.println("❌ Connection failed: " + e.getMessage());
        }
    }
}
