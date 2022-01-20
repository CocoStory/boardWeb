<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%	//member 삭제 노출되지 않는 화면 

	String midx = request.getParameter("midx");

	String url  = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";

	Connection conn = null;
	PreparedStatement psmt = null;
	//삭제만 할 것이라 resultset은 필요없다 
	

	try{
		Class.forName("oracle.jdbc.driver.OracleDriver"); //오타가 있으면 ClassNotFound 오류 발생 (대소문자 확인) 
		conn = DriverManager.getConnection(url,user,pass);
		
	
		String sql = " delete from member where midx="+midx ;
				
		psmt = conn.prepareStatement(sql);
		
		int result = psmt.executeUpdate();  
		
			response.sendRedirect("list.jsp");
	
		
		}catch(Exception e){
			e.printStackTrace();
				
		}finally{
			if(conn != null) conn.close();
			if(psmt != null) psmt.close();
		}
		
%>