<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>내 위시리스트</title>
<style>
  body {
    padding-top: 100px;
    background-color: #f9f9f9;
    font-family: 'Noto Sans KR', sans-serif;
  }
  .container {
    max-width: 1100px;
    margin: 0 auto;
  }
  h2 {
    font-weight: 700;
    margin-bottom: 30px;
    color: #333;
  }
  #wishlistBody {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 24px;
  }
  .wishlist-item {
    background-color: #fff;
    border-radius: 14px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    overflow: hidden;
    transition: transform 0.2s ease;
    cursor: pointer;
  }
  .wishlist-item:hover {
    transform: translateY(-6px);
  }
  .wishlist-thumb {
    width: 100%;
    height: 180px;
    object-fit: cover;
    display: block;
  }
  .wishlist-details {
    padding: 14px 18px;
  }
  .wishlist-title {
    font-size: 1.15rem;
    font-weight: 600;
    color: #222;
    margin-bottom: 6px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .wishlist-location {
    font-size: 0.9rem;
    color: #777;
    margin-bottom: 8px;
  }
  .wishlist-price {
    font-weight: 700;
    color: #4a90e2;
    font-size: 1.05rem;
  }
  /* 찜 취소 버튼 */
  .btn-remove-wish {
    margin-top: 10px;
    display: inline-block;
    padding: 6px 12px;
    font-size: 0.85rem;
    color: #fff;
    background-color: #e74c3c;
    border-radius: 8px;
    text-align: center;
    user-select: none;
    transition: background-color 0.3s ease;
  }
  .btn-remove-wish:hover {
    background-color: #c0392b;
  }
</style>

<script>
  // 찜 취소 예시 (AJAX)
  function removeWish(roomSeq, element) {
    if(!confirm("찜 목록에서 삭제하시겠습니까?")) return;
    
    $.ajax({
      type: "POST",
      url: "/wishlist/remove",
      data: { roomSeq: roomSeq },
      success: function(response) {
        if(response.code === 0) {
          alert("찜 목록에서 삭제되었습니다.");
          // 삭제된 아이템 DOM 제거
          $(element).closest('.wishlist-item').remove();
        } else {
          alert("삭제 실패: " + response.message);
        }
      },
      error: function() {
        alert("서버 오류가 발생했습니다.");
      }
    });
  }
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container">
  <h2>내가 찜한 숙소 목록</h2>

  <c:if test="${empty list}">
    <p>찜한 숙소가 없습니다.</p>
  </c:if>

  <div id="wishlistBody">
    <c:forEach var="room" items="${list}">
      <div class="wishlist-item">
        <div class="wishlist-details">
          <div class="wishlist-title" title="${room.roomTitle}">${room.roomTitle}</div>
          <div class="wishlist-location">${room.region}</div>
          
          <div class="btn-remove-wish" onclick="removeWish(${room.roomSeq}, this)">찜 취소</div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>
