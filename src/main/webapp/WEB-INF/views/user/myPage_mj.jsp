<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>마이페이지</title>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <style>
        /* 기존 마이페이지 스타일 유지 */
        body {
            background-color: #f8f9fa;
            padding-bottom: 40px;
        }
        .mypage-wrapper {
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }
        .mypage-card {
            display: flex;
            width: 100%;
            max-width: 1000px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,.1);
            min-height: 700px;
        }
        .mypage-sidebar {
            width: 250px;
            padding: 30px 20px;
            border-right: 1px solid #eee;
            background-color: #f8f9fa;
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }
        .mypage-sidebar h4 {
            margin-bottom: 25px;
            font-weight: bold;
            color: #333;
        }
        .mypage-sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .mypage-sidebar li {
            margin-bottom: 10px;
        }
        .mypage-sidebar a {
            display: block;
            padding: 10px 15px;
            color: #495057;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.2s, color 0.2s;
        }
        .mypage-sidebar a:hover {
            background-color: #e9ecef;
            color: #007bff;
        }
        .mypage-sidebar a.active {
            background-color: #007bff;
            color: #fff;
            font-weight: bold;
        }

        .mypage-content {
            flex-grow: 1;
            padding: 30px;
        }

        /* --- 새로 추가되거나 수정될 스타일 --- */
        .mypage-summary-box {
            display: flex; /* 내부 요소들을 가로로 배치 */
            justify-content: space-around; /* 요소들 사이에 균등한 공간 배분 */
            align-items: center; /* 수직 가운데 정렬 */
            background-color: #eaf6ff; /* 연한 파란색 배경 (정보 박스) */
            border: 1px solid #cce5ff; /* 테두리 */
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px; /* 아래 섹션과의 간격 */
            text-align: center;
        }

        .mypage-summary-item {
            flex: 1; /* 각 항목이 공간을 균등하게 차지 */
            padding: 0 10px;
        }

        .mypage-summary-item h4 {
            margin-bottom: 5px;
            color: #0056b3; /* 짙은 파란색 */
            font-size: 1.2rem;
        }

        .mypage-summary-item p {
            margin: 0;
            font-size: 2rem; /* 큰 숫자 강조 */
            font-weight: bold;
            color: #007bff; /* 파란색 */
        }
        
        .mypage-content h3 {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #007bff;
            color: #333;
            font-size: 1.8rem;
        }

        /* 각 섹션 내 폼/테이블 스타일 (기존 유지) */
        .mypage-content form .form-group {
            margin-bottom: 20px;
        }
        .mypage-content form label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .mypage-content form .form-control {
            width: 100%;
            max-width: 400px;
            padding: 10px 15px;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            font-size: 1rem;
        }
        .mypage-content form .btn {
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: .25rem;
        }
        .mypage-content table.table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .mypage-content table.table th,
        .mypage-content table.table td {
            padding: 12px;
            border: 1px solid #dee2e6;
            text-align: left;
        }
        .mypage-content table.table thead th {
            background-color: #e9ecef;
            font-weight: bold;
            color: #495057;
        }
        .mypage-content table.table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .mypage-content .no-data {
            text-align: center;
            padding: 30px;
            color: #6c757d;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function(){
            const urlParams = new URLSearchParams(window.location.search);
            const currentSection = urlParams.get('section');

            if (currentSection) {
                $(`#menu-${currentSection}`).addClass("active");
            } else {
                $("#menu-editInfo").addClass("active"); // 기본 활성화 메뉴
            }

            // 사이드바 메뉴 클릭 이벤트 처리
            $(".mypage-sidebar a").on("click", function(e) {
                const href = $(this).attr("href");

                // '회원정보 수정' 메뉴 클릭 시 별도 페이지로 이동
                if (href === "/user/updateForm_mj") {
                    // 기본 동작을 허용하여 페이지를 새로 로드합니다.
                    return true;
                }

                e.preventDefault(); // 다른 메뉴들은 기본 동작 방지 (새로고침 없이 콘텐츠 전환)

                $(".mypage-sidebar a").removeClass("active");
                $(this).addClass("active");

                const targetSection = $(this).attr("id").replace("menu-", "");
                history.pushState(null, '', `?section=${targetSection}`);
                loadMyPageContent(targetSection);
            });

            // 페이지 로드 시 초기 콘텐츠 로드
            loadMyPageContent(currentSection || 'editInfo');

            function loadMyPageContent(section) {
                $(".mypage-section").hide(); // 모든 섹션 숨기기
                
                // section이 'editInfo'인 경우를 제외하고 (별도 페이지로 이동할 예정이므로)
                // 현재 페이지 내에서 보여줄 섹션만 show()
                if (section !== 'editInfo') {
                    $(`#section-${section}`).show();
                } else if (!currentSection) { // URL에 section 파라미터가 없으면 '회원정보 수정' 콘텐츠를 보여줌
                                               // (혹은 마이페이지 소개 화면 등을 보여줄 수 있음)
                    // 현재는 'editInfo' 섹션 자체를 별도 페이지로 넘기므로,
                    // 이 else if 블록에서는 다른 기본 환영 메시지 등을 보여줄 수 있습니다.
                    // 예를 들어,
                    $("#section-welcome").show(); // 환영 메시지 섹션을 만들어 보여줄 수 있음
                }

                // AJAX로 콘텐츠를 로드하는 경우의 주석은 그대로 둡니다.
            }
        });
    </script>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<br/><br/>
    <div class="container mypage-wrapper">
        <div class="mypage-card">
            <div class="mypage-sidebar">
                <h4>마이페이지</h4>
                <ul>
                    <li><a href="/user/updateForm_mj" id="menu-editInfo">회원정보 수정</a></li> <%-- 이 링크는 별도 페이지로 이동 --%>
                    <li><a href="?section=payments" id="menu-payments">결제 내역</a></li>
                    <li><a href="?section=posts" id="menu-posts">내가 쓴 게시글</a></li>
                    <li><a href="?section=wishlist" id="menu-wishlist">위시리스트</a></li>
                    <li><a href="?section=cart" id="menu-cart">장바구니</a></li> <%-- 장바구니 추가 --%>
                    <li><a href="/user/deleteForm_mj" id="menu-deactivate">회원 탈퇴</a></li>
                    <%-- 기타 메뉴 추가 --%>
                </ul>
            </div>

            <div class="mypage-content">
                <div class="mypage-summary-box">
                    <div class="mypage-summary-item">
                        <h4>마일리지</h4>
                        <p><fmt:formatNumber value="${user.mile}" pattern="#,###"/>P</p>
                    </div>
                    <div class="mypage-summary-item">
                        <h4>총 쿠폰</h4>
                        <p><fmt:formatNumber value="${user.mile}" pattern="#,###"/>개</p>
                    </div>
                    <div class="mypage-summary-item">
                        <h4>등급</h4>
                        <p>"${user.grade}"</p>
                    </div>
                </div>

                <div id="section-welcome" class="mypage-section" style="display:none;">
                    <h3>환영합니다, ${user.userName}님!</h3>
                    <p>마이페이지에서 회원 정보를 관리하고 서비스 이용 내역을 확인하세요.</p>
                    <p>왼쪽 메뉴를 클릭하여 원하는 정보를 확인하실 수 있습니다.</p>
                    <p>현재 마일리지와 보유 쿠폰 정보를 확인해 보세요!</p>
                </div>

                <div id="section-payments" class="mypage-section" style="display:none;">
                    <h3>결제 내역</h3>
                    <p>최근 결제하신 내역을 확인하실 수 있습니다.</p>
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

                <div id="section-posts" class="mypage-section" style="display:none;">
                    <h3>내가 쓴 게시글</h3>
                    <p>회원님이 작성하신 게시글 목록입니다.</p>
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
                                <c:when test="${not empty postList}">
                                    <c:forEach var="post" items="${postList}">
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

                <div id="section-wishlist" class="mypage-section" style="display:none;">
                    <h3>찜 목록</h3>
                    <p>회원님이 찜한 상품 또는 콘텐츠 목록입니다.</p>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>상품명</th>
                                <th>가격</th>
                                <th>추가일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty wishList}">
                                    <c:forEach var="item" items="${wishList}">
                                        <tr>
                                            <td>${item.productName}</td>
                                            <td><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</td>
                                            <td>${item.addedDate}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="no-data">찜한 상품이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div id="section-cart" class="mypage-section" style="display:none;">
                    <h3>장바구니</h3>
                    <p>장바구니에 담긴 상품 목록입니다.</p>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>상품명</th>
                                <th>수량</th>
                                <th>가격</th>
                                <th>총 가격</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty cartList}">
                                    <c:forEach var="item" items="${cartList}">
                                        <tr>
                                            <td>${item.productName}</td>
                                            <td><fmt:formatNumber value="${item.quantity}" pattern="#,###"/></td>
                                            <td><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</td>
                                            <td><fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>원</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="no-data">장바구니가 비어 있습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div class="text-right mt-3">
                        <strong>총 결제 예정 금액: <fmt:formatNumber value="${cartTotalAmount}" pattern="#,###"/>원</strong>
                        <button type="button" class="btn btn-success ml-3">주문하기</button>
                    </div>
                </div>


            </div> <%-- .mypage-content 끝 --%>
        </div> <%-- .mypage-card 끝 --%>
    </div> <%-- .mypage-wrapper 끝 --%>

    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>