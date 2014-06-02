<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8");%>
<%
request.setCharacterEncoding("UTF-8");
if (request.getParameterMap().size() == 0)
	return;
String userName=request.getParameter("user");
System.out.println(userName);
%>

