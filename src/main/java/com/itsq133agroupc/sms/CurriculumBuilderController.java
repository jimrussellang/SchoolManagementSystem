package com.itsq133agroupc.sms;

import java.sql.ResultSet;
import java.sql.Statement;
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
public class CurriculumBuilderController {

	private static final Logger logger = LoggerFactory.getLogger(CurriculumBuilderController.class);

	LoginController logincontroller = new LoginController();

	// Simply selects the home view to render by returning its name.
	@RequestMapping(value = { "/curriculum-builder" }, method = RequestMethod.GET)
	public String curriculumBuilder(Model model, HttpSession session, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has accessed the curriculum builder.");

		// Checks if user is logged in. If not, redirects to Login page.
		if (!logincontroller.isLoggedIn(session, response)) {
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			// Used for redirecting to current page after logging in
			session.setAttribute("pageforward", request.getRequestURL());
			return "login";
		}
		// Attribute used for printing the page title
		model.addAttribute("page_title", "Curriculum Builder");

		Database database = new Database();
		request.setAttribute("curriculums_curriculums-list", database.retrieveCurriculums());

		return "curriculum_builder";
	}

	// AJAX for Reload Table
	@RequestMapping(value = { "/curriculum-builder_reloadtable" }, method = RequestMethod.POST)
	public @ResponseBody String accounts_reloadtable(Model model, HttpSession session,
			@ModelAttribute("accountBean") AccountBean accountBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has reloaded Curriculums table.");
		String script = "<script>";
		Database database = new Database();
		request.setAttribute("curriculums_curriculums-list", database.retrieveCurriculums());
		ArrayList<ArrayList<String>> curriculums = (ArrayList<ArrayList<String>>) request
				.getAttribute("curriculums_curriculums-list");
		script = script.concat("var dataSet = [");
		for (int i = 0; i < curriculums.size(); i++) {
			ArrayList<String> curriculum = curriculums.get(i);
			script = script.concat("[");
			script = script.concat("'" + curriculum.get(0) + "',");
			script = script.concat("'" + curriculum.get(1) + "',");
			script = script.concat("'" + curriculum.get(2) + "',");
			script = script.concat("'" + curriculum.get(3) + "',");
			script = script.concat("'" + curriculum.get(4) + "'");
			script = script.concat("]");
			if (i < curriculum.size() - 1) {
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

	// AJAX for Curriculum Editor
	@RequestMapping(value = { "/curriculum-builder_curriculumeditor" }, method = RequestMethod.POST)
	public @ResponseBody String curriculumEditor(Model model, HttpSession session,
			@ModelAttribute("curriculumBean") CurriculumBean curriculumBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has accessed the Curriculum Editor.");
		String script = "<script>";
		Database database = new Database();
		ArrayList<ArrayList<String>> curriculums = database.retrieveSubjects();
		for (int i = 0; i < curriculums.size(); i++) {
			ArrayList<String> curriculum = curriculums.get(i);
			script = script.concat("$('#subjects_container').append('<li id=\"subj_" + curriculum.get(0) + "\">" + "<b>"
					+ curriculum.get(1) + "</b>" + "<br>Name: " + curriculum.get(2) + "" + "<br>Units: "
					+ curriculum.get(3) + "');");
		}

		// Initialize Curriculum Years and Terms
		ArrayList<String> curriculum_info = database.getCurriculumInfo(curriculumBean.getCurriculumid());
		String curriculum_years = curriculum_info.get(2);
		String curriculum_terms = curriculum_info.get(3);
		String curriculum_structure = curriculum_info.get(5);
		script = script.concat("curriculum_id_currentedit = " + curriculumBean.getCurriculumid()
				+ "; curriculum_structure = '" + curriculum_structure + "'; curriculum_years = " + curriculum_years
				+ "; curriculum_terms = " + curriculum_terms + ";");

		// Draw Curriculum Editor elements
		for (int i = 0; i < Integer.parseInt(curriculum_years); i++) {
			System.out.println("Year: " + i);
			script = script.concat("$('#curriculum_fullcontainer').append('<div class=\"row\">"
					+ "<div class=\"panel-group\"><div class=\"panel panel-default\"><div class=\"panel-heading\">"
					+ "<a data-toggle=\"collapse\" href=\"#curriculum_year" + (i + 1) + "\">Year " + (i + 1)
					+ "</a></div>");
			int colmd_divide = 12 / Integer.parseInt(curriculum_terms);
			script = script
					.concat("<div id=\"curriculum_year" + (i + 1) + "\" class=\"collapse\"><div class=\"panel-body\">");
			for (int j = 0; j < Integer.parseInt(curriculum_terms); j++) {
				System.out.println("Term: " + j);
				script = script.concat("<div class=\"container-fluid col-md-" + colmd_divide + "\">Term " + (j + 1)
						+ "<ul class=\"sort_style\" id=\"curriculum_container__y" + (i + 1) + "t" + (j + 1)
						+ "\"></ul></div>");
			}
			script = script.concat("</div></div>");
			script = script.concat("');");
			/*
			 * +
			 * "<div class=\"container-fluid col-md-4\">Term 2<ul class=\"sort_style\" id=\"curriculum_container__y1t2\"></ul></div>"
			 * +
			 * "<div class=\"container-fluid col-md-4\">Term 3<ul class=\"sort_style\" id=\"curriculum_container__y1t3\"></ul></div>"
			 * + "</div>');");
			 */
		}

		// Implement Drag and Drop features
		ArrayList<String> put_containers = new ArrayList<String>();
		put_containers.add("subjects_container");
		for (int i = 0; i < Integer.parseInt(curriculum_years); i++) {
			for (int j = 0; j < Integer.parseInt(curriculum_terms); j++) {
				put_containers.add("curriculum_container__y" + (i + 1) + "t" + (j + 1));
			}
		}
		for (int i = 0; i < put_containers.size(); i++) {
			script = script.concat(
					"var " + put_containers.get(i) + " = document.getElementById('" + put_containers.get(i) + "');");
			script = script.concat("var " + put_containers.get(i).replaceAll("_container", "_sortable")
					+ " = Sortable.create(" + put_containers.get(i) + ", {" + "group : {" + "name : '"
					+ put_containers.get(i) + "'," + "put : [ ");
			for (int j = 0; j < put_containers.size(); j++) {
				script = script.concat("'" + put_containers.get(j) + "'");
				if (j < put_containers.size() - 1) {
					script = script.concat(",");
				}
			}
			script = script.concat("]" + "},animation : 100});");
		}
		// script = script.concat("var subjects_container =
		// document.getElementById('subjects_container');");
		// script = script.concat("var subjects_sortable =
		// Sortable.create(subjects_container, {"
		// + "group : {"
		// + "name : 'subjects_container',"
		// + "put : [ 'subjects_container',
		// 'curriculum_container__y1t1','curriculum_container__y1t2','curriculum_container__y1t3'
		// ]"
		// + "},animation : 100});");
		//
		// script = script.concat("var curriculum_container__y1t1 =
		// document.getElementById('curriculum_container__y1t1');");
		// script = script.concat("var curriculum_sortable__y1t1 =
		// Sortable.create(curriculum_container__y1t1, {"
		// + "group : {"
		// + "name : 'curriculum_container__y1t1',"
		// + "put : [ 'subjects_container',
		// 'curriculum_container__y1t1','curriculum_container__y1t2','curriculum_container__y1t3'
		// ]"
		// + "},animation : 100});");
		// script = script.concat("var curriculum_container__y1t2 =
		// document.getElementById('curriculum_container__y1t2');");
		// script = script.concat("var curriculum_sortable__y1t2 =
		// Sortable.create(curriculum_container__y1t2, {"
		// + "group : {"
		// + "name : 'curriculum_container__y1t2',"
		// + "put : [ 'subjects_container',
		// 'curriculum_container__y1t1','curriculum_container__y1t2','curriculum_container__y1t3'
		// ]"
		// + "},animation : 100});");
		// script = script.concat("var curriculum_container__y1t3 =
		// document.getElementById('curriculum_container__y1t3');");
		// script = script.concat("var curriculum_sortable__y1t3 =
		// Sortable.create(curriculum_container__y1t3, {"
		// + "group : {"
		// + "name : 'curriculum_container__y1t3',"
		// + "put : [ 'subjects_container',
		// 'curriculum_container__y1t1','curriculum_container__y1t2','curriculum_container__y1t3'
		// ]"
		// + "},animation : 100});");

		script = script.concat("</script>");

		System.out.println("CS: " + curriculum_structure);
		return script;
	}

	// AJAX for Curriculum Editor Save Operation
	@RequestMapping(value = { "/curriculum-builder_curriculumeditor_save" }, method = RequestMethod.POST)
	public @ResponseBody String curriculumEditorSave(Model model, HttpSession session,
			@ModelAttribute("curriculumBean") CurriculumBean curriculumBean, HttpServletResponse response,
			HttpServletRequest request) {
		logger.info("A user has saved a curriculum's structure.");

		Database database = new Database();
		boolean result = database.saveCurriculumStructure(curriculumBean.getCurriculumid(),
				curriculumBean.getCurriculumstructure());
		String script = "";

		if (result == true) {
			script = "<script>$.notify('Successfully saved curriculum!', 'success');</script>";
		} else {
			script = "<script>$.notify('Error saving curriculum!', 'error');</script>";
		}

		return script;
	}

}
