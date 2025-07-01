<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>숙소 리스트</title>
<style>
body {
  padding-top: 100px;
}
#roomListBody {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;
}

.room-list-item {
  background-color: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.2s ease-in-out;
  cursor: pointer;
}
.room-list-item:hover {
  transform: translateY(-4px);
}

.room-thumbnail {
  width: 100%;
  height: 200px;
  object-fit: cover;
  display: block;
}

.room-details {
  padding: 16px;
  font-size: 0.95rem;
}

.room-title {
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 4px;
}

.room-location {
  color: #888;
  font-size: 0.85rem;
  margin-bottom: 6px;
}

.room-rating {
  color: #555;
  font-size: 0.85rem;
  margin-bottom: 6px;
}

.room-price {
  font-weight: bold;
  color: #6c5ce7;
  font-size: 1rem;
}

.category-wrapper {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-top: 24px;
}

.category-row {
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

.category-label {
  font-size: 1.1rem;
  font-weight: bold;
  min-width: 80px;
  color: #2c3e50;
}

.category-btn-group {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.category-btn {
  background: #f1f1f1;
  border: 2px solid #ccc;
  border-radius: 20px;
  padding: 8px 18px;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  color: #333;
  transition: all 0.2s ease;
}

.category-btn:hover {
  background: #e0e0e0;
}

.category-btn.active {
  background: #56ab2f;
  color: white;
  border-color: #56ab2f;
}
</style>
<script>
let curPage = parseInt("${curPage}");
let maxPage = ${totalPage};
let loading = false;

$(document).ready(function(){
	
	//✅ category 값이 있으면 해당 버튼을 active로 만듦
	const selectedCategory = $("#category").val();
	if (selectedCategory) {
	  $(".category-btn").each(function() {
	    if ($(this).text().trim() === selectedCategory) {
	      $(this).addClass("active");
	    }
	  });
	}

	// ✅ 카테고리 버튼 클릭 이벤트
	$(".category-btn").on("click", function() {
	  const isActive = $(this).hasClass("active");

	  // 모든 버튼 비활성화
	  $(".category-btn").removeClass("active");

	  if (!isActive) {
	    // 현재 버튼만 활성화
	    $(this).addClass("active");
	    $("#category").val($(this).text().trim());
	  } else {
	    // 다시 누르면 비활성화 및 히든값 초기화
	    $("#category").val("");
	  }
	});
	
  // 검색 버튼
  $("#btnSearch").on("click", function(){

	  
	  
	console.log("선택된 날짜 확인:", window.selectedDates);
    document.roomForm.regionList.value = "";
    document.roomForm.roomSeq.value = "";
    document.roomForm.searchValue.value = $("#_searchValue").val();
    document.roomForm.curPage.value = "1";
    
    
    
 	// 시간값 설정
    //document.roomForm.startTime.value = $("#startTime").val();
    //document.roomForm.endTime.value = $("#endTime").val();
    
 	// ✅ 날짜 강제로 hidden input에 넣기
    const startInput = document.getElementById("calendarTest_start");
    const endInput = document.getElementById("calendarTest_end");
    

    if (window.selectedDates && window.selectedDates.length === 2) {
      const [start, end] = window.selectedDates;
      const formatYYYYMMDD = (date) => {
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        return `${yyyy}${mm}${dd}`;
      };
      if (startInput && endInput) {
        startInput.value = formatYYYYMMDD(start);
        endInput.value = formatYYYYMMDD(end);
      } else {
        console.warn("hidden input 찾을 수 없음");
      }
    } else {
      console.warn("선택된 날짜 없음");
    }
    
    document.roomForm.submit();
  });
  
	//JavaScript에서 JSP 변수를 비교
  var startDate = "${startDate}";
  var endDate = "${endDate}";
  
  if (startDate === endDate) {
    alert("시작일과 종료일이 같을 수 없습니다.");
    return;
  }

  // 지역 필터 드롭다운 토글
  $("#toggleFilter").on("click", function () {
    $("#regionDropdown").toggle();
  });

  // 필터 적용 -> hidden 추가
  $("#applyFilter").on("click", function(){
	  const selectedRegion = $("#regionForm input[name='region']:checked").val();
	  // 기존 hidden 제거
	  //$("input[name='regionList']").remove();
	  if (selectedRegion) {
	    //$("<input>").attr({
	      //type: "hidden",
	      //name: "regionList",
	      //value: selectedRegion
	    //}).appendTo("#roomForm");
	    document.roomForm.regionList.value = selectedRegion;
	  }
	  
		document.roomForm.roomSeq.value = "";
		document.roomForm.searchValue.value = $("#_searchValue").val();
		document.roomForm.curPage.value = "1";
		
		// 시간값 설정
	    //document.roomForm.startTime.value = $("#startTime").val();
	    //document.roomForm.endTime.value = $("#endTime").val();
		
		document.roomForm.submit();

	  $("#regionDropdown").hide();
	});
});
	
function fn_list(curPage) {
  document.roomForm.curPage.value = curPage;
  document.roomForm.action = "/room/list";
  document.roomForm.submit();
}

//마우스 스크롤 처리를 위함 시작
//스크롤 도달 시 Ajax로 다음 페이지 게시글만 추가 조회
function fn_list_scroll(nextPage) {
	if (nextPage > maxPage || loading) return;
	loading = true;

	$.ajax({
		url: "/room/listFragment",
		type: "POST",
		data: {
			curPage: nextPage,
			searchValue: $("#_searchValue").val(),
			regionList: $("#regionList").val()
		},
		success: function(data) {
			if (data.trim().length > 0) {
				$("#roomListBody").append(data);
				curPage = nextPage;
			}
			loading = false;
		},
		error: function() {
			alert("목록을 불러오는 데 실패했습니다.");
			loading = false;
		}
	});
}


//스크롤 이벤트 등록
$(window).on("scroll", function () {
	if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
		fn_list_scroll(curPage + 1);
	}
});
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5" style="margin-top: 100px;">
  <h2 class="fw-bold mb-4">숙소 목록</h2>

  <!-- ✅ 검색 + 날짜 + 필터 -->
  <div class="d-flex justify-content-center align-items-center mb-5" style="gap: 12px; flex-wrap: wrap;">

      <c:set var="calId" value="calendarTest"/> 
	  <c:set var="fetchUrl" value=""/> 
	  
	  <!-- JSP include로 파라미터 전달 -->
	  <jsp:include page="/WEB-INF/views/component/calendar.jsp">
	    <jsp:param name="calId" value="calendar" />
	    <jsp:param name="fetchUrl" value="" />
	    <jsp:param name="startDate" value="${startDate}" />
	    <jsp:param name="endDate" value="${endDate}" />
	  </jsp:include>
    
    <!-- ✅ 시간 선택 수평 정렬 
<div class="d-flex align-items-center gap-3" style="height: 44px;">
  <div class="d-flex align-items-center" style="gap: 8px;">
    <span style="font-weight: bold; white-space: nowrap;">이용시작</span>
		<select id="startTime" name="startTime" class="form-select" style="width: 100px; height: 44px; border-radius: 12px;">
		  <c:forEach var="i" begin="0" end="24">
		    <option value="${i}" <c:if test="${i == param.startTime}">selected</c:if>>${i}시</option>
		  </c:forEach>
		</select>
  </div>

  <div class="d-flex align-items-center" style="gap: 8px;">
    <span style="font-weight: bold; white-space: nowrap;">이용끝</span>
    <select id="endTime" name="endTime" class="form-select" style="width: 100px; height: 44px; border-radius: 12px;">
	  <c:forEach var="i" begin="0" end="24">
	    <option value="${i}" <c:if test="${i == param.endTime}">selected</c:if>>${i}시</option>
	  </c:forEach>
	</select>
  </div>
</div>
-->
    <input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" class="form-control shadow-sm" maxlength="20"
           style="width: 260px; height: 44px; border-radius: 12px;" placeholder="검색어를 입력하세요" />
    <button type="button" id="btnSearch" class="btn"
            style="height: 44px; background: linear-gradient(to right, #a8e063, #56ab2f); color: white; font-weight: bold; border-radius: 12px; padding: 0 20px;">
      🔍 검색
    </button>

    <!-- 필터 버튼 -->
		<div class="position-relative" style="min-width: 120px;">
		  <button type="button" id="toggleFilter"
			        class="btn"
			        style="height: 44px; background: linear-gradient(to right, #a8e063, #56ab2f);
			               color: white; font-weight: bold; border-radius: 12px;
			               display: flex; align-items: center; justify-content: center;">
			  지역 필터
			</button>
		  <div id="regionDropdown" style="display:none; position: absolute; top: 52px; right: 0; z-index: 999;
		       background: white; border: 1px solid #ccc; border-radius: 10px; padding: 12px;
		       box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 240px;">
		    <form id="regionForm">
		      <c:forEach var="region" items="${fn:split('서울,경기,인천,부산,대구,광주,대전,울산,제주,강원,경남,경북,전남,전북,충남,충북', ',')}">
		        <div class="form-check mb-1">
		          <input class="form-check-input" type="radio" name="region" value="${region}" id="region_${region}" />
		          <label class="form-check-label" for="region_${region}">${region}</label>
		        </div>
		      </c:forEach>
		      <div class="text-end mt-2">
		        <button type="button" id="applyFilter" class="btn btn-sm btn-success">적용</button>
		      </div>
		    </form>
		  </div>
		</div>
		
<!-- ✅ 카테고리 선택 영역 -->
<div class="category-wrapper">

  <!-- 🛏 숙박 -->
  <div class="category-row">
    <div class="category-label">숙박</div>
    <div class="category-btn-group">
      <button type="button" class="category-btn">풀빌라</button>
      <button type="button" class="category-btn">호텔</button>
      <button type="button" class="category-btn">팬션</button>
      <button type="button" class="category-btn">민박</button>
      <button type="button" class="category-btn">리조트</button>
      <button type="button" class="category-btn">주택</button>
      <button type="button" class="category-btn">캠핑장</button>
    </div>
  </div>

  <!-- 🏢 공간 대여 
  <div class="category-row">
    <div class="category-label">공간 대여</div>
    <div class="category-btn-group">
      <button type="button" class="category-btn">파티룸</button>
      <button type="button" class="category-btn">카페</button>
      <button type="button" class="category-btn">연습실</button>
      <button type="button" class="category-btn">스튜디오</button>
      <button type="button" class="category-btn">회의실</button>
      <button type="button" class="category-btn">녹음실</button>
      <button type="button" class="category-btn">운동시설</button>
    </div>
  </div>
-->
</div>



  </div>
  

  <!-- ✅ 리스트 출력 -->
  <div id="roomListBody">
  <c:forEach var="room" items="${list}">
    <div class="room-list-item">
      <img src="/resources/upload/room/main/${room.roomImageName}" alt="${room.roomTitle}" class="room-thumbnail">
      <div class="room-details">
        <div class="room-title">${room.roomTitle}  ${room.roomSeq}</div>
        <div class="room-location">${room.roomAddr}</div>
        <div class="room-rating">⭐ ${room.averageRating} (${room.reviewCount}명)</div>
        <div class="room-price">
          <fmt:formatNumber value="${room.amt}" type="currency" currencySymbol="₩" />
        </div>
      </div>
    </div>
  </c:forEach>
</div>
  <!-- ✅ 페이지네이션 
  <nav>
    <ul class="pagination justify-content-center">
      <c:if test="${!empty paging}">
        <c:if test="${paging.prevBlockPage gt 0}">
          <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전</a></li>
        </c:if>
        <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
          <c:choose>
            <c:when test="${i ne curPage}">
              <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
            </c:when>
            <c:otherwise>
              <li class="page-item active"><a class="page-link" href="javascript:void(0)">${i}</a></li>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${paging.nextBlockPage gt 0}">
          <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음</a></li>
        </c:if>
      </c:if>
    </ul>
  </nav>
  -->
</div>


<!-- ✅ 폼 -->
<form name="roomForm" id="roomForm" method="post">
  <input type="hidden" name="roomSeq" value="${roomSeq}" />
  <input type="hidden" name="searchValue" value="${searchValue}" />
  <input type="hidden" name="curPage"  value="${curPage}" />
  <input type="hidden" name="regionList" id="regionList" value="${regionList}" />
  <!-- input type="hidden" name="startTime" id="startTime" value="${startTime}"/ -->
  <!--input type="hidden" name="endTime" id="endTime" value="${endTime}"/-->
  <input type="hidden" name="category" id="category" value="${category}"/>
</form>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>


</body>
</html>
