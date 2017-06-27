package com.itsq133agroupc.sms;

import java.util.ArrayList;
import java.util.Arrays;

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
public class SubjectsController {

	private static final Logger logger = LoggerFactory.getLogger(AccountsController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the accounts view to render by returning its name.
	@RequestMapping(value = { "/subjects" }, method = RequestMethod.GET)
	public String accounts(Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has accessed the subjects page.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Subjects");

		Database database = new Database();
		if(session.getAttribute("login_accounttype").equals("admin")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(0, ""));
		}
		else if(session.getAttribute("login_accounttype").equals("SCH")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(2, session.getAttribute("login_school").toString().trim()));
		}
		else if(session.getAttribute("login_accounttype").equals("ST")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(3, session.getAttribute("login_school").toString().trim()));
		}
		
		//Menu Active Number
		request.setAttribute("menuactivenum", 3);
		if(session.getAttribute("login_accounttype").equals("SCH")){
			request.setAttribute("menuactivenum", 2);
		}
		return "subjects";
	}

	// Adds new subject to the database
	@RequestMapping(value = { "/subjects_add" }, method = RequestMethod.POST)
	public String accounts_add(Model model, HttpSession session, @ModelAttribute("subjectBean") SubjectBean subjectBean,
			HttpServletResponse response, HttpServletRequest request) {
		logger.info("A user has added a new subject.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}

		Database database = new Database();
		boolean isAdded = false;

		//Sets up the appropriate School Prefix
		if(session.getAttribute("login_school") != null){
			subjectBean.setCoursecode(session.getAttribute("login_school").toString().trim() + "." + subjectBean.getCoursecode());
		}
		isAdded = database.addCourse("", subjectBean.getCoursecode(),
				subjectBean.getCoursename(), String.valueOf(subjectBean.getCourseunits()),
				subjectBean.getPrerequisites(), String.valueOf(subjectBean.getPrice()));

		if (isAdded) {
			model.addAttribute("notify_msg_state", "success");
			model.addAttribute("notify_msg", "Successfully added a new subject!");
		} else {
			model.addAttribute("notify_msg_state", "error");
			model.addAttribute("notify_msg", "An error occurred adding a subject! Please check if values are correct.");
		}

		// Reload Subjects Table
		if(session.getAttribute("login_accounttype").equals("admin")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(0, ""));
		}
		else if(session.getAttribute("login_accounttype").equals("SCH")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(2, session.getAttribute("login_school").toString().trim()));
		}
		else if(session.getAttribute("login_accounttype").equals("ST")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(3, session.getAttribute("login_school").toString().trim()));
		}

		return "redirect:subjects";
	}

	// AJAX for Reload Table
	@RequestMapping(value = { "/subjects_reloadtable" }, method = RequestMethod.POST)
	public @ResponseBody String subjects_reloadtable(Model model, HttpSession session,
			@ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has reloaded subjects table.");
		String script = "<script>";
		Database database = new Database();
		if(session.getAttribute("login_accounttype").equals("admin")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(0, ""));
		}
		else if(session.getAttribute("login_accounttype").equals("SCH")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(2, session.getAttribute("login_school").toString().trim()));
		}
		else if(session.getAttribute("login_accounttype").equals("ST")){
			request.setAttribute("subjects_subjects-list", database.retrieveSubjects(3, session.getAttribute("login_school").toString().trim()));
		}
		ArrayList<ArrayList<String>> subjects = (ArrayList<ArrayList<String>>) request
				.getAttribute("subjects_subjects-list");
		script = script.concat("var dataSet = [");
		for (int i = 0; i < subjects.size(); i++) {
			ArrayList<String> subject = subjects.get(i);
			script = script.concat("[");
			script = script.concat("'" + subject.get(0) + "',");
			script = script.concat("'" + subject.get(1) + "',");
			script = script.concat("'" + subject.get(2) + "',");
			script = script.concat("'" + subject.get(3) + "',");
			script = script.concat("'" + subject.get(4) + "',");
			script = script.concat("'" + subject.get(5) + "'");
			script = script.concat("]");
			if (i < subjects.size() - 1) {
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

	// AJAX for Subjects Edit
	@RequestMapping(value = { "/subjects_edit" }, method = RequestMethod.POST)
	public @ResponseBody String subjects_edit(Model model, HttpSession session,
			@ModelAttribute("subjectBean") SubjectBean subjectBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has edited a subject in the subjects table.");

		Database database = new Database();
		boolean isEdited = false;
		
		if(session.getAttribute("login_accounttype").equals("admin")){
			isEdited = database.editCourse(subjectBean.getCourseid(), subjectBean.getCoursecode(),
					subjectBean.getCoursename(), String.valueOf(subjectBean.getCourseunits()),
					subjectBean.getPrerequisites(), String.valueOf(subjectBean.getPrice()));
		}
		else{
			if(subjectBean.getCoursecode().startsWith(session.getAttribute("login_school").toString().trim() + ".")){
				isEdited = database.editCourse(subjectBean.getCourseid(), subjectBean.getCoursecode(),
						subjectBean.getCoursename(), String.valueOf(subjectBean.getCourseunits()),
						subjectBean.getPrerequisites(), String.valueOf(subjectBean.getPrice()));
			}
			else{
				isEdited = false;
			}
		}

		if (isEdited) {
			return "<script>$.notify('Successfully edited subject', 'success');</script>";
		} else {
			return "<script>$.notify('An error has occurred!', 'error');</script>";
		}

	}

	// AJAX for Subjects Delete
	@RequestMapping(value = { "/subjects_delete" }, method = RequestMethod.POST)
	public @ResponseBody String subjects_delete(Model model, HttpSession session,
			@ModelAttribute("subjectBean") SubjectBean subjectBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has deleted some subjects in the subjects table.");

		ArrayList<String> courseids = new ArrayList(Arrays.asList(subjectBean.getCourseids().split(",")));

		boolean result = false;
		Database database = new Database();
		for (int i = 0; i < courseids.size(); i++) {
			result = database.deleteCourse(courseids.get(i));
			if (result == false) {
				return "<script>$.notify('An error has occurred!', 'error');</script>";
			}
		}

		return "<script>$.notify('Successfully deleted subjects', 'success');</script>";
	}
}
