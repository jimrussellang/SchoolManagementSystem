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
public class DegreesController {

	private static final Logger logger = LoggerFactory.getLogger(DegreesController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/degrees" }, method = RequestMethod.GET)
	public String degrees(Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has accessed the degrees page.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Degrees");

		Database database = new Database();
		request.setAttribute("degrees_degrees-list", database.retrieveDegrees());

		// For Curriculums List
		request.setAttribute("degrees_curriculums-list", database.retrieveCurriculums());

		//Menu Active Number
		request.setAttribute("menuactivenum", 3);
		return "degrees";
	}

	// AJAX for Reload Table
	@RequestMapping(value = { "/degrees_reloadtable" }, method = RequestMethod.POST)
	public @ResponseBody String degrees_reloadtable(Model model, HttpSession session,
			@ModelAttribute("degreeBean") DegreeBean degreeBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has reloaded degrees table.");
		String script = "<script>";
		Database database = new Database();
		request.setAttribute("degrees_degrees-list", database.retrieveDegrees());
		ArrayList<ArrayList<String>> degrees = (ArrayList<ArrayList<String>>) request
				.getAttribute("degrees_degrees-list");
		script = script.concat("var dataSet = [");
		for (int i = 0; i < degrees.size(); i++) {
			ArrayList<String> degree = degrees.get(i);
			script = script.concat("[");
			script = script.concat("'" + degree.get(0) + "',");
			script = script.concat("'" + degree.get(1) + "',");
			script = script.concat("'" + degree.get(2) + "',");
			script = script.concat("'" + degree.get(3) + "'");
			script = script.concat("]");
			if (i < degrees.size() - 1) {
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

	// Adds new degree to the database
	@RequestMapping(value = { "/degrees_add" }, method = RequestMethod.POST)
	public String degrees_add(Model model, HttpSession session, @ModelAttribute("degreeBean") DegreeBean degreeBean,
			HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has added a new degree.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}

		Database database = new Database();
		boolean isAdded = false;

		isAdded = database.addDegree("", degreeBean.getDegreecode(), degreeBean.getDegreename(),
				degreeBean.getDegreecurriculum());

		if (isAdded) {
			model.addAttribute("notify_msg_state", "success");
			model.addAttribute("notify_msg", "Successfully added a new degree!");
		} else {
			model.addAttribute("notify_msg_state", "error");
			model.addAttribute("notify_msg", "An error occurred adding a degree! Please check if values are correct.");
		}

		// Reload Accounts Table
		request.setAttribute("degrees_degrees-list", database.retrieveSchools());

		return "redirect:degrees";
	}

	// AJAX for Degrees Edit
	@RequestMapping(value = { "/degrees_edit" }, method = RequestMethod.POST)
	public @ResponseBody String degrees_edit(Model model, HttpSession session,
			@ModelAttribute("degreeBean") DegreeBean degreeBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has edited a degree in the degrees table.");

		Database database = new Database();
		boolean isEdited = false;
		// Prevents admin conflict
		isEdited = database.editDegree(degreeBean.getDegreeid(), degreeBean.getDegreecode(), degreeBean.getDegreename(),
				degreeBean.getDegreecurriculum());
		if (isEdited) {
			return "<script>$.notify('Successfully edited degree', 'success');</script>";
		} else {
			return "<script>$.notify('An error has occurred!', 'error');</script>";
		}

	}

	// AJAX for Accounts Delete
	@RequestMapping(value = { "/degrees_delete" }, method = RequestMethod.POST)
	public @ResponseBody String degrees_delete(Model model, HttpSession session,
			@ModelAttribute("degreeBean") DegreeBean degreeBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has deleted some degrees in the degrees table.");

		ArrayList<String> degreeids = new ArrayList(Arrays.asList(degreeBean.getDegreeids().split(",")));

		boolean result = false;
		Database database = new Database();
		for (int i = 0; i < degreeids.size(); i++) {
			result = database.deleteDegree(degreeids.get(i));
			if (result == false) {
				return "<script>$.notify('An error has occurred!', 'error');</script>";
			}
		}

		return "<script>$.notify('Successfully deleted degrees', 'success');</script>";
	}

}
