<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<style>
.board-list{width :500px; margin: 0 auto;}
.board-list tfoot{text-align:center;}
.signUp_agree {text-align:center;}
.signUp_agree_textarea {text-align: center;}
.signUp_agree_textarea textarea {resize:none;}
</style>
</head>
<body>
<form id="frm">
	<table class="board_list">
		<caption>
			회원가입
		</caption>
		<thead>
			<tr>
				<td colspan="3" class="signUp_agree">약관동의</td>
			</tr>
			<tr>
				<td colspan="3" class="signUp_agree_textarea"><textarea cols="100" rows="20" readonly="readonly">회원가입</textarea></td>
			</tr>
			<tr>
				<td colspan="3" class="signUp_agree_chcekbox"><input type="checkbox" id ="agree_checkbox">약관에 동의</td>
				
			</tr>
		</thead>
		<tbody>
			<tr>
				<th scope="row">이름</th>
				<td><input type="text" id="user_name" name="NAME" class="wdp_90"></td>
				<td></td>
			</tr>
			<tr>
				<th scope="row">전화번호</th>
				<td><input type="text" id="user_tel" name="TEL" class="wdp_90"></td>
				<td></td>
			</tr>
			<tr>
				<th scope="row">아이디</th>
				<td><input type="text" id="user_id" name="ID" class="wdp_90"></td>
				
				<td><a href="#" id="user_id_checkBtn" class="btn">중복확인</a></td>
			</tr>
			<tr>
				<th scope="row">비밀번호</th>
				<td><input type="password" id="user_pwd" name="PASSWORD" class="wdp_90"></td>
				<td></td>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="3">
					<a href="#" class="btn" id="signUpBtn">회원가입</a>
					<a href="#" class="btn" id="homeBtn">취소</a>
				</td>
			</tr> 
		</tfoot>
	</table>
	
</form>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<script>
	$(document).ready(function(){
		$("#user_id_checkBtn").unbind("click").click(function(e){
			e.preventDefault();
			fn_userIDCheck();
		});
		$("#signUpBtn").unbind("click").click(function(e){
			e.preventDefault();
			fn_signUp();
		});
	});
	
	function fn_signUp() {
		if($("#agree_checkbox").prop("checked")== false){
			alert("약관에 동의해주시기 바랍니다");
		}
		else if($("#user_name").val().length<1){
			alert("이름을 입력해주세요");
		}
		else if($("#user_tel").val().length<1){
			alert("전화번호를 입력해주세요");
		}
		else if($("#user_id").val().length<1){
			alert("ID를 입력해주세요");
		}
		else if($("#user_pwd").val().length<1){
			alert("비밀번호를 입력해주세요");
		}
		else if(!$("#user_id").attr("disabled")){
			alert("아이디 중복확인을 해주세요");
		}
		else{
			
			if(window.confirm("회원가입을 하시겠습니까?")){
				var comSubmit = new ComSubmit("frm");
				comSubmit.setUrl("<c:url value='/user/signUp.do'/>");
				comSubmit.addParam("ID",$("#user_id").val());
				comSubmit.submit();
			}
			
		}
	}
	
	
	function fn_userIDCheck(){
		var userId=$("#user_id").val();
		var userData={"ID": userId};
		
		if(userId.length<1){
			alert("ID를 입력해주세요");
		}
		else{
			
			$.ajax({
				type:"POST",
				url:"<c:url value='/user/checkUserID.do'/>",
				data: userData,
				dataType: "json",
				error:  function(error){
					alert("서버가 응답하지 않습니다.\n 다시시도 해주세용");
				},
				success : function(result){
					if(result==0){
						$("#user_id").attr("disabled",true);
						alert("사용이 가능한 아이디입니다.")
					}
					else if(result==1){
						alert("이미 존재하는 아이디 입니다.")
					}
					else{
						alert("error가 발생하였습니다.")
					}
					
				}
			
			});
		}
		
	}
	
	
</script>
</body>
</html>