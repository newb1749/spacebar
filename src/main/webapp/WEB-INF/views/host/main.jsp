<%-- /WEB-INF/views/host/main.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>판매자 마이페이지</title>
    <link rel="stylesheet" href="/resources/css/myPage.css">
    <style>
        /* 만약 직접 테스트 중이면 위 myPage.css 대신 여기 style을 사용 */

    /* 테이블 선 없애기 */
    .table-borderless th,
    .table-borderless td,
    .table-borderless {
        border: none !important;
    }
    /* 이미지 사이즈 조절 */
    .img {
       width: 350px;
  	   flex-shrink: 0;
       height: 100%;  
    }
    .img img {
      width: 100%;
	  height: 100%;
	  object-fit: cover;
	  border-radius: 12px; 
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    </style>
    <script type="text/javascript">
    function fn_list(curPage)
    {
    	//document.mainPaging.hibbsSeq.value = "";
    	document.mainPaging.curPage.value = curPage;
    	document.mainPaging.action = "/host/main";
    	document.mainPaging.submit();
    }
  </script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
    <div class="container">
        <!-- 사이드바 -->
        <div class="sidebar">
            <h2>판매자 메뉴</h2>
            <div class="menu-item active" onclick="showContent('dashboard')">대시보드</div>
            <div class="menu-item" onclick="showContent('sales')">판매 내역</div>
            <div class="menu-item" onclick="showContent('rooms')">숙소/공간 관리</div>
            <div class="menu-item" onclick="showContent('reviews')">리뷰 관리</div>
            <div class="menu-item" onclick="showContent('profile')">내 정보</div>
        </div>

        <!-- 메인 컨텐츠 -->
        <div class="main-content">
        <jsp:include page="/WEB-INF/views/component/hostCalendar.jsp" />
            <!-- 통계 카드 영역 -->


            <!-- 대시보드 -->
            <div class="content-area" id="dashboard-area">
                <div class="welcome-message">안녕하세요, <strong>${sessionScope.SESSION_USER_NAME}</strong> 판매자님!</div>
                <div class="sub-message">오늘도 좋은 하루 되세요. 아래에서 판매 현황, 예약 현황, 주요 알림을 확인하세요.</div>
                <div class="arrow"></div>
				<div class="period-selector">
				  <div class="btn-group">
				    <button class="btn-period" onclick="loadStats('week')">이번 주간</button>
				    <button class="btn-period" onclick="loadStats('month')">이번 월간</button>
				    <button class="btn-period" onclick="loadStats('year')">이번 연간</button>
				    <button class="btn-period" onclick="loadStats('total')">누적</button>
				  </div>
				
				  <div class="manual-inputs" id="manualPeriodInput">
				    <input type="number" id="monthInput" min="1" max="12" placeholder="월 (1~12)" />
				    <input type="number" id="yearInput" min="2020" max="2025" placeholder="연도 (예: 2025)" />
				    <button class="btn-period btn-submit" onclick="requestStats(currentPeriod)">조회</button>
				  </div>
				</div>

            </div>

            <!-- 판매 내역 -->
            <div class="content-area hidden" id="sales-area">
                <div class="detail-content">	
                	<h3>숙소/공간 판매 내역</h3>
			        <c:choose>
			            <c:when test="${!empty reservations}"> 
			            <c:forEach var="res" items="${reservations}" >
							<div class="info-item mb-3 border p-3 mt-3 shadow-sm rounded">
							  <div class="row g-3 align-items-stretch">
						    	 <div class="col-md-6">
							      <div class="img">
							        <img src="/resources/upload/roomtype/main/${res.roomTypeImgName}" alt="숙소 이미지"/>
							      </div>
							     </div>
							    <div class="col-md-6 d-flex flex-column justify-content-center align-items-start" style="height: 100%;">
									<table class="table table-sm table-borderless" style="font-size: 0.95rem;">
									  <tbody>
									    <tr>
									      <th>예약번호</th>
									      <td>${res.rsvSeq}</td>
									    </tr>
									    <tr>
									      <th>객실명</th>
									      <td>${res.roomTypeTitle}</td>
									    </tr>
									    <c:choose>
									      <c:when test="${not empty res.rsvCheckInDt and not empty res.rsvCheckOutDt}">
									        <tr>
									          <th style="width: 100px; height: 40px;">체크인</th>
									          <td>${res.rsvCheckInDt}</td>
									        </tr>
									        <tr>
									          <th>체크아웃</th>
									          <td>${res.rsvCheckOutDt}</td>
									        </tr>
									      </c:when>
									      <c:otherwise>
									        <tr>
									          <th>체크인</th>
									          <td>${res.rsvCheckInTime}</td>
									        </tr>
									        <tr>
									          <th>체크아웃</th>
									          <td>${res.rsvCheckOutTime}</td>
									        </tr>
									      </c:otherwise>
									    </c:choose>
									    <tr>
									      <th>예약자</th>
									      <td>${res.guestId}</td>
									    </tr>
									    <tr>
									      <th>결제상태</th>
									      <td>
									        <c:choose>
									          <c:when test="${res.rsvPaymentStat eq 'PAID'}">결제완료</c:when>
									          <c:when test="${res.rsvPaymentStat eq 'UNPAID'}">미결제</c:when>
									          <c:when test="${res.rsvPaymentStat eq 'CANCELED'}">결제취소</c:when>
									          <c:otherwise>-</c:otherwise>
									        </c:choose>
									      </td>
									    </tr>
									    <tr>
									      <th>예약상태</th>
									      <td>
									        <c:choose>
									          <c:when test="${res.rsvStat eq 'CONFIRMED'}">예약완료</c:when>
									          <c:when test="${res.rsvStat eq 'CANCELED'}">예약취소</c:when>
									          <c:when test="${res.rsvStat eq 'PENDING'}">결제대기</c:when>
									          <c:otherwise>-</c:otherwise>
									        </c:choose>
									      </td>
									    </tr>
									    <tr>
									      <th>금액</th>
									      <td><fmt:formatNumber value="${res.finalAmt}" pattern="#,###" />원</td>
									    </tr>
									  </tbody>
									</table>

							   </div>
							  </div>
							</div>
			                </c:forEach>
			            </c:when>
			            <c:otherwise>
			                <div class="alert alert-info text-center">등록된 숙소/공간 정보가 없습니다.</div>
			                <div class="d-flex justify-content-center mt-3">
			                    <a href="/room/addForm" class="btn btn-success">새 숙소 등록하기</a>
			                </div>
			            </c:otherwise>
			        </c:choose>    			        
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
			</div>
          <form name="mainPaging" id="mainPaging">
          	<input type="hidden" name="curPage" value="${curPage}" />
          </form>
            <!-- 숙소/공간 관리 -->
            <div class="content-area hidden" id="rooms-area">
                <div class="detail-content">
                    <h3>내 숙소/공간 목록</h3>
                    <ul>
                        <li>강릉오션뷰펜션 (판매중)</li>
                        <li>서울강남모던하우스 (비공개)</li>
                    </ul>
                    <a href="/room/addForm" class="btn btn-success mt-3">+ 객실 추가</a>
                </div>
            </div>

			<!-- 리뷰 관리 -->
			<div class="content-area hidden" id="reviews-area">
			    <div id="review-manage-area">
			        <div class="loading">로딩 중...</div> <!-- 초기 로딩 메시지 -->
			    </div>
			</div>

            <!-- 내 정보 -->
            <div class="content-area hidden" id="profile-area">
                <div class="detail-content">
                    <h3>내 정보</h3>
                    <div class="info-item">아이디: <b>${sessionScope.SESSION_USER_ID}</b></div>
                    <div class="info-item">이름: <b>${sessionScope.SESSION_USER_NAME}</b></div>
                    <div class="info-item">이메일: <b>${sessionScope.SESSION_USER_EMAIL}</b></div>
                    <a href="/seller/profile/edit" class="btn btn-success mt-3">회원정보 수정</a>
                </div>
            </div>
        </div>
    </div>
    
    
<script>
    	// [추가] rooms 콘텐츠가 로딩되었는지 확인하는 변수
window.onload = function () {
  const lastTab = localStorage.getItem("lastHostTab") || "dashboard";
  showContent(lastTab);

  if (lastTab === "dashboard") {
    console.log("📊 대시보드 진입 - 초기 세팅 시작");

    // 1. 달력 초기화
    initWeekCalendar();

    // ✅ 바로 아래가 문제였던 부분 (start, end 가져오는 부분)
    const start = document.getElementById("weekCalendar_start")?.value;
    const end = document.getElementById("weekCalendar_end")?.value;

    if (start && end) {
      const weekDetail = `${start}~${end}`;
      console.log("📦 초기 주간 periodDetail:", weekDetail);
      loadStats("week", weekDetail); // ✅ 이렇게 정확히 넘겨야 함
    } else {
      console.warn("❌ 주간 날짜가 비어있습니다.");
    }
  }
};


    	let isRoomsContentLoaded = false;
    
        // 메뉴 클릭 시 컨텐츠 전환 함수      
        function showContent(area) {
            localStorage.setItem("lastHostTab", area);
            document.querySelectorAll('.menu-item').forEach(item => item.classList.remove('active'));
            document.querySelectorAll('.content-area').forEach(item => item.classList.add('hidden'));
            document.querySelector('.menu-item[onclick*="' + area + '"]').classList.add('active');
            const contentArea = document.getElementById(area + '-area');
            contentArea.classList.remove('hidden');

            if (area === 'rooms') {
            	contentArea.classList.remove('hidden'); 
                loadRoomsContent(true);
            } else if (area === 'reviews') {
            	contentArea.classList.remove('hidden');
                loadReviewManageContent(true); // 리뷰 관리 fragment도 비동기로 로딩
            }
        }


        // [추가] roomList를 AJAX로 불러오는 함수
		function loadRoomsContent(forceReload = false) {
		    if (isRoomsContentLoaded && !forceReload) return;
		
		    const contentArea = document.getElementById('rooms-area');
		    contentArea.innerHTML = '<div class="loading">로딩 중...</div>';
		
		    fetch('/host/fragment/roomList')
		        .then(res => res.text())
		        .then(html => {
		            contentArea.innerHTML = html;
		            isRoomsContentLoaded = true;
		        })
		        .catch(err => {
		        	console.log("roomList fragment HTML:", html);
		            console.error("로딩 실패:", err);
		            contentArea.innerHTML = '<div class="no-data">콘텐츠를 불러오는 데 실패했습니다.</div>';
		        });
		}
        
		let isReviewManageContentLoaded = false;

		function loadStats(period, inputPeriodDetail = "") {
			  console.log("📥 loadStats 호출됨, period:", period);

			  let start = $("#weekCalendar_start").val();
			  let end = $("#weekCalendar_end").val();

			  // 값이 없으면 자동으로 계산
			  if (!start || !end) {
			    const today = new Date();
			    const range = getWeekRangeFromDate(today);
			    start = range.start;
			    end = range.end;

			    $("#weekCalendar_start").val(start);
			    $("#weekCalendar_end").val(end);
			  }

			  let finalPeriodDetail = inputPeriodDetail;

			  if (period === "week") {
			    finalPeriodDetail = start + "~" + end; // ✅ 핵심 수정
			    console.log("✅ 선택된 주간 날짜:", finalPeriodDetail);
			  }

			  // 월, 연도는 수동 입력 받도록 분기
			  if (period === "month" || period === "year") {
			    const manualInputDiv = document.getElementById("manualPeriodInput");
			    if (manualInputDiv) manualInputDiv.style.display = "flex";
			    return; // 수동입력 대기
			  }

			  requestStats(period, finalPeriodDetail); // ✅ 제대로 넘김
			}




  
        /*
        function fetchAvgRating(period) {
        	  $.ajax({
        	    url: "/host/stat/avgRating",
        	    method: "GET",
        	    data: { period: period },
        	    success: function (avgRating) {
        	      console.log("평균 평점:", avgRating);  // ← 콘솔 확인
        	      $("#avgReviewScore").text(avgRating.toFixed(1));
        	    },
        	    error: function (err) {
        	      console.error("평균 평점 오류:", err);
        	    }
        	  });
        	}
        	// 예: 기본 호출
        	fetchAvgRating("total");
		*/
		
			let currentPeriod = 'total'; // 전역 변수로 저장
			/* 0722 11:26
			function loadStats(period) {
			  currentPeriod = period;
	
			  // 날짜 수동 입력창 초기화
			  const manualDiv = document.getElementById('manualPeriodInput');
			  if (!manualDiv) return;`
	
			  if (period === 'month' || period === 'year') {
			    manualDiv.style.display = 'block'; // 수동입력 UI 보이기
			  } else {
			    manualDiv.style.display = 'none';
	
			    // 주간 처리: 시작/끝 추출
			    let periodDetail = '';
			    if (period === 'week') {
			      const start = document.getElementById('weekCalendar_start').value;
			      const end = document.getElementById('weekCalendar_end').value;
			      periodDetail = (start && end) ? `${start}~${end}` : '';
			    }
	
			    // 바로 통계 요청
			    requestStats(period, periodDetail);
			  }
			}
			*/
			function loadStats(period, inputPeriodDetail = "") {
				  console.log("📥 loadStats 호출됨, period:", period);

				  let finalPeriodDetail = inputPeriodDetail;

				  // ✅ 주간이면 무조건 input값을 사용한다 (내부 재계산 안함)
				  if (period === 'week') {
				    console.log("✅ 선택된 주간 날짜:", finalPeriodDetail);
				  }

				  // 월, 연도는 수동 입력 받도록
				  if (period === 'month' || period === 'year') {
				    const manualInputDiv = document.getElementById('manualPeriodInput');
				    if (manualInputDiv) manualInputDiv.style.display = 'flex';
				    return; // 수동입력 대기
				  }

				  requestStats(period, finalPeriodDetail); // 제대로 넘김
				}








			
	
			// 수동 입력 버튼 클릭 시 호출
			function onSubmitManualInput() {
			  const year = document.getElementById('yearInput').value;
			  const month = document.getElementById('monthInput').value;
	
			  let periodDetail = '';
			  if (currentPeriod === 'month') {
			    if (!year || !month) return alert("연도와 월을 모두 입력하세요.");
			    const paddedMonth = ('0' + month).slice(-2);
			    periodDetail = `${year}-${paddedMonth}`;
			  } else if (currentPeriod === 'year') {
			    if (!year) return alert("연도를 입력하세요.");
			    periodDetail = year;
			  }
	
			  requestStats(currentPeriod, periodDetail);
			}
			
			
			function formatCurrency(amount) {
				  return amount.toLocaleString('ko-KR') + '원';
			}


				
			// 수동 입력 이후 호출되는 함수
			function requestStats(period, detail = '') {
			  // 월간 수동 입력 처리
			  if (period === 'month') {
			    const year = document.getElementById('yearInput').value;
			    const month = document.getElementById('monthInput').value;
			    if (!year || !month) {
			      alert("연도와 월을 모두 입력하세요.");
			      return;
			    }
			    const paddedMonth = ('0' + month).slice(-2);
			    detail = `${year}-${paddedMonth}`;
			  }
			  // 연간 수동 입력 처리
			  else if (period === 'year') {
			    const year = document.getElementById('yearInput').value;
			    if (!year) {
			      alert("연도를 입력하세요.");
			      return;
			    }
			    detail = year;
			  }
			
			  $.get('/host/statistics', {
			    period: period,
			    periodDetail: detail
			  }, function(res) {
			    console.log("통계 응답:", res);
			    $('#totalSales').text(res.totalSales);
			    $('#totalAmount').text(formatCurrency(res.totalAmount));
			    $('#avgReviewScore').text(res.avgRating.toFixed(1));
			  }).fail(function(err) {
			    console.error("통계 요청 실패:", err);
			  });
			}



       			
    </script>
    
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>







<style>
/**
* 네비게이션
*/
.site-nav {
  position: relative;
  top: 0;
  width: 100%;
  z-index: 999;
  height: 120px;
}
.main-content {
  padding-top: 120px; /* .site-nav 높이만큼 여백 줌 */
}

/**
* 대시보드 하단 기간 입력 공간
*/
.period-selector {
  margin-top: 20px;
  text-align: center;
}

.btn-group {
  display: flex;
  justify-content: center;
  gap: 10px;
  flex-wrap: wrap;
  margin-bottom: 10px;
}

.btn-period {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 8px 16px;
  font-size: 14px;
  border-radius: 6px;
  cursor: pointer;
  transition: 0.2s;
}
.btn-period:hover {
  background-color: #2980b9;
}

.manual-inputs {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  margin-top: 10px;
  display: none; /* JS로 동적 표시 */
}

.manual-inputs input {
  width: 120px;
  padding: 6px;
  border: 1px solid #ccc;
  border-radius: 6px;
}


</style>

<script src="/resources/js/host/roomList.js?v=1"></script>