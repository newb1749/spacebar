<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
    .result-box {
        background-color: #f8f9fa;
        border-radius: 10px;
        padding: 30px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .result-id {
        font-size: 24px;
        font-weight: bold;
        color: #0d6efd;
        margin: 20px 0;
    }
    .links a {
        margin-right: 20px;
    }
</style>
</head>
<body class="bg-gradient-primary">
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container"><br/><br/><br/><br/>
    <div class="result-box">
        <h2>아이디 찾기 결과</h2>

        <c:choose>
            <c:when test="${empty userId}">
                <p class="text-danger">
                    <c:out value="${msg}" default="일치하는 회원 정보를 찾을 수 없습니다."></c:out>
                </p>
            </c:when>
            <c:otherwise>
                <p class="result-id">
                    회원님의 아이디는 <c:out value="${userId}"/> 입니다.
                </p>
            </c:otherwise>
        </c:choose>

        <a href="/user/loginForm" class="btn btn-success mt-3">로그인 하러 가기</a>

        <div class="links mt-3">
            <a href="/user/findPwdForm">비밀번호 찾기</a>
            <a href="/user/regForm">회원가입</a>
        </div>
    </div>
</div><br/>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>