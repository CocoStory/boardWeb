<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="java.util.*" %>

<%
	//세션
	Member login = (Member)session.getAttribute("loginUser");

	//인코딩
	request.setCharacterEncoding("UTF-8");

	//DB에 연결하는 부분 	
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");

	String bidx = request.getParameter("bidx");

	String url  = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	//댓글
	PreparedStatement psmtReply = null;
	ResultSet rsReply = null;
	
	
	String subject_ = "";
	String writer_ = "";
	String content_ = "";
	int bidx_ = 0;
	int midx_ = 0;
	ArrayList<Reply> rList = new ArrayList<>();
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " select * from board where bidx="+bidx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery(); 
	
		//rs는 한두개라서 굳이 while문으로 가지 않는다.
		if(rs.next()){
			subject_ = rs.getString("subject");
			writer_ = rs.getString("writer");
			content_ = rs.getString("content");
			bidx_ = rs.getInt("bidx");
			midx_ = rs.getInt("midx");
		}
		
		sql = "select * from reply r, member m where r.midx = m.midx and bidx="+bidx;
		
		psmtReply = conn.prepareStatement(sql); //실행
		
		rsReply = psmtReply.executeQuery();//담기
		
		while(rsReply.next()){
			Reply reply = new Reply();
			reply.setBidx(rsReply.getInt("bidx"));
			reply.setMidx(rsReply.getInt("midx"));
			reply.setRidx(rsReply.getInt("ridx"));
			reply.setRcontent(rsReply.getString("rcontent"));
			reply.setRdate(rsReply.getString("rdate"));
			reply.setMembername(rsReply.getString("membername"));
			
			rList.add(reply);
			
			
		}
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
		if(psmtReply != null)psmtReply.close();
		if(rsReply != null)rsReply.close();
	}

%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script><!-- 제이쿼리연결 -->

<script>
	var midx = 0; //전역변수 midx
	
	<%
		if(login != null){
	%>
		midx = <%=login.getMidx() %> 
	<%
		}
	%>
	
	
		
		//URL :reply.jsp로 연결
		//type: post는 데이터를 보낼 때 사용되는 메소드다. 
		//댓글 데이터를 보내기 위해 사용한다. 보통 form 태그와 함께 사용한다
		//DATA: //serialize는 JQuery 메소드 중 하나이다.form을 대상으로 사용. 
		//ajax에 data값 세팅시 serialize 사용하여 해당 form의 모든 데이터를 쉽게 받을 수 있다.
		//SUCCESS: ajax 결과 성공시 콜백함수
		
