<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>결제 결과</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 50px; }
    .message {
      padding: 20px;
      border-radius: 5px;
      font-size: 1.5em;
      max-width: 600px;
      margin: 0 auto;
      text-align: center;
    }
    .success { background-color: #d4edda; color: #155724; }
    .fail { background-color: #f8d7da; color: #721c24; }
    pre {
      background: #f1f1f1;
      padding: 10px;
      overflow-x: auto;
      max-height: 300px;
      white-space: pre-wrap;
      word-wrap: break-word;
      text-align: left;
    }
  </style>
</head>
<body>
  <div class="message ${result == 'success' ? 'success' : 'fail'}">
    <c:choose>
      <c:when test="${result == 'success'}">
        <h2>결제가 완료되었습니다!</h2>
        <p>마일리지가 정상적으로 충전되었습니다.</p>
        <pre>${info}</pre> <!-- 필요 시 상세정보 출력 -->
      </c:when>
      <c:otherwise>
        <h2>결제에 실패하였습니다.</h2>
        <p>${message}</p>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>
