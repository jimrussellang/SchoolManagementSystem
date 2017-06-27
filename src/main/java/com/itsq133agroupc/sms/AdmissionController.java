package com.itsq133agroupc.sms;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Handles requests for the application home page.
 */
@Controller
public class AdmissionController {

	private static final Logger logger = LoggerFactory.getLogger(AdmissionController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/admission" }, method = RequestMethod.GET)
	public String admission(Model model, HttpSession session, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has accessed the admission page.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Admission");

		Database database = new Database();
		if (session.getAttribute("login_accounttype").equals("admin")) {
			request.setAttribute("admission_students-list", database.retrieveStudents(0, ""));
		} else if (session.getAttribute("login_accounttype").equals("SCH")) {
			request.setAttribute("admission_students-list",
					database.retrieveStudents(2, session.getAttribute("login_school").toString().trim()));
		}
		
		//For Degrees List
		if(session.getAttribute("login_accounttype").equals("admin")){
			request.setAttribute("admission_degrees-list", database.retrieveDegrees(0, ""));
		}
		else if(session.getAttribute("login_accounttype").equals("SCH")){
			request.setAttribute("admission_degrees-list", database.retrieveDegrees(2, session.getAttribute("login_school").toString().trim()));
		}
		else if(session.getAttribute("login_accounttype").equals("ST")){
			request.setAttribute("admission_degrees-list", database.retrieveDegrees(3, session.getAttribute("login_school").toString().trim()));
		}

		// Menu Active Number
		request.setAttribute("menuactivenum", 3);
		if(session.getAttribute("login_accounttype").equals("SCH")){
			request.setAttribute("menuactivenum", 2);
		}
		return "admission";
	}

	// Adds new student to the database
	@RequestMapping(value = { "/admission_add" }, method = RequestMethod.POST)
	public String accounts_add(Model model, HttpSession session, @ModelAttribute("accountBean") AccountBean accountBean,
			HttpServletResponse response, HttpServletRequest request, @ModelAttribute("degreeBean") DegreeBean degreeBean) {
		logger.info("A user has added a new student.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}

		Database database = new Database();
		boolean isAdded = false;
		// Prevents admin conflict
		if (!accountBean.getUsername().toLowerCase().equals("admin")) {
			//Sets up the appropriate School Prefix
			if(session.getAttribute("login_school") != null){
				accountBean.setUsername(session.getAttribute("login_school").toString().trim() + "." + accountBean.getUsername());
			}
			isAdded = database.addAccount("", accountBean.getUsername(), accountBean.getAccttype(),
					accountBean.getPassword(), accountBean.getFullname());
			if(isAdded){
				isAdded = database.setAccountParameter(accountBean.getUsername(), "degreeid: " + degreeBean.getDegreeid());
			}
		}
		if (isAdded) {
			model.addAttribute("notify_msg_state", "success");
			model.addAttribute("notify_msg", "Successfully added a new account!");
		} else {
			model.addAttribute("notify_msg_state", "error");
			model.addAttribute("notify_msg",
					"An error occurred adding an account! Please check if values are correct.");
		}

		// Reload Accounts Table
		if (session.getAttribute("login_accounttype").equals("admin")) {
			request.setAttribute("admission_students-list", database.retrieveStudents(0, ""));
		} else if (session.getAttribute("login_accounttype").equals("SCH")) {
			request.setAttribute("admission_students-list",
					database.retrieveStudents(2, session.getAttribute("login_school").toString().trim()));
		}

		return "redirect:admission";
	}

}
