<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8">
  <title>내 예약 내역</title>

  <%-- <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>--%>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
 <%--  <script src="${pageContext.request.contextPath}/resources/js/tiny-slider.js" defer></script>
  <script src="${pageContext.request.contextPath}/resources/js/custom.js" defer></script>
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js" defer></script>
 --%>
  <style>
    body {
      padding-top: 80px;
      background-color: #f8f9fa;
    }
    h2 {
      margin-top: 50px;
      text-align: left !important;
    }
    /* .container {
      max-width: 960px;
      margin: 0 auto;
    } */
    table {
      margin-top: 20px;
      font-size: 1.1rem;
    }
    .table thead tr {
      background-color: #343a40;
    }
    .table thead tr th {
      color: #fff;
      text-align: center;
    }
    .table td {
      text-align: center;
      vertical-align: middle;
    }
    .table td.amount {
      text-align: right;
      padding-right: 12px;
    }
    .btn, .btn-sm {
      font-size: 1.1rem;
      padding: 0.5rem 1.2rem;
      margin-top: 6px;
    }
    form {
      display: inline-block;
    }
  </style>
    <script>
    // 로그인 여부 체크
    $(document).ready(function() {
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("sessionUserId") : "" %>';
      if (!sessionUserId) {
        alert("로그인이 필요합니다.");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
      }
    });
  </script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container">
  <h2>내 예약 내역</h2>

  <c:if test="${empty reservations}">
    <div class="alert alert-info text-center">예약 내역이 없습니다.</div>
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
            <td>
			  <fmt:formatDate value="${r.rsvCheckInDateObj}" pattern="yyyy-MM-dd"/>
			  <c:if test="${not empty r.rsvCheckInTime}">
			    &nbsp;${r.rsvCheckInTime}
			  </c:if>
			</td>
			<td>
			  <fmt:formatDate value="${r.rsvCheckOutDateObj}" pattern="yyyy-MM-dd"/>
			  <c:if test="${not empty r.rsvCheckOutTime}">
			    &nbsp;${r.rsvCheckOutTime}
			  </c:if>
			</td>
            <td>
              <c:choose>
                <c:when test="${r.rsvStat eq 'CONFIRMED'}">예약완료</c:when>
                <c:when test="${r.rsvStat eq '취소'}">예약취소</c:when>
                <c:when test="${r.rsvStat eq 'PENDING'}">결제대기</c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:choose>
                <c:when test="${r.rsvPaymentStat eq 'PAID'}">결제완료</c:when>
                <c:when test="${r.rsvPaymentStat eq 'UNPAID'}">미결제</c:when>
                <c:when test="${r.rsvPaymentStat eq '취소'}">환불완료</c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td class="amount">
              <fmt:formatNumber value="${r.finalAmt}" groupingUsed="true"/> 원
              <c:if test="${r.rsvStat eq 'CONFIRMED'}">
                <form action="${pageContext.request.contextPath}/reservation/cancel" method="post" onsubmit="return confirm('정말 취소하시겠습니까?')">
                  <input type="hidden" name="rsvSeq" value="${r.rsvSeq}" />
                  <button type="submit" class="btn btn-sm btn-danger">환불</button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>