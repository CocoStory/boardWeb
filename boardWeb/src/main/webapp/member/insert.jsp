<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
</head>
<body>
	<%@include file="/header.jsp" %>
	<section><!-- member -->
		<h2>회원등록</h2>
		<article>
			<form action="insertOk.jsp" method="post">
				<table border="1" width="70%">
				<tr>
					<th>회원 아이디</th>
					<td><input type="text" name="memberid"></td>
					<th>회원 비밀번호</th>
					<td><input type="password" name="memberpwd"></td>
				</tr>
				<tr>
					<th>회원 이름</th>
					<td><input type="text" name="membername"></td>
					<th>주소</th>
					<td><input type="text" name="addr"></td>
				</tr>
				<tr>
					<th>회원 연락처</th>
					<td><input type="text" name="phone"></td>
					<th>회원 이메일</th>
					<td><input type="text" name="email"></td>
				</tr>
				<tr>
					<th>성별</th>
				<!--<td><input type="text" name="gender"></td>  -->	
					<td><input type="radio" name="gender" value='M'>남
					    <input type="radio" name="gender" value='F'>여</td>
				</tr>
			</table>
				<input type="button" value="취소" onclick="location.href='list.jsp'">
				<input type="submit" value="등록">
			</form>
		</article>
	</section>
	<%@include file="/footer.jsp" %>
</body>
</html>