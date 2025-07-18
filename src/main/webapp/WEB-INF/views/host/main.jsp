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
                    <h3>판매 내역</h3>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>예약번호</th>
                                <th>숙소명</th>
                                <th>결제일시</th>
                                <th>결제금액</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1001</td>
                                <td>강릉오션뷰펜션</td>
                                <td>2025-07-14 11:23</td>
                                <td>200,000원</td>
                                <td>완료</td>
                            </tr>
                            <tr>
                                <td>1000</td>
                                <td>서울강남모던하우스</td>
                                <td>2025-07-12 20:51</td>
                                <td>350,000원</td>
                                <td>취소</td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="no-data">더 많은 판매내역은 추후 API 연동</div>
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
