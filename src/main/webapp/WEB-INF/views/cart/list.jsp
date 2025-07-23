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
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    body {
      padding-top: 100px;
      font-family: 'Noto Sans KR', sans-serif;
      background: #f5f5f5;
      font-size: 0.9rem;
      line-height: 1.2;
    }

    /* 카드 레이아웃 */
    .cart-container {
      max-width: 800px;
      margin: 0 auto;
      padding: 12px 0;
    }
    .cart-container h2 {
      margin-bottom: 12px;
    }
    .cart-card {
     position: relative;      /* 이 한 줄만 추가해 주시면 됩니다! */
      display: flex;
  align-items: stretch;    /* 자식 요소 높이를 카드 높이에 맞춤 */
  height: 130px;           /* 원하시는 고정 높이로 조정하세요 */
  padding-left: 32px;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    /* 체크박스 */
    .cart-checkbox {
      position: absolute;
      top: 50%;
      left: 8px;
      transform: translateY(-50%);
      margin: 0;
      padding: 0;
      z-index: 1; /* 혹시 가려지면 z-index도 높여주세요 */
    }

    /* 나머지 카드 내부 스타일 그대로 */
    .cart-img {
       width: 200px;
  flex-shrink: 0;
  height: 100%;  
    }
    .cart-img img {
      width: 100%;
  height: 100%;
  object-fit: cover;
    }
    .cart-info {
      flex: 1;                       
  padding: 8px 12px;
  display: flex;
  flex-direction: column;       /* 위→아래 쌓기 */
  justify-content: space-between; /* 상단 제목과 하단 버튼/가격 간격 유지 */
  position: relative;
    }
    .room-title { 
    
 font-size: 1.1rem;
  font-weight: 700;
  color: #222;
  white-space: nowrap;          /* 한 줄 고정 */
  overflow: hidden;
  text-overflow: ellipsis;      /* 넘치면 … */
    
    }
    .cart-location { font-size:0.75rem; color:#777; }
    .divider { border-bottom:1px solid #eee; margin:4px 0; }
    .type-title { font-size:0.95rem; font-weight:600; color:#444; }
    .cart-meta { font-size:0.8rem; color:#555; margin-bottom:4px; }
    .cart-price { font-size: 0.95rem;
  font-weight: bold;
  color: #007B5E; }
    .cancel-rule { font-size:0.7rem; color:#888; }
    .cart-actions {   position: absolute;
  bottom: 8px;  /* 카드를 꽉 채워도 항상 하단에 */
  right: 8px; }
    .btn-delete { font-size:0.75rem; color:#999; text-decoration:none; }
    .btn-delete:hover { color:#e74c3c; }

    /* 요약(하단) */
    .cart-summary {
      display: flex; justify-content: space-between; align-items:center;
      background:#fff; padding:8px 12px; border-radius:8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .cart-summary .total-amt { font-weight:bold; color:#007B5E; }
    .btn-buy {
      background:#007B5E; color:#fff; padding:6px 12px;
      border:none; border-radius:6px; cursor:pointer; font-size:0.9rem;
    }
    .btn-buy:disabled { background:#ccc; cursor:not-allowed; }
  </style>
  <script>
    // 삭제
    function deleteCart(cartSeq) {
      if (!confirm("정말 삭제하시겠습니까?")) return;
      $.post("${pageContext.request.contextPath}/cart/delete", { cartSeq }, function(res) {
        if (res.code === 0) location.reload();
        else alert("삭제 실패: " + res.message);
      });
    }

    // 체크박스 선택 요약
    $(function(){
      function updateSummary(){
        let cnt=0, amt=0;
        $('.itemCheckbox:checked').each(function(){
          cnt++;
          amt += parseInt($(this).data('amt'),10) || 0;
        });
        $('#summaryCnt').text(cnt);
        $('#summaryAmt').text(amt.toLocaleString());
        $('#btnCheckout').prop('disabled', cnt===0);
      }
      $('#selectAll').on('change', function(){
        $('.itemCheckbox').prop('checked', this.checked);
        updateSummary();
      });
      $(document).on('change', '.itemCheckbox', function(){
        $('#selectAll').prop(
          'checked',
          $('.itemCheckbox').length === $('.itemCheckbox:checked').length
        );
        updateSummary();
      });
      updateSummary();
    });
    
  </script>
  
  <c:if test="${not empty msg}">
  <script>
    Swal.fire({
      icon: 'success',
      title: '예약 완료!',
      text: '${msg}',
      confirmButtonText: '확인'
    });
  </script>
</c:if>

</head>
<body>
  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

  <div class="cart-container">
    <h2>장바구니</h2>
    <form action="${pageContext.request.contextPath}/cart/confirm" method="post">
      <label>
        <input type="checkbox" id="selectAll"/> 전체선택
      </label>

      <c:forEach var="cart" items="${cartList}">
        <div class="cart-card">
          <input type="checkbox"
                 class="cart-checkbox itemCheckbox"
                 name="cartSeqs"
                 value="${cart.cartSeq}"
                 data-amt="${cart.cartTotalAmt}"/>

          <div class="cart-img">
          <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${cart.roomSeq}">
            <img src="/resources/upload/roomtype/main/${cart.roomTypeImgName}"
                 alt="숙소 이미지"/>
           </a>
          </div>
          <div class="cart-info">
            <div class="room-title">
            	 <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${cart.roomSeq}">
            	 	${cart.roomTitle}
            	</a>	 
           	</div>
            <div class="cart-location">
              ${cart.roomCatName} &nbsp;/&nbsp; ${cart.roomAddr}
            </div>
            <div class="divider"></div>
            <div class="type-title">${cart.roomTypeTitle}</div>

            <fmt:parseDate var="inDate"
                           value="${cart.cartCheckInDt}"
                           pattern="yyyyMMdd"/>
            <fmt:parseDate var="outDate"
                           value="${cart.cartCheckOutDt}"
                           pattern="yyyyMMdd"/>
            <fmt:parseDate var="inTime"
                           value="${cart.cartCheckInTime}"
                           pattern="HHmm"/>
            <fmt:parseDate var="outTime"
                           value="${cart.cartCheckOutTime}"
                           pattern="HHmm"/>

            <div class="cart-meta">
              <fmt:formatDate value="${inDate}" pattern="yyyy년 M월 d일"/> ~
              <fmt:formatDate value="${outDate}" pattern="yyyy년 M월 d일"/>
              &nbsp;|&nbsp;
              <fmt:formatDate value="${inTime}" pattern="a h시"/> ~
              <fmt:formatDate value="${outTime}" pattern="a h시"/>
              &nbsp;|&nbsp; ${cart.cartGuestsNum}명
            </div>

            <div class="cart-price">
              <fmt:formatNumber value="${cart.cartTotalAmt}" type="number"/>원
            </div>
            <!-- <div class="cancel-rule">(${cart.cancelPolicy})</div>   -->
            <div class="cart-actions">
              <a href="javascript:;" class="btn-delete"
                 onclick="deleteCart(${cart.cartSeq})">&times; 삭제</a>
            </div>
          </div>
        </div>
      </c:forEach>

      <div class="cart-summary">
        <span>총 <strong id="summaryCnt">0</strong>건</span>
        <span>결제 예상 금액
          <strong class="total-amt" id="summaryAmt">0</strong>원
        </span>
        <button type="submit" id="btnCheckout" class="btn-buy" disabled>
          예약하기
        </button>
      </div>
    </form>
  </div>

  <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
