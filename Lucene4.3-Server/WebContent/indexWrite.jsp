<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="com.project.lucene.bean.LogBean" %>
	<%@ page import="com.project.lucene.main.SearchEngine" %>
	<%@ page import ="java.io.File" %>
	
<%
		request.setCharacterEncoding("UTF-8");
		if (request.getParameterMap().size() == 0)
			return;
		String userName=request.getParameter("user");
		String content=request.getParameter("content");
		String title=request.getParameter("title");
		String url=request.getParameter("url");
		//String date=request.getParameter("date");
		
		LogBean bean = new LogBean();
		bean.setUserName(userName);
		bean.setTitle(title);
		bean.setURL(url);
		bean.setContent(content);
		System.out.println(title);
		//bean.setDate(date);
		
		
		SearchEngine.index(bean);
%>