<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>방 리스트</title>
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
</style>
<script>
let curPage = parseInt("${curPage}");
let maxPage = ${paging.totalPage};
let loading = false;

$(document).ready(function(){
  // 검색 버튼
  $("#btnSearch").on("click", function(){
    document.roomForm.roomSeq.value = "";
    document.roomForm.searchValue.value = $("#_searchValue").val();
    document.roomForm.curPage.value = "1";
    document.roomForm.submit();
  });

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
    <input type="date" id="checkInDate" class="form-control shadow-sm" style="width: 160px; height: 44px; border-radius: 12px;" />
    <input type="date" id="checkOutDate" class="form-control shadow-sm" style="width: 160px; height: 44px; border-radius: 12px;" />
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
  </div>
  

  <!-- ✅ 리스트 출력 -->
  <div id="roomListBody">
  <c:forEach var="room" items="${list}">
    <div class="room-list-item">
      <img src="/resources/upload/room/main/${room.roomImageName}" alt="${room.roomTitle}" class="room-thumbnail">
      <div class="room-details">
        <div class="room-title">${room.roomTitle}</div>
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
</form>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>


</body>
</html>
