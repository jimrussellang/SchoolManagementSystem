package com.itsq133agroupc.sms;

import java.sql.*;
import java.util.ArrayList;

import org.jasypt.util.password.BasicPasswordEncryptor;
import org.jasypt.util.password.StrongPasswordEncryptor;

public class Database {

	// private String connectionURL =
	// "jdbc:mysql://mysql.hostinger.ph/u643893263_mgtsc";
	// private String username = "u643893263_rem";
	// private String password = "itsq133a";

	private String dbName = "sql12178500";
	private String connectionURL = "jdbc:mysql://sql12.freesqldatabase.com/" + dbName;
	private String username = "sql12178500";
	private String password = "u5e8Bt8RGa";

	// private String dbName = "sms";
	// private String connectionURL = "jdbc:mysql://localhost/" + dbName;
	// private String username = "root";
	// private String password = "";

	Connection con;

	StrongPasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();

	private String root_user = "admin";
	private String root_pass = "masterpassword";

	public void connect() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(connectionURL, username, password);
		} catch (Exception e) {
			System.out.println("Database Connection Error! " + e + connectionURL);
		}
	}

	public void initializeDatabase() {
		try {
			connect();
			String query = "SELECT table_name FROM information_schema.tables WHERE table_schema='" + dbName + "';";
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			int count = 0;
			// Container for table names found
			ArrayList<String> tables = new ArrayList<String>();

			boolean has_rootaccount = false;
			boolean has_accounts = false;
			while (rs.next()) {
				count++;
				tables.add(rs.getString("table_name"));
				System.out.println("Table: " + rs.getString("table_name"));
				// Check if Root Account table exists
				if (rs.getString("table_name").equals("root_account")) {
					has_rootaccount = true;
				}
				// Check if Accounts table exists
				if (rs.getString("table_name").equals("accounts")) {
					has_accounts = true;
				}
			}

			// If Root Account table does not exist, create one
			if (!has_rootaccount) {
				query = "CREATE TABLE root_account ( UserID int NOT NULL, UserName varchar(5) NOT NULL, Password varchar(100) NOT NULL, PRIMARY KEY (UserID) )";
				stmt.execute(query);
				query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user + "', '"
						+ passwordEncryptor.encryptPassword(root_pass) + "' )";
				stmt.execute(query);
				System.out.println("Root Account Table is now configured.");
			} else {
				query = "SELECT * FROM root_account";
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					try {
						if (rs.getInt("UserID") == 0 && rs.getString("UserName").equals(root_user)
								&& passwordEncryptor.checkPassword(root_pass, rs.getString("Password"))) {
							System.out.println("Root Account is configured correctly!");
						} else {
							query = "DELETE FROM root_account WHERE UserID = " + rs.getInt("UserID");
							stmt.execute(query);
							query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user
									+ "', '" + passwordEncryptor.encryptPassword(root_pass) + "' )";
							stmt.execute(query);
							System.out.println(
									"Root Account was set incorrectly, therefore, a reinitialization was executed. Root Account is now correctly configured.");
						}
					} catch (Exception e) {
						System.out.println("Error! " + e);

						query = "DELETE FROM root_account WHERE UserID = " + rs.getInt("UserID");
						stmt.execute(query);
						query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user
								+ "', '" + passwordEncryptor.encryptPassword(root_pass) + "' )";
						stmt.execute(query);
						System.out.println(
								"Root Account was set incorrectly, therefore, a reinitialization was executed. Root Account is now correctly configured.");
					}
				} else {
					query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user + "', '"
							+ passwordEncryptor.encryptPassword(root_pass) + "' )";
					stmt.execute(query);
					System.out.println(
							"Root Account was not found, therefore, a reinitialization was executed. Root Account is now correctly configured.");
				}
			}
			// If Accounts table does not exist, create one
			if (!has_accounts) {
				query = "CREATE TABLE accounts ( UserID int NOT NULL, UserName varchar(20) NOT NULL, Password varchar(100) NOT NULL, AccountType varchar(100) NOT NULL, DateRegistered datetime NOT NULL, PRIMARY KEY (UserID) )";
				stmt.execute(query);
				System.out.println("Accounts Table is now configured.");
			} else {
				System.out.println("Accounts table is configured correctly!");
			}

			con.close();
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
	}

	public boolean loginAccount(String username, String password) {
		boolean is_validaccount = false;
		try {
			connect();
			String query = null;
			if (username.equals("admin")) {
				query = "SELECT * FROM root_account WHERE UserName ='" + username + "'";
			} else {
				query = "SELECT * FROM accounts WHERE UserName ='" + username + "'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next() && rs.last()) {
				try {
					if (passwordEncryptor.checkPassword(password, rs.getString("Password"))) {
						is_validaccount = true;
					}
				} catch (Exception e) {
					System.out.println("Error! " + e);
				}
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}

		return is_validaccount;
	}

}