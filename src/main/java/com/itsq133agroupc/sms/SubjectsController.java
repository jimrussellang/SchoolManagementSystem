package com.itsq133agroupc.sms;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class SubjectsController {

	private static final Logger logger = LoggerFactory.getLogger(AccountsController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/subjects" }, method = RequestMethod.GET)
	public String accounts(Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has accessed the accounts page.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Accounts");

//		Database database = new Database();
//		request.setAttribute("accounts_accounts-list", database.retrieveAccounts());
		return "subjects";
	}
}
