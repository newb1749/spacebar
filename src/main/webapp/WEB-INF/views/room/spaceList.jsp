<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<title>공간대여 리스트</title>
<style>
body {
  padding-top: 20px;
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

#roomListBody {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;
}
#toggleFilter {
  display: flex;
  align-items: center;
  justify-content: center;
}
/* 필터 드롭다운 늘리기 */
  #filterDropdown {
    width: 520px !important;
  }
  /* 편의시설 그리드 레이아웃 */
#filterDropdown .facilities-grid {
  display: grid;
  /* 한 칸 최소 140px, 최대 1fr (자동 채우기) */
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 8px 12px;
  margin-top: 8px;
}

/* 각 아이템은 flex로 체크박스+라벨 가운데 정렬 */
#filterDropdown .facilities-grid .form-check {
  display: flex;
  align-items: center;
}

/* 라벨 텍스트 줄바꿈 방지 */
#filterDropdown .facilities-grid .form-check-label {
  white-space: nowrap;
  margin-left: 4px;
}

  /* 가격 입력창 너비 조정 */
  #filterDropdown .form-control {
    width: 180px;
    border-radius: 6px;
    border: 1px solid #ddd;
    padding: 8px 12px;
  }

  /* 입력창 사이 ~ 기호 간격 */
  #filterDropdown .price-range {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
  }

  /* 체크박스 리스트 한 줄 더 늘리기 (3열 그리드) */
  #filterDropdown .mb-3:nth-child(2) .d-flex {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 8px 12px;
  }

  /* 적용 버튼 스타일 */
  #filterDropdown .btn-success {
    background: linear-gradient(to right, #56ab2f, #a8e063);
    border: none;
    border-radius: 6px;
    padding: 10px 24px;
    font-size: 0.95rem;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    transition: background 0.2s;
  }
  #filterDropdown .btn-success:hover {
    background: linear-gradient(to right, #48a026, #94c558);
  }

.room-list-item {
  background-color: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.2s ease-in-out;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  height: 100%;
  
  position: relative;
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
  display: flex;
  flex-direction: column;
  flex: 1;
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
  color: #28a745;
  font-size: 1rem;
  margin-top: auto;
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

.container.mt-5 {
  /* 기존 margin-top:100px; 은 inline style 에서 처리 중이니, 
     여백만 bottom 쪽으로 더 주세요 */
  margin-bottom: 60px;  /* 원하는 값으로 조절 */
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
    document.roomForm.regionList.value = $("#_regionList").val();
    document.roomForm.roomSeq.value = "";
    document.roomForm.searchValue.value = $("#_searchValue").val();
    document.roomForm.curPage.value = "1";
    document.roomForm.personCount.value = $("#_personCount").val();
    
    const facilities = [];
    $("input[name='_facilityList']:checked").each(function(){
      facilities.push($(this).val());
    });
    document.roomForm.facilityList.value = facilities.length > 0 ? facilities.join(',') : "";
      document.roomForm.minPrice.value = $("#_minPrice").val();
	  document.roomForm.maxPrice.value = $("#_maxPrice").val();

    
    
 	// 시간값 설정
    document.roomForm.startTime.value = $("#_startTime").val();
    document.roomForm.endTime.value = $("#_endTime").val();
    
    
    
    
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
    document.roomForm.action = "/room/spaceList";
    document.roomForm.submit();
  });
  
	//JavaScript에서 JSP 변수를 비교
  var startDate = "${startDate}";
  var endDate = "${endDate}";
  
  if (startDate !== endDate) {
    alert("날짜는 하루만 선택해 주세요");
    return;
  }

	//필터 드롭다운 토글
  $("#toggleFilter").on("click", function () {
    $("#filterDropdown").toggle();
  });

  // 필터 적용
  $("#applyFilter").on("click", function () {

	  document.roomForm.minPrice.value = $("#_minPrice").val();
	  document.roomForm.maxPrice.value = $("#_maxPrice").val();

    // 체크된 편의시설 값을 모두 수집
    const facilities = [];
	$("input[name='_facilityList']:checked").each(function () {
	  facilities.push($(this).val());
	});
	document.roomForm.facilityList.value = facilities.length > 0 ? facilities.join(',') : "";
	
 	// 시간값 설정
    document.roomForm.startTime.value = $("#_startTime").val();
    document.roomForm.endTime.value = $("#_endTime").val();
    
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

    
    document.roomForm.regionList.value = $("#_regionList").val();
    document.roomForm.roomSeq.value = "";
    document.roomForm.searchValue.value = $("#_searchValue").val();
    document.roomForm.curPage.value = "1";
    document.roomForm.personCount.value = $("#_personCount").val();
    document.roomForm.action = "/room/spaceList"
    document.roomForm.submit();
  });
  
	//JavaScript에서 JSP 변수를 비교
  var startDate = "${startDate}";
  var endDate = "${endDate}";
  var startTime = "${startTime}";
  var endTime = "${endTime}";
  
  const st = parseInt(startTime, 10);
  const et = parseInt(endTime, 10);
  

