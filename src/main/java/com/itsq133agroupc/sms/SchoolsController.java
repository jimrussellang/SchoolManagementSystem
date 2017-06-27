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
public class SchoolsController {

	private static final Logger logger = LoggerFactory.getLogger(SchoolsController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/schools" }, method = RequestMethod.GET)
	public String schools(Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has accessed the schools page.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Schools");

		Database database = new Database();
		request.setAttribute("schools_schools-list", database.retrieveSchools());
		
		//Menu Active Number
		request.setAttribute("menuactivenum", 2);
		return "schools";
	}

	// Adds new school to the database
	@RequestMapping(value = { "/schools_add" }, method = RequestMethod.POST)
	public String schools_add(Model model, HttpSession session, @ModelAttribute("schoolBean") SchoolBean schoolBean,
			HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has added a new school.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}

		Database database = new Database();
		boolean isAdded = false;
		
		isAdded = database.addSchool(schoolBean.getSchoolcode(), schoolBean.getSchoolname());

		if (isAdded) {
			model.addAttribute("notify_msg_state", "success");
			model.addAttribute("notify_msg", "Successfully added a new school!");
		} else {
			model.addAttribute("notify_msg_state", "error");
			model.addAttribute("notify_msg", "An error occurred adding a school! Please check if values are correct.");
		}

		// Reload Accounts Table
		request.setAttribute("schools_schools-list", database.retrieveSchools());

		return "redirect:schools";
	}

	// AJAX for Reload Table
	@RequestMapping(value = { "/schools_reloadtable" }, method = RequestMethod.POST)
	public @ResponseBody String schools_reloadtable(Model model, HttpSession session,
			@ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has reloaded schools table.");
		String script = "<script>";
		Database database = new Database();
		request.setAttribute("schools_schools-list", database.retrieveSchools());
		ArrayList<ArrayList<String>> schools = (ArrayList<ArrayList<String>>) request
				.getAttribute("schools_schools-list");
		script = script.concat("var dataSet = [");
		for (int i = 0; i < schools.size(); i++) {
			ArrayList<String> school = schools.get(i);
			script = script.concat("[");
			script = script.concat("'" + school.get(0) + "',");
			script = script.concat("'" + school.get(1) + "'");
			script = script.concat("]");
			if (i < schools.size() - 1) {
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
	@RequestMapping(value = { "/schools_delete" }, method = RequestMethod.POST)
	public @ResponseBody String accounts_delete(Model model, HttpSession session,
			@ModelAttribute("schoolBean") SchoolBean schoolBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has deleted some schools.");

		ArrayList<String> schoolcodes = new ArrayList(Arrays.asList(schoolBean.getSchoolcodes().split(",")));

		boolean result = false;
		Database database = new Database();
		for (int i = 0; i < schoolcodes.size(); i++) {
			result = database.deleteSchool(schoolcodes.get(i));
			if (result == false) {
				return "<script>$.notify('An error has occurred!', 'error');</script>";
			}
		}

		return "<script>$.notify('Successfully deleted records', 'success');</script>";
	}

	// AJAX for Accounts Edit
	@RequestMapping(value = { "/schools_edit" }, method = RequestMethod.POST)
	public @ResponseBody String accounts_edit(Model model, HttpSession session,
			@ModelAttribute("schoolBean") SchoolBean schoolBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has edited a school in the schools table.");

		Database database = new Database();
		boolean isEdited = false;
		
		isEdited = database.editSchool(schoolBean.getSchoolcode(), schoolBean.getSchoolname());
			
		if (isEdited) {
			return "<script>$.notify('Successfully edited record', 'success');</script>";
		} else {
			return "<script>$.notify('An error has occurred!', 'error');</script>";
		}

	}

}
