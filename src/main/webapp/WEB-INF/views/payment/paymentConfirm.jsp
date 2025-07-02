<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" /> <!-- 추가 -->
  <title>결제 확인</title>
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <style>
    body {
      padding-top: 230px; /* 네비게이션이 fixed라면 조정 */
    }
    .container {
      max-width: 720px;
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/navigation.jsp" />
  
  <div class="container">
    <h2 class="mb-4">결제 상태 확인</h2>
    
    <c:choose>
      <c:when test="${status eq 'SUCCESS'}">
        <div class="alert alert-success">
          <strong>결제가 성공적으로 완료되었습니다!</strong><br/>
          마일리지 충전이 완료되었습니다. 감사합니다.
        </div>
      </c:when>
      <c:when test="${status eq 'CANCEL'}">
        <div class="alert alert-warning">
          <strong>결제가 취소되었습니다.</strong><br/>
          결제를 다시 시도해 주세요.
        </div>
      </c:when>
      <c:otherwise>
        <div class="alert alert-danger">
          <strong>결제 실패 또는 알 수 없는 상태입니다.</strong><br/>
          문제가 발생했습니다. 관리자에게 문의해 주세요.
        </div>
      </c:otherwise>
    </c:choose>

    <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-3">메인으로 돌아가기</a>
  </div>

  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
