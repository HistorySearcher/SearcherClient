<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.project.lucene.bean.LogBean" %>
<%@ page import="com.project.lucene.main.SearchEngine" %>
<%@ page import ="java.io.File" %>
<%@ page import ="java.util.List" %>

<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="style.css">
	<title>Chrome History</title>
	<style type="text/css">
		.GOAY0-5JC{background-color:transparent;}.GOAY0-5JC>.GOAY0-5MC{position:fixed;top:0;left:0;bottom:0;right:0;background:#fff;opacity:0.5;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=50);filter:alpha(opacity=50);z-index:99990;}.GOAY0-5JC.GOAY0-5LC>.GOAY0-5MC{background:#fff url(https://www.gstatic.com/commerce/inapp/images/widgets/loading.gif) center center no-repeat;}.GOAY0-5JC>iframe{position:fixed;top:0;left:0;height:100%;width:100%;border:0;z-index:99999;background-color:transparent;}.GOAY0-5JC.GOAY0-5LC>iframe{visibility:hidden;}.GOAY0-5JC.GOAY0-5NC>iframe{position:absolute;}.GOAY0-5KC{display:none;}
	</style>
</head>


<body class="chrome-bootstrap new_tags">
	<div class="app">
		<div class="frame">
			<div class="mainview view">
			
				<div class="day_view with_controls" style="display: none;"> 
					<header>
						<h1 class="title">
						"	Saturday	"   
						<span class="sub_title">December 21st 2013</span> 
						</h1>
						<div class="corner">
							<input class="search" placeholder="Search title, url, or date" type="text">
							<input type="submit" value="Search"/>
						</div>
						<div class="controls">
							<a class="text back_to_week" href="#weeks/12-16-13">	← Back to Week	</a> 
							<div class="spacer"></div>
							<button class="delete_day">     Delete ...    </button>
						</div>						
					</header>
					<div class="content">
						<div>
						
							<ol class="history"></ol> <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
						</div>
					</div>
				</div> 
				
				<div class="week_view with_controls loaded" style="display: none;"> 
					<header>
						<h1>Week of Monday, December 23rd</h1> 
						<div class="corner">
							<input class="search" placeholder="Search title, url, or date" type="text">
						</div>
						<div class="controls">
							<span class="text count">36 visits</span>
							<div class="spinner"></div>
							<div class="spacer"></div>
							<button class="delete_all">     Delete ...    </button>
						</div>						
					</header>
					<div class="content"> </div>  <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
					<div class="day_views"></div>
				</div> 
				
				<!-- ***************************************************************실제 보여지는 본문 부분*************************************************************** -->
				<%
					DecimalFormat df = new DecimalFormat("00");
					Calendar currentCalendar = Calendar.getInstance();
					//현재 날짜 구하기
					//"Monday" December 23rd 2013
					//String strYear = Integer.toString(currentCalendar.get(Calendar.YEAR));					
					//String strMonth = df.format(currentCalendar.get(Calendar.MONTH) + 1);
					//String strDay = df.format(currentCalendar.get(Calendar.DATE));
					
					int year = currentCalendar.get(Calendar.YEAR);
					int month = currentCalendar.get(Calendar.MONTH) + 1;
					String monthOfWeek = "";
					
					switch(month){
						case 1:
							monthOfWeek = "January";  
					        break;
						case 2:
							monthOfWeek = "February";  
					        break;
						case 3:
							monthOfWeek = "March";  
					        break;
						case 4:
							monthOfWeek = "April";  
					        break;
						case 5:
							monthOfWeek = "May";  
					        break;
						case 6:
							monthOfWeek = "June";  
					        break;
						case 7:
							monthOfWeek = "July";  
					        break;
						case 8:
							monthOfWeek = "August";  
					        break;
						case 9:
							monthOfWeek = "September";  
					        break;
						case 10:
							monthOfWeek = "October";  
					        break;
						case 11:
							monthOfWeek = "November";  
					        break;
						case 12:
							monthOfWeek = "December";  
					        break;					  				
					}
				
					
					int date = currentCalendar.get(Calendar.DATE);
					String dateOfWeek = "";
					
					switch(date){
						case 1:
							dateOfWeek = "1st";  
					        break;
						case 2:
							dateOfWeek = "2nd";  
					        break;
						case 3:
							dateOfWeek = "3rd";  
					        break;
						case 4:
							dateOfWeek = "4th";  
					        break;
						case 5:
							dateOfWeek = "5th";  
					        break;
						case 6:
							dateOfWeek = "6th";  
					        break;
						case 7:
							dateOfWeek = "7th";  
					        break;
						case 8:
							dateOfWeek = "8th";  
					        break;
						case 9:
							dateOfWeek = "9th";  
					        break;
						case 10:
							dateOfWeek = "10th";  
					        break;
						case 11:
							dateOfWeek = "11th";  
					        break;
						case 12:
							dateOfWeek = "12th";  
					        break;
						case 13:
							dateOfWeek = "13th";  
					        break;
						case 14:
							dateOfWeek = "14th";  
					        break; 
						case 15:
							dateOfWeek = "15th";  
					        break;
						case 16:
							dateOfWeek = "16th";  
					        break;
						case 17:
							dateOfWeek = "17th";  
					        break;
						case 18:
							dateOfWeek = "18th";  
					        break;
						case 19:
							dateOfWeek = "19th";  
					        break;
						case 20:
							dateOfWeek = "20th";  
					        break;
						case 21:
							dateOfWeek = "21st";  
					        break;
						case 22:
							dateOfWeek = "22nd";  
					        break;
						case 23:
							dateOfWeek = "23rd";  
					        break;
						case 24:
							dateOfWeek = "24th";  
					        break;
						case 25:
							dateOfWeek = "25th";  
					        break;
						case 26:
							dateOfWeek = "26th";  
					        break;
						case 27:
							dateOfWeek = "27th";  
					        break;
						case 28:
							dateOfWeek = "28th";  
					        break;
						case 29:
							dateOfWeek = "29th";  
					        break;
						case 30:
							dateOfWeek = "30th";  
					        break;
						case 31:
							dateOfWeek = "31st";  
					        break;    				
					}
					
					int iDayOfWeek = currentCalendar.get(Calendar.DAY_OF_WEEK);					
					String dayOfWeek = "";
					
					switch(iDayOfWeek){
				      case 1: 
				    	  dayOfWeek = "Sunday";    //"일요일";
				         break;
				      case 2: 
				    	  dayOfWeek = "Monday";    //"월요일";
				         break;
				      case 3: 
				    	  dayOfWeek = "Tuesday";    //"화요일";
				         break;
				      case 4: 
				    	  dayOfWeek = "Wednesday"; //"수요일";
				         break;
				      case 5: 
				    	  dayOfWeek = "Thursday";  //"목요일";
				         break;
				      case 6: 
				    	  dayOfWeek = "Friday";    //"금요일";
				         break;
				      case 7: 
				    	  dayOfWeek = "Saturday";  //"토요일";
				         break;
				      }
					
					
					
					//String strDate = "\"" + dayOfWeek + "\"" + "     " + strYear + "/" + strMonth + "/" + strDay;
					//"Monday" December 23rd 2013
					String strDate = "\"" + dayOfWeek + "\"" + " " + monthOfWeek + " " + dateOfWeek + " " + year;
				 	
				%>
				<div class="day_view with_contorls selected" style="display: block;">
				<header>
					<h1 class="title">
						<% %>  <!-- ★★★★★요일 받아오기 -->
						<span class="sub_title"><% out.println(strDate); %></span> <!-- ★★★★★날짜 받아오기 -->
					</h1>
					<div class="corner">
						<!--  <input class="search" placeholder="Search title, url, or date" type="text" tabindex="1">   -->
						<form action="ChromeHistory_output.jsp"> <!-- ChromeHistory_input -->						
							<!--  <input type="submit" value="Search"/> -->
							<input name="query" placeholder="Search title, url, or content" type="text" value=""><br>
							<!--  <input name="user" type="text" value="hajeong"><br> -->
							<button type="submit" value="Search" style="visibility: hidden">Search</button> 
						</form> <!-- ChromeHistory_input -->
					</div>
					
					<%
					request.setCharacterEncoding("UTF-8");
           			if (request.getParameterMap().size() == 0)
           				return;
           			
           			System.out.println("outputPage");
           			//String userName=request.getParameter("user");
           			String userName = session.getAttribute("id").toString();
           			String query=request.getParameter("query");
					
					%>
					<div class="controls">
						<!--<a class="text back_to_week" href="#weeks/12-23-13">  ← Back to Week   </a> --> <!-- ★★★★★전 주 주소 받아오기 -->						 
						<div class="spacer"><a href="http://112.108.40.87:8080/Lucene4.3-Server/ChromeHistory_input.jsp?user=<%=userName%>&pages=1"> ← Back to Sorting of time</a></div>
						<!-- <button class="delete_day">     Delete ...    </button> -->   <!-- ★★★★★방문한 주소 전체 지우기/-->
					</div>
				</header>
				<div class="content"> 
					<div>
						<ol class="history">  <!-- ★★★★★실제 각 페이지 url 및 title 출력해주는 body부분 -->
							<li class="interval" data-id="1:15">
								<header>
									<h4 class="title">1:15 AM</h4>
									<a class="delete_interval delete" href="#" title="Delete">	Delete	</a>	
								</header>
								<ol class="visits highlightable editable">
								
								    <!-- ★★★★★list 단위로 제목 & url 나타냄 (마우스 오버롤 기능 있음+ delete) -->
								    <% 
										
													
								           			
								           			List<LogBean> beans = SearchEngine.search(userName, query);
								           			
								           			String user ="";
								           			String url ="";
								           			String title = "";
								           			String time ="";
								           			String score ="";
								           			String data = "";
								           			for (LogBean bean : beans) {
								           			
								           				user = bean.getUserName();
								           				url = bean.getURL();
								           				title = bean.getTitle();
								           				time = bean.getTime();
								           				//score = bean.getScore();
								           				data = bean.getContent();							           												           				
								           			
								           			//}
								           			
								    %>
									<li class="visit" draggable="true" data-id="c2082"> <!-- ★★★★★데이터 아이디 db에서 각 자료 id로 가져오기 -->
										<!-- <div class="drag_handle">   -->
											<div class="line"></div>
											<div class="line"></div>
											<div class="line"></div>
											<div class="line"></div>
											<div class="line"></div>
										<!-- </div> -->
										
								           			<a href=<% out.println(url); %> class="site">  <!-- ★★★★★방문 페이지 url -->
													<dl class="description" style="background-image: url(chrome://favicon/http://localhost:9080/ChromeHistory/ChromeHistory.jsp#weeks/12-16-13)"> <!-- ★★★★★방문 페이지 url 박스? -->
														<dt>
															<div class="active_tags"></div>
																			<% out.println(title); %>				  <!-- ★★★★★제목 -->
																			
														</dt>
														<dd class="time"><% out.println(time); %></dd> <!-- ★★★★★시간-->
														<dd class="location"> <% out.println(url); %> </dd> <!-- ★★★★★추출 본문-->
														
														<dd><% out.println(data); %></dd> <!-- ★★★★★추출 본문-->
													</dl>
												</a>
												<!--  <a class="search_domain action" href="#search/http://localhost:9080/">More from site</a>  --><!-- ★★★★★방문 페이지와 같은 기본 url 가진 페이지들 모아서 보여줌 -->
												<!--  <a class="delete_visit delete" href="#" title="Delete">Delete</a> -->                        <!-- ★★★★★방문 페이지 지우는 기능 -->
											</li>
								    <% 
								        } //for문

							        %>
				  <!--***************************************************************실제 보여지는 본문 부분*************************************************************** -->
									
								</ol> 
							</li>	
							<li class="interval" data-id="1:00"></li> <!-- 위와 같은 내용들을 15분 단위로 끊어둔 부분--------------------------------------------------- -->	
							<li class="interval" data-id="0:45"></li> <!-- 위와 같은 내용들을 15분 단위로 끊어둔 부분--------------------------------------------------- -->	
							<li class="interval" data-id="0:30"></li> <!-- 위와 같은 내용들을 15분 단위로 끊어둔 부분--------------------------------------------------- -->		
							<li class="interval" data-id="0:15"></li> <!-- 위와 같은 내용들을 15분 단위로 끊어둔 부분--------------------------------------------------- -->							
						</ol> 
					</div>
				</div>
				</div>
			    <div class="search_view with_controls loaded" style="display: none;"> </div> <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
	    	</div>
		<div class="navigation"> 
			<h1>
				<a href="#/">    History    </a>
			</h1>
			
			<div class="available_tags"></div>
			<ul class="menu"> </ul> <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
			<div class="menu menu_view disappearable"> </div>  <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
			<ul class="menu disapperable">  </ul>  <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
		</div>
		</div>
	<div id="coverup"></div>
	</div>
	 <!-- script부분 뺌 광곤가??이부분 채워야됨-------------------------------------------------------------------------------------------- -->
</body>
</html>