<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
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
						"	Saturday	"   <!-- ★★★★★요일 받아오기 -->
						<span class="sub_title">December 21st 2013</span> <!-- ★★★★★날짜 받아오기 -->
						</h1>
						<div class="corner">
							<input class="search" placeholder="Search title, url, or date" type="text">
							<input type="submit" value="Search"/>
						</div>
						<div class="controls">
							<a class="text back_to_week" href="#weeks/12-16-13">	← Back to Week	</a> <!-- ★★★★★back to week 주소 생성해서  받아오기 -->
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
						<h1>Week of Monday, December 23rd</h1>  <!-- ★★★★★날짜 받아오기 -->
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
				<div class="day_view with_contorls selected" style="display: block;">
				<header>
					<h1 class="title">
						"	Monday	"  <!-- ★★★★★요일 받아오기 -->
						<span class="sub_title">December 23rd 2013</span> <!-- ★★★★★날짜 받아오기 -->
					</h1>
					<div class="corner">
						<input class="search" placeholder="Search title, url, or date" type="text" tabindex="1"> <!-- 검색창  -->
					</div>
					<div class="controls">
						<a class="text back_to_week" href="#weeks/12-23-13">  ← Back to Week   </a> <!-- ★★★★★전 주 주소 받아오기 -->
						<div class="spacer"></div>
						<button class="delete_day">     Delete ...    </button>   <!-- ★★★★★무슨역할?????/-->
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
								
								    <!--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->
								    <!-- ★★★★★list 단위로 제목 & url 나타냄 (마우스 오버롤 기능 있음+ delete) -->
									<li class="visit" draggable="true" data-id="c2082"> <!-- ★★★★★데이터 아이디 db에서 각 자료 id로 가져오기 -->>
										<div class="drag_handle"> 
											<div class="line"></div>
											<div class="line"></div>
											<div class="line"></div>
											<div class="line"></div>
											<div class="line"></div>
										</div>
										<% 
										
										String h_vdate = "2013/12/16"; //테스트 코드
										
										Connection conn = null;
									 	PreparedStatement pstmt = null;
									 	ResultSet rs = null;
									 	
									 	Connection conn_count = null;
									 	PreparedStatement pstmt_count = null;
									 	ResultSet rs_count = null;
									 	
									 	int count = 0;
									 	
									 	String str_url;
									 	String str_title;
									 	String str_content;
									 	String str_vdate;
									 	String str_vtime;
									 	String str_vcount;
									 	
							        	
										String DB_SERVER = "localhost:3306";
										String DB_USERNAME = "root";
										String DB_PASSWORD = "kbssmhj0713";
										String DB_DATABASE = "chromehistory";

										String jdbcUrl = "jdbc:mysql://" + DB_SERVER + "/" + DB_DATABASE;            
							            
							            try {
							            	
								                Class.forName("com.mysql.jdbc.Driver").newInstance();
								                conn = DriverManager.getConnection(jdbcUrl, DB_USERNAME, DB_PASSWORD);	
								                
								                String sql_count = "SELECT * from test_history where h_vdate = ?";
								                
												pstmt_count = conn_count.prepareStatement(sql_count);
								           		
								           		pstmt_count.setString(1, h_vdate);
								                
								                rs_count = pstmt_count.executeQuery();
								                
								                rs_count.last();
								                
								                count = rs_count.getRow();
								                
								                rs_count.beforeFirst();
								                
								                
								                
								 						              
								               		 
								           		String sql = "SELECT h_url, h_title, h_content, h_vdate, h_vtime, h_vcount FROM test_histroy where h_vdate =?";
								           				
								           		pstmt = conn.prepareStatement(sql);
								           		
								           		pstmt.setString(1, h_vdate);							           				
								                   		                   		
								           		rs = pstmt.executeQuery();	
								           		
								           		if(rs.next())
								           		{
								           			str_url = rs.getString("h_url");
								           			//out.println(str_url);
								           			
								           			str_title = rs.getString("h_title");
								           			//out.println(str_title);
								           			
								           			str_content = rs.getString("h_content");
								           			//out.println(str_content);
								           			
								           			str_vdate = rs.getString("h_vdate");
								           			//out.println(str_vdate);
								           			
								           			str_vtime = rs.getString("h_vtime");
								           			//out.println(str_vtime);
								           			
								           			str_vcount = rs.getString("h_vcount");
								           			//out.println(str_vcount);  
								           			
								           			%>
								           			<a href=<% out.println(str_url); %> class="site">  <!-- ★★★★★방문 페이지 url -->
													<dl class="description" style="background-image: url(chrome://favicon/http://localhost:9080/ChromeHistory/ChromeHistory.jsp#weeks/12-16-13)"> <!-- ★★★★★방문 페이지 url 박스? -->
														<dt>
															<div class="active_tags"></div>
																			<% out.println(str_title); %>				  <!-- ★★★★★제목 -->
														</dt>
														<dd class="time"><% out.println(str_vtime); %></dd>
														<dd class="location"> <% out.println(str_url); %> </dd>
													</dl>
												</a>
												<a class="search_domain action" href="#search/http://localhost:9080/">More from site</a> <!-- ★★★★★방문 페이지와 같은 기본 url 가진 페이지들 모아서 보여줌 -->
												<a class="delete_visit delete" href="#" title="Delete">Delete</a>                        <!-- ★★★★★방문 페이지 지우는 기능 -->
											</li>
								           			<% 
								           		}
								           		else
								           		{
								           			out.println("Nothing in test_history");
								           		}
							                              
							               
							                 }catch (Exception e) {
							                	 e.printStackTrace();
							                 } 
							                        
							            %>
									
									<!--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->
									
									<li class="visit" draggable="true" data-id="c2083">
										<div class="drag_handle"> 
												<div class="line"></div>
												<div class="line"></div>
												<div class="line"></div>
												<div class="line"></div>
												<div class="line"></div>
										</div>
										<a href="http://webfine.tistory.com/category/JAVA/JSP/JAVA" class="site">
											<dl class="description" style="background-image: url(chrome://favicon/http://webfine.tistory.com/category/JAVA/JSP/JAVA)">
												<dt>
													<div class="active_tags"></div>
													"				Webdevelop의 프로그래밍 세상 :: HTML 파싱해서 데이터 가져오기				"
												</dt>
												<dd class="time">1:11 AM</dd>
												<dd class="location">http://webfine.tistory.com/category/JAVA/JSP/JAVA</dd>
											</dl>
										</a>
										<a class="search_domain action" href="#search/http://webfine.tistory.com/">More from site</a> 
										<a class="delete_visit delete" href="#" title="Delete">Delete</a>
									</li>
									<li class="visit" draggable="true" data-id="c2084">
										<div class="drag_handle"> 
												<div class="line"></div>
												<div class="line"></div>
												<div class="line"></div>
												<div class="line"></div>
												<div class="line"></div>
										</div>
										<a href="https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CDQQFjAA&url=http%3A%2F%2Fwebfine.tistory.com%2Fcategory%2FJAVA%2FJSP%2FJAVA&ei=tsG1UqvVKOSjiAfF3IHYDA&usg=AFQjCNGyZzQrIRuqRAsWAv1Sl1V31qKkvw&sig2=JSgqfoRYjkog7eVLra4hng&bvm=bv.58187178,d.aGc&cad=rjt" class="site">
											<dl class="description" style="background-image: url(chrome://favicon/https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CDQQFjAA&url=http%3A%2F%2Fwebfine.tistory.com%2Fcategory%2FJAVA%2FJSP%2FJAVA&ei=tsG1UqvVKOSjiAfF3IHYDA&usg=AFQjCNGyZzQrIRuqRAsWAv1Sl1V31qKkvw&sig2=JSgqfoRYjkog7eVLra4hng&bvm=bv.58187178,d.aGc&cad=rjt)">
												<dt>
													<div class="active_tags"></div>
													"				(No Title)				"
												</dt>
												<dd class="time">1:11 AM</dd>
												<dd class="location">
													"https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CDQQFjAA&url=http%3A%2F%2Fwebfine.tistory.com%2Fcategory%2FJAVA%2FJSP%2FJAVA&ei=tsG1UqvVKOSjiAfF3IHYDA&usg=AFQjCNGyZzQrIRuqRAsWAv1Sl1V31qKkvw&sig2=JSgqfoRYjkog7eVLra4hng&bvm=bv.58187178,d.aGc&cad=rjt"
												</dd>
											</dl>
										</a>
									</li> <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->
									<li class="visit grouped_sites" draggable="true" data-id="1:15"></li> <!-- 이부분 채워야됨-------------------------------------------------------------------------------------------- -->								
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