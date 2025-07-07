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
      </div>

      <div class="col-lg-4">
        <div class="property-info">
          <h2 class="text-primary mb-3">${room.roomTitle}</h2>
          <p class="meta mb-1"><i class="icon-map-marker"></i> ${room.roomAddr} (${room.region})</p>
          <p class="text-black-50">${room.roomDesc}</p>
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

          <%-- 지도 모듈 포함 --%>
          <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
            <jsp:param name="address" value="${room.roomAddr}" />
            <jsp:param name="roomName" value="${room.roomTitle}" />
          </jsp:include>

          <%-- 달력 모듈 포함 --%>
          <jsp:include page="/WEB-INF/views/component/calendar.jsp">
            <jsp:param name="calId" value="roomDetailCalendar" />
            <jsp:param name="fetchUrl" value="" />
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

          <%-- 예약하기 버튼 --%>
          <button id="reserveBtn" class="btn btn-primary mt-3">예약하기</button>
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
    // 캘린더 초기화
    initRoomCalendar("roomDetailCalendar", {
      fetchUrl: "",
      onChange: (dates) => {
        window.selectedDates = dates;
      }
    });

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
</script>
</body>
</html>
