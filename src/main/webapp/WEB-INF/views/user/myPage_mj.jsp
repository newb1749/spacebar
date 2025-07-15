<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- fmt 태그 라이브러리 추가 --%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <%@ include file="/WEB-INF/views/include/head.jsp" %> <%-- 기존 head.jsp 포함 --%>
<style>
/* 초기 CSS를 새로운 구조에 맞춰 재조정 */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Arial', sans-serif;
    background-color: #f5f5f5;
    padding-bottom: 40px; /* 푸터를 위한 하단 여백 */
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    gap: 20px;
    padding-top: 50px; /* 상단 네비게이션과의 간격 */
}

.sidebar {
    width: 250px;
    background: white;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    height: fit-content;
}

.sidebar h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 18px;
}

.menu-item {
    padding: 12px 15px;
    margin-bottom: 5px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s ease;
    color: #666;
    font-size: 14px;
}

.menu-item:hover {
    background-color: #f0f0f0;
    color: #333;
}

.menu-item.active {
    background-color: #3B5B6D;
    color: #FFFFFF;
    font-weight: bold;
}

.main-content {
    flex: 1;
    background: white;
    border-radius: 10px;
    padding: 30px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.stats-container {
    display: flex;
    gap: 20px;
    margin-bottom: 30px;
}

.stat-card {
    flex: 1;
    text-align: center;
    padding: 20px;
    background: #e3f2fd;
    border-radius: 10px;
    transition: transform 0.3s ease;
}

.stat-card:hover {
    transform: translateY(-5px);
}

.stat-number {
    font-size: 24px;
    font-weight: bold;
    color: #1976d2;
    margin-bottom: 5px;
}

.stat-label {
    color: #666;
    font-size: 14px;
}

.content-area {
    background: #f8f9fa;
    border-radius: 10px;
    padding: 40px;
    text-align: center;
    min-height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    /* 기본적으로 숨겨진 상태로 시작 */
    display: none;
}

.content-area:not(.hidden) {
    display: flex; /* hidden 클래스가 없으면 보이도록 */
}


.arrow {
    width: 0;
    height: 0;
    border-left: 20px solid transparent;
    border-right: 20px solid transparent;
    border-top: 30px solid #4CAF50;
    margin: 20px 0;
    position: relative;
    animation: bounce 2s infinite;
}

.arrow::before {
    content: '';
    position: absolute;
    top: -35px;
    left: -10px;
    width: 20px;
    height: 20px;
    background: #4CAF50;
    border-radius: 3px;
}

@keyframes bounce {
    0%, 20%, 50%, 80%, 100% {
        transform: translateY(0);
    }
    40% {
        transform: translateY(-10px);
    }
    60% {
        transform: translateY(-5px);
    }
}

.welcome-message {
    font-size: 20px;
    color: #333;
    margin-bottom: 10px;
}

.sub-message {
    color: #666;
    font-size: 14px;
}

.hidden {
    display: none !important; /* JavaScript에서 hidden 클래스를 사용하여 숨김 */
}

.detail-content {
    text-align: left;
    padding: 20px;
    background: white;
    border-radius: 10px;
    margin-top: 20px;
    width: 100%; /* 너비 조정 */
}

.detail-content h3 {
    color: #333;
    margin-bottom: 15px;
}

.detail-content p, .detail-content ul {
    color: #666;
    line-height: 1.6;
}

.detail-content ul {
    list-style: none; /* 리스트 스타일 제거 */
    padding-left: 0;
}
.detail-content li {
    margin-bottom: 8px;
}

/* 테이블 스타일 */
.table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

.table th, .table td {
    padding: 12px;
    border: 1px solid #ddd;
    text-align: left;
}

.table thead th {
    background-color: #f2f2f2;
    font-weight: bold;
}

.table tbody tr:nth-child(even) {
    background-color: #f9f9f9;
}

.no-data {
    text-align: center;
    padding: 20px;
    color: #888;
}

.text-right {
    text-align: right;
}
.mt-3 {
    margin-top: 1rem;
}
.ml-3 {
    margin-left: 1rem;
}
.btn {
    display: inline-block;
    padding: 10px 20px;
    font-size: 1rem;
    cursor: pointer;
    border-radius: 5px;
    text-decoration: none;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    border: 1px solid transparent;
}
.btn-success {
    color: #fff;
    background-color: #28a745;
    border-color: #28a745;
}
.btn-success:hover {
    background-color: #218838;
    border-color: #1e7e34;
}
    
.info-item {
	font-size: 1.2em; /* info-item 안의 모든 텍스트를 크게 만듭니다 */
	margin-bottom: 10px; /* 각 항목 간의 간격을 늘립니다 (선택 사항) */
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<br/><br/><br/><br/><br/>
    <div class="container">
        <div class="sidebar">
            <h2>마이페이지</h2>
            <div class="menu-item"  onclick="showContent('editInfo')">회원정보 수정</div>
            <div class="menu-item"  onclick="showContent('coupon')">쿠폰내역</div>
            <div class="menu-item"  onclick="showContent('payments')">결제 내역</div>
            <div class="menu-item"  onclick="showContent('mile')">마일리지 충전 내역</div>
            <div class="menu-item"  onclick="showContent('posts')">내가 쓴 게시글</div>
            <div class="menu-item"  onclick="showContent('wishlist')">위시리스트</div>
            <div class="menu-item"  onclick="showContent('cart')">장바구니</div>
            <div class="menu-item"  onclick="showContent('deactivate')">회원 탈퇴</div>
        </div>

        <div class="main-content">
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-number"><fmt:formatNumber value="${user.mile}" pattern="#,###"/>P</div>
                    <div class="stat-label">마일리지</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${not empty couponCount}">
                                <fmt:formatNumber value="${couponCount}" pattern="#,###"/>개
                            </c:when>
                            <c:otherwise>
                                0개
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">총 쿠폰</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><c:out value="${user.grade}"/></div>
                    <div class="stat-label">등급</div>
                </div>
            </div>
			
			<%-- 초기 활성화될 섹션 --%>
			<div id="home-content" class="content-area">
			    <h3>환영합니다, <c:out value="${user.userName}"/>님!</h3>
			    <p>마이페이지에서 회원 정보를 관리하고 서비스 이용 내역을 확인하세요.</p>
			    <p>왼쪽 메뉴를 클릭하여 원하는 정보를 확인하실 수 있습니다.</p>
			    <p>현재 마일리지와 보유 쿠폰 정보를 확인해 보세요!</p>
			</div>


            <%-- 각 섹션별 콘텐츠 --%>
            <%-- 회원정보 수정 --%>
            <div id="editInfo-content" class="content-area hidden">
                <div class="welcome-message">회원정보 수정</div>
                <div class="sub-message">회원정보를 확인하실 수 있습니다.</div>
                <div class="detail-content">
                    <h3>회원정보</h3>
                    <div class="info-item">
                        <span class="info-label">이름 :</span>
                        <span class="info-value">${user.userName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">연락처 :</span>
                        <span class="info-value">${user.phone}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">주소 :</span>
                        <span class="info-value">${user.userAddr}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">이메일 :</span>
                        <span class="info-value">${user.email}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">가입일 :</span>
                        <span class="info-value">${user.joinDt}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">등급 :</span>
                        <span class="info-value">${user.grade}</span>
                    </div>
                </div>
                <button type="button" id="btnUpdate" class="btn btn-primary mt-3">수정하기</button>
            </div>
           
			<%-- 쿠폰내역 --%>
            <div id="coupon-content" class="content-area hidden"> 
                <div class="welcome-message">쿠폰내역</div>
                <div class="arrow"></div>
                <div class="sub-message">보유하고 계신 쿠폰 목록입니다.</div>
                <div class="detail-content">
                    <h3>보유 쿠폰</h3>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>쿠폰명</th>
                                <th>할인율/금액</th>
                                <th>유효기간</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty couponList}">
                                    <c:forEach var="coupon" items="${couponList}">
                                        <tr>
                                            <td>${coupon.couponName}</td>
                                            <td>${coupon.discountInfo}</td> <%-- 예: 10% 또는 5000원 --%>
                                            <td>${coupon.expiryDate}</td>
                                            <td>${coupon.status}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="no-data">보유하신 쿠폰이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

			<%-- 예약 내역 --%><!-- ------------------수정필요------------------ -->
            <div id="payments-content" class="content-area hidden">
                <div class="welcome-message">결제 내역</div>
                <div class="sub-message">최근 결제하신 내역을 확인하실 수 있습니다.</div>
                <div class="detail-content">
                    <h3>결제 내역</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>상품명</th>
                                <th>결제일</th>
                                <th>금액</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty paymentList}">
                                    <c:forEach var="payment" items="${paymentList}">
                                        <tr>
                                            <td>${payment.orderNo}</td>
                                            <td>${payment.productName}</td>
                                            <td>${payment.paymentDate}</td>
                                            <td><fmt:formatNumber value="${payment.amount}" pattern="#,###"/>원</td>
                                            <td>${payment.status}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="no-data">결제 내역이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            
           <%-- 마일리지 충전 내역 --%><!-- ------------------수정필요------------------ -->
            <div id="mile-content" class="content-area hidden">
                <div class="welcome-message">마일리지 충전 내역</div>
                <div class="sub-message">마일리지 충전하신 내역을 확인하실 수 있습니다.</div>
                <div class="detail-content">
                    <h3>마일리지 충전 내역</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>결제일</th>
                                <th>금액</th>
                                <th>유형</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty mileHistory}">
                                    <c:forEach var="mile" items="${mileHistory}">
                                        <tr>
                                            <td>${mile.trxDt}</td>
                                            <td><fmt:formatNumber value="${mile.trxAmt}" pattern="#,###"/>P</td>
                                            <td>${mile.trxType}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="no-data">결제 내역이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

			<%-- 내가 쓴 게시글 --%><!-- ------------------수정필요------------------ -->
            <div id="posts-content" class="content-area hidden">
                <div class="welcome-message">내가 쓴 게시글</div>
                <div class="sub-message">회원님이 작성하신 게시글 목록입니다.</div>
                <div class="detail-content">
                    <h3>내가 쓴 게시글</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>제목</th>
                                <th>게시판</th>
                                <th>작성일</th>
                                <th>조회수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty freeBoard}">
                                    <c:forEach var="post" items="${freeBoard}">
                                        <tr>
                                            <td><a href="/board/view?postNo=${post.postNo}">${post.title}</a></td>
                                            <td>${post.boardName}</td>
                                            <td>${post.regDate}</td>
                                            <td><fmt:formatNumber value="${post.viewCount}" pattern="#,###"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="no-data">작성하신 게시글이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

			<%-- 위시리스트 --%><!-- ------------------수정필요------------------ -->


			<%-- 장바구니 --%><!-- ------------------수정필요------------------ -->

            
            <%-- 회원 탈퇴 --%>
            <div id="deactivate-content" class="content-area hidden">
                <div class="welcome-message">회원 탈퇴</div>
                <div class="sub-message">회원 탈퇴는 신중하게 결정해주세요.</div>
                <div class="detail-content">
                    <h3>회원 탈퇴 안내</h3>
                    <p>회원 탈퇴 시 모든 회원 정보 및 서비스 이용 내역이 삭제되며, 복구할 수 없습니다.</p>
                    <p>탈퇴를 진행하시려면 아래 버튼을 눌러주세요.</p>
                    <%-- 여기에 회원 탈퇴 관련 폼 또는 버튼 추가 --%>
                    <button type="button" id="btnDelete" class="btn btn-danger mt-3">회원 탈퇴 진행</button>
                </div>
            </div>

            <%-- 새로운 HTML 코드에 있던 "회원 달력" 등 더미 콘텐츠들은 기존 JSP에 매핑되는 내용이 없으므로, 필요하면 추가 데이터를 백엔드에서 받아와서 구현해야 합니다. 여기서는 기존 JSP에 있던 마이페이지 메뉴와 매칭되는 부분만 반영했습니다. --%>
        </div>
    </div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script>
    function showContent(contentType) {
        // 모든 콘텐츠 숨기기
        const contents = document.querySelectorAll('.content-area');
        contents.forEach(content => {
            content.classList.add('hidden');
        });
        
        // 모든 메뉴 아이템에서 active 클래스 제거
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => {
            item.classList.remove('active');
        });
        
        // 선택된 콘텐츠 보이기
        const selectedContent = document.getElementById(contentType + '-content');
        if (selectedContent) {
            selectedContent.classList.remove('hidden');
        }
        
        // 클릭된 메뉴 아이템에 active 클래스 추가
        event.target.classList.add('active');
    }
    
    $(document).ready(function(){
        $("#btnUpdate").on("click",function(){
        	location.href = "/user/updateForm_mj";	
        });
        
        $("#btnDelete").on("click",function(){
        	location.href = "/user/deleteForm_mj";	
        });
    });

    
</script>
</body>
</html>       