/*   if (startDate === endDate && st >= et) {
    alert("올바른 시간대를 입력해주세요.");
    return;
  }
  
  if ((startTime === "" && endTime !== "") || (startTime !== "" && endTime === ""))
	  {
	  	alert("시작과 끝 시간은 같이 입력해주세요.");
	  	return;
	  } */
  
});
	
//function fn_list(curPage) {
//  document.roomForm.curPage.value = curPage;
//  document.roomForm.action = "/room/roomList";
//  document.roomForm.submit();
//}

//마우스 스크롤 처리를 위함 시작
//스크롤 도달 시 Ajax로 다음 페이지 게시글만 추가 조회
function fn_list_scroll(nextPage) {
  if (nextPage > maxPage || loading) return;
  loading = true;
  
  $("#loadingIndicator").show();

  // 1) 보낼 파라미터 객체를 만듭니다.
  const payload = {
    curPage:      nextPage,
    searchValue:  $("#_searchValue").val()   || "",
    regionList:   $("#_regionList").val()    || "",
    personCount:  $("#_personCount").val()   || "",
    minPrice:     $("#_minPrice").val()      || "",
    maxPrice:     $("#_maxPrice").val()      || "",
    startTime:    $("#_startTime").val()     || "",
    endTime :     $("#_endTime").val()       || "",
    startDate:    $("#calendar_start").val() || "",
    endDate:      $("#calendar_end").val()   || "",
    category:     $("#category").val()       || ""
  };

  // 2) 체크된 편의시설만 따로 수집해서, 실제로 하나라도 있을 때만 payload에 넣습니다.
  const facs = [];
  $("input[name='_facilityList']:checked").each(function(){
    facs.push(this.value);
  });
  if (facs.length > 0) {
    payload.facilityList = facs.join(",");
  }

  // 3) URL 은 반드시 컨트롤러 매핑( @RequestMapping("/room/roomListFragment") ) 과
  //    일치시켜야 200 OK 가 찍힙니다.
  $.ajax({
    url:      "/room/spaceListFragment",
    type:     "POST",
    data:     payload,
    dataType: "html",    // fragment HTML 을 기대할 때
    success: function(data) {
      if (data.trim().length) {
        $("#roomListBody").append(data);
        curPage = nextPage;
      }
      loading = false;
      $("#loadingIndicator").hide();
    },
    error: function(xhr, status, err) {
      console.error("스크롤 AJAX 에러:", status, err, xhr.responseText);
      alert("추가 데이터를 불러오는 데 실패했습니다.");
      loading = false;
      $("#loadingIndicator").hide();
    }
  });
}


//스크롤 이벤트 등록
$(window).on("scroll", function () {
	if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
		fn_list_scroll(curPage + 1);
	}
});

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
	      }
	      else if(res.code === 500) {
	  	        Swal.fire("로그인 후 이용하세요", res.message, "warning");
	  	      }
	      else {
	        Swal.fire("오류", res.message, "error");
	      }
	    })
	    .fail(function() {
	      Swal.fire("네트워크 오류", "잠시 후 다시 시도해주세요.", "error");
	    });
	}
	
function fn_roomDetail(roomSeq)
{
	document.roomForm.roomSeq.value = roomSeq;
	document.roomForm.action = "/room/roomDetail";
	document.roomForm.submit();
}
</script>


