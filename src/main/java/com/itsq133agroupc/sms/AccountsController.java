package com.itsq133agroupc.sms;

import java.text.DateFormat;
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
public class AccountsController {

	private static final Logger logger = LoggerFactory.getLogger(AccountsController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/accounts" }, method = RequestMethod.GET)
	public String accounts(Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has accessed the accounts page.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Accounts");

		Database database = new Database();
		request.setAttribute("accounts_accounts-list", database.retrieveAccounts());
		return "accounts";
	}

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/accounts_add" }, method = RequestMethod.POST)
	public String accounts_add(Model model, HttpSession session, @ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has accessed added a new account.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		
		Database database = new Database();
		boolean isAdded = false;
		//Prevents admin conflict
		if(!accountBean.getUsername().toLowerCase().equals("admin")){
			isAdded = database.addAccount(accountBean.getUserid(), accountBean.getUsername(), accountBean.getAccttype(), accountBean.getPassword());
		}
		if(isAdded){
			model.addAttribute("notify_msg_state", "success");
			model.addAttribute("notify_msg", "Successfully added a new account!");
		}
		else{
			model.addAttribute("notify_msg_state", "error");
			model.addAttribute("notify_msg", "An error occurred adding an account! Please check if values are correct.");
		}
		
		//Reload Accounts Table
		request.setAttribute("accounts_accounts-list", database.retrieveAccounts());
		
		return "redirect:accounts";
	}

}
