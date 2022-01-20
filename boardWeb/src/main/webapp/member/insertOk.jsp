<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>  
<%	//member 글 등록을 위한 눈에 보이지 않는 화면
	request.setCharacterEncoding("UTF-8");
	
	//form태그 name값과 일치해야함
	String memberid = request.getParameter("memberid"); 
	String memberpwd = request.getParameter("memberpwd");
	String membername = request.getParameter("membername");
	String addr = request.getParameter("addr");
	String phone = request.getParameter("phone");
	String email = request.getParameter("email");
	String gender = request.getParameter("gender");
	
	//db연결정보
	String url  = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
	
	//db저장 쿼리
		String sql = " insert into member(midx,memberid,memberpwd,membername,addr,phone,email,gender)"
				   + " values(midx_seq.nextval,?,?,?,?,?,?,?)"; 
		
	
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,memberid);
		psmt.setString(2,memberpwd);
		psmt.setString(3,membername);
		psmt.setString(4,addr);
		psmt.setString(5,phone);
		psmt.setString(6,email);
		psmt.setString(7,gender);
		
		
	//쿼리 실행 
		int result = psmt.executeUpdate();
		
	//잘된 경우 list로 이동 
		response.sendRedirect("list.jsp");
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}


%>