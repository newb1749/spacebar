<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>내 위시리스트</title>
<style>

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.4); }
  100% { transform: scale(1); }
}

.wish-heart.clicked {
  animation: pulse 0.3s ease;
}
  body {
    padding-top: 120px;
    background-color: #f9f9f9;
    font-family: 'Noto Sans KR', sans-serif;
  }
  .container {
    max-width: 1200px;
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
  position: relative;
  background-color: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  overflow: hidden;
  transition: transform 0.2s ease;
}

.wishlist-item:hover {
  transform: translateY(-6px);
}


.wishlist-thumb {
  width: 100%;
  height: 240px;
  object-fit: cover;
  display: block;
}


.wishlist-details {
  padding: 16px;
  position: relative;
}
  
.wishlist-title {
  font-size: 1.15rem;
  font-weight: bold;
  color: #222;
  margin-bottom: 10px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: block;
  text-decoration: none;
}
.wishlist-info {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  position: relative;
}

.wishlist-location {
  font-size: 0.9rem;
  color: #777;
  margin-bottom: 6px;
}
  .wishlist-price {
    font-weight: 700;
    color: #4a90e2;
    font-size: 1.05rem;
  }
  /* 찜 취소 버튼 */
  .btn-remove-wish {
    display: inline-block;
    padding: 7px 14px;
    font-size: 0.85rem;
    color: #fff;
    background-color: #e74c3c;
    border-radius: 8px;
    text-align: center;
    transition: background-color 0.3s ease;
  }
  
.room-rating {
  font-size: 0.9rem;
  color: #888;
}
  
  .btn-remove-wish:hover {
    background-color: #c0392b;
  }
  
  .wishlist-title {
  text-decoration: none;
  color: #222;
  font-weight: bold;
  font-size: 1.15rem;
  margin-bottom: 6px;
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.wishlist-title:hover {
  text-decoration: underline;
  color: #007acc;
}

.wishlist-meta-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.wish-heart {
  position: absolute;
  bottom: 16px;
  right: 16px;
  font-size: 28px; /* 크게! */
  color: #e74c3c;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  margin: 0;
  line-height: 1;
  transition: transform 0.2s ease;
}


.wish-heart:hover {
  transform: scale(1.2);
  color: #c0392b;
}

.wished {
  color: #e74c3c;
}
</style>

<script>
  // 찜 취소 예시 (AJAX)
function removeWish(roomSeq, element) {
  Swal.fire({
    title: "찜 해제하시겠습니까?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#e74c3c",
    cancelButtonColor: "#aaa",
    confirmButtonText: "네, 삭제할게요",
    cancelButtonText: "아니요"
  }).then((result) => {
    if (result.isConfirmed) {
      $.ajax({
        type: "POST",
        url: "/wishlist/remove",
        data: { roomSeq: roomSeq },
        success: function(response) {
          if(response.code === 0) {
            Swal.fire("삭제 완료", "찜에서 제거됐습니다.", "success");
            $(element).closest(".wishlist-item").fadeOut(300, function() {
              $(this).remove();
            });
          }
        }
      });
    }
  });
}
  
function toggleWish(roomSeq, btn) {
	  const $btn    = $(btn);
	  const $icon   = $btn.find('i.fa-heart');
	  const wished  = $btn.data('wished');              // true면 지금은 찜된 상태
	  const url     = wished ? "/wishlist/remove" : "/wishlist/add";
	  
	  $.post(url, { roomSeq: roomSeq })
	    .done(function(res) {
	      if (res.code === 0) {
	        if (wished) {
	          // → 삭제(하얀 하트) & 알림
	          $icon
	            .removeClass("fas wished")
	            .addClass("far");
	          $btn.data('wished', false);
	          Swal.fire({
	            icon: "success",
	            title: "삭제됐습니다",
	            text: "찜 목록에서 제거되었습니다.",
	            timer: 1500,
	            showConfirmButton: false
	          });
	        } else {
	          // → 추가(빨간 하트) & 알림
	          $icon
	            .removeClass("far")
	            .addClass("fas wished");
	          $btn.data('wished', true);
	          Swal.fire({
	            icon: "success",
	            title: "추가되었습니다",
	            text: "찜 목록에 추가되었습니다.",
	            timer: 1500,
	            showConfirmButton: false
	          });
	        }
	      } else {
	        Swal.fire("오류", res.message, "error");
	      }
	    })
	    .fail(function() {
	      Swal.fire("네트워크 오류", "잠시 후 다시 시도해주세요.", "error");
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
		  <a href="/room/roomDetail?roomSeq=${room.roomSeq}">
		    <img src="/resources/upload/room/main/${room.roomImgName}" 
			     onerror="this.src='/resources/upload/room/main/default-room.png'" 
			     alt="${room.roomTitle}" 
			     class="wishlist-thumb">
		  </a>
		
		  <div class="wishlist-details">
		    <a href="/room/roomDetail?roomSeq=${room.roomSeq}" class="wishlist-title" title="${room.roomTitle}">
		      ${room.roomTitle}
		    </a>
		
		    <div class="wishlist-info">
		      <div>
		        <div class="wishlist-location">
				    ${room.region} / <strong><fmt:formatNumber value="${room.weekdayAmt}" pattern="#,###" />원~</strong>
				</div>
		        <div class="room-rating">⭐ ${room.averageRating} (${room.reviewCount}명)</div>
		      </div>
		      
		
		      <!-- ❤️ 우측하단 꽉 찬 빨간 하트 아이콘 (클릭 시 삭제) -->
				<button class="wish-heart" 
					     data-wished="true"                
					     onclick="toggleWish(${room.roomSeq}, this)" >
			      <i class="fas fa-heart wished"></i>
			    </button>
		    </div>
		  </div>
		</div>

	</c:forEach>
	
	</div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>
