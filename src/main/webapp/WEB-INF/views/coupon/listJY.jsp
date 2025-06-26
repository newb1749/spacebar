<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전체 쿠폰 목록</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

  <style>
    .clickable {
      cursor: pointer;
      color: #FE7743;
      font-weight: bold;
    }
    .clickable:hover {
      text-decoration: underline;
    }
    .alert-fixed {
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 9999;
      display: none;
    }
  </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/include/navigation.jsp" />

<div class="container" style="padding-top: 300px;">
  <h2 class="text-center mb-4">전체 쿠폰 목록</h2>

  <div class="alert alert-success alert-fixed" id="alertBox"></div>

  <table class="table table-bordered text-center">
    <thead class="table-dark">
      <tr>
        <th>쿠폰번호</th>
        <th>쿠폰명</th>
        <th>설명</th>
        <th>할인율/금액</th>
        <th>발급 시작일</th>
        <th>발급 종료일</th>
        <th>상태</th>
        <th>등록일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="coupon" items="${couponList}">
        <tr>
          <td>${coupon.cpnSeq}</td>
          <td>
            <c:choose>
              <c:when test="${coupon.cpnStat eq 'Y'}">
                <span class="clickable" onclick="issueCoupon(${coupon.cpnSeq})">${coupon.cpnName}</span>
              </c:when>
              <c:otherwise>
                ${coupon.cpnName}
              </c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${coupon.cpnStat eq 'Y'}">
                <span class="clickable" onclick="issueCoupon(${coupon.cpnSeq})">${coupon.cpnDesc}</span>
              </c:when>
              <c:otherwise>
                ${coupon.cpnDesc}
              </c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${coupon.discountRate > 0}">
                ${coupon.discountRate}%
              </c:when>
              <c:when test="${coupon.discountAmt > 0}">
                ${coupon.discountAmt}원
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>
          <td>${coupon.issueStartDt}</td>
          <td>${coupon.issueEndDt}</td>
          <td>
            <c:choose>
              <c:when test="${coupon.cpnStat eq 'Y'}">
                <span class="badge bg-success">활성</span>
              </c:when>
              <c:otherwise>
                <span class="badge bg-secondary">비활성</span>
              </c:otherwise>
            </c:choose>
          </td>
          <td>${coupon.regDt}</td>
        </tr>
      </c:forEach>
      <c:if test="${empty couponList}">
        <tr><td colspan="8">등록된 쿠폰이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>
</div>

<script>
  function issueCoupon(cpnSeq) {
    $.ajax({
      url: '${pageContext.request.contextPath}/coupon/issue',
      type: 'POST',
      data: { cpnSeq: cpnSeq },
      success: function(res) {
        showAlert(res.message, res.success);
      },
      error: function() {
        showAlert('요청 중 오류가 발생했습니다.', false);
      }
    });
  }

  function showAlert(message, success) {
    const alertBox = $('#alertBox');
    alertBox
      .removeClass('alert-success alert-danger')
      .addClass(success ? 'alert-success' : 'alert-danger')
      .text(message)
      .fadeIn();

    setTimeout(() => {
      alertBox.fadeOut();
    }, 2000);
  }
</script>

</body>
</html>
