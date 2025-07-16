<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>${room.roomTitle} - 상세페이지</title>
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
            <c:forEach var="roomImg" items="${detailImages}">
              <div class="item">
                <img src="/resources/upload/room/detail/${roomImg.roomImgName}" class="img-fluid" alt="${roomImg.imgType}" />
              </div>
            </c:forEach>
          </div>
        </div>

        <!-- 질문 작성 버튼 -->
		<div class="d-flex justify-content-end gap-2 mb-3 mt-4">
		  <c:if test="${user.userType eq 'G'}">
		    <a href="/room/qnaForm_mj?roomSeq=${room.roomSeq}" class="btn btn-outline-primary">
		      ✏ Q&A 작성하기
		    </a>
		  </c:if>

		  <!-- 수정 버튼 (작성자가 회원 본인일 경우에만 노출) -->
		  <!-- <c:if test="${sessionUserId == roomQna.userId}">
		    <a href="/room/qnaUpdateForm_mj?roomSeq=${room.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-warning btn">
		      ✏ Q&A 수정하기
		    </a>
		  </c:if> -->
		</div>     

<!-- QnA 리스트 -->
<div class="clearfix">
<div class="qna-list mt-3">
  <c:forEach var="qna" items="${qnaList}">
    <div class="qna-item d-flex mb-4 pb-4 border-bottom">
      <div class="qna-avatar me-3">
      <!-- 게스트 Q&A -->
      <c:choose>
      <c:when test="${!empty qna.profImgExt}">
        <img src="/resources/upload/userprofile/${qna.userId}.${qna.profImgExt}"  
        alt="profile" width="40" height="40" style="border-radius: 50%;" />
       </c:when>
       <c:otherwise>
       	<img src="/resources/upload/userprofile/default_profile.png"  
        alt="profile" width="40" height="40" style="border-radius: 50%;" />
       </c:otherwise>
      </c:choose>
      </div>
      <div class="qna-content w-100">
        <!-- 삭제된 게시물 표시 -->
        <c:choose>
          <c:when test="${qna.roomQnaStat eq 'N'}">
			<span class="deleted-title">삭제된 게시물입니다.</span>
          </c:when>
          <c:otherwise>
            <!-- 일반 게시물 -->
            <p class="fw-bold mb-1">${qna.nickName}</p>
            <p class="mb-1">${qna.roomQnaContent}</p>
            <p class="text-muted mb-2" style="font-size: 0.9em;">
                <c:choose>
                	<%-- 수정일자가 있을 경우 --%>
                    <c:when test="${!empty qna.updateDt}">
                        수정일자: ${qna.updateDt}
                    </c:when>
                    <%-- 수정일자가 없을 경우 --%>
                    <c:otherwise>
                        등록일자: ${qna.regDt}
                    </c:otherwise>
                </c:choose>
            </p>
            
            <!-- 수정 버튼 (작성자가 회원 본인일 경우에만 노출) -->
            <c:if test="${sessionUserId == qna.userId}">
                <a href="/room/qnaUpdateForm_mj?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-warning btn">
                  ✏ Q&A 수정하기
                </a>
            </c:if> 
            
            <!-- 호스트 답글 -->
            <c:if test="${!empty qna.roomQnaComment}">
              <div class="qna-answer bg-light p-2 rounded">
                <p class="text-primary fw-semibold mb-1">호스트의 답글</p>
                <p class="mb-1">${qna.roomQnaComment.roomQnaCmtContent}</p>                  
                <p class="text-muted mb-2" style="font-size: 0.9em;">
                    <c:choose>
                    	<%-- 수정일자가 있을 경우 --%>
                        <c:when test="${!empty qna.roomQnaComment.updateDt}">
                            수정일자: ${qna.roomQnaComment.updateDt}
                        </c:when>
                        <%-- 수정일자가 없을 경우 --%>
                        <c:otherwise>
                            등록일자: ${qna.roomQnaComment.createDt}
                        </c:otherwise>
                    </c:choose>
                </p>
              </div>
            </c:if>
            
            <!-- 답글 작성 버튼 -->
            <div class="d-flex justify-content-end gap-2 mb-3 mt-4">
             <c:if test="${user.userType =='H' and empty qna.roomQnaComment}">
                 <a href="/room/qnaCmtForm_mj?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-primary">
                   ✏ 답글 작성하기
                 </a>
            </c:if> 
            
            <!-- 답글 수정 버튼 -->
            <c:if test="${user.userType =='H' and !empty qna.roomQnaComment}">
              <a href="/room/qnaCmtUpdateForm_mj?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}&roomQnaCmtSeq=${qna.roomQnaComment.roomQnaCmtSeq}" class="btn btn-outline-warning btn">
                ✏ 답글 수정하기
              </a>
            </c:if>                      
          </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </c:forEach>
  <c:if test="${empty qnaList}">
    <p class="text-muted text-center">등록된 Q&A가 없습니다.</p>
  </c:if>
