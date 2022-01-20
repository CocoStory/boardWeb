<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>  
<%  //member 수정을 위한 눈에 보이지 않는 화면 
	request.setCharacterEncoding("UTF-8"); //한글이 있을 수 있으니 Encoding 필요 

	//원하는 파라미터 꺼내기
	String memberpwd = request.getParameter("memberpwd");
	String addr = request.getParameter("addr");
	String phone = request.getParameter("phone");
	String email = request.getParameter("email");
	String midx = request.getParameter("midx");
	
	//PK가 필요하다 - 원하는 한 건에대한 데이터를 수정하기 위해서임
	//아래 부분은 데이터 접근을 위해 반드시 필요
	
	String url  = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	//연결부분 - 전에 작성 했던 것과 거의 동일하다
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver"); //오타가 있으면 ClassNotFound 오류 발생 (대소문자 확인) 
		conn = DriverManager.getConnection(url,user,pass);
		
		//수정해야하는 부분 sql 
		String sql = " update member set " 
					+ " memberpwd = '"+memberpwd+"' " 
				   + " ,addr = '"+addr+"' " 
				   + " ,phone = '"+phone+"' " 
				   + " ,email = '"+email+"' "
				   + "where midx="+midx;
					
		
		psmt = conn.prepareStatement(sql);
		
		//달라지는 점
		
		int result = psmt.executeUpdate();  //update가 잘 이루어졌는지 판단
		
		if(result>0){
			//0보다 크면 update가 잘 된 것 
			response.sendRedirect("view.jsp?midx="+midx);
		}else{
			response.sendRedirect("list.jsp");
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
		
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
	

%>
