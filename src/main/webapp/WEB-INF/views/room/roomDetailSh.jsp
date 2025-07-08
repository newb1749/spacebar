<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  
<style>
.hero.page-inner.overlay {
  /* 좌우 마진 20px씩 */
  width: calc(100% - 40px) !important;
  margin: 0 auto !important;

  /* 이미지가 잘려서 보이지 않도록 */
  background-size: cover !important;
  background-position: center !important;
  background-repeat: no-repeat !important;

  /* 높이는 필요에 따라 조정 */
  min-height: 300px !important;
}


  /* 1) 부모를 기준으로 절대 위치 */
.property-slider-wrap {
  position: relative !important;
}

/* 2) 컨트롤 박스를 슬라이더 전체 높이에 걸쳐서 flex 컨테이너로 */
.property-slider-wrap .tns-outer > .tns-controls {
  position: absolute !important;
  top: 0 !important;
  bottom: 0 !important;
  left: 0 !important;
  right: 0 !important;
  display: flex !important;
  align-items: center !important;       /* 수직 중앙 */
  justify-content: space-between !important; /* 좌우 끝으로 */
  pointer-events: none !important;      /* 배경 클릭 방해 안 함 */
  z-index: 100 !important;
}

/* 3) 버튼만 클릭 가능하도록 */
.property-slider-wrap .tns-outer > .tns-controls button {
  pointer-events: auto !important;
  background: none !important;
  border: none !important;
  padding: 0 !important;
  transform: translateY(-50px) !important;
}

/* 4) 이미지 크기 */
.property-slider-wrap .tns-outer > .tns-controls button img {
  display: block !important;
  width: 32px !important;
  height: 32px !important;
}

  </style>
<script>
$(document).ready(function(){
	$("#btnRoomList").on("click",function(){
		document.roomForm.action = "/room/roomList";
		document.roomForm.submit();
	});
});



</script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="site-mobile-menu"><div class="site-mobile-menu-body"></div></div>
<div class="loader"></div>
<div id="overlayer"></div>


<c:choose>
  <c:when test="${mainImages.imgType eq 'main'}">
    <c:set var="bgImage"
           value="${pageContext.request.contextPath}/resources/upload/room/main/${mainImages.roomImgName}" />
  </c:when>
  <c:otherwise>
    <c:set var="bgImage"
           value="${pageContext.request.contextPath}/resources/images/file.png" />
  </c:otherwise>
</c:choose>

<!-- 한 번만 열고, bgImage 변수 사용 -->
<div class="hero page-inner overlay"
     style="background-image: url('${bgImage}');">
  <div class="container text-center mt-5">
    <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
  </div>
</div>

