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
public class LoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	
	//Controller for Login
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Locale locale, Model model) {
		logger.info("A user has accessed the Login page.");
		
		return "login";
	}
	
	//Controller for Login
	@RequestMapping(value = "/login_verify", method = RequestMethod.POST)
	public @ResponseBody String loginVerify(Model model, @ModelAttribute("loginBean") LoginBean loginBean, HttpSession session, HttpServletRequest request) {
		logger.info("A user is trying to login...");
		
		if (loginBean != null && loginBean.getUsername() != null & loginBean.getPassword() != null) {
			Database database = new Database();
			boolean is_validaccount = database.loginAccount(loginBean.getUsername(), loginBean.getPassword());
            if (is_validaccount) {
            	session.setAttribute("login_userid", database.getAccountUserID(loginBean.getUsername()));
            	if(session.getAttribute("pageforward") != null){
            		String pageforward = session.getAttribute("pageforward").toString();
            		session.removeAttribute("pageforward");
            		return "<script>"
                    		+ "window.location ='" + pageforward + "';"
                    		+ "</script>";
            	}
            	else{
            		return "<script>"
                    		+ "window.location.replace('home')"
                    		+ "</script>";
            	}
            } else {
            	logger.info("A user fails to login...");
                model.addAttribute("login_message", "Invalid Details");
                return "<script>"
                		+ "$('#login_container').removeClass('__loading');"
                		+ "$.notify('Invalid credentials!', 'error');"
                		+ "</script>";
            }
        } else {
        	logger.info("A user has not entered any credentials...");
            model.addAttribute("login_message", "Please enter Details");
            return "<script>"
    			+ "$('#login_container').removeClass('__loading');"
    			+ "$.notify('Credentials are empty!', 'error');"
    			+ "</script>";
        }
		
	}
	
	//Checks for active login session
	public boolean isLoggedIn(HttpSession session, HttpServletResponse response){
		response.setHeader("Cache-Control","no-cache"); //Forces caches to obtain a new copy of the page from the origin server
		response.setHeader("Cache-Control","no-store"); //Directs caches not to store the page under any circumstance
		response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
		response.setHeader("Pragma","no-cache"); //HTTP 1.0 backward compatibility
		
		boolean isloggedin = false;
		if(session.getAttribute("login_userid") == null){
			isloggedin = false;
		}
		else{
			isloggedin = true;
		}
		return isloggedin;
	}
	
	//Controller for Logout
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(Model model, @ModelAttribute("loginBean") LoginBean loginBean, HttpSession session) {
		logger.info("A user is logging out...");
		
		model.addAttribute("logout", "true");
		session.invalidate();
		
		return "redirect:login";
			
	}
}