function saveR(){
	//ajax 등록(insert reply) - 댓글 [저장]버튼 눌렀을 때 실행되는 함수 
	$.ajax({  
		url:"reply.jsp", 
		type:"post", 
		data : $("form[name='reply']").serialize(), 
		success: function(data){ 
			var json = JSON.parse(data.trim()); 
			var html = "<tr>";
			html += "<td>"+json[0].membername+" <input type='hidden' name='ridx' value='"+json[0].ridx+"'></td>";
			html += "<td>"+json[0].rcontent+"</td>"; 
			html += "<td>"
			
			//+=연산자는 앞의 변수에 뒤의 값을 더한다. <tr>에 이어붙이기
			//membername으로 작성자를 얻어온다 
			//input type=hidden 사용이유 : 사용자에게 보이지 않는 필드로 데이터를 받아올 때 사용 (ridx)
			//json의 rcontent 내용을 가져와 td에 넣기
			//자신이 쓴 댓글에만 수정, 삭제 버튼이 보이게 구현
			//로그인된 자의 midx가 json midx와 같을시(댓글을 쓴 사람의 midx는 json midx)
			
			if(midx == json[0].midx){
				html += "<input type='button' value='수정' onclick='modify(this)'>";
				html += "<input type='button' value='삭제' onclick='deleteReply(this)'>";	
			}
				
			html += "</td>";
			html += "</tr>";
			
			//제이쿼리 : id가 replyTable인 것을 찾아서(#replyTable) tbody에 변수 html을 덧붙여 준다
			
			$("#replyTable>tbody").append(html); 
			
			//자바스크립트 - form태그 중 reply 찾아서 reset 시키기
			//댓글 쓰고 나서 저장 누르면 입력INPUT에 있던 것 초기화 시키기 위함
			
			document.reply.reset();
			
		}
		
	});
}
		
	//댓글수정 - ajax 사용 하지 않고 바로 jQuery를 사용하였음
	//prev() - 이전 요소를 선택하도록 반환 
	//text() - 어떤 태그 안에 들어있는 내용을 변경 가능하게 
	//html() - 내용을 바꿀 수 있는데 text가 아니라 태그로 인식 
	//$() - () 안에 찾으려는 값을 넣어 접근 
		
	function modify(obj){
		var rcontent = $(obj).parent().prev().text();
		var html = "<input type='text' name='rcontent' value='"+rcontent+"'><input type='hidden' name='origin' value='"+rcontent+"'>";
		$(obj).parent().prev().html(html);
		
		html = "<input type='button' value='저장' onclick='updateReply(this)'><input type='button' value='취소' onclick='cancleReply(this)'>";
		$(obj).parent().html(html);
}

	function cancleReply(obj){//댓글수정취소
		
		var originContent = $(obj).parent().prev().find("input[name='origin']").val();
		$(obj).parent().prev().html(originContent);
		
		var html = "";
		html += "<input type='button' value='수정' onclick='modify(this)'>";
		html += "<input type='button' value='삭제' onclick='deleteReply(this)'>";
		
		$(obj).parent().html(html);
	}
	
	
	
	//댓글수정업데이트 
	//val() - form의 값을 가져오거나 값을 설정 할 수 있다.
	//ajax url : 요청한 url
	//type:데이터 전송 방식 - 여기선 post로 데이터를 보내주기
	//data: 요청과 함께 전송할 것
	//success: 요청이 성공했을 때 호출할 콜백 함수
	
	function updateReply(obj){
		var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
		var rcontent = $(obj).parent().prev().find("input:text").val();
		
		$.ajax({
			url : "updateReply.jsp",
			type : "post",
			data : "ridx="+ridx+"&rcontent="+rcontent,
			success : function(data){
				$(obj).parent().prev().html(rcontent);
				
			// 만약 수정 저장 후 수정,삭제 버튼으로 복구할 때 자신이 쓴글인지 비교가 필요하면
			// 첫 번째 셀에 midx hidden을 추가하여 사용
			var html = "<input type='button' value='수정' onclick='modify(this)'>";
			html += "<input type='button' value='삭제' onclick='deleteReply(this)'>";
			$(obj).parent().html(html);
		}
	});
}

function deleteReply(obj){
	var YN = confirm("정말 삭제하시겠습니까?");
	
	if(YN){
		var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
		
		$.ajax({
			url:"deleteReply.jsp",
			type:"post",
			data:"ridx="+ridx,
			success: function(){
				$(obj).parent().parent().remove();
			}
			
		});
	}
}


</script>
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>게시글 상세조회</h2>
		<article>
			<table border="1" width="70%">
				<tr>
					<th>글제목</th>
					<td colspan="3"><%=subject_ %></td>
				</tr>
				<tr>
					<th>글번호</th>
					<td><%=bidx_ %></td>
					<th>작성자</th>
					<td><%=writer_ %></td>
				</tr>
				<tr height="300">
					<th>내용</th>
					<td colspan="3"><%=content_ %></td>
				</tr>
			</table>
			<button onclick="location.href='list.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>'">목록</button>
			
			<% if(login != null && login.getMidx() == midx_){ %>
			
			<button onclick="location.href='modify.jsp?bidx=<%=bidx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
			<button onclick="deleteFn()">삭제</button>
			<%
				} 
			%>
			<form name="frm" action="deleteOk.jsp" method="post">
				<input type="hidden" name="bidx" value="<%=bidx_%>">
			</form>

			<div class="replyArea">
				<div class="replyList">
				<table id="replyTable">
					<tbody>
				<%for(Reply r : rList){ %>
						<tr>
							<td><%=r.getMembername() %> : <input type="hidden" name="ridx" value="<%=r.getRidx()%>"></td>
							<td><%=r.getRcontent()%></td>
							<td>
								<%if(login != null && (login.getMidx() == r.getMidx())){ %>
								<input type="button" value="수정" onclick='modify(this)'>
								<input type="button" value="삭제" onclick="deleteReply(this)">
								<%} %>
							</td>							
						</tr>						
				<%} %>
					</tbody>
				</table>
				</div>
				<div class="replyInput">
					<form name="reply">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<% if(login != null){ %>
						<p>
							<label>
								내용 : <input type="text" name="rcontent" size="50">
							</label>
						</p>
						<p>
							<input type="button" value="저장" onclick="saveR()">
						</p>
						<%} %>
					</form>				
				</div>  
			</div>		
		
		
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn(){
			console.log(document.frm);
			document.frm.submit();
		}
	
	</script>
</body>
</html>








