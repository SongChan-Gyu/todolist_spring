<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
	
<!DOCTYPE>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/include/include-header2.jspf" %>
<title>Insert title here</title>
</head>
<body>
	<div class="arrow_box">
		<ul>
			
		</ul>
	</div>
	<div class="top">
		<div class="member">
		 <h1>${list[0].user_id} 님 안녕하세요</h1>
		</div>
		<div class="alarm">
			<div class="notice_counter">0</div>
    	</div>
    	
		<div class="logout">[logout]</div>
		
	</div>
	
	<div class='pagetemplate'>
		<h1>Todo-list</h1>
			<div id="btn" class="button">추가</div>
		<form>		
			<div id="myModal" class="modal">
		      <!-- Modal content -->
		      
		      <div class="modal-content">
		        <span class="close">&times;</span>
		        <div class="todo_title">                                                               
		        	<input type="text" name="" placeholder="제목을 입력하세요"/>
		        </div>
		        <div class="todo_content">
		        	<textarea name="content" cols="100" rows="8" placeholder="내용을 입력하세요"></textarea>
		        </div>
		        <div class="date_name">
		        	날짜를 입력하세요	
		        </div>
		        <div class="todo_date">
		        	<input type="datetime-local" class="date_timer" name="date"/>
		        </div>
		        <div class="modal_btn" id="add_open">
		   			추가     
		        </div>
		      </div>
	    	</div>	
    	</form>
    	<form>		
			<div id="editModal" class="modal">
		      <!-- Modal content -->
		      
		      <div class="modal-content">
		        <span class="close" id="modal_close">&times;</span>
		        <div class="todo_title" id="id_title">                                                               
		        	<input type="text" name="" placeholder="제목을 입력하세요"/>
		        </div>
		        <div class="todo_content">
		        	<textarea name="content" cols="100" rows="8" placeholder="내용을 입력하세요"></textarea>
		        </div>
		        <div class="date_name">
		        	날짜를 입력하세요	
		        </div>
		        <input type="hidden" class="hidden_modify" id="hidden_modify" value=""/>
		        <div class="todo_date">
		        	<input type="datetime-local" class="date_timer" name="date"/>
		        </div>
		        <div class="modal_btn" id="modify_btn">
		   			수정     
		        </div>
		      </div>
	    	</div>	
    	</form>
    	<div class="todohave" id="sortable">
    	<c:choose>
    		 <c:when test="${fn:length(list)>0}">
    		 	  <c:forEach items="${list }" var="con" >
    				<div class="todo_den">
    		 		<div class="todolist">
    		 			<input type="hidden" class="hidden_id" value="${con.id}"/>    
						<input class="tick" type="checkbox" ${con.chacked}/>
						<div class="todo">${con.title}</div>
						<div class="edit">[수정]</div>
						<div class="delete">[삭제]</div>
					</div>
						<div class="tododetail">
							<div class="detail_content">
								<pre><span class="pre_content">${con.content}</span>
								</pre>
							</div>
							<div class="time_when">${fn:substring(con.times,5,16)}</div>
						</div>			
					</div>
    		 	  </c:forEach>
    		</c:when>
    	</c:choose>
    	</div>  
		
	</div>
</body>
</html>

