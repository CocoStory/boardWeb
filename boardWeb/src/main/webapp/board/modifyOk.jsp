<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>  
<%  //board 수정을 위한 눈에 보이지 않는 화면 
	request.setCharacterEncoding("UTF-8"); //인코딩처리
	
	
	//전송된 데이터 반환
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	String bidx = request.getParameter("bidx");
	
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
		//JDBC 1단계 : 드라이버 로드
		Class.forName("oracle.jdbc.driver.OracleDriver"); //오타가 있으면 ClassNotFound 오류 발생 (대소문자 확인)
		
		//JDBC 2단계 : Connection 객체 생성 
		conn = DriverManager.getConnection(url,user,pass);
		
		//sql문 작성 
		String sql = " update board set " 
				   + " subject = '"+subject+"' " 
				   + " ,content = '"+content+"' "
				   + "where bidx="+bidx;
					
		//"update board set subject = '??', content='??' where bidx=?"
				
		// JDBC 3단계 : PreparedStatement 객체 생성
		psmt = conn.prepareStatement(sql);
		
		//달라지는 점
		
		int result = psmt.executeUpdate();  //update가 잘 이루어졌는지 판단
		
		if(result>0){
			//0보다 크면 update가 잘 된 것 
			//out.print("<script>alert('수정완료!');</script>");
			response.sendRedirect("view.jsp?bidx="+bidx);
		}else{
			response.sendRedirect("list.jsp");
		}
		
		
	}catch(Exception e){
		e.printStackTrace(); //데이터베이스 조회 에러 발생 시 콘솔에 에러 출력
		
	}finally{
		//자원정리
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
	

%>