<div class="section">
  <div class="container">
    <div class="row justify-content-between align-items-start">
    <!-- 왼쪽 정렬 -->
      <div class="col-lg-7">
        <div class="property-slider-wrap">
		  <!-- Tiny Slider 구조 -->
		  <div class="my-slider">
		    <c:forEach var="roomImg" items="${detailImages}">
		      <div class="slide-item">
		        <img src="${pageContext.request.contextPath}/resources/upload/room/detail/${roomImg.roomImgName}"
		             class="img-fluid" alt="${roomImg.imgType}" />
		      </div>
		    </c:forEach>
		  </div>
		</div>
		<h2 class="text-primary mb-3">${room.roomTitle}</h2>
          <p class="meta mb-1"><i class="icon-map-marker"></i> ${room.roomAddr} (${room.region})</p>
          <p class="text-black-50">${room.roomDesc}</p>
          
          <!-- 룸타입 리스트 -->
          <h2>룸타입</h2>
          <div class="container mt-4">
  <div class="row g-4">
    <c:forEach var="rt" items="${roomTypes}">
      <div class="col-12">
        <div class="card h-100 border rounded" style="min-height: 220px;">
          <div class="row g-0">
            <!-- 이미지 영역: 전체의 30% 너비 -->
            <div class="col-md-4">
              <img
                src="${pageContext.request.contextPath}/resources/upload/roomtype/main/${rt.roomTypeSeq}.jpg"
                class="img-fluid h-100 w-100 rounded-start"
                style="object-fit: cover;"
                alt="${rt.roomTypeTitle}"
              />
            </div>
            <!-- 텍스트 영역: 전체의 70% 너비 -->
            <div class="col-md-8">
              <div class="card-body p-3">
                <!-- 더 큰 제목 -->
                <h5 class="card-title fs-4 mb-2">${rt.roomTypeTitle}</h5>
                
                <!-- 요금 -->
                <p class="mb-1"><strong>주중:</strong> ${rt.weekdayAmt}원</p>
                <p class="mb-2"><strong>주말:</strong> ${rt.weekendAmt}원</p>
                
                <!-- 설명 (있을 때만) -->
                <c:if test="${not empty rt.roomTypeDesc}">
                  <p class="text-muted mb-0">${rt.roomTypeDesc}</p>
                </c:if>
                
                 <!-- 버튼 -->
            <c:choose>
              <c:when test="${rt.reservationCheck > 0}">
                <button type="button"
                        class="btn btn-secondary mt-3"
                        disabled>
                  만실
                </button>
              </c:when>
              <c:otherwise>
                <button type="button"
                        class="btn btn-primary mt-3"
                        onclick="location.href='/reservation/step1JY?roomTypeSeq=${rt.roomTypeSeq}'">
                  예약하기
                </button>
              </c:otherwise>
            </c:choose>
            
              </div>
            </div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

          

          <%-- 지도 모듈 포함 --%>
          <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
            <jsp:param name="address" value="${room.roomAddr}" />
            <jsp:param name="roomName" value="${room.roomTitle}" />
          </jsp:include>
      </div>

		<!-- 오른쪽 정렬 -->
      <div class="col-lg-4">
        <div class="property-info">
          

          <%-- 달력 모듈 포함 --%>
          <jsp:include page="/WEB-INF/views/component/calendar.jsp">
            <jsp:param name="calId" value="roomDetailCalendar" />
            <jsp:param name="fetchUrl" value="" />
            <jsp:param name="startDate" value="${startDate}" />
	    	<jsp:param name="endDate" value="${endDate}" />
          </jsp:include>

          <%-- 객실 타입 선택 --%>
          <label for="roomTypeSelect" class="mt-3">객실 타입 선택:</label>
          <select id="roomTypeSelect" class="form-select" style="width:100%;">
            <c:forEach var="rt" items="${roomTypes}">
              <option value="${rt.roomTypeSeq}">
                ${rt.roomTypeTitle} - 주중: ${rt.weekdayAmt}원 / 주말: ${rt.weekendAmt}원
              </option>
            </c:forEach>
          </select>

          <%-- 인원 수 선택 --%>
          <label for="numGuests" class="mt-3">인원 수 선택:</label>
          <select id="numGuests" class="form-select" style="width:100px;">
            <c:forEach begin="1" end="10" var="i">
              <option value="${i}">${i}명</option>
            </c:forEach>
          </select>
          
          <ul class="list-unstyled mt-4">
            <li><strong>등록일:</strong> ${room.regDt}</li>
            <li><strong>이용 시간:</strong> ${room.minTimes} ~ ${room.maxTimes}시간</li>
            <li><strong>자동 예약 확정:</strong>
              <c:choose>
                <c:when test="${room.autoConfirmYn == 'Y'}">예</c:when>
                <c:otherwise>아니오</c:otherwise>
              </c:choose>
            </li>
            <li><strong>취소 정책:</strong> ${room.cancelPolicy}</li>
            <li><strong>평점:</strong> ${room.averageRating} / 리뷰 수: ${room.reviewCount}</li>
          </ul>

          <%-- 예약하기 버튼 --%>
          <button id="reserveBtn" class="btn btn-primary mt-3">예약하기</button>
		
		<%-- roomCatSeq 값에 따라 추가 버튼 노출 --%>
			<div class="mt-2 d-flex">
			  <c:choose>
			    <c:when test="${room.roomCatSeq >= 1 && room.roomCatSeq <= 7}">
			      <button id="btnSpaceList" type="button" class="btn btn-secondary btn-sm px-3">
			        공간 리스트로 돌아가기
			      </button>
			    </c:when>
			    <c:when test="${room.roomCatSeq >= 8 && room.roomCatSeq <= 14}">
			      <button id="btnRoomList" type="button" class="btn btn-secondary btn-sm px-3">
			        룸 리스트로 돌아가기
			      </button>
			    </c:when>
			  </c:choose>
			</div>

        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/tiny-slider.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/navbar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/counter.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/custom.js"></script>

