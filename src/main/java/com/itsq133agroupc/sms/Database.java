package com.itsq133agroupc.sms;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.sql.*;
import java.util.ArrayList;
import java.util.Random;

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

	private Connection con;

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
				// Check if Root Account Table has the correct columns
				query = "DESCRIBE root_account";
				rs = stmt.executeQuery(query);
				boolean has_rootaccount_userid = false;
				boolean has_rootaccount_username = false;
				boolean has_rootaccount_password = false;
				while (rs.next()) {
					if (rs.getString("Field").equals("UserID") && rs.getString("Type").contains("int")) {
						has_rootaccount_userid = true;
					}
					if (rs.getString("Field").equals("UserName") && rs.getString("Type").equals("varchar(5)")) {
						has_rootaccount_username = true;
					}
					if (rs.getString("Field").equals("Password") && rs.getString("Type").equals("varchar(100)")) {
						has_rootaccount_password = true;
					}
				}
				if (has_rootaccount_userid && has_rootaccount_username && has_rootaccount_password) {
					// Check if Root Account exists and is configured correctly
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
								query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '"
										+ root_user + "', '" + passwordEncryptor.encryptPassword(root_pass) + "' )";
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
						query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user
								+ "', '" + passwordEncryptor.encryptPassword(root_pass) + "' )";
						stmt.execute(query);
						System.out.println(
								"Root Account was not found, therefore, a reinitialization was executed. Root Account is now correctly configured.");
					}
				}
				else{
					query = "DROP TABLE root_account";
					stmt.execute(query);
					query = "CREATE TABLE root_account ( UserID int NOT NULL, UserName varchar(5) NOT NULL UNIQUE, Password varchar(100) NOT NULL, PRIMARY KEY (UserID) )";
					stmt.execute(query);
					query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user + "', '"
							+ passwordEncryptor.encryptPassword(root_pass) + "' )";
					stmt.execute(query);
					System.out.println("Root Account Table is configured incorrectly, therefore, a reconfiguration was executed. Root Table is now correctly configured.");
				}
			}
			
			// If Accounts table does not exist, create one
			if (!has_accounts) {
				query = "CREATE TABLE accounts ( UserID int NOT NULL, UserName text NOT NULL, Password text NOT NULL, AccountType text NOT NULL, Parameters text, DateRegistered datetime NOT NULL, PRIMARY KEY (UserID) )";
				stmt.execute(query);
				System.out.println("Accounts Table is now configured.");
			} else {
				// Check if Accounts Table has the correct columns
				query = "DESCRIBE accounts";
				rs = stmt.executeQuery(query);
				boolean has_accounts_userid = false;
				boolean has_accounts_username = false;
				boolean has_accounts_password = false;
				boolean has_accounts_accounttype = false;
				boolean has_accounts_parameters = false;
				boolean has_accounts_dateregistered = false;
				while(rs.next()){
					if (rs.getString("Field").equals("UserID")) {
						has_accounts_userid = true;
					}
					if (rs.getString("Field").equals("UserName")) {
						has_accounts_username = true;
					}
					if (rs.getString("Field").equals("Password")) {
						has_accounts_password = true;
					}
					if (rs.getString("Field").equals("AccountType")) {
						has_accounts_accounttype = true;
					}
					if (rs.getString("Field").equals("Parameters")) {
						has_accounts_parameters = true;
					}
					if (rs.getString("Field").equals("DateRegistered")) {
						has_accounts_dateregistered = true;
					}
				}
				//Check if Accounts Table has the correct primary key
				boolean has_accounts_primarykey = false;
				query = "SHOW INDEX FROM accounts";
				rs = stmt.executeQuery(query);
				if(rs.next()){
					if(rs.getString("Column_name").equals("UserID")){
						has_accounts_primarykey = true;
					}
				}
				if(!has_accounts_userid){
					query = "ALTER TABLE accounts ADD COLUMN UserID int";
					stmt.execute(query);
					query = "ALTER TABLE accounts ADD PRIMARY KEY(UserID)";
					stmt.execute(query);
				}
				if(!has_accounts_primarykey){
					query = "ALTER TABLE accounts ADD PRIMARY KEY(UserID)";
					stmt.execute(query);
				}
				if(!has_accounts_username){
					query = "ALTER TABLE accounts ADD COLUMN UserName text NOT NULL";
					stmt.execute(query);
				}
				if(!has_accounts_password){
					query = "ALTER TABLE accounts ADD COLUMN Password text NOT NULL";
					stmt.execute(query);
				}
				if(!has_accounts_accounttype){
					query = "ALTER TABLE accounts ADD COLUMN AccountType text NOT NULL";
					stmt.execute(query);
				}
				if(!has_accounts_parameters){
					query = "ALTER TABLE accounts ADD COLUMN Parameters text";
					stmt.execute(query);
				}
				if(!has_accounts_dateregistered){
					query = "ALTER TABLE accounts ADD COLUMN DateRegistered datetime NOT NULL";
					stmt.execute(query);
				}
				System.out.println("Accounts table is now configured correctly!");
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

	public int getAccountUserID(String username) {
		int userid = -1;
		try {
			connect();
			String query = null;
			if (username.equals("admin")) {
				userid = 0;
			} else {
				query = "SELECT * FROM accounts WHERE UserName ='" + username + "'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next() && rs.last()) {
				userid = rs.getInt("UserID");
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}

		return userid;
	}

	public ArrayList<ArrayList<String>> retrieveAccounts() {
		ArrayList<ArrayList<String>> accounts = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "SELECT * FROM accounts";
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> record = new ArrayList<String>();
				record.add(rs.getString("UserID"));
				record.add(rs.getString("UserName"));
				record.add(rs.getString("AccountType"));
				record.add(rs.getString("DateRegistered"));
				accounts.add(record);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return accounts;
	}

	public boolean addAccount(String userID, String userName, String accountType, String pass) {

		try {
			connect();
			StrongPasswordEncryptor spwd = new StrongPasswordEncryptor();
			// generate random data if empty
			if (userID.trim().isEmpty())
				userID = "" + (new Random()).nextInt(9999); // random UserID
			if (userName.trim().isEmpty())
				userName = new BigInteger(64, (new SecureRandom())).toString(32); // random
																					// Username
			if (accountType.trim().isEmpty())
				accountType = "School" + (new Random()).nextInt(100) + "-" + "6000"; // random
																						// AcctType
			if (pass.isEmpty())
				pass = spwd.encryptPassword("rosebud"); // Should be encrypted
														// before or after going
														// in method?
			else
				pass = spwd.encryptPassword(pass);

			String query = "INSERT INTO `accounts` " + "(`UserID`, " + "`UserName`, " + "`Password`, "
					+ "`AccountType`, " + "`DateRegistered`) " + "VALUES ('" + userID + "', " + "'" + userName + "', "
					+ "'" + pass + "', " + "'" + accountType + "', " + "DATE_ADD(NOW(), INTERVAL 16 HOUR));"; // Server
																												// time
																												// is
																												// offset
																												// by
																												// 16
																												// hours
																												// (Server
																												// Time
																												// UTC
																												// -8)
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}

	public boolean deleteAccount(String userID) {
		try {
			String query = "DELETE FROM `accounts` WHERE `accounts`.`UserID` = " + userID;
			connect();
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}
		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}

}