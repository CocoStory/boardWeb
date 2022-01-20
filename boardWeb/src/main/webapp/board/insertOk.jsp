<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>  
<%@ page import="boardWeb.vo.*" %>
<%	//board 글 등록을 위한 눈에 보이지 않는 화면


	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	//form name값과 일치해야함
	String subject = request.getParameter("subject"); 
	String writer = request.getParameter("writer");
	String content = request.getParameter("content");
	
	String url  = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	//저장만 하고 끝나기에 result set은 필요없다
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " insert into board(bidx,subject,writer,content,midx)"
				   + " values(bidx_seq.nextval,?,?,?,?)"; //포린키가 1인 것으로 넣기
		
		//midx는 포린키
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,subject);
		psmt.setString(2,writer);
		psmt.setString(3,content);
		psmt.setInt(4,login.getMidx());
		
		int result = psmt.executeUpdate();
		
		response.sendRedirect("list.jsp");
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}


%>