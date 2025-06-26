<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>${room.roomTitle}-상세페이지</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/tiny-slider.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/aos.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="site-mobile-menu"><div class="site-mobile-menu-body"></div></div>
<div class="loader"></div>
<div id="overlayer"></div>

<c:choose>
  <c:when test="${mainImages.imgType eq 'main'}">
    <div class="hero page-inner overlay" style="background-image: url('/resources/upload/room/main/${mainImages.roomImgName}')">
  </c:when>
  <c:otherwise>
    <div class="hero page-inner overlay" style="background-image: url('/resources/images/file.png')">
  </c:otherwise>
</c:choose>
  <div class="container text-center mt-5">
    <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
  </div>
</div>

<div class="section">
  <div class="container">
    <div class="row justify-content-between align-items-start">
      <div class="col-lg-7">
        <div class="property-slider-wrap">
          <div class="property-slider tiny-slider">
            <c:forEach var="roomImg" items="${detailImages}" varStatus="status">
              <div class="item">
                <img src="/resources/upload/room/detail/${roomImg.roomImgName}" class="img-fluid" alt="${roomImg.imgType}" />
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

          <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
            <jsp:param name="address" value="${room.roomAddr}"/>
            <jsp:param name="roomName" value="${room.roomTitle}"/>
          </jsp:include>

          <!-- 달력 포함 -->
          <jsp:include page="/WEB-INF/views/component/calendar.jsp">
            <jsp:param name="calId" value="roomDetailCalendar" />
            <jsp:param name="fetchUrl" value="" />
          </jsp:include>

          <!-- 인원 선택 UI 추가 -->
          <label for="numGuests" class="mt-3">인원 수 선택:</label>
          <select id="numGuests" class="form-select" style="width:100px;">
            <c:forEach begin="1" end="10" var="i">
              <option value="${i}">${i}명</option>
            </c:forEach>
          </select>

          <!-- 예약하기 버튼 -->
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
    // 캘린더 초기화 - 날짜 선택 시 window.selectedDates에 저장
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
      // 날짜를 yyyy-MM-dd 형식으로 변환
      const startDate = window.selectedDates[0].toISOString().split("T")[0];
      const endDate = window.selectedDates[1].toISOString().split("T")[0];
      const roomTypeSeq = '<c:out value="${room.roomTypeSeq}" />';
      const numGuests = document.getElementById("numGuests").value;

      // 예약 1단계 페이지로 이동
      location.href = "/reservation/step1JY?roomTypeSeq=" + encodeURIComponent(roomTypeSeq)
                    + "&checkIn=" + encodeURIComponent(startDate)
                    + "&checkOut=" + encodeURIComponent(endDate)
                    + "&numGuests=" + encodeURIComponent(numGuests);
    });
  });
</script>
</body>
</html>
