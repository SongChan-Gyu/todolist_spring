<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/include/include-header3.jspf" %>
<title>Insert title here</title>
</head>
<body>
	<div class="pagetemplate">
		<div class="top">
		</div>
		
		<form id="frm">
			<div class="id">
				<input type="text" name="ID" id="user_id" placeholder="id"/>
			</div>
			<div class="pwd">
				<input type="password" name="PWD" id="user_pwd" placeholder="password"/>
			</div>
			
			<div class="submit">
				<a href="#" class="button" id="submit">LOGIN</a>
			</div>
		</form>
		
		<div class="member">
			<div class="text">회원이 아니세요?</div>
			<div class="create">계정을 만드세요</div>
		</div>
	</div>
</body>
</html>


<script type="text/javascript">
	$(document).ready(function(){
		$(".button").on("click",function(e){
			e.preventDefault();
			fn_submit();
		})
	})

	function fn_submit(){
		if($("#user_id").val().length<1){
			alert("ID를 입력해주세요");
		}
		else if($("#user_pwd").val().length<1){
			alert("비밀번호를 입력해주세요");
		}
		else{
			var ID= $("#user_id").val();
			var PWD=$("#user_pwd").val();
			var userData= {"ID" : ID, "PWD" : PWD};
			$.ajax({
				type:"POST",
				url:"<c:url value='/user/doLogIn.do'/>",
				data: userData,
				dataType: "json",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세요");
				},
				success : function(result){
					if(result==-1){
						alert("아이디가 없습니다.")
					}
					else if(result==0){
						alert("비밀번호가 틀렸습니다.")
					}
					else{
						alert("로그인이 되었습니다");
						window.location.href="/myapp/sample/todolist.do"
					}
					
				}
			
			});
		}
	}

</script>