<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<title>아이디 찾기</title>

<script type="text/javascript">
function fn_submit()
{
    if ($("#userName").val() <= 0) {
        alert("이름을 입력해주세요.");
        $("#userName").focus();
        return false;
    }
    
    if ($("#phone").val() <= 0) {
        alert("전화번호를 입력해주세요.");
        $("#phone").focus();
        return false;
    }

    if (confirm("아이디를 찾으시겠습니까?")) 
    {
		$("#findIdForm").attr("action","searchResultId_mj").submit();
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
                    
                        <div class="col-lg-6 d-none d-lg-block bg-password-image"></div>
                        
                            <div class="p-5">
                                <div class="text-center"><br/>
                                    <h1 class="h4 text-gray-900 mb-2">아이디 찾기</h1>
                                    <p class="mb-4">가입 시 입력한 이름과 전화번호를 입력해주세요.</p>
                                </div>
                                <form id="findIdForm" name="findIdForm"  method="post">
                                    <div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="userName" name="userName" placeholder="이름 입력" size=10>
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control form-control-user" id="phone" name="phone" placeholder="전화번호 입력 ex)010-0000-0000">
                                    </div>
                                    <a href="javascript:void(0)" onclick="fn_submit(); return false;" class="btn btn-primary btn-user btn-block">아이디 찾기</a>
                                </form>
                                <hr>
                                <div class="text-center">
                                    <a class="small" href="/user/findPwdForm_mj">비밀번호 찾기</a>
                                </div>
                                <div class="text-center">
                                    <a class="small" href="/user/regForm_mj">회원가입</a>
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
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>