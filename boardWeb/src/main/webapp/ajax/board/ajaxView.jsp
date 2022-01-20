<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
    
<%
	String bidx = request.getParameter("bidx");

	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	

	try{
		// Connection 객체 생성 
		conn = DBManager.getConnection();
		
		//sql문 작성 
		String sql = " select * from board where bidx ="+bidx;
		
		//PreparedStatement 객체 생성
		psmt = conn.prepareStatement(sql);
		
		//sql 수행 결과행을 rs에 담아줌 
		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		
		if(rs.next()){
			JSONObject Obj = new JSONObject();
			Obj.put("bidx",rs.getInt("bidx"));
			Obj.put("subject",rs.getString("subject"));
			Obj.put("writer",rs.getString("writer"));
			Obj.put("content",rs.getString("content"));
			
			list.add(Obj);
		}
		
		out.print(list.toJSONString());
		
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBManager.close(psmt,conn,rs);
		
		}
		
		
%>