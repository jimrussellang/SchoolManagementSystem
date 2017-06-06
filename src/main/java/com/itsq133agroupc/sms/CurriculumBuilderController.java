package com.itsq133agroupc.sms;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

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
	
	//Simply selects the home view to render by returning its name.
	@RequestMapping(value = {"/curriculum-builder"}, method = RequestMethod.GET)
	public String curriculumBuilder(Model model, HttpSession session, HttpServletResponse response) {
		logger.info("A user has accessed the curriculum builder.");
			
		//Checks if user is logged in. If not, redirects to Login page.
		if(!logincontroller.isLoggedIn(session, response)){
			model.addAttribute("access_denied_msg", "You must login first to access this page!");
			return "login";
		}
		
		return "curriculum_builder";
	}
	
}
