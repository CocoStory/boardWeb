<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="boardWeb.vo.*"%>
<%@ page import="org.json.simple.*" %> 
<%@ page import="java.sql.*" %> 
   
<%	
	request.setCharacterEncoding("UTF-8");
	
	//insert 필요 data 꺼내오기 
	String bidx = request.getParameter("bidx");
	String rcontent = request.getParameter("rcontent");
	
	//session 에서 data 가져오기 - midx
	Member loginUser = (Member)session.getAttribute("loginUser");
	
	int midx =  loginUser.getMidx();

	//db 접속 
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	
	
	try{//연결하기
		conn = DBManager.getConnection();
		//쿼리문 작성  - 바인드 변수
		String sql = " insert into reply(RIDX,BIDX,MIDX,rcontent,rdate)values(ridx_seq.nextval,?,?,?,sysdate)"; //시퀀스는 _seq.nextval로 , radat는 sysdate로 하면 등록 시점으로 들어간다.
		
		
		psmt = conn.prepareStatement(sql); //sql문이 db에 전송되어 진다.
		
		//데이터 넘겨주기 (데이터가 빠진 ?(바인드변수)에 대한 데이터 설정)
		psmt.setInt(1,Integer.parseInt(bidx));
		psmt.setInt(2,midx);
		psmt.setString(3,rcontent);
		
		
		psmt.executeUpdate(); 
		
		//
		sql = "select * from reply r, member m where r.midx = m.midx and r.ridx = (select max(ridx) from reply)";
		
		psmt = conn.prepareStatement(sql); // sql 문 db전송 
		
		rs = psmt.executeQuery();//rs:전역변수에 선언한 Resultset
		
		//JSON 사용 이유 - 화면에 동적으로 바로 표시되게 하기 위함 
		JSONArray list = new JSONArray();
		if(rs.next()){
			JSONObject jobj = new JSONObject();
			jobj.put("bidx",rs.getInt("bidx"));
			jobj.put("midx",rs.getInt("midx"));
			jobj.put("ridx",rs.getInt("ridx"));
			jobj.put("rcontent",rs.getString("rcontent"));
			jobj.put("membername",rs.getString("membername"));
			
			list.add(jobj);
		}
		
		out.print(list.toJSONString());
		
				
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
	

%>