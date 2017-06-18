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
			boolean has_courses = false;
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
				// Check if Courses table exists
				if (rs.getString("table_name").equals("courses")) {
					has_courses = true;
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
				} else {
					query = "DROP TABLE root_account";
					stmt.execute(query);
					query = "CREATE TABLE root_account ( UserID int NOT NULL, UserName varchar(5) NOT NULL UNIQUE, Password varchar(100) NOT NULL, PRIMARY KEY (UserID) )";
					stmt.execute(query);
					query = "INSERT INTO root_account ( UserID, UserName, Password ) VALUES ( 0, '" + root_user + "', '"
							+ passwordEncryptor.encryptPassword(root_pass) + "' )";
					stmt.execute(query);
					System.out.println(
							"Root Account Table is configured incorrectly, therefore, a reconfiguration was executed. Root Table is now correctly configured.");
				}
			}

			// If Accounts table does not exist, create one
			if (!has_accounts) {
				query = "CREATE TABLE accounts ( UserID int NOT NULL UNIQUE, UserName varchar(255) NOT NULL UNIQUE, Password text NOT NULL, FullName text NOT NULL, AccountType text NOT NULL, Parameters text, DateRegistered datetime NOT NULL, Status int NOT NULL DEFAULT 1, PRIMARY KEY (UserID) )";
				stmt.execute(query);
				System.out.println("Accounts Table is now configured.");
			} else {
				// Check if Accounts Table has the correct columns
				query = "DESCRIBE accounts";
				rs = stmt.executeQuery(query);
				boolean has_accounts_userid = false;
				boolean has_accounts_username = false;
				boolean has_accounts_password = false;
				boolean has_accounts_fullname = false;
				boolean has_accounts_accounttype = false;
				boolean has_accounts_parameters = false;
				boolean has_accounts_dateregistered = false;
				boolean has_accounts_status = false;
				while (rs.next()) {
					if (rs.getString("Field").equals("UserID")) {
						has_accounts_userid = true;
					}
					if (rs.getString("Field").equals("UserName")) {
						has_accounts_username = true;
					}
					if (rs.getString("Field").equals("Password")) {
						has_accounts_password = true;
					}
					if (rs.getString("Field").equals("FullName")) {
						has_accounts_fullname = true;
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
					if (rs.getString("Field").equals("Status")) {
						has_accounts_status = true;
					}
				}
				// Check if Accounts Table has the correct primary key
				boolean has_accounts_primarykey = false;
				query = "SHOW INDEX FROM accounts";
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					if (rs.getString("Column_name").equals("UserID")) {
						has_accounts_primarykey = true;
					}
				}
				if (!has_accounts_userid) {
					query = "ALTER TABLE accounts ADD COLUMN UserID int";
					stmt.execute(query);
					query = "ALTER TABLE accounts ADD PRIMARY KEY(UserID)";
					stmt.execute(query);
				}
				if (!has_accounts_primarykey) {
					query = "ALTER TABLE accounts ADD PRIMARY KEY(UserID)";
					stmt.execute(query);
				}
				if (!has_accounts_username) {
					query = "ALTER TABLE accounts ADD COLUMN UserName varchar(255) NOT NULL UNIQUE";
					stmt.execute(query);
				}
				if (!has_accounts_password) {
					query = "ALTER TABLE accounts ADD COLUMN Password text NOT NULL";
					stmt.execute(query);
				}
				if (!has_accounts_fullname) {
					query = "ALTER TABLE accounts ADD COLUMN FullName text NOT NULL";
					stmt.execute(query);
				}
				if (!has_accounts_accounttype) {
					query = "ALTER TABLE accounts ADD COLUMN AccountType text NOT NULL";
					stmt.execute(query);
				}
				if (!has_accounts_parameters) {
					query = "ALTER TABLE accounts ADD COLUMN Parameters text";
					stmt.execute(query);
				}
				if (!has_accounts_dateregistered) {
					query = "ALTER TABLE accounts ADD COLUMN DateRegistered datetime NOT NULL";
					stmt.execute(query);
				}
				if (!has_accounts_status) {
					query = "ALTER TABLE accounts ADD COLUMN Status int NOT NULL DEFAULT 1";
					stmt.execute(query);
				}
				System.out.println("Accounts table is now configured correctly!");
			}

			// If Courses table does not exist, create one
			if (!has_courses) {
				query = "CREATE TABLE courses ( CourseID int NOT NULL UNIQUE, CourseCode varchar(255) NOT NULL UNIQUE, CourseName text NOT NULL, CourseUnits float NOT NULL DEFAULT 0, Prerequisites text, Price float NOT NULL DEFAULT 0, Status int NOT NULL DEFAULT 1, PRIMARY KEY (CourseID) )";
				stmt.execute(query);
				System.out.println("Courses Table is now configured.");
			} else {
				// Check if Courses Table has the correct columns
				query = "DESCRIBE courses";
				rs = stmt.executeQuery(query);
				boolean has_courses_courseid = false;
				boolean has_courses_coursecode = false;
				boolean has_courses_coursename = false;
				boolean has_courses_courseunits = false;
				boolean has_courses_prerequisites = false;
				boolean has_courses_price = false;
				boolean has_courses_status = false;
				while (rs.next()) {
					if (rs.getString("Field").equals("CourseID")) {
						has_courses_courseid = true;
					}
					if (rs.getString("Field").equals("CourseCode")) {
						has_courses_coursecode = true;
					}
					if (rs.getString("Field").equals("CourseName")) {
						has_courses_coursename = true;
					}
					if (rs.getString("Field").equals("CourseUnits")) {
						has_courses_courseunits = true;
					}
					if (rs.getString("Field").equals("Prerequisites")) {
						has_courses_prerequisites = true;
					}
					if (rs.getString("Field").equals("Price")) {
						has_courses_price = true;
					}
					if (rs.getString("Field").equals("Status")) {
						has_courses_status = true;
					}
				}
				// Check if Courses Table has the correct primary key
				boolean has_courses_primarykey = false;
				query = "SHOW INDEX FROM courses";
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					if (rs.getString("Column_name").equals("CourseID")) {
						has_courses_primarykey = true;
					}
				}
				if (!has_courses_courseid) {
					query = "ALTER TABLE courses ADD COLUMN CourseID int";
					stmt.execute(query);
					query = "ALTER TABLE courses ADD PRIMARY KEY(CourseID)";
					stmt.execute(query);
				}
				if (!has_courses_primarykey) {
					query = "ALTER TABLE courses ADD PRIMARY KEY(CourseID)";
					stmt.execute(query);
				}
				if (!has_courses_coursecode) {
					query = "ALTER TABLE courses ADD COLUMN CourseCode varchar(255) NOT NULL UNIQUE";
					stmt.execute(query);
				}
				if (!has_courses_coursename) {
					query = "ALTER TABLE courses ADD COLUMN CourseName text NOT NULL";
					stmt.execute(query);
				}
				if (!has_courses_courseunits) {
					query = "ALTER TABLE courses ADD COLUMN CourseUnits float NOT NULL DEFAULT 0";
					stmt.execute(query);
				}
				if (!has_courses_prerequisites) {
					query = "ALTER TABLE courses ADD COLUMN Prerequisites text NOT NULL";
					stmt.execute(query);
				}
				if (!has_courses_price) {
					query = "ALTER TABLE courses ADD COLUMN Price float NOT NULL DEFAULT 0";
					stmt.execute(query);
				}
				if (!has_courses_status) {
					query = "ALTER TABLE courses ADD COLUMN Status int NOT NULL DEFAULT 1";
					stmt.execute(query);
				}
				System.out.println("Courses table is now configured correctly!");
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

	public String getAccountType(String username) {
		String accounttype = "";
		try {
			connect();
			String query = null;
			if (username.equals("admin")) {
				accounttype = "admin";
			} else {
				query = "SELECT * FROM accounts WHERE UserName ='" + username + "'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next() && rs.last()) {
				accounttype = rs.getString("AccountType");
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}

		return accounttype;
	}

	public String getAccountFullName(String username) {
		String fullname = "";
		try {
			connect();
			String query = null;
			if (username.equals("admin")) {
				fullname = "-SUPERADMIN-";
			} else {
				query = "SELECT * FROM accounts WHERE UserName ='" + username + "'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next() && rs.last()) {
				fullname = rs.getString("FullName");
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}

		return fullname;
	}

	public ArrayList<ArrayList<String>> retrieveAccounts() {
		ArrayList<ArrayList<String>> accounts = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "SELECT * FROM accounts WHERE Status = 1";
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> record = new ArrayList<String>();
				record.add(rs.getString("UserID"));
				record.add(rs.getString("UserName"));
				record.add(rs.getString("FullName"));
				record.add(rs.getString("AccountType"));
				record.add(rs.getString("DateRegistered"));
				accounts.add(record);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return accounts;
	}

	public boolean addAccount(String userID, String userName, String accountType, String pass, String fullName) {

		try {
			connect();
			StrongPasswordEncryptor spwd = new StrongPasswordEncryptor();
			// generate random data if empty
			if (userID.trim().isEmpty())
				userID = "" + (new Random()).nextInt(9999); // random UserID
			if (userName.trim().isEmpty())
				userName = new BigInteger(64, (new SecureRandom())).toString(32); // randueuwqio
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

			String query = "INSERT INTO `accounts` " + "(`UserID`, " + "`UserName`, " + "`Password`, " + "`FullName`, "
					+ "`AccountType`, " + "`DateRegistered`) " + "VALUES ('" + userID + "', " + "'" + userName + "', "
					+ "'" + pass + "', " + "'" + fullName + "', " + "'" + accountType + "', "
					+ "DATE_ADD(NOW(), INTERVAL 16 HOUR));"; // Server
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

	public boolean editAccount(String userID, String userName, String accountType, String pass, String fullName) {
		try {
			connect();
			String query = "";

			if (pass.length() > 0) {
				pass = new StrongPasswordEncryptor().encryptPassword(pass);
				query = "UPDATE `accounts` SET UserName = '" + userName + "', Password = '" + pass + "', FullName = '"
						+ fullName + "', AccountType = '" + accountType + "'  WHERE userID ='" + userID + "'";
			} else {
				query = "UPDATE `accounts` SET UserName = '" + userName + "', FullName = '" + fullName
						+ "', AccountType = '" + accountType + "'  WHERE userID ='" + userID + "'";
			}
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
			String query = "UPDATE `accounts` SET Status = 0 WHERE `accounts`.`UserID` = " + userID;
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
	
	public ArrayList<ArrayList<String>> retrieveSubjects() {
		ArrayList<ArrayList<String>> subjects = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "SELECT * FROM courses WHERE Status = 1";
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> subject = new ArrayList<String>();
				subject.add(rs.getString("CourseID"));
				subject.add(rs.getString("CourseCode"));
				subject.add(rs.getString("CourseName"));
				subject.add(rs.getString("CourseUnits"));
				subject.add(rs.getString("Prerequisites"));
				subjects.add(subject);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return subjects;
	}
	
	
	public boolean addCourse(String courseID, String courseCode, String courseName, String courseUnits, String prerequisites,
			String price, String status) {

		try {
			connect();
			// generate random data if empty
			if (courseID.trim().isEmpty())
				courseID = "" + (new Random()).nextInt(9999); // random courseID
			
			String query = "INSERT INTO `courses` " + "(`CourseID`, " + "`CourseCode`, " + "`CourseName`, " + "`CourseUnits`, "
					+ "`Prerequisites`, " + "`Price`, " + "'Status') " + "VALUES ('" + courseID + "', " + "'" + courseCode + "', "
					+ "'" + courseName + "', " + "'" + courseUnits + "', " + "'" + prerequisites + "', "
					+ "'" + price + "', '" + status + "';";
			
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean editCourse(String courseID, String courseCode, String courseName, String courseUnits, String prerequisites,
			String price, String status) {

		try {
			connect();
						
			String query = "UPDATE `courses` SET CourseCode = '"+ courseCode +"', CourseName = '"+ courseName +"', CourseUnits = '"+ courseUnits +"', "
					+ "Prerequisites = '"+ prerequisites +"', Price = '"+ price +"', Status = '"+ status +"' WHERE CourseID = '"+ courseID +"';";
			
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean deleteCourses(String courseID) {
		try {
			String query = "UPDATE `courses` SET Status = 0 WHERE `courses`.`CourseID` = " + courseID;
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