<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <title>장바구니</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body {
      padding-top: 100px;
      font-family: 'Noto Sans KR', sans-serif;
      background: #f5f5f5;
      font-size: 0.9rem;
      line-height: 1.2;
    }
    .cart-container {
      max-width: 800px;
      margin: 0 auto;
      padding: 12px 0;
    }
    .cart-container h2 {
      margin-bottom: 12px;
      font-size: 1.4rem;
      font-weight: bold;
      color: #333;
    }
    .cart-card {
      display: flex;
      align-items: stretch;
      background-color: #fff;
      border-radius: 8px;
      overflow: hidden;
      margin-bottom: 10px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .cart-img {
      flex-shrink: 0;
      width: 200px;
    }
    .cart-img img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .cart-info {
      flex: 1;
      position: relative;
      padding: 8px 12px;
    }
    .cart-info .room-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: #222;
      margin-bottom: 2px;
    }
    .cart-info .cart-location {
      font-size: 0.75rem;
      color: #777;
      margin-bottom: 2px;
    }
    .cart-info .divider {
      border-bottom: 1px solid #eee;
      margin: 4px 0;
    }
    .cart-info .type-title {
      font-size: 0.95rem;
      font-weight: 600;
      color: #444;
      margin-bottom: 4px;
    }
    .cart-info .cart-meta {
      font-size: 0.8rem;
      color: #555;
      margin-bottom: 4px;
    }
    .cart-info .cart-price {
      font-size: 0.95rem;
      font-weight: bold;
      color: #007B5E;
      margin-bottom: 2px;
    }
    .cart-info .cancel-rule {
      font-size: 0.7rem;
      color: #888;
    }
    .cart-actions {
      position: absolute;
      top: 8px;
      right: 8px;
    }
    .btn-delete {
      font-size: 0.75rem;
      color: #999;
      text-decoration: none;
    }
    .btn-delete:hover {
      color: #e74c3c;
    }
    .cart-summary {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: #fff;
      padding: 8px 12px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .cart-summary span {
      font-size: 0.9rem;
      color: #333;
    }
    .cart-summary .total-amt {
      font-weight: bold;
      color: #007B5E;
    }
    .btn-buy {
      background-color: #007B5E;
      padding: 6px 12px;
      border: none;
      border-radius: 6px;
      color: white;
      font-weight: bold;
      cursor: pointer;
      font-size: 0.9rem;
    }
    .btn-buy:disabled {
      background-color: #ccc;
      cursor: not-allowed;
    }
  </style>
  <script>
    function deleteCart(cartSeq) {
      if (!confirm("정말 삭제하시겠습니까?")) return;
      $.post("/cart/delete", { cartSeq: cartSeq }, function(res) {
        if (res.code === 0) location.reload();
        else alert("삭제 실패: " + res.message);
      });
    }
  </script>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

  <div class="cart-container">
    <h2>장바구니</h2>

    <c:set var="totalCnt" value="${fn:length(cartList)}"/>
    <c:set var="totalAmt" value="0"/>

    <c:forEach var="cart" items="${cartList}">
      <c:set var="totalAmt" value="${totalAmt + cart.cartTotalAmt}"/>

      <div class="cart-card">
        <div class="cart-img">
          <img
            src="/resources/upload/roomtype/main/${cart.roomTypeImgName}"
            alt="숙소 이미지"
          />
        </div>
        <div class="cart-info">
          <div class="room-title">${cart.roomTitle}</div>
          <div class="cart-location">
            ${cart.roomCatName} &nbsp;/&nbsp; ${cart.roomAddr}
          </div>
          <div class="divider"></div>
          <div class="type-title">${cart.roomTypeTitle}</div>

      
		  <fmt:parseDate var="inDate"
               value="${cart.cartCheckInDt}"
               pattern="yyyyMMdd" />

		<fmt:parseDate var="outDate"
		               value="${cart.cartCheckOutDt}"
		               pattern="yyyyMMdd" />
		
		<fmt:parseDate var="inTime"
		               value="${cart.cartCheckInTime}"
		               pattern="HHmm" />
		
		<fmt:parseDate var="outTime"
		               value="${cart.cartCheckOutTime}"
		               pattern="HHmm" />

         
		  <div class="cart-meta">
		    <fmt:formatDate value="${inDate}"  pattern="yyyy년 M월 d일" />
		    &nbsp;~&nbsp;
		    <fmt:formatDate value="${outDate}" pattern="yyyy년 M월 d일" />
		    &nbsp;|&nbsp;
		    <fmt:formatDate value="${inTime}"  pattern="a h시" />
		    &nbsp;~&nbsp;
		    <fmt:formatDate value="${outTime}" pattern="a h시" />
		    &nbsp;|&nbsp; ${cart.cartGuestsNum}명
		  </div>

          <div class="cart-price">
            <fmt:formatNumber value="${cart.cartTotalAmt}" type="number"/>원
          </div>
          <div class="cancel-rule">(${cart.cancelPolicy})</div>
          <div class="cart-actions">
            <a
              href="javascript:;"
              class="btn-delete"
              onclick="deleteCart(${cart.cartSeq})"
            >&times; 삭제</a>
          </div>
        </div>
      </div>
    </c:forEach>

    <div class="cart-summary">
      <span>총 <strong>${totalCnt}</strong>건</span>
      <span>
        결제 예상 금액 <strong class="total-amt">
          <fmt:formatNumber value="${totalAmt}" type="number"/>원
        </strong>
      </span>
      <button
        class="btn-buy"
        <c:if test="${totalCnt == 0}">disabled</c:if>
      >구매하기</button>
    </div>
  </div>

  <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
