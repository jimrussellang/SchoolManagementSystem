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
	public String admission(Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
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
		request.setAttribute("admission_students-list", database.retrieveStudents());
		
		//Menu Active Number
		request.setAttribute("menuactivenum", 3);
		return "admission";
	}

}
