package com.itsq133agroupc.sms;

import java.util.ArrayList;

public class CurriculumBean {
 
	private String curriculumid;
    private String username;
    private String password;
    private String repassword;
    private String fullname;
    private String accttype;
    private String userids;
    private String curriculumstructure;
 
    public String getCurriculumid() {
        return curriculumid;
    }
 
    public void setCurriculumid(String curriculumid) {
        this.curriculumid = curriculumid;
    }
    
    public String getCurriculumstructure() {
        return curriculumstructure;
    }
 
    public void setCurriculumstructure(String curriculumstructure) {
        this.curriculumstructure = curriculumstructure;
    }
    public String getUsername() {
        return username;
    }
 
    public void setUsername(String username) {
        this.username = username;
    }
 
    public String getPassword() {
        return password;
    }
 
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRepassword() {
        return repassword;
    }
 
    public void setRepassword(String repassword) {
        this.repassword = repassword;
    }
    
    public String getFullname() {
        return fullname;
    }
 
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }
    
    public String getAccttype() {
        return accttype;
    }
 
    public void setAccttype(String accttype) {
        this.accttype = accttype;
    }
    
    public String getUserids() {
        return userids;
    }
 
    public void setUserids(String userids) {
        this.userids = userids;
    }
 
} 