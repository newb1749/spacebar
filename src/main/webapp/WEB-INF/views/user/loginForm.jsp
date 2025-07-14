<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
body {
  /* padding-top: 40px; */
  padding-bottom: 40px;
  /* background-color: #eee; */
}

.form-signin {
  max-width: 330px;
  padding: 15px;
  margin: 0 auto;
  text-align: center; 
}
.form-signin .form-signin-heading,
.form-signin .checkbox {
  margin-bottom: 10px;
}
.form-signin .checkbox {
  font-weight: 400;
}
.form-signin .form-control {
  position: relative;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="text"] {
  margin-bottom: 5px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
.links a {
    margin-right: 20px;
    color: #6c757d; /* 회색 */
    /* 방문했을 때 색상 변경 방지 (선택 사항) */
    &:visited {
        color: #6c757d;
    } 
    /* 마우스 오버 시 색상 변경 (선택 사항) */
    &:hover {
        color: #5a6268;
    } 
}
</style>

<script type="text/javascript">
$(document).ready(function(){
	$("#userId").focus();
	
	$("#userId").on("keypress", function(e){
		if(e.which == 13)
		{
			fn_loginCheck();
		}
	});
	
	$("#userPwd").on("keypress", function(e){
		if(e.which == 13)
		{
			fn_loginCheck();
		}
	});
	
	$("#btnLogin").on("click",function(){
		fn_loginCheck();
	});
	
	$("#btnReg").on("click",function(){
		location.href = "/user/regForm";
	});
});

function fn_loginCheck()
{
	if($.trim($("#userId").val()).length <= 0)
	{
		alert("아이디를 입력하세요.");
		$("#userId").val("");
		$("#userId").focus();
		return;
	}
	
	if($.trim($("#userPwd").val()).length <= 0)
	{
		alert("비밀번호를 입력하세요.");
		$("#userPwd").val("");
		$("#userPwd").focus();
		return;
	}
	
	$.ajax({
		type:"POST",
		url:"/user/loginProc",
		data:
		{
			userId:$("#userId").val(),
			userPwd:$("#userPwd").val()
		},
		dataType:"JSON",
		beforeSend:function(xhr)
		{
			xhr.setRequestHeader("AJAX","true");
		},
		success:function(res)
		{
			if(res.code == 0)
			{
				alert("로그인되었습니다.");
				location.href = "/index";
			}
			else if(res.code == -1)
			{
				alert("비밀번호가 올바르지 않습니다.");
				$("#userPwd").focus();
			}
			else if(res.code == -99)
			{
				alert("정지된 사용자입니다. 관리자에게 문의하세요");
				$("#userId").focus();
			}
			else if(res.code == 400)
			{
				alert("파라미터 값이 올바르지 않습니다.");
				$("#userId").focus();
			}
			else if(res.code == 404)
			{
				alert("아이디와 일치하는 정보가 없습니다. ");
				$("#userId").focus();
			}
			else 
			{
				alert("오류가 발생하였습니다.");
				$("#userId").focus();
			}
		},
		error:function(error)
		{
			icia.common.error(error);
		}
	});
}

</script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp"%>


<div class="container"><br/><br/><br/><br/><br/>

	<form class="form-signin">
	    <h2 class="form-signin-heading m-b3">로그인</h2>
		<label for="userId" class="sr-only">아이디</label>
		<input type="text" id="userId" name="userId" class="form-control" maxlength="20" placeholder="아이디">
		<label for="userPwd" class="sr-only">비밀번호</label>
		<input type="password" id="userPwd" name="userPwd" class="form-control" maxlength="20" placeholder="비밀번호">
		  
		<button type="button" id="btnLogin" class="btn btn-lg btn-primary btn-block">로그인</button>
    	<button type="button" id="btnReg" class="btn btn-lg btn-primary btn-block">회원가입</button>
		<div class="links mt-3">
            <a href="/user/findIdForm">아이디 찾기</a>
            <a href="/user/findPwdForm">비밀번호 찾기</a>
        </div>      
	</form>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>