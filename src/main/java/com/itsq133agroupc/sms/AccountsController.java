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
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Accounts");

		Database database = new Database();
		request.setAttribute("accounts_accounts-list", database.retrieveAccounts());
		return "accounts";
	}

	// Adds new account to the database
	@RequestMapping(value = { "/accounts_add" }, method = RequestMethod.POST)
	public String accounts_add(Model model, HttpSession session, @ModelAttribute("accountBean") AccountBean accountBean,
			HttpServletResponse response, HttpServletRequest request) {
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
		// Prevents admin conflict
		if (!accountBean.getUsername().toLowerCase().equals("admin")) {
			isAdded = database.addAccount(accountBean.getUserid(), accountBean.getUsername(), accountBean.getAccttype(),
					accountBean.getPassword(), accountBean.getFullname());
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
		request.setAttribute("accounts_accounts-list", database.retrieveAccounts());

		return "redirect:accounts";
	}

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/accounts_reloadtable" }, method = RequestMethod.POST)
	public @ResponseBody String accounts_reloadtable(Model model, HttpSession session,
			@ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has reloaded accounts table.");
		String script = "<script>";
		Database database = new Database();
		request.setAttribute("accounts_accounts-list", database.retrieveAccounts());
		ArrayList<ArrayList<String>> accounts = (ArrayList<ArrayList<String>>) request
				.getAttribute("accounts_accounts-list");
		script = script.concat("var dataSet = [");
		for (int i = 0; i < accounts.size(); i++) {
			ArrayList<String> record = accounts.get(i);
			script = script.concat("[");
			script = script.concat("'" + record.get(0) + "',");
			script = script.concat("'" + record.get(1) + "',");
			script = script.concat("'" + record.get(2) + "',");
			script = script.concat("'" + record.get(3) + "',");
			script = script.concat("'" + record.get(4) + "'");
			script = script.concat("]");
			if (i < accounts.size() - 1) {
				script = script.concat(",");
			}
		}
		script = script.concat("];");
		script = script.concat("$('table').DataTable().destroy();");
		script = script.concat(
				"$('table').DataTable( { data: dataSet, dom: '<\"top\"fl<\"clear\">>rt<\"bottom\"ip<\"clear\">>', oLanguage: { sSearch: \"\", sLengthMenu: \"_MENU_\" }, initComplete: function initComplete(settings, json) {$('div.dataTables_filter input').attr('placeholder', 'Search...'); } } );");
		script = script.concat("</script>");
		return script;
	}

	// AJAX for Accounts Delete
	@RequestMapping(value = { "/accounts_delete" }, method = RequestMethod.POST)
	public @ResponseBody String accounts_delete(Model model, HttpSession session,
			@ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has deleted some records in the accounts table.");

		ArrayList<String> userids = new ArrayList(Arrays.asList(accountBean.getUserids().split(",")));

		boolean result = false;
		Database database = new Database();
		for (int i = 0; i < userids.size(); i++) {
			result = database.deleteAccount(userids.get(i));
			if (result == false) {
				return "<script>$.notify('An error has occurred!', 'error');</script>";
			}
		}

		return "<script>$.notify('Successfully deleted records', 'success');</script>";
	}

	// AJAX for Accounts Edit
	@RequestMapping(value = { "/accounts_edit" }, method = RequestMethod.POST)
	public @ResponseBody String accounts_edit(Model model, HttpSession session,
			@ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has edited a record in the accounts table.");
		System.out.println("a" + accountBean.getUserid());
		
		Database database = new Database();
		boolean isEdited = false;
		// Prevents admin conflict
		if (!accountBean.getUsername().toLowerCase().equals("admin")) {
			isEdited = database.editAccount(accountBean.getUserid(), accountBean.getUsername(), accountBean.getAccttype(),
					accountBean.getPassword(), accountBean.getFullname());
		}
		if (isEdited) {
			return "<script>$.notify('Successfully edited record', 'success');</script>";
		} else {
			return "<script>$.notify('An error has occurred!', 'error');</script>";
		}
		
	}

}
