<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>
	var clickBtn;
	var printTable = false;

	function callList(){
		printTable = true;
		$.ajax({
			url: "ajaxList.jsp",
			type: "get",
			success: function(data){
				var json = JSON.parse(data.trim());
				console.log(json);
				
			    var html = "";
	            html += "<table border='1'>";
	            html += "<thead>";
	            html += "<tr>";
	            html += "<th>글번호</th><th>제목</th><th>작성자</th><th> </th>";
	            html += "</tr>";
	            html += "</thead>";
	            html += "<tbody>";
	            for(var i=0; i<json.length; i++){
	               html += "<tr>";
	               html += "<td>"+json[i].bidx+"</td>";
	               html += "<td>"+json[i].subject+"</td>";
	               html += "<td>"+json[i].writer+"</td>";
	               html += "<td><button onclick='modify("+json[i].bidx+",this)'>수정</button>"
				      +"<button onclick='deleteFn("+json[i].bidx+",this)'>삭제</button></td>";
	               html += "</tr>";
	            }
	            html += "</tbody>";
	            html += "</table>";
	            
	            $("#list").html(html);
	         }
	      });
	   }
	
	//삭제는 되도록 post 타입으로 작성 
	
	function deleteFn(bidx,obj){
		$.ajax({
			url:"delete.jsp",
			type:"post",
			data:"bidx="+bidx,
			success:function(data){
				if(data>0){
					$(obj).parent().parent().remove();
				}
			}
			
		});
	}
	
	
	
	
		/*
			$.ajax({
				url : "경로",
				type : "메소드",
				data : "파라미터형식으로 된 데이터 " -> "bidx = 5", <- 요청 경로에서 데이터는 request.getParameter("bidx"); 로 찾을 수 있다. 
				success : function(data){
					
				}
				
			});
	
				json data 만들기 
		*/
		
		
		
		
		function modify(bidx,obj){
			clickBtn = obj; //전역변수에 버튼 그 자체를 담았음 
				
			$.ajax({
				url : "ajaxView.jsp",
				type: "get",
				data : "bidx=" +bidx , //요청경로로 date 넘기기. 파라미터 형식("bidx="+bidx) 으로 넘기기 or 객체로 넘기기 { bidx : bidx : 1 }
				success : function(data){
					var json = JSON.parse(data.trim()); 
					
					$("input[name='subject']").val(json[0].subject);
					$("input[name='writer']").val(json[0].writer);
					$("textarea").val(json[0].content);
					$("input[name='bidx']").val(json[0].bidx);
					
					
				
				}
			});
		}
				

				
				
				
				//저장버튼 클릭시 ajax를 이용하여 해당 데이터 수정
				//1.form태그 안에 입력한 입력양식 데이터
				//2.modify.jsp 로 ajax 통하여 1번의 데이터를 전송
				//3.modify.jsp 에서는 board 테이블 수정 작업
				//4.success는 일단은 비워두세요.
				//serialize();메소드->파라미터로 만들어주는 메소드 bidx=?&~
				
		function save(){
			
			var subject = $("input[name='subject']").val();
			var writer = $("input[name='writer']").val();
			var bidx = $("input[name='bidx']").val(); 
			
			var YN; // 확인시 true 취소시 false
			
			if(bidx == ""){ //bidx가 빈 값일 때는 아직 아무런 값이 없는 거니 등록을 함 
				YN = confirm("등록하시겠습니까?"); //confirm 은 확인,취소 두 가지가 나온다. 
					if(YN){
						$.ajax({
							url : "ajaxInsert.jsp" ,
							type : "post" ,
							data : $("form").serialize(),
							success : function(data){
								//화면에 게시글 목록이 출력되고 있는 경우에만 응답 데이터 한 건 테이블 맨 윗 행으로 추가
								//jQuery prepend() 사용 
								
								if(printTable){
									var json = JSON.parse(data.trim());
									var html = "<tr>";
									html += "<td>"+json[0].bidx+"</td>"
									html += "<td>"+json[0].subject+"</td>"
									html += "<td>"+json[0].writer+"</td>"
							     	html += "<td><button onclick='modify("+json[0].bidx+",this)'>수정</button>"
								      +"<button onclick='deleteFn("+json[0].bidx+",this)'>삭제</button></td>";
					                html += "</tr>";	
					                $("tbody").prepend(html);
					          
									
								}
								
								
								
							}
						});
						
					}
			}else{ //bidx에 값이 있는 경우 - 칸이 채워져 있다  
				YN = confirm("수정하시겠습니까?");
					if(YN){
						$.ajax({
							url : "modify.jsp",
							type: "post",
							data : $("form").serialize(), //모든 데이터가 필요할 때, serialize()는 form 이 있어야 사용 가능 
							success: function(data){
								if(data.trim()>0){
									alert("수정이 완료 되었습니다");
								}else{
									alert("수정 실패 했습니다")
								}
								
								$(clickBtn).parent().prev().text(writer);
								$(clickBtn).parent().prev().prev().text(subject);
								
								document.frm.reset();//JAVAscript로 해주는 초기화 
								$("input[name='bidx']").val("");
							}
						});
					}
				}
			}
			
			
		function resetFn(){
			document.frm.reset();//JAVAscript로 해주는 초기화 
			$("input[name='bidx']").val("");
		}
				
				
				
</script>
</head>
<body>
	<button onclick="callList()">목록 출력</button>
		<h2> ajax 를 이용한 게시판 구현 </h2>
		<div id="list">
		
		</div>
		<div id="write">
			<form name = "frm">
			<input type="hidden" name="bidx">
				<p>
					<label>
						제목 : <input type="text" name="subject" size="50" >
					</label>
				</p>
				<p>
					<label>
						작성자 : <input type="text" name="writer" >
					</label>
				</p>
				<p>
					<label>
						내용 : <textarea name ="content" ></textarea>
					</label>
				</p>
				<input type = "button" value = "저장" onclick="save()">
				<input type= "button" value = "초기화" onclick="resetFn()">
			</form>
		</div>
</body>
</html>