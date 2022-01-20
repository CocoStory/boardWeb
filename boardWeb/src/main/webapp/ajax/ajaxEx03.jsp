<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>
	function callJSON(){
		$.ajax({ //%.ajax({options}); 메소드 호출 .  options는 url, type, data, error 등등 종류가 다양하다 
			url : "data/json/data1.json",
			type : "get",
			success : function(data){
				alert("통신 성공!");
				console.log(data);
				
				for(var i = 0; i<data.lengh; i++){
					console.log(data[i].name);
					$("#result").html($("result").html()+date[i.name+"<br>"]);
				}
			},
			error : function(xhr,status,error){
				alert("통신 오류!");
			}
			
		});
	}

	function callXML(){
		$.ajax({
			url : "data/xml/data1.xml",
			type : "get",
			success: function(data){
				console.log(data);
				var jXML = $(data);
				
				jXML.find("book").each(function(){
					var name = $(this).find("name").text();
					console.log(name);
				});
			},
			errorLfunction(){
				alert("통신오류");
			}
			
		});
	}

</script>
</head>
<body>
	<h2>jQuery를 이용한 ajax</h2>
	<button onclick="callJSON()">json</button>
	<div id="result"></div>
</body>
</html>