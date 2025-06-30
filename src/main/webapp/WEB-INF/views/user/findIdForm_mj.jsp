<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>아이디 찾기</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {
    var msg = "${msg}";
    if (msg != "") {
        alert(msg);
    }
});

function fnSubmit() {

    if ($("#userName").val() <= 0) {
        alert("이름을 입력해주세요.");
        $("#userName").focus();
        return false;
    }
    
    if ($("#email").val() <= 0) {
        alert("이메일을 입력해주세요.");
        $("#email").focus();
        return false;
    }

	if(!fn_emailCheck($("#email").val()))
	{
		alert("이메일 형식이 올바르지 않습니다.");
		$("#email").focus();
		return;
	}

    if (confirm("아이디를 찾으시겠습니까?")) {
        $("#findIdForm").submit();
    }
}

//이메일 정규식 체크
function fn_emailCheck(value)
{
	var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	
	return emailCheck.test(value);
}
</script>
<link href="/resources/css/sb-admin-2.min.css" rel="stylesheet">
</head>
<body class="bg-gradient-primary">
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-xl-10 col-lg-12 col-md-9">
            <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-0">
                    <div class="row">
                        <div class="col-lg-6 d-none d-lg-block bg-password-image"></div>
                        <div class="col-lg-6">
                            <div class="p-5">
                                <div class="text-center">
                                    <h1 class="h4 text-gray-900 mb-2">아이디 찾기</h1>
                                    <p class="mb-4">가입 시 입력한 이름과 이메일을 입력해주세요.</p>
                                </div>
                                <form id="findIdForm" name="findIdForm"  method="post">
                                    <div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="userName" name="userName" placeholder="이름 입력">
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="email" name="email" placeholder="이메일 입력 ex) test@sist.co.kr">
                                    </div>
                                    <a href="javascript:void(0)" onclick="fnSubmit(); return false;" class="btn btn-primary btn-user btn-block">아이디 찾기</a>
                                </form>
                                <hr>
                                <div class="text-center">
                                    <a class="small" href="/user/findPwdForm">비밀번호 찾기</a>
                                </div>
                                <div class="text-center">
                                    <a class="small" href="/user/regForm">회원가입</a>
                                </div>
                                <div class="text-center">
                                    <a class="small" href="/index">로그인</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