</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5" style="margin-top: 100px;">
  <h2 class="fw-bold mb-4">공간 대여 목록</h2>

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
    
    <!-- ✅ 시간 선택 수평 정렬 -->
<div class="d-flex align-items-center gap-3" style="height: 44px;">
  <div class="d-flex align-items-center" style="gap: 8px;">
    <span style="font-weight: bold; white-space: nowrap;">이용시간</span>
		<select id="_startTime" name="_startTime" class="form-select" style="width: 80px; height: 44px; border-radius: 12px;">
		<option value="" <c:if test="${empty startTime}">selected</c:if>>시작</option>
		  <c:forEach var="i" begin="0" end="24">
		    <option value="${i}"<c:if test="${not empty startTime and i == startTime}">selected</c:if>>${i}시</option>
		  </c:forEach>
		</select>
  </div>

  <div class="d-flex align-items-center" style="gap: 8px;">
    <span style="font-weight: bold; white-space: nowrap;">~</span>
    <select id="_endTime" name="_endTime" class="form-select" style="width: 80px; height: 44px; border-radius: 12px;">
    <option value="" <c:if test="${empty endTime}">selected</c:if>>끝</option>
	  <c:forEach var="i" begin="0" end="24">
	    <option value="${i}"<c:if test="${not empty endTime and i == endTime}">selected</c:if>>${i}시</option>
	  </c:forEach>
	</select>
  </div>
</div>

<!-- ✅ 지역 선택 -->
<select name="_regionList" id="_regionList" class="form-select shadow-sm" style="width: 120px; height: 44px; border-radius: 12px;">
  <option value="">지역</option>
  <c:forEach var="region" items="${fn:split('서울,경기,인천,부산,대구,광주,대전,울산,제주,강원,경남,경북,전남,전북,충남,충북', ',')}">
    <option value="${region}" <c:if test="${regionList eq region}">selected</c:if>>${region}</option>
  </c:forEach>
</select>


<!-- ✅ 인원수 선택 (수정) -->
<div style="display: inline-flex; align-items: center; gap: 8px;">
<input type="number" id="_personCount" name="_personCount" class="form-control shadow-sm" style="width: 100px; height: 44px; border-radius: 12px; text-align: center;"
    placeholder="인원수" value="${personCount != 0 ? personCount : ''}" min="0" step="1"/>
  <span style="font-size: 0.95rem; color: #555; white-space: nowrap;">명</span>
</div>


    <input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" class="form-control shadow-sm" maxlength="20"
           style="width: 260px; height: 44px; border-radius: 12px;" placeholder="검색어를 입력하세요" />
    <button type="button" id="btnSearch" class="btn"
            style="height: 44px; background: linear-gradient(to right, #a8e063, #56ab2f); color: white; font-weight: bold; border-radius: 12px; padding: 0 20px;">
      🔍 검색
    </button>

    <!-- 필터 버튼 -->
