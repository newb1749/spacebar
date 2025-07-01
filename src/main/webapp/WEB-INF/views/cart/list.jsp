<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
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
    }
    .cart-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}
.cart-meta {
    font-size: 0.9rem;
    color: #555;
    margin-top: 8px;
}
    .cart-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px;
      margin-bottom: 10px;
      border: 1px solid #ddd;
      border-radius: 8px;
      background-color: #fff;
    }
    .cart-info {
    flex: 1;
    padding: 15px;
    position: relative;
}
    .cart-date {
      font-size: 0.9rem;
      color: #555;
    }
    .cart-total {
      font-size: 1.1rem;
      font-weight: bold;
      color: #4a90e2;
    }
    .cart-actions {
      text-align: right;
    }
    .btn-delete {
      background-color: #e74c3c;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
    }
    .btn-delete:hover {
      background-color: #c0392b;
    }
    .cart-card {
    display: flex;
    border: 1px solid #e0e0e0;
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 20px;
    background-color: #fff;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}
.cart-img img {
    width: 140px;
    height: 140px;
    object-fit: cover;
    border-right: 1px solid #eee;
}
.cart-title {
    font-size: 1.1rem;
    font-weight: bold;
    display: flex;
    align-items: center;
    gap: 8px;
}
.cart-price {
    margin-top: 12px;
    font-size: 1rem;
    color: #007B5E;
}
.cancel-rule {
    display: block;
    font-size: 0.8rem;
    color: #888;
}

.cart-actions {
    position: absolute;
    top: 15px;
    right: 15px;
}

.btn-delete {
    color: #999;
    font-size: 0.9rem;
    text-decoration: none;
}

.btn-delete:hover {
    color: red;
}

.cart-summary {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px;
    border-top: 2px solid #eee;
    font-size: 1.1rem;
}

.btn-buy {
    background-color: #ccc;
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    color: white;
    font-weight: bold;
    cursor: not-allowed;
}
  </style>
  <script>
    function deleteCart(cartSeq) {
      if (confirm("정말로 삭제하시겠습니까?")) {
        $.post("/cart/delete", { cartSeq: cartSeq }, function(response) {
          if (response.code === 0) {
            alert("삭제되었습니다.");
            location.reload();
          } else {
            alert("삭제 실패: " + response.message);
          }
        });
      }
    }
  </script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="cart-container">
    <h2>장바구니</h2>

    <c:forEach var="cart" items="${cartList}">
        <div class="cart-card">
            <div class="cart-img">
                <img src="/resources/upload/roomtype/main/${cart.roomTypeImgName}" alt="숙소 이미지">
            </div>

            <div class="cart-info">
                <div class="cart-title">
                    
                    <strong>${cart.roomTypeTitle}</strong>
                </div>

                <div class="cart-meta">
                    ${cart.cartCheckIn} ~ ${cart.cartCheckOut} / ${cart.cartGuestsNum}명
                </div>

                <div class="cart-price">
                    <span><strong><fmt:formatNumber value="${cart.cartTotalAmt}" type="number"/>원</strong></span>
                    <span class="cancel-rule">무료취소 (체크인 하루 전까지)</span>
                </div>

                <div class="cart-actions">
                    <a href="javascript:void(0);" class="btn-delete" onclick="deleteCart(${cart.cartSeq})">삭제</a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div class="cart-summary">
        <span>총 <strong>0건</strong></span>
        <span>결제 예상 금액 <strong>0원</strong></span>
        <button class="btn-buy" disabled>구매하기</button>
    </div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
