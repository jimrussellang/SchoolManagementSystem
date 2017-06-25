package com.itsq133agroupc.sms;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	LoginController logincontroller = new LoginController();

	//Comments MORE
	// Simply selects the home view to render by returning its name.
	@RequestMapping(value = { "/", "home" }, method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		logger.info("Welcome home! The client locale is {} kevin apostol.", locale);
		//System.out.println(new Database().addSchoolAccount());
		System.out.println("HELLO!");
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

		String formattedDate = dateFormat.format(date);
		
		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}

		model.addAttribute("serverTime", formattedDate);
		
		//Attribute used for printing the page title
		model.addAttribute("page_title", "Dashboard");
		
		//Menu Active Number
		request.setAttribute("menuactivenum", 0);
		
		return "home";
	}

	// Setup Controller
	@RequestMapping(value = { "setup" }, method = RequestMethod.GET)
	public String setup(Locale locale, Model model, HttpSession session, HttpServletResponse response) {
		logger.info("System Setup is being accessed...");
		
		//Attribute used for printing the page title
		model.addAttribute("page_title", "System Setup");
				
		return "setup";
	}

	// Setup Ini POST Method
	@RequestMapping(value = { "setup_ini" }, method = RequestMethod.POST)
	public @ResponseBody String setupIni(Locale locale, Model model, HttpSession session, HttpServletResponse response) {
		logger.info("Setting up system...");

		
		Database db = new Database();
		db.initializeDatabase();
		
		return "<script>"
		+ "$('#setup_container').removeClass('__loading');"
		+ "$.notify('School Management System is now configured correctly!', 'success');"
		+ "</script>";
	}

}
