<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>내 예약 내역</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <style>
    body {
      padding-top: 100px;
    }
    .container {
      max-width: 800px;
    }
    .table th {
      background-color: #343a40;
      color: #fff;
      text-align: center;
    }
    .table td {
      text-align: center;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navigation.jsp" />

<div class="container mt-5">
  <h3 class="mb-4">내 예약 내역</h3>
  
  <c:if test="${empty reservations}">
    <div class="alert alert-info">예약 내역이 없습니다.</div>
  </c:if>

  <c:if test="${not empty reservations}">
    <table class="table table-bordered">
      <thead>
        <tr>
          <th>예약번호</th>
          <th>객실유형</th>
          <th>체크인</th>
          <th>체크아웃</th>
          <th>상태</th>
          <th>결제상태</th>
          <th>총금액</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${reservations}">
          <tr>
            <td>${r.rsvSeq}</td>
            <td>${r.roomTypeSeq}</td>
            <td><fmt:formatDate value="${r.rsvCheckInDt}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${r.rsvCheckOutDt}" pattern="yyyy-MM-dd"/></td>
            <td>${r.rsvStat}</td>
            <td>${r.rsvPaymentStat}</td>
            <td><fmt:formatNumber value="${r.finalAmt}" type="currency"/></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
