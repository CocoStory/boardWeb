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
	<section>
		<form action="loginOk.jsp" method="post">
			<p>
				<label>
					아이디:
					<input type="text" name="memberid">
				</label>
			</p>
			<p>
				<label>
					비밀번호:
					<input type="password" name="memberpwd">
				</label>
			</p>
			<input type="submit" value="로그인">
		</form>
	</section>
	<%@include file="/footer.jsp" %><!-- /를 붙여야 이 위치에 없는 최상위 경로를 가져온다-->
</body>
</html>