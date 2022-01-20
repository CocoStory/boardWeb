<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "boardWeb.util.*" %>
<%@ page import = "boardWeb.vo.*" %>

<%
	String memberid = request.getParameter("memberid");
	String memberpwd = request.getParameter("memberpwd");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where memberid=? and memberpwd = ? ";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,memberid);
		psmt.setString(2,memberpwd);
		
		rs = psmt.executeQuery();
		Member m = null;
		
		if(rs.next()){
			
			m = new Member(); //만들어진 빈, 기본값, 데이터 채울 곳 
			m.setMidx(rs.getInt("midx"));
			m.setMemberid(rs.getString("memberid"));
			m.setMembername(rs.getString("membername"));	//객체생성
		
			//세션에 담아야함
			session.setAttribute("loginUser",m);
			
		}
		
		if(m != null){//입력한 아이디,패스워드가 존재하면 m 이 null이 아니게 된다.
			response.sendRedirect(request.getContextPath());
		}else{
			response.sendRedirect("login.jsp"); //다시 로그인 페이지로 이동 
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
		
	}



%>