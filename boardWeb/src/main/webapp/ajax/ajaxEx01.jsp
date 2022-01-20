<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callString(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					document.getElementById("result").innerHTML = request.responseText;
				}
			}
		}
		
		//open 메소드의 세번쩨 인자는 비동기 여부로 true 요청에 대한 응답을 기다리지 않고 처리하다 응답이 오면처리 
		//false 요청에 대한 응답을 기다린 후 응답이 오면 처리
		
		request.open("GET","data/html/data1.html",false);
		request.send();
		
		
	}
	
	function callHTML(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){ //onreadystatechange 변할 때 마다 호출됨 
			if(request.readyState == 4){ //예외 처리 검사 , readyState == 4 내가 보낸 데이터가 왔을 때 
				if(request.status == 200){ //오류 없이 응답데이터가 왔다.  status == 200 처리가 완료 되었다는 뜻  
					
					document.getElementById("result").innerHTML = request.responseText;
					
				}
			}
		}
		request.open("GET","data/html/data2.html",false)
		request.send();
		
	}

</script>

</head>

<body>
	<h2>ajax example</h2>
	<button onclick = "callString()">String call</button>
	<button onclick = "callHTML()">html call</button>
</body>
<div id="result">

</div>
</html>