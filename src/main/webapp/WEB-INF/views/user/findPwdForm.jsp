<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>비밀번호 찾기</title>

<script type="text/javascript">
function fn_submit()
{
	//공백체크
	var emptCheck = /\s/g;
	//아이디, 비밀번호 8~12자 영문 대소문자, 숫자
	var idPwdCheck = /^[a-zA-Z0-9]{8,12}$/;
	//전화번호 ex)010-0000-0000
	var phoneCheck = /^\d{3}-\d{4}-\d{4}$/;
	
    if ($("#userId").val() <= 0) {
        alert("아이디 입력해주세요.");
        $("#userId").val("");
        $("#userId").focus();
        return false;
    }
    
	if(emptCheck.test($("#userId").val()))
	{
		alert("아이디는 공백을 포함할 수 없습니다.");
		$("#userId").focus();
		return;
	}
	
	if(!idPwdCheck.test($("#userId").val()))
	{
		alert("아이디는 8~12자 영문 대소문자, 숫자로만 입력이 가능합니다.");
		$("#userId").focus();
		return;
	}
    
    if ($("#userName").val() <= 0) {
        alert("이름을 입력해주세요.");
        $("#userName").focus();
        return false;
    }
    
    if ($("#phone").val() <= 0) {
        alert("전화번호를 입력해주세요.");
        $("#phone").val("");
        $("#phone").focus();
        return false;
    }
    
	if(!phoneCheck.test($("#phone").val()))
	{
		alert("전화번호 형식이 올바르지 않습니다.");
		$("#phone").focus();
		return;
	}

    if (confirm("비밀번호를 찾으시겠습니까?")) 
    {
		$("#findPwdForm").attr("action","searchResultPwd").submit();
    }
}

</script>

</head>
<body class="bg-gradient-primary">
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-xl-10 col-lg-12 col-md-9">
            <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-0">
                    <div class="row d-flex align-items-center justify-content-center" style="min-height: 400px;">
                        <div class="col-lg-6 d-none d-lg-block bg-password-image"></div>
                        <div class="col-lg-6">
                            <div class="p-5">
                                <div class="text-center">
                                    <h1 class="h4 text-gray-900 mb-2">비밀번호 찾기</h1>
                                    <p class="mb-4">가입 시 입력한 아이디와 이름, 전화번호를 입력해주세요.</p>
                                </div>
                                <form id="findPwdForm" name="findPwdForm"  method="post">
                                	<div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="userId" name="userId" placeholder="아이디 입력">
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="userName" name="userName" placeholder="이름 입력">
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="phone" name="phone" placeholder="전화번호 입력 ex)010-0000-0000">
                                    </div>
                                    <a href="javascript:void(0)" onclick="fn_submit(); return false;" class="btn btn-primary btn-user btn-block">비밀번호 찾기</a>
                                </form>
                                <hr>
                                <div class="text-center">
                                    <a class="small" href="/user/findIdForm">아이디 찾기</a>
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