</div>
</div>
      
		<!-- 📌 QnA 리스트 아래 페이징 영역 시작 -->
<div class="paging text-center mt-4">
  <nav>
    <ul class="pagination justify-content-center">
      <c:if test="${!empty paging}">
        <!-- 이전 블럭 -->
        <c:if test="${paging.prevBlockPage gt 0}">
          <li class="page-item">
            <a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a>
          </li>
        </c:if>

        <!-- 페이지 번호 -->
        <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
          <c:choose>
            <c:when test="${i ne curPage}">
              <li class="page-item">
                <a class="page-link" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
              </li>
            </c:when>
            <c:otherwise>
              <li class="page-item active">
                <a class="page-link" href="javascript:void(0)" style="cursor:default;">${i}</a>
              </li>
            </c:otherwise>
          </c:choose>
        </c:forEach>

        <!-- 다음 블럭 -->
        <c:if test="${paging.nextBlockPage gt 0}">
          <li class="page-item">
            <a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a>
          </li>
        </c:if>
      </c:if>
    </ul>
  </nav>
</div>
<!-- 📌 QnA 리스트 아래 페이징 영역 끝 -->
		


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
            <jsp:param name="address" value="${room.roomAddr}" />
            <jsp:param name="roomName" value="${room.roomTitle}" />
          </jsp:include>

          <jsp:include page="/WEB-INF/views/component/calendar.jsp">
            <jsp:param name="calId" value="roomDetailCalendar" />
            <jsp:param name="fetchUrl" value="" />
          </jsp:include>

          <label for="roomTypeSelect" class="mt-3">객실 타입 선택:</label>
          <select id="roomTypeSelect" class="form-select" style="width:100%;">
            <c:forEach var="rt" items="${roomTypes}">
              <option value="${rt.roomTypeSeq}">
                ${rt.roomTypeTitle} - 주중: ${rt.weekdayAmt}원 / 주말: ${rt.weekendAmt}원
              </option>
            </c:forEach>
          </select>

          <label for="numGuests" class="mt-3">인원 수 선택:</label>
          <select id="numGuests" class="form-select" style="width:100px;">
            <c:forEach begin="1" end="10" var="i">
              <option value="${i}">${i}명</option>
            </c:forEach>
          </select>

          <button id="reserveBtn" class="btn btn-primary mt-3">예약하기</button>
          <form name="roomQnaForm" id="roomQnaForm">
          	<input type="hidden" name="roomSeq" value="${room.roomSeq}" />
          	<input type="hidden" name="curPage" value="${curPage}" />
          </form>
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
    initRoomCalendar("roomDetailCalendar", {
      fetchUrl: "",
      onChange: (dates) => {
        window.selectedDates = dates;
      }
    });

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
  
function fn_list(curPage)
{
	document.roomQnaForm.roomSeq.value = "${room.roomSeq}";
	document.roomQnaForm.curPage.value = curPage;
	document.roomQnaForm.action = "/room/roomDetail_mj";
	document.roomQnaForm.submit();
}
</script>
</body>
</html>