<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/xml; charset=UTF-8"); %>
<%@ page import="com.project.lucene.bean.LogBean" %>
<%@ page import="com.project.lucene.main.SearchEngine" %>
<%@ page import ="java.io.File" %>
<%@ page import ="java.util.List" %>
<%
		request.setCharacterEncoding("UTF-8");
		if (request.getParameterMap().size() == 0)
			return;
		String userName=request.getParameter("user");
		String query=request.getParameter("query");
		
		List<LogBean> beans = SearchEngine.search(userName, query);
		
		String xml = SearchEngine.toXml(beans);
%>
<%=xml%>