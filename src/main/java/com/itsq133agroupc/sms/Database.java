package com.itsq133agroupc.sms;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.sql.*;
import java.util.ArrayList;
import java.util.Random;
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
			//int count = 0;
			// Container for table names found
			ArrayList<String> tables = new ArrayList<String>();

			boolean has_rootaccount = false;
			boolean has_accounts = false;
			boolean has_courses = false;
			boolean has_curriculums = false;
			boolean has_schools = false;
			boolean has_degrees = false;
			while (rs.next()) {
				//count++;
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
				// Check if Curriculums table exists
				if (rs.getString("table_name").equals("curriculums")) {
					has_curriculums = true;
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
					query = "ALTER TABLE accounts ADD COLUMN UserID int NOT NULL UNIQUE";
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
					query = "ALTER TABLE courses ADD COLUMN CourseID int NOT NULL UNIQUE";
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

			// If Curriculums table does not exist, create one
			if (!has_curriculums) {
				query = "CREATE TABLE curriculums ( CurriculumID int NOT NULL UNIQUE, CurriculumCode varchar(255) NOT NULL UNIQUE, Years int NOT NULL DEFAULT 0, Terms int NOT NULL DEFAULT 0, TotalUnits float NOT NULL DEFAULT 0, Courses text, TotalPrice float NOT NULL DEFAULT 0, Status int NOT NULL DEFAULT 1, PRIMARY KEY (CurriculumID) )";
				stmt.execute(query);
				System.out.println("Curriculums Table is now configured.");
			} else {
				// Check if Curriculums Table has the correct columns
				query = "DESCRIBE curriculums";
				rs = stmt.executeQuery(query);
				boolean has_curriculums_curriculumid = false;
				boolean has_curriculums_curriculumcode = false;
				boolean has_curriculums_years = false;
				boolean has_curriculums_terms = false;
				boolean has_curriculums_totalunits = false;
				boolean has_curriculums_courses = false;
				boolean has_curriculums_totalprice = false;
				boolean has_curriculums_status = false;
				while (rs.next()) {
					if (rs.getString("Field").equals("CurriculumID")) {
						has_curriculums_curriculumid = true;
					}
					if (rs.getString("Field").equals("CurriculumCode")) {
						has_curriculums_curriculumcode = true;
					}
					if (rs.getString("Field").equals("Years")) {
						has_curriculums_years = true;
					}
					if (rs.getString("Field").equals("Terms")) {
						has_curriculums_terms = true;
					}
					if (rs.getString("Field").equals("TotalUnits")) {
						has_curriculums_totalunits = true;
					}
					if (rs.getString("Field").equals("Courses")) {
						has_curriculums_courses = true;
					}
					if (rs.getString("Field").equals("TotalPrice")) {
						has_curriculums_totalprice = true;
					}
					if (rs.getString("Field").equals("Status")) {
						has_curriculums_status = true;
					}
				}
				// Check if Curriculums Table has the correct primary key
				boolean has_curriculums_primarykey = false;
				query = "SHOW INDEX FROM curriculums";
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					if (rs.getString("Column_name").equals("CurriculumID")) {
						has_curriculums_primarykey = true;
					}
				}
				if (!has_curriculums_curriculumid) {
					query = "ALTER TABLE curriculums ADD COLUMN CurriculumID int NOT NULL UNIQUE";
					stmt.execute(query);
					query = "ALTER TABLE curriculums ADD PRIMARY KEY(CurriculumID)";
					stmt.execute(query);
				}
				if (!has_curriculums_primarykey) {
					query = "ALTER TABLE curriculums ADD PRIMARY KEY(CurriculumID)";
					stmt.execute(query);
				}
				if (!has_curriculums_curriculumcode) {
					query = "ALTER TABLE curriculums ADD COLUMN CurriculumCode varchar(255) NOT NULL UNIQUE";
					stmt.execute(query);
				}
				if (!has_curriculums_years) {
					query = "ALTER TABLE curriculums ADD COLUMN Years int NOT NULL DEFAULT 0";
					stmt.execute(query);
				}
				if (!has_curriculums_terms) {
					query = "ALTER TABLE curriculums ADD COLUMN Terms int NOT NULL DEFAULT 0";
					stmt.execute(query);
				}
				if (!has_curriculums_totalunits) {
					query = "ALTER TABLE curriculums ADD COLUMN TotalUnits float NOT NULL DEFAULT 0";
					stmt.execute(query);
				}
				if (!has_curriculums_courses) {
					query = "ALTER TABLE curriculums ADD COLUMN Courses text";
					stmt.execute(query);
				}
				if (!has_curriculums_totalprice) {
					query = "ALTER TABLE curriculums ADD COLUMN TotalPrice float NOT NULL DEFAULT 0";
					stmt.execute(query);
				}
				if (!has_curriculums_status) {
					query = "ALTER TABLE curriculums ADD COLUMN Status int NOT NULL DEFAULT 1";
					stmt.execute(query);
				}
				System.out.println("Curriculums table is now configured correctly!");
			}

			// If Schools table does not exist, create one
			if (!has_schools) {
				query = "CREATE TABLE schools ( SchoolCode varchar(255) NOT NULL UNIQUE, SchoolName varchar(255) NOT NULL UNIQUE, Status int NOT NULL DEFAULT 1, PRIMARY KEY (SchoolCode) )";
				stmt.execute(query);
				System.out.println("Schools Table is now configured.");
			} else {
				// Check if Schools Table has the correct columns
				query = "DESCRIBE schools";
				rs = stmt.executeQuery(query);
				boolean has_schools_schoolcode = false;
				boolean has_schools_schoolname = false;
				boolean has_schools_status = false;
				while (rs.next()) {
					if (rs.getString("Field").equals("SchoolCode")) {
						has_schools_schoolcode = true;
					}
					if (rs.getString("Field").equals("SchoolName")) {
						has_schools_schoolname = true;
					}
					if (rs.getString("Field").equals("Status")) {
						has_schools_status = true;
					}
				}
				// Check if Schools Table has the correct primary key
				boolean has_schools_primarykey = false;
				query = "SHOW INDEX FROM schools";
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					if (rs.getString("Column_name").equals("SchoolCode")) {
						has_schools_primarykey = true;
					}
				}
				if (!has_schools_schoolcode) {
					query = "ALTER TABLE schools ADD COLUMN SchoolCode varchar(255) NOT NULL UNIQUE";
					stmt.execute(query);
					query = "ALTER TABLE schools ADD PRIMARY KEY(SchoolCode)";
					stmt.execute(query);
				}
				if (!has_schools_primarykey) {
					query = "ALTER TABLE schools ADD PRIMARY KEY(SchoolCode)";
					stmt.execute(query);
				}
				if (!has_schools_schoolname) {
					query = "ALTER TABLE schools ADD COLUMN SchoolName varchar(255) NOT NULL UNIQUE";
					stmt.execute(query);
				}
				if (!has_schools_status) {
					query = "ALTER TABLE schools ADD COLUMN Status int NOT NULL DEFAULT 1";
					stmt.execute(query);
				}
				System.out.println("Schools table is now configured correctly!");
			}

			// If Degrees table does not exist, create one
			if (!has_degrees) {
				query = "CREATE TABLE degrees ( DegreeID int NOT NULL UNIQUE, DegreeCode varchar(255) NOT NULL UNIQUE, DegreeName text NOT NULL, DegreeCurriculum int, Status int NOT NULL DEFAULT 1, PRIMARY KEY (DegreeID) )";
				stmt.execute(query);
				System.out.println("Degrees Table is now configured.");
			} else {
				// Check if Degrees Table has the correct columns
				query = "DESCRIBE degrees";
				rs = stmt.executeQuery(query);
				boolean has_degrees_degreeid = false;
				boolean has_degrees_degreecode = false;
				boolean has_degrees_degreename = false;
				boolean has_degrees_degreecurriculum = false;
				boolean has_degrees_status = false;
				while (rs.next()) {
					if (rs.getString("Field").equals("DegreeID")) {
						has_degrees_degreeid = true;
					}
					if (rs.getString("Field").equals("DegreeCode")) {
						has_degrees_degreecode = true;
					}
					if (rs.getString("Field").equals("DegreeName")) {
						has_degrees_degreename = true;
					}
					if (rs.getString("Field").equals("DegreeCurriculum")) {
						has_degrees_degreecurriculum = true;
					}
					if (rs.getString("Field").equals("Status")) {
						has_degrees_status = true;
					}
				}
				// Check if Degrees Table has the correct primary key
				boolean has_degrees_primarykey = false;
				query = "SHOW INDEX FROM degrees";
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					if (rs.getString("Column_name").equals("DegreeID")) {
						has_degrees_primarykey = true;
					}
				}
				if (!has_degrees_degreeid) {
					query = "ALTER TABLE degrees ADD COLUMN DegreeID int NOT NULL UNIQUE";
					stmt.execute(query);
					query = "ALTER TABLE degrees ADD PRIMARY KEY(DegreeID)";
					stmt.execute(query);
				}
				if (!has_degrees_primarykey) {
					query = "ALTER TABLE degrees ADD PRIMARY KEY(DegreeID)";
					stmt.execute(query);
				}
				if (!has_degrees_degreecode) {
					query = "ALTER TABLE degrees ADD COLUMN DegreeCode varchar(255) NOT NULL UNIQUE";
					stmt.execute(query);
				}
				if (!has_degrees_degreename) {
					query = "ALTER TABLE degrees ADD COLUMN DegreeName text NOT NULL";
					stmt.execute(query);
				}
				if (!has_degrees_degreecurriculum) {
					query = "ALTER TABLE degrees ADD COLUMN DegreeCurriculum int";
					stmt.execute(query);
				}
				if (!has_degrees_status) {
					query = "ALTER TABLE degrees ADD COLUMN Status int NOT NULL DEFAULT 1";
					stmt.execute(query);
				}
				System.out.println("Degrees table is now configured correctly!");
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

	public ArrayList<ArrayList<String>> retrieveAccounts(int state, String school) {
		ArrayList<ArrayList<String>> accounts = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "";
			if(state == 0){
				query = "SELECT * FROM accounts WHERE Status = 1";
			}
			else if(state == 1){
				query = "SELECT * FROM accounts WHERE Status = 1 AND AccountType != 'ST'";
			}
			else if(state == 2){
				query = "SELECT * FROM accounts WHERE Status = 1 AND AccountType != 'BM' AND UserName LIKE '" + school + "%'";
			}
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
			// generate random data if empty
			if (userID.trim().isEmpty())
				userID = "" + (new Random()).nextInt(9999); // random UserID
			if (userName.trim().isEmpty())
				userName = new BigInteger(64, (new SecureRandom())).toString(32);// random Username
			if (accountType.trim().isEmpty())
				accountType = "School" + (new Random()).nextInt(100) + "-" + "6000"; // random AcctType																				
			if (pass.isEmpty())
				pass = passwordEncryptor.encryptPassword("rosebud"); // Should be encrypted
														// before or after going
														// in method?
			else
				pass = passwordEncryptor.encryptPassword(pass);

			String query = "INSERT INTO `accounts` " + "(`UserID`, " + "`UserName`, " + "`Password`, " + "`FullName`, "
					+ "`AccountType`, " + "`DateRegistered`) " + "VALUES ('" + userID + "', " + "'" + userName + "', "
					+ "'" + pass + "', " + "'" + fullName + "', " + "'" + accountType + "', "
					+ "DATE_ADD(NOW(), INTERVAL 16 HOUR));"; // Server time is UTC-8)
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
				pass = passwordEncryptor.encryptPassword(pass);
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
	
	public boolean setAccountParameter(String userName, String param) {
		try {
			connect();
			String query = "UPDATE `accounts` SET Parameters = '" + param + "' WHERE `accounts`.`UserName` = '" + userName + "'";
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}

	public ArrayList<ArrayList<String>> retrieveSubjects(int state, String school) {
		ArrayList<ArrayList<String>> subjects = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "";
			if(state == 0){
				query = "SELECT * FROM courses WHERE Status = 1";
			}
			else if(state == 2){
				query = "SELECT * FROM courses WHERE Status = 1 AND CourseCode LIKE '" + school + "%'";
			}
			else if(state == 3){
				query = "SELECT * FROM courses WHERE Status = 1 AND CourseCode LIKE '" + school + "%'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> subject = new ArrayList<String>();
				subject.add(rs.getString("CourseID"));
				subject.add(rs.getString("CourseCode"));
				subject.add(rs.getString("CourseName"));
				subject.add(rs.getString("CourseUnits"));
				subject.add(rs.getString("Prerequisites"));
				subject.add(rs.getString("Price"));
				subjects.add(subject);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return subjects;
	}
	
	public int getSubjectUnits(String id) {
		if(id.trim().equals("")){
			id = "0";
		}
		try {
			connect();
			String query = "";
			query = "SELECT CourseUnits FROM courses WHERE CourseID = " + id;
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next()) {
				return Integer.valueOf(rs.getString("CourseUnits"));
			}
			else{
				return 0;
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return 0;
	}
	
	public float getSubjectPrice(String id) {
		if(id.trim().equals("")){
			id = "0";
		}
		try {
			connect();
			String query = "";
			query = "SELECT Price FROM courses WHERE CourseID = " + id;
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next()) {
				return Float.valueOf(rs.getString("Price"));
			}
			else{
				return 0;
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return 0;
	}
	
	
	public boolean addCourse(String courseID, String courseCode, String courseName, String courseUnits, String prerequisites,
			String price) {

		try {
			connect();
			// generate random data if empty
			if (courseID.trim().isEmpty())
				courseID = "" + (new Random()).nextInt(9999); // random courseID
			
			String query = "INSERT INTO `courses` "
					+ "(`CourseID`, `CourseCode`, `CourseName`, `CourseUnits`, `Prerequisites`, `Price`) "
					+ "VALUES ('" 
					+ courseID + "','" 
					+ courseCode + "', '"
					+ courseName + "', '" 
					+ courseUnits + "', '" 
					+ prerequisites + "', '" 
					+ price + "');";
			
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
			String price) {

		try {
			connect();
						
			String query = "UPDATE `courses` SET CourseCode = '"+ courseCode +"', CourseName = '"+ courseName +"', CourseUnits = '"+ courseUnits +"', "
					+ "Prerequisites = '"+ prerequisites +"', Price = '"+ price +"' WHERE CourseID = '"+ courseID +"';";
			
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean deleteCourse(String courseID) {
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

	public ArrayList<ArrayList<String>> retrieveCurriculums(int state, String school) {
		ArrayList<ArrayList<String>> curriculums = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "";
			if(state == 0){
				query = "SELECT * FROM curriculums WHERE Status = 1";
			}
			else if(state == 2){
				query = "SELECT * FROM curriculums WHERE Status = 1 AND CurriculumCode LIKE '" + school + "%'";
			}
			else if(state == 3){
				query = "SELECT * FROM curriculums WHERE Status = 1 AND CurriculumCode LIKE '" + school + "%'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> curriculum = new ArrayList<String>();
				curriculum.add(rs.getString("CurriculumID"));
				curriculum.add(rs.getString("CurriculumCode"));
				curriculum.add(rs.getString("Years"));
				curriculum.add(rs.getString("Terms"));
				curriculum.add(rs.getString("TotalUnits"));
				curriculum.add(rs.getString("TotalPrice"));
				curriculums.add(curriculum);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return curriculums;
	}

	public ArrayList<String> getCurriculumInfo(String curriculum_id) {
		ArrayList<String> curriculum = new ArrayList<String>();
		try {
			connect();
			String query = "SELECT * FROM curriculums WHERE Status = 1 AND CurriculumID = " + curriculum_id;
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next()) {
				curriculum.add(rs.getString("CurriculumID"));
				curriculum.add(rs.getString("CurriculumCode"));
				curriculum.add(rs.getString("Years"));
				curriculum.add(rs.getString("Terms"));
				curriculum.add(rs.getString("TotalUnits"));
				curriculum.add(rs.getString("Courses"));
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return curriculum;
	}

	public boolean saveCurriculumStructure(String curriculum_id, String curriculum_structure, int units, float totalprice) {
		try {
			connect();
			String query = "UPDATE curriculums SET courses = '" + curriculum_structure + "', TotalUnits = " + units + ", TotalPrice = " + totalprice + " WHERE CurriculumID = "
					+ curriculum_id;
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}
		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean addCurriculum(String currID, String currCode, String currYears, String currTerms) {

		try {
			connect();
			// generate random data if empty
			if (currID.trim().isEmpty())
				currID = "" + (new Random()).nextInt(9999); // random courseID
			
			String query = "INSERT INTO `curriculums` "
					+ "(`CurriculumID`, `CurriculumCode`, `Years`, `Terms`) "
					+ "VALUES ('" 
					+ currID + "','" 
					+ currCode + "', '"
					+ currYears + "', '" 
					+ currTerms + "');";
			
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean editCurriculum(String currID, String currCode, String years, String terms) {
		try {
			connect();
			String query = "";

			query = "UPDATE `curriculums` SET CurriculumCode = '" + currCode + "', Years = '" + years
						+ "', Terms = '" + terms + "'  WHERE CurriculumID ='" + currID + "'";

			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}
		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}

	public boolean deleteCurriculum(String currID) {
		try {
			String query = "UPDATE `curriculums` SET Status = 0 WHERE `curriculums`.`CurriculumID` = " + currID;
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

	public ArrayList<ArrayList<String>> retrieveSchools() {
		ArrayList<ArrayList<String>> schools = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "SELECT * FROM schools WHERE Status = 1";
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> school = new ArrayList<String>();
				school.add(rs.getString("SchoolCode"));
				school.add(rs.getString("SchoolName"));
				schools.add(school);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return schools;
	}

	public boolean addSchool(String schoolCode, String schoolName) {

		try {
			connect();
			// generate random data if empty
			if (schoolCode.trim().isEmpty())
				schoolCode = new BigInteger(64, (new SecureRandom())).toString(32); //random schoolcode
			if (schoolName.trim().isEmpty())
				schoolName = new BigInteger(64, (new SecureRandom())).toString(32); // random
																					// School Name

			String query = "INSERT INTO `schools` " + "(`SchoolCode`, " + "`SchoolName`) " + "VALUES ('" + schoolCode + "', " + "'" + schoolName + "');";
			
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean editSchool(String schoolCode, String schoolName) {
		try {
			connect();
			String query = "";

				query = "UPDATE `schools` SET SchoolName = '" + schoolName + "'  WHERE SchoolCode ='" + schoolCode + "'";
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}
		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean deleteSchool(String schoolCode) {
		try {
			String query = "UPDATE `schools` SET Status = 0 WHERE `schools`.`SchoolCode` = '" + schoolCode + "'";
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

	public ArrayList<ArrayList<String>> retrieveDegrees(int state, String school) {
		ArrayList<ArrayList<String>> degrees = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "";
			if(state == 0){
				query = "SELECT * FROM degrees WHERE Status = 1";
			}
			else if(state == 2){
				query = "SELECT * FROM degrees WHERE Status = 1 AND DegreeCode LIKE '" + school + "%'";
			}
			else if(state == 3){
				query = "SELECT * FROM degrees WHERE Status = 1 AND DegreeCode LIKE '" + school + "%'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> degree = new ArrayList<String>();
				degree.add(rs.getString("DegreeID"));
				degree.add(rs.getString("DegreeCode"));
				degree.add(rs.getString("DegreeName"));
				degree.add(rs.getString("DegreeCurriculum"));
				degrees.add(degree);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return degrees;
	}
	
	public boolean addDegree(String degreeID, String degreeCode, String degreeName, String degreeCurriculum) {
		try {
			connect();
			// generate random data if empty
			if (degreeID.trim().isEmpty())
				degreeID = "" + (new Random()).nextInt(9999); // random Degree ID
			if (degreeCode.trim().isEmpty())
				degreeCode = new BigInteger(64, (new SecureRandom())).toString(32);// random Degree Code
			if (degreeName.trim().isEmpty())
				degreeName = new BigInteger(64, (new SecureRandom())).toString(32);// random Degree Name
			if (degreeCurriculum.trim().isEmpty())
				degreeCurriculum = new BigInteger(64, (new SecureRandom())).toString(32);// random Degree Curriculum
			
			String query = "INSERT INTO `degrees` " + "(`DegreeID`, " + "`DegreeCode`, " + "`DegreeName`, " + "`DegreeCurriculum`) " + "VALUES ('" + degreeID + "', " + "'" + degreeCode + "', "
					+ "'" + degreeName + "', " + "'" + degreeCurriculum + "');";
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean editDegree(String degreeID, String degreeCode, String degreeName, String degreeCurriculum) {

		try {
			connect();
						
			String query = "UPDATE `degrees` SET DegreeCode = '"+ degreeCode +"', DegreeName = '"+ degreeName +"', DegreeCurriculum = "+ degreeCurriculum + " WHERE DegreeID = '"+ degreeID +"';";
			
			int res = con.createStatement().executeUpdate(query);
			if (res > 0) {
				return true;
			}

		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
		return false;
	}
	
	public boolean deleteDegree(String degreeID) {
		try {
			String query = "UPDATE `degrees` SET Status = 0 WHERE `degrees`.`DegreeID` = " + degreeID;
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
	
	public String getDegreeName(String id) {
		String degree =  "Unknown Degree";
		try {
			connect();
			String query = null;
			query = "SELECT * FROM degrees WHERE DegreeID = " + id;
			
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			if (rs.next() && rs.last()) {
				degree = rs.getString("DegreeName");
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}

		return degree;
	}

	public ArrayList<ArrayList<String>> retrieveStudents(int state, String school) {
		ArrayList<ArrayList<String>> students = new ArrayList<ArrayList<String>>();
		try {
			connect();
			String query = "";
			if(state == 0){
				query = "SELECT * FROM accounts WHERE AccountType = 'ST' AND Status = 1";
			}
			else if(state == 2){
				query = "SELECT * FROM accounts WHERE AccountType = 'ST' AND Status = 1 AND UserName LIKE '" + school + "%'";
			}
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				ArrayList<String> record = new ArrayList<String>();
				record.add(rs.getString("UserID"));
				record.add(rs.getString("UserName"));
				record.add(rs.getString("FullName"));
				if(rs.getString("Parameters") != null){
					record.add(getDegreeName(rs.getString("Parameters").replaceAll("degreeid: ", "")));
				}
				else{
					record.add("NOT SET");
				}
				record.add(rs.getString("DateRegistered"));
				students.add(record);
			}
		} catch (Exception e) {
			System.out.println("Database Process Error! " + e);
		}
		return students;
	}

}