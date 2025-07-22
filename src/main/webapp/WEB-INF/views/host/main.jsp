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
    </style>
</head>
<body>
    <div class="container">
        <!-- 사이드바 -->
        <div class="sidebar">
            <h2>판매자 메뉴</h2>
            <div class="menu-item active" onclick="showContent('dashboard')">대시보드</div>
            <div class="menu-item" onclick="showContent('sales')">판매 내역</div>
            <div class="menu-item" onclick="showContent('rooms')">객실/공간 관리</div>
            <div class="menu-item" onclick="showContent('reviews')">리뷰 관리</div>
            <div class="menu-item" onclick="showContent('profile')">내 정보</div>
        </div>

        <!-- 메인 컨텐츠 -->
        <div class="main-content">
            <!-- 통계 카드 영역 -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-number">1,230</div>
                    <div class="stat-label">총 판매 건수</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">15,600,000원</div>
                    <div class="stat-label">누적 정산 금액</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">4.8</div>
                    <div class="stat-label">평균 리뷰 평점</div>
                </div>
            </div>

            <!-- 대시보드 -->
            <div class="content-area" id="dashboard-area">
                <div class="welcome-message">안녕하세요, <strong>${sessionScope.SESSION_USER_NAME}</strong> 판매자님!</div>
                <div class="sub-message">오늘도 좋은 하루 되세요. 아래에서 판매 현황, 예약 현황, 주요 알림을 확인하세요.</div>
                <div class="arrow"></div>
            </div>

            <!-- 판매 내역 -->
            <div class="content-area hidden" id="sales-area">
                <div class="detail-content">	
                	<h3>숙소/공간 판매 내역</h3>
			        <c:choose>
			            <c:when test="${!empty reservations}"> 
			            <c:forEach var="res" items="${reservations}" >
							<div class="info-item mb-3 border p-3 mt-3 shadow-sm rounded">
							  <div class="row g-3 align-items-center">
						    	 <div class="col-md-6">
							      <div class="cart-img">
							        <img src="/resources/upload/roomtype/main/${res.roomTypeImgName}" alt="숙소 이미지"
							             style="width: 100%; height: auto; border-radius: 12px; object-fit: cover; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
							      </div>
							     </div>
							    <div class="col-md-6 d-flex flex-column justify-content-center align-items-start" style="height: 100%;">
									<table class="table table-bordered table-sm" style="font-size: 0.95rem;">
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
									      <th>상태</th>
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
			    </div>
			</div>

            <!-- 객실/공간 관리 -->
            <div class="content-area hidden" id="rooms-area">
                <div class="detail-content">
                    <h3>내 객실/공간 목록</h3>
                    <ul>
                        <li>강릉오션뷰펜션 (판매중)</li>
                        <li>서울강남모던하우스 (비공개)</li>
                    </ul>
                    <a href="/room/addForm" class="btn btn-success mt-3">+ 객실 추가</a>
                </div>
            </div>

            <!-- 리뷰 관리 -->
            <div class="content-area hidden" id="reviews-area">
                <div class="detail-content">
                    <h3>받은 리뷰</h3>
                    <ul>
                        <li>★★★★★ "깨끗하고 뷰가 좋았어요!" (2025-07-10)</li>
                        <li>★★★★☆ "위치는 좋은데 주변이 조금 시끄러움" (2025-07-05)</li>
                    </ul>
                    <div class="no-data">실제 리뷰 연동 예정</div>
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
    	let isRoomsContentLoaded = false;
    
        // 메뉴 클릭 시 컨텐츠 전환 함수 
        function showContent(area) {
            // 모든 메뉴, 컨텐츠 초기화
            document.querySelectorAll('.menu-item').forEach(item => item.classList.remove('active'));
            document.querySelectorAll('.content-area').forEach(item => item.classList.add('hidden'));
            document.querySelector('.menu-item[onclick*="' + area + '"]').classList.add('active');
            const contentArea = document.getElementById(area + '-area');
            contentArea.classList.remove('hidden');

            // [수정] '객실/공간 관리' 메뉴를 클릭했고, 아직 로딩된 적이 없다면 AJAX 요청
            if (area === 'rooms' && !isRoomsContentLoaded) {
                loadRoomsContent();
            }
        }

        // [추가] roomList를 AJAX로 불러오는 함수
        function loadRoomsContent() {
            const contentArea = document.getElementById('rooms-area');
            contentArea.innerHTML = '<div class="loading">로딩 중...</div>';

            // fetch URL은 이전 답변의 컨트롤러 경로에 맞춰주세요.
            fetch('/host/fragment/roomList') 
                .then(response => {
                    if (!response.ok) {
                        throw new Error('데이터 로딩 실패');
                    }
                    return response.text();
                })
                .then(html => {
                    contentArea.innerHTML = html;
                    // [추가] 로딩이 성공하면, 변수를 true로 바꿔서 다시는 로딩하지 않도록 설정
                    isRoomsContentLoaded = true;
                })
                .catch(error => {
                    console.error('Error:', error);
                    contentArea.innerHTML = '<div class="no-data">콘텐츠를 불러오는 데 실패했습니다.</div>';
                });
        }

        // 최초 진입시 대시보드 보이도록
        window.onload = function() {
            showContent('dashboard');
        };
    </script>
</body>
</html>