<div class="position-relative" style="min-width: 120px;">
  <button type="button" id="toggleFilter" class="btn"
    style="height: 44px; background: linear-gradient(to right, #a8e063, #56ab2f); color: white; font-weight: bold; border-radius: 12px;">
    ▼ 필터 
  </button>

  <div id="filterDropdown" style="display:none; position: absolute; top: 52px; right: 0; z-index: 999;
       background: white; border: 1px solid #ccc; border-radius: 10px; padding: 16px;
       box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 320px;">

	    <!-- 가격 필터 -->
	<div class="mb-3">
	  <label class="fw-bold">가격</label>
	  <p style="font-size:0.8rem;color:#999;">가격을 설정해주세요.</p>
	  <div class="price-range">
	    <input type="number" id="_minPrice" name="_minPrice" placeholder="최소가격"
	           value="${minPrice != 0 ? minPrice : ''}" min="0" step="10000" class="form-control" />
	    <span>~</span>
	    <input type="number" id="_maxPrice" name="_maxPrice" placeholder="최대가격"
	           value="${maxPrice != 0 ? maxPrice : ''}" min="0" step="10000" class="form-control" />
	  </div>
	</div>

    <!-- 편의시설 필터 -->
		<div class="mb-3">
		  <label class="fw-bold">편의시설</label>
		  <!-- 기존 d-flex 대신 facilities-grid 사용 -->
		  <div class="facilities-grid">
		    <c:forEach var="facility" items="${fn:split('와이파이,냉장고,전자레인지,정수기,에어컨 / 난방기,드라이기,다리미,거울 (전신거울 포함),침구,욕실용품,옷걸이 / 행거,TV (OTT 가능),세탁기 / 건조기,취사도구,바베큐 시설,수영장,방음 시설,마이크 / 오디오 장비,앰프 / 스피커,조명 장비,삼각대 / 촬영 장비,블루투스 스피커,악기류 (피아노 드럼 등),빔프로젝터 / 스크린,TV 모니터,화이트보드,프린터 / 복합기,사무용 의자 / 책상,커피머신,화장실 / 샤워실,취사장 / 개수대,전기 공급,텐트 / 타프,캠프파이어 구역,야외 테이블 / 의자,벌레퇴치용품', ',')}">
		      <div class="form-check">
		        <input class="form-check-input" type="checkbox"
		               name="_facilityList" value="${facility}"
		               id="facility_${facility}"
		               <c:if test="${fn:contains(facilityList, facility)}">checked</c:if> />
		        <label class="form-check-label" for="facility_${facility}">
		          ${facility}
		        </label>
		      </div>
		    </c:forEach>
		  </div>
		</div>

    <div class="text-end">
      <button type="button" id="applyFilter" class="btn btn-sm btn-success">적용</button>
    </div>
  </div>
</div>


<!-- ✅ 카테고리 선택 영역 -->
<div class="category-wrapper">

  <!-- 🛏 숙박 
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
-->
  <!-- 🏢 공간 대여 -->
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

</div>



  </div>
  

  <!-- ✅ 리스트 출력 -->
  <div id="roomListBody">
  <c:forEach var="room" items="${list}">
    <div class="room-list-item">
      <img src="/resources/upload/room/main/${room.roomImageName}" alt="${room.roomTitle}" class="room-thumbnail" onclick="fn_roomDetail(${room.roomSeq});">
      <div class="room-details">
        <div class="room-title" style="cursor: pointer;" onclick="fn_roomDetail(${room.roomSeq});">${room.roomTitle}  ${room.roomSeq}</div>
        <div class="room-location">${room.roomAddr}</div>
        <div class="room-rating">⭐ ${room.averageRating} (${room.reviewCount}명)</div>
        <div class="room-price">
          <fmt:formatNumber value="${room.amt}" type="currency" currencySymbol="₩" />
        
	        <c:set var="isWished" value="false"/>
			  <c:forEach var="seq" items="${wishSeqs}">
			    <c:if test="${seq eq room.roomSeq}">
			      <c:set var="isWished" value="true"/>
			    </c:if>
			  </c:forEach>
			
			  <button class="wish-heart" data-wished="${isWished}"
			          onclick="toggleWish(${room.roomSeq}, this)">
			    <i class="${isWished ? 'fas fa-heart wished' : 'far fa-heart'}"></i>
			  </button>
        
        </div>
      </div>
    </div>
  </c:forEach>
</div>

<!-- 여기에 로딩 메시지 -->
<div id="loadingIndicator" style="display:none; text-align:center; padding:16px; color:#555;">
  로딩중… 잠시만 기다려주세요
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
<form name="roomForm" id="roomForm" method="get" action="${pageContext.request.contextPath}/room/roomDetail">
  <input type="hidden" name="roomSeq" value="${roomSeq}" />
  <input type="hidden" name="searchValue" value="${searchValue}" />
  <input type="hidden" name="curPage"  value="${curPage}" />
  <input type="hidden" name="regionList" id="regionList" value="${regionList}" />
  <input type="hidden" name="startTime" id="startTime" value="${startTime}" />
  <input type="hidden" name="endTime" id="endTime" value="${endTime}"/>
  <input type="hidden" name="category" id="category" value="${category}"/>
  <input type="hidden" name="personCount" id="personCount" value="${personCount}" />
  <input type="hidden" name="minPrice" id="minPrice" value="${minPrice}" />
  <input type="hidden" name="maxPrice" id="maxPrice" value="${maxPrice}" />
  <input type="hidden" name="facilityList" id="facilityList" value="${facilityList}" />
</form>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>


</body>
</html>
