package com.project.lucene.bean;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * XML 파일 로그
 * @author dooroomee
 *
 */
public class LogBean {
	private String userName;
	private String urlAddress;
	private String visitingTime;
	private String title;
	private String date;
	private String time;
	private static SimpleDateFormat simple = new SimpleDateFormat("yyyyMMddHHmmss");
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd' 'HH:mm:ss");
	private static SimpleDateFormat today = new SimpleDateFormat("yyyyMMddHH");
	private static SimpleDateFormat year = new SimpleDateFormat("yyyy");
	private String score;
	private String content;
	private String now;
	private String searchYear;
	
	public LogBean() {
		date = simple.format(new Date()).toString();
		time=sdf.format(new Date()).toString();
		now = today.format(new Date());
		searchYear = year.format(new Date()).toString();
		
		
	}
	public String getNow(){
		return now;
	}
	public void setTime(String time){
		this.time = time;
	}
	
	public String getTime(){
		return time;
	}
	
	public void setYear(String searchYear){
		this.searchYear = searchYear;
	}
	
	public String getYear(){
		return searchYear;
	}
	
	public String getScore(){
		return score;
	}
	
	public void setScore(String score){
		this.score=score;
	}
	public String getDate() {
		return date;
	}
	
	public void setDate(String date) {
		this.date = date;
	}

	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content=content;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String string) {
		this.title=string;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public String getURL() {
		return urlAddress;
	}

	public String getVistingTime() {
		return visitingTime == null ? date : visitingTime;
	}
	
	public void setUserName(String userName) {
		this.userName=userName;
	}
	
	public void setURL(String urlAddress) {
		this.urlAddress=urlAddress;
	}
	
	public void setVisitingTime(String visitingTime) {
		this.visitingTime = visitingTime;
	}
	
}
