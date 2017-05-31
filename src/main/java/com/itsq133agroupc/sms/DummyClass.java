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
public class DummyClass {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	
	//Simply selects the home view to render by returning its name.
	@RequestMapping(value = {"dummy", "dummy2"}, method = RequestMethod.GET)
	public String dummy(Locale locale, Model model, HttpSession session, HttpServletResponse response) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		
		return "dummy";
	}
	
	
}
