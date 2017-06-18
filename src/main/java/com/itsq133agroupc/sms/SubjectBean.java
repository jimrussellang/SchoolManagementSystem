package com.itsq133agroupc.sms;

import java.util.ArrayList;

public class SubjectBean {
 
	private String courseid;
    private String coursecode;
    private String coursename;
    private float courseunits;
    private String prerequisites;
    private float price;
 
    public String getCourseid() {
        return courseid;
    }
    public void setCourseid(String courseid) {
        this.courseid = courseid;
    }
    
    public String getCoursecode() {
        return coursecode;
    }
    public void setCoursecode(String coursecode) {
        this.coursecode = coursecode;
    }
    
    public String getCoursename() {
        return coursename;
    }
    public void setCoursename(String coursename) {
        this.coursename = coursename;
    }
    
    public float getCourseunits() {
        return courseunits;
    }
    public void setCourseunits(float courseunits) {
        this.courseunits = courseunits;
    }
    
    public String getPrerequisites() {
        return prerequisites;
    }
    public void setPrerequisites(String prerequisites) {
        this.prerequisites = prerequisites;
    }
    
    public float getPrice() {
        return price;
    }
    public void setPrice(float price) {
        this.price = price;
    }
} 