<script>
  document.addEventListener('DOMContentLoaded', function () {

    
 // 2️⃣ hidden input을 form 내부로 강제 이동
    const startInput = document.getElementById(calendarId + '_start');
    const endInput   = document.getElementById(calendarId + '_end');
    const form       = document.getElementById("roomForm");  // 여기에 id="roomForm" 폼을 잡아서

    if (form) {
      if (startInput && !form.contains(startInput)) {
        form.appendChild(startInput);
      }
      if (endInput   && !form.contains(endInput)) {
        form.appendChild(endInput);
      }
    } else {
      console.warn("roomForm을 찾을 수 없음");
    }


    // 예약하기 버튼 클릭 이벤트
    document.getElementById("reserveBtn").addEventListener("click", function () {
      if (!window.selectedDates || window.selectedDates.length !== 2) {
        alert("예약할 날짜를 선택해주세요.");
        return;
      }
      const startDate = window.selectedDates[0].toISOString().split("T")[0];
      const endDate = window.selectedDates[1].toISOString().split("T")[0];
      const roomTypeSelect = document.getElementById("roomTypeSelect");
      const selectedRoomTypeSeq = roomTypeSelect.value;
      const numGuests = document.getElementById("numGuests").value;

      location.href = "/reservation/step1JY?roomTypeSeq=" + encodeURIComponent(selectedRoomTypeSeq)
                    + "&checkIn=" + encodeURIComponent(startDate)
                    + "&checkOut=" + encodeURIComponent(endDate)
                    + "&numGuests=" + encodeURIComponent(numGuests);
    });
  });
  
  document.addEventListener('DOMContentLoaded', function() {
	  var slider = tns({
	    container: '.my-slider',
	    items: 1,
	    slideBy: 'page',
	    autoplay: true,
	    autoplayButtonOutput: false,
	    nav: false,
	    controls: true,
	    gutter: 10,
	    controlsText: [
	      // 왼쪽 버튼: <img> 태그로 교체
	      '<img src="${pageContext.request.contextPath}/resources/images/prev.png" alt="이전">',
	      // 오른쪽 버튼: <img> 태그로 교체
	      '<img src="${pageContext.request.contextPath}/resources/images/next.png" alt="다음">'
	    ]
	  });
	});
  
  document.addEventListener('DOMContentLoaded', function(){
	  const calInput = document.getElementById("roomDetailCalendar");
	  const form     = document.getElementById("roomForm");
	  if (!calInput || !calInput._flatpickr || !form) return;

	  // 1) 새로고침 후 이전 스크롤 위치 복원
	  const savedPos = sessionStorage.getItem("roomDetailScrollPos");
	  if (savedPos) {
	    window.scrollTo({ top: parseInt(savedPos, 10), behavior: "instant" });
	    sessionStorage.removeItem("roomDetailScrollPos");
	  }

	  // 2) 날짜 변경 시 — selectedDates 길이가 2일 때만 submit
	  calInput._flatpickr.config.onChange.push(function(selectedDates){
	    if (selectedDates.length === 2) {
	      // 2-1) 현재 스크롤 위치 저장
	      sessionStorage.setItem("roomDetailScrollPos", window.scrollY);
	      // 2-2) 폼 제출 (page reload)
	      form.submit();
	    }
	  });
	});
	

	
</script>

<form name="roomForm" id="roomForm" method="post">
  <input type="hidden" name="roomSeq" value="${roomSeq}" />
  <input type="hidden" name="searchValue" value="${searchValue}" />
  <input type="hidden" name="curPage"  value="${curPage}" />
  <input type="hidden" name="regionList" id="regionList" value="${regionList}" />
  <input type="hidden" name="startTime" id="startTime" value="${startTime}"/>
  <input type="hidden" name="endTime" id="endTime" value="${endTime}"/>
  <input type="hidden" name="category" id="category" value="${category}"/>
  <input type="hidden" name="personCount" id="personCount" value="${personCount}" />
  <input type="hidden" name="minPrice" id="minPrice" value="${minPrice}" />
  <input type="hidden" name="maxPrice" id="maxPrice" value="${maxPrice}" />
</form>

</body>
</html>