<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="https://code.jquery.com/jquery-1.9.1.min.js" ></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" ></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.5/sockjs.js"></script>

		
<script type="text/javascript">

	//socket  
    
	function send_message() {
        websocket = new WebSocket("ws://ec2-15-164-153-58.ap-northeast-2.compute.amazonaws.com:8090/myapp/socket");
        websocket.onopen = function(evt){
    		console.log("socket connected");    	
        };
        websocket.onmessage = function(evt) {
        	console.log(evt.data);
        	var num = Number($(".notice_counter").text());
        	num = num+1;
        	$(".notice_counter").text(num);
        	var string = evt.data;
        	$(".arrow_box ul").append("<li>"+string+"</li>");
        };

        websocket.onerror = function(evt) {
        	console.log("socket error");
        };

     }
    
    $(document).ready(function(){
    		send_message();
    });
    



	
	//sortable
	$(function() {
	    $("#sortable").sortable();
	    $("#sortable").disableSelection();
	});
	
	$( "#sortable" ).on( "sortupdate", function( event, ui ) {
		console.log("sortchange");
		$(".todolist").each(function(index,item){
			
			var idx = $(item).find(".hidden_id").val();
			var userData={
					"priority": index,
					"IDX" : idx 
			};
			
			console.log(index);
			console.log(idx);
			
			$.ajax({
				type:"POST",
				url:"<c:url value='/sample/changePriority.do'/>",
				data: userData,
				dataType: "json",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
				},
				success : function(result){	
					console.log("변경되었습니다");	
				}	
			});

		});
	} 
);
	

	//알림창 끄기,켜기
	$(".alarm").on("click",function(e){
		e.preventDefault();
		if($(".arrow_box").css("visibility")=="visible"){
			$(".arrow_box").css("visibility","hidden");
			$(".arrow_box ul").empty();
		}
		else{
			$(".notice_counter").text("0");
			$(".arrow_box").css("visibility","visible");
			
		}
			})

	//로그아웃관리
	$(".logout").on("click",function(e){
		e.preventDefault();
		if(confirm("로그아웃하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"<c:url value='/sample/dologout.do'/>",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
				},
				success : function(result){	
						if(result==1){
							alert("로그아웃되었습니다");
							window.location.href="/myapp/user/openlogin.do";
						}
						else{
							alert("로그인 되어있지않습니다.");
							window.location.href="/myapp/user/openlogin.do";
						}
				}	
			});
			
		}
	})
	
	//모달 창 관리
	var modal = document.getElementById('myModal');
	var btn = document.getElementById("btn");
	var span = document.getElementsByClassName("close")[0];
	
	var modal2 = document.getElementById('editModal');
	
	btn.onclick = function() {
	    modal.style.display = "block";
	}
	span.onclick = function() {
	    modal.style.display = "none";
	}
	window.onclick = function(event) {
	    if (event.target == modal) {
	        modal.style.display = "none";
	    }
	    else if(event.target == modal2) {
	        modal2.style.display = "none";
	    }
	}
	
	// 체크박스 유무
	$(".todolist .tick").each(function(index,item){
		$(item).on("change",function(e){
			var checked ="";
			if($(item).prop("checked")){
				checked="checked";
			}
			else{
				checked="unchecked";
			}
			console.log(checked);
			var idx= $(item).prev().val();
			var userData={
					"checked": checked,
					"IDX":idx
			};
			$.ajax({
				type:"POST",
				url:"<c:url value='/sample/doChecked.do'/>",
				data: userData,
				dataType: "json",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
				},
				success : function(result){	
							
				}	
			});
			
				
		})
	})
	
	
	// 수정 버튼 열기
	$(".edit").each(function(index,item){
		$(item).on("click",function(e){
			e.preventDefault();
			$("#editModal #id_title input").val('');
			$("#editModal .todo_content textarea").val('');
			$("#editModal").css("display","block");
				
			var date1 = $("#editModal .todo_date input").val();
			console.log(date1);
			
			var idx = $(item).prev().prev().prev().val();
			$("#hidden_modify").val(idx);
			var userData={
					"IDX" : idx
			}
			$.ajax({
				type:"POST",
				url:"<c:url value='/sample/openModify.do'/>",
				data: userData,
				dataType: "json",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
				},
				success : function(result){	
							console.log(result.date);
							var date2 = new Date(result.date);
							console.log(date2);
							date2.setHours(date2.getHours()+9);
							console.log(date2);
							var str = new Date(date2).toISOString().slice(0, 19);
							//var str2 = str.format('yyyy-MM-dda/pHH:mm:ss');
							
							
							$("#editModal .todo_title input").val(result.title);
							$("#editModal .todo_content textarea").val(result.content);
							$("#editModal .todo_date input").val(str);
					
				}	
			});		
			
		})
	})
	


	//수정 확인
	$("#modify_btn").on("click",function(){
		var title = $("#editModal #id_title input").val();
		var content = $("#editModal .todo_content textarea").val();
		var date = new Date($("#editModal .todo_date input").val()).getTime();
		var IDX = $("#hidden_modify").val();
		console.log(title);
		console.log(content);
		console.log(date);
		var userData ={
				"title": title,
				"content":content,
				"date":date,
				"IDX" : IDX
		};
		$.ajax({
			type:"POST",
			url:"<c:url value='/sample/doModify.do'/>",
			data: userData,
			dataType: "json",
			error:  function(error){
				alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
			},
			success : function(result){	
						if(result==0){
							alert("수정되었습니다.");
							window.location.href="/myapp/sample/todolist.do";
						}
			}	
		});
		
	});
	
	//수정 모달 닫기
	$("#modal_close").on("click",function(){	
		$("#editModal").css("display","none");
	})
	
	//삭제 
	$(".todolist .delete").each(function(index,item){
		$(item).on("click",function(e){
			e.preventDefault();
			if(confirm("삭제하시겠습니까?")){
				var idx = $(item).prev().prev().prev().prev().val();
				var userData={
						"IDX":idx
				};
			
				$.ajax({
					type:"POST",
					url:"<c:url value='/sample/delete.do'/>",
					data: userData,
					dataType: "json",
					error:  function(error){
						alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
					},
					success : function(result){	
								if(result==0){
									alert("삭제되었습니다.");
									window.location.href="/myapp/sample/todolist.do";
								}
					}	
				});
			}
		})
	})
	
	
	
	// 상세 리스트 열기
	$(".todolist .todo").each(function(index, item){
		$(item).on("click",function(e){
			e.preventDefault();
			if($(item).parent().next().css('display')=="none"){
				$(item).parent().next().css('display','flex');
			}
			else{
				$(item).parent().next().css('display','none');
			}
		})
	})
	
	
	//추가 
	$("#add_open").on("click",function(){
		addButton();
	})
	
	
	function addButton(){
		var title = $(".todo_title input").val().toString();
		var content = $(".todo_content textarea").val().toString();
		var date = new Date($(".date_timer").val()).getTime();
		console.log($(".date_timer").val());
		console.log(new Date($(".date_timer").val()));
		if(title.length<1){
			alert("제목을 입력해주세요");
		}
		else if(content.length<1){
			alert("내용을 입력해주세요");
		}
		else if(date.length<15)
			alert("날짜를 입력해주세요");
		else{
			var userData={
					"title": title,
					"content": content,
					"date" : date
			};
			$.ajax({
				type:"POST",
				url:"<c:url value='/sample/addList.do'/>",
				data: userData,
				dataType: "json",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
				},
				success : function(result){	
						if(result==0){
							alert("추가 되었습니다.");
							window.location.href="/myapp/sample/todolist.do";
						}
				}	
			});
		}
	}
	
	//알람 기능
	
	
	
</script>
