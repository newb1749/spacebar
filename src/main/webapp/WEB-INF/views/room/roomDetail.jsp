<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>${room.roomTitle} – 상세페이지</title>
  <!-- CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/tiny-slider.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/aos.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />

  <!-- jQuery 먼저 로드 -->
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <!-- 기타 JS -->
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/tiny-slider.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/counter.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/custom.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<c:set var="roomCatSeq" value="${room.roomCatSeq}" />

<c:choose>
  <c:when test="${mainImages.imgType=='main'}">
    <div class="hero page-inner overlay"
         style="background-image:url('/resources/upload/room/main/${mainImages.roomImgName}')">
  </c:when>
  <c:otherwise>
    <div class="hero page-inner overlay"
         style="background-image:url('/resources/images/file.png')">
  </c:otherwise>
</c:choose>
  <div class="container text-center mt-5">
    <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
  </div>
</div>

<div class="section">
  <div class="container">
    <div class="row justify-content-between align-items-start">
      <!-- 좌측 이미지 -->
      <div class="col-lg-7">
        <div class="property-slider-wrap">
          <div class="property-slider tiny-slider">
            <c:forEach var="img" items="${detailImages}">
              <div class="item">
                <img src="/resources/upload/room/detail/${img.roomImgName}"
                     class="img-fluid" alt="${img.imgType}" />
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
      <!-- 우측 정보 -->
      <div class="col-lg-4">
        <div class="property-info">
          <h2 class="text-primary mb-3">${room.roomTitle}</h2>
          <p class="meta mb-1">
            <i class="icon-map-marker"></i> ${room.roomAddr} (${room.region})
          </p>
          <p class="text-black-50">${room.roomDesc}</p>
          <ul class="list-unstyled mt-4">
            <li><strong>등록일:</strong> ${room.regDt}</li>
            <li><strong>이용 시간:</strong> ${room.minTimes} ~ ${room.maxTimes}시간</li>
            <li>
              <strong>자동 예약 확정:</strong>
              <c:choose>
                <c:when test="${room.autoConfirmYn=='Y'}">예</c:when>
                <c:otherwise>아니오</c:otherwise>
              </c:choose>
            </li>
            <li><strong>취소 정책:</strong> ${room.cancelPolicy}</li>
            <li><strong>평점:</strong> ${room.averageRating} / 리뷰 수: ${room.reviewCount}</li>
          </ul>

          <!-- 지도 & 캘린더 -->
          <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
            <jsp:param name="address"  value="${room.roomAddr}" />
            <jsp:param name="roomName" value="${room.roomTitle}" />
          </jsp:include>
          <jsp:include page="/WEB-INF/views/component/calendar.jsp">
            <jsp:param name="calId"    value="roomDetailCalendar" />
            <jsp:param name="fetchUrl" value="" />
          </jsp:include>

          <!-- 객실 타입, 인원수 -->
          <label for="roomTypeSelect" class="mt-3">객실 타입 선택:</label>
          <select id="roomTypeSelect" class="form-select" style="width:100%;">
            <c:forEach var="rt" items="${roomTypes}">
              <option value="${rt.roomTypeSeq}"
                      data-in-time="${rt.roomCheckInTime}"
                      data-out-time="${rt.roomCheckOutTime}">
                ${rt.roomTypeTitle} – 주중:${rt.weekdayAmt}원 / 주말:${rt.weekendAmt}원
              </option>
            </c:forEach>
          </select>

          <label for="numGuests" class="mt-3">인원 수 선택:</label>
          <select id="numGuests" class="form-select" style="width:100px;">
            <c:forEach begin="1" end="10" var="i">
              <option value="${i}">${i}명</option>
            </c:forEach>
          </select>

       
          <c:choose>
            <c:when test="${roomCatSeq >= 1 && roomCatSeq <= 7}">
              <div id="customTimePickers" style="margin-top:12px;">
                <label>시작 시간</label>
                <input type="time" id="customInTime" class="form-control mb-1"/>
                <label>종료 시간</label>
                <input type="time" id="customOutTime" class="form-control"/>
              </div>
              <div id="durationPicker" style="margin-top:12px;">
                <label for="numHours">이용 시간 선택</label>
                <select id="numHours" class="form-select">
                  <c:forEach begin="${room.minTimes}" end="${room.maxTimes}" var="h">
                    <option value="${h}">${h}시간</option>
                  </c:forEach>
                </select>
              </div>
            </c:when>
            
            <c:otherwise>
              <div id="defaultTimeDisplay" style="margin-top:12px;">
                체크인 시간 : ${rt.roomCheckInTime} /
                체크아웃 시간 : ${rt.roomCheckOutTime}
              </div>
            </c:otherwise>
          </c:choose>

          
          <button id="reserveBtn" class="btn btn-primary mt-3">예약하기</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 예약하기 클릭 -->
<script>
  $('#reserveBtn').on('click', function(){
    if(!window.selectedDates || window.selectedDates.length<2){
      alert('예약할 날짜를 선택해주세요.');
      return;
    }
    const startD = window.selectedDates[0].toISOString().split('T')[0];
    const endD   = window.selectedDates[1].toISOString().split('T')[0];
    const rtSeq  = $('#roomTypeSelect').val();
    const guests = $('#numGuests').val();

    const inTime = ${roomCatSeq} <= 7
      ? $('#customInTime').val()
      : '${rt.roomCheckInTime}';
    const outTime= ${roomCatSeq} <= 7
      ? $('#customOutTime').val()
      : '${rt.roomCheckOutTime}';

    const params = $.param({
      roomTypeSeq:      rtSeq,
      checkIn:          startD,
      checkOut:         endD,
      rsvCheckInTime:   inTime,
      rsvCheckOutTime:  outTime,
      numGuests:        guests
    });

    location.href = '${pageContext.request.contextPath}/reservation/step1JY?' + params;
  });
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
