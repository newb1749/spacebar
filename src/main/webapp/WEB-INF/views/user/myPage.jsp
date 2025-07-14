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
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="/resources/css/myPage.css">
<link rel="stylesheet" href="/resources/css/cart.css">
<link rel="stylesheet" href="/resources/css/wishList.css">
<link rel="stylesheet" href="/resources/css/mileage.css">
<link rel="stylesheet" href="/resources/css/reservation.css">
<script>

//==========================위시리스트 시작==========================//
// 찜 취소 예시 (AJAX)
function removeWish(roomSeq, element) {
  Swal.fire({
    title: "찜 해제하시겠습니까?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#e74c3c",
    cancelButtonColor: "#aaa",
    confirmButtonText: "네, 삭제할게요",
    cancelButtonText: "아니요"
  }).then((result) => {
    if (result.isConfirmed) {
      $.ajax({
        type: "POST",
        url: "/wishlist/remove",
        data: { roomSeq: roomSeq },
        success: function(response) {
          if(response.code === 0) {
            Swal.fire("삭제 완료", "찜에서 제거됐습니다.", "success");
            $(element).closest(".wishlist-item").fadeOut(300, function() {
              $(this).remove();
            });
          }
        }
      });
    }
  });
}
  
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
      } else {
        Swal.fire("오류", res.message, "error");
      }
    })
    .fail(function() {
      Swal.fire("네트워크 오류", "잠시 후 다시 시도해주세요.", "error");
    });
}
//==========================위시리스트 끝==========================//
//==========================장바구니 시작==========================//
// 삭제
function deleteCart(cartSeq) {
  if (!confirm("정말 삭제하시겠습니까?")) return;
  $.post("${pageContext.request.contextPath}/cart/delete", { cartSeq }, function(res) {
    if (res.code === 0) location.reload();
    else alert("삭제 실패: " + res.message);
  });
}

// 체크박스 선택 요약
$(function(){
  function updateSummary(){
    let cnt=0, amt=0;
    $('.itemCheckbox:checked').each(function(){
      cnt++;
      amt += parseInt($(this).data('amt'),10) || 0;
    });
    $('#summaryCnt').text(cnt);
    $('#summaryAmt').text(amt.toLocaleString());
    $('#btnCheckout').prop('disabled', cnt===0);
  }
  $('#selectAll').on('change', function(){
    $('.itemCheckbox').prop('checked', this.checked);
    updateSummary();
  });
  $(document).on('change', '.itemCheckbox', function(){
    $('#selectAll').prop(
      'checked',
      $('.itemCheckbox').length === $('.itemCheckbox:checked').length
    );
    updateSummary();
  });
  updateSummary();
});
//==========================장바구니 끝==========================//
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

    <div class="container">
        <div class="sidebar">
            <h2>마이페이지</h2>
            <c:if test="${user.userType == 'H'}">
	            <div class="menu-item"  onclick="showContent('roomHost')">내 숙소 / 공간 관리</div>
            </c:if>
	            <div class="menu-item"  onclick="showContent('editInfo')">회원정보 수정</div>
	            <div class="menu-item"  onclick="showContent('coupon')">쿠폰내역</div>
	            <div class="menu-item"  onclick="showContent('reservation')">예약 내역</div>
	            <div class="menu-item"  onclick="showContent('mile')">마일리지 충전 내역</div>
	            <div class="menu-item"  onclick="showContent('posts')">내가 쓴 게시글</div>
	            <div class="menu-item"  onclick="showContent('wishlist')">위시리스트</div>
	            <div class="menu-item"  onclick="showContent('cart')">장바구니</div>
	            <div class="menu-item"  onclick="showContent('deactivate')">회원 탈퇴</div>
        </div>

        <div class="main-content">
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-number"><fmt:formatNumber value="${user.mile}" pattern="#,###"/>원</div>
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
            <!-- 호스트일때 숙소/공간 정보 관리 -->
			<div id="roomHost-content" class="content-area hidden">
			    <div class="welcome-message">숙소/공간 정보 관리</div>
			    <div class="sub-message">호스트님이 등록하신 숙소/공간의 상세 정보를 확인하고 수정/삭제할 수 있습니다.</div>
			    <div class="detail-content">
			        <h3>등록된 숙소/공간 상세 정보</h3>
			        <c:choose>
			            <c:when test="${!empty hostRoomList}"> 
			            <c:forEach var="room" items="${hostRoomList}">
							<div class="info-item mb-3 border p-3 mt-3 shadow-sm rounded">
							  <div class="row g-3 align-items-center">
						    	 <div class="col-md-6">
							      <div class="cart-img">
							        <img src="/resources/upload/room/main/${room.roomImgName}"
							             alt="숙소 이미지"
							             style="width: 190%; height: auto; border-radius: 12px; object-fit: cover; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
							      </div>
							     </div>
							    <div class="col-md-6 d-flex flex-column justify-content-center align-items-center" style="height: 100%;">
							    <p class="mb-3 fs-5"><strong>숙소명:</strong> ${room.roomTitle}</p>
						        <div class="d-flex flex-row justify-content-center gap-3">
						          <button type="button" class="btn btn-primary btn"
						                  onclick="location.href='/room/hostUpdateForm?roomSeq=${room.roomSeq}'">수정하기</button>
						          <button type="button" class="btn btn-danger btn"
						                  onclick="hostDeleteRoom('${room.roomSeq}')">삭제하기</button>
						        </div>  
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
			
			        <h3 class="mt-5">숙소/공간 예약 내역</h3>
			        <div class="sub-message">호스트님 숙소와 관련된 모든 예약 및 결제 내역입니다.</div>
			        <c:if test="${empty reservations}">
			            <div class="alert alert-info text-center">예약 내역이 없습니다.</div>
			        </c:if>
			        <c:if test="${not empty reservations}">
			            <table class="table table-hover">
			                <thead>
			                    <tr>
			                        <th>예약번호</th>
			                        <th>숙소명</th> <th>객실유형</th>
			                        <th>체크인</th>
			                        <th>체크아웃</th>
			                        <th>상태</th>
			                        <th>결제상태</th>
			                        <th>총금액</th>
			                        <th>관리</th>
			                    </tr>
			                </thead>
			                <tbody>
			                    <c:forEach var="r" items="${reservations}">
			                        <tr>
			                            <td>${r.rsvSeq}</td>
			                            <td></td> <td>${r.roomTypeSeq}</td>
			                            <td><fmt:formatDate value="${r.rsvCheckInDateObj}" pattern="yyyy-MM-dd"/></td>
			                            <td><fmt:formatDate value="${r.rsvCheckOutDateObj}" pattern="yyyy-MM-dd"/></td>
			                            <td>
			                                <c:choose>
			                                    <c:when test="${r.rsvStat eq 'CONFIRMED'}">예약완료</c:when>
			                                    <c:when test="${r.rsvStat eq 'CANCELED'}">예약취소</c:when>
			                                    <c:when test="${r.rsvStat eq 'PENDING'}">결제대기</c:when>
			                                    <c:otherwise>-</c:otherwise>
			                                </c:choose>
			                            </td>
			                            <td>
			                                <c:choose>
			                                    <c:when test="${r.rsvPaymentStat eq 'PAID'}">결제완료</c:when>
			                                    <c:when test="${r.rsvPaymentStat eq 'UNPAID'}">미결제</c:when>
			                                    <c:when test="${r.rsvPaymentStat eq 'CANCELED'}">결제취소</c:when>
			                                    <c:otherwise>-</c:otherwise>
			                                </c:choose>
			                            </td>
			                            <td class="amount">
			                                <fmt:formatNumber value="${r.finalAmt}" groupingUsed="true"/> 원
			                            </td>
			                            <td>
			                                <c:if test="${r.rsvStat eq 'CONFIRMED'}">
			                                    <form action="${pageContext.request.contextPath}/reservation/cancel" method="post" onsubmit="return confirm('이 예약을 정말 취소(환불)하시겠습니까?')">
			                                        <input type="hidden" name="rsvSeq" value="${r.rsvSeq}" />
			                                        <button type="submit" class="btn btn-sm btn-danger">환불</button>
			                                    </form>
			                                </c:if>
			                            </td>
			                        </tr>
			                    </c:forEach>
			                </tbody>
			            </table>
			        </c:if>
			    </div>
			</div>
            
            <%-- 회원정보 수정 --%>
			<div id="editInfo-content" class="content-area hidden">
			    <div class="welcome-message">회원정보 수정</div>
			    <div class="sub-message">회원정보를 확인하고 수정하실 수 있습니다.</div>
			    
			    <div class="detail-content p-4"> <h3 class="mb-4">회원정보</h3> <form id="userUpdateForm"> <div class="mb-3 row info-item"> <label for="userId" class="col-sm-3 col-form-label info-label">아이디 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="userId" value="${user.userId}">
			                </div>
			            </div>
			            
			            <div class="mb-3 row info-item">
			                <label for="userName" class="col-sm-3 col-form-label info-label">이름 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="userName" value="${user.userName}">
			                </div>
			            </div>
			 
			            <div class="mb-3 row info-item">
			                <label for="nickName" class="col-sm-3 col-form-label info-label">닉네임 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="nickName" value="${user.nickName}">
			                </div>
			            </div>
			            
			            <div class="mb-3 row info-item">
			                <label for="phone" class="col-sm-3 col-form-label info-label">연락처 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="phone" value="${user.phone}">
			                </div>               
			            </div>
			            
			            <div class="mb-3 row info-item">
			                <label for="userAddr" class="col-sm-3 col-form-label info-label">주소 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="userAddr" value="${user.userAddr}">
			                </div> 
			            </div>
			            
			            <div class="mb-3 row info-item">
			                <label for="email" class="col-sm-3 col-form-label info-label">이메일 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="email" value="${user.email}">
			                </div> 
			            </div>
			            
			            <div class="mb-3 row info-item">
			                <label for="joinDt" class="col-sm-3 col-form-label info-label">가입일 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="joinDt" value="${user.joinDt}">
			                </div>
			            </div>
			            
			            <div class="mb-3 row info-item">
			                <label for="grade" class="col-sm-3 col-form-label info-label">등급 :</label>
			                <div class="col-sm-9">
			                    <input type="text" readonly class="form-control-plaintext info-value" id="grade" value="${user.grade}">
			                </div>
			            </div>
			            
			            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4"> 
<<<<<<< HEAD
			            	 <button type="button" id="btnUpdate" class="btn btn-primary mt-3">수정하기</button>
=======
			            	<button type="button" id="btnUpdate" class="btn btn-primary btn-lg">수정하기</button>
>>>>>>> feature/qna
			            </div>
			        </form>
			    </div>
			</div>
           
			<%-- 쿠폰내역 --%>
            <div id="coupon-content" class="content-area hidden"> 
                <div class="welcome-message">쿠폰내역</div>
                <div class="arrow"></div>
                <div class="sub-message">보유하고 계신 쿠폰 목록입니다.</div>
                <div class="detail-content">
                    <h3>보유 쿠폰</h3>
				  <table class="table table-bordered">
				    <thead>
				      <tr>
				        <th>쿠폰번호</th>
				        <th>쿠폰명</th>
				        <th>설명</th>
				        <th>쿠폰 발급일</th>
				        <th>쿠폰 사용 여부</th>
				        <th>사용 가능 쿠폰</th>
				      </tr>
				    </thead>
				    <tbody>
				      <c:forEach var="coupon" items="${couponList}">
				        <tr>
				          <td>${coupon.cpnSeq}</td>
				          <td>
				            <c:choose>
				              <c:when test="${coupon.cpnStat eq 'Y'}">
				                <span class="clickable">${coupon.cpnName}</span>
				              </c:when>
				              <c:otherwise>
				                ${coupon.cpnName}
				              </c:otherwise>
				            </c:choose>
				          </td>
				          <td>
				            <c:choose>
				              <c:when test="${coupon.cpnStat eq 'Y'}">
				                <span class="clickable">${coupon.cpnDesc}</span>
				              </c:when>
				              <c:otherwise>
				                ${coupon.cpnDesc}
				              </c:otherwise>
				            </c:choose>
				          </td> 
				          <td>${coupon.issueDt}</td>
				          <td>
				            <c:choose>
				              <c:when test="${coupon.userCpnIsUsed eq 'Y'}">
				                <span class="badge bg-success">사용</span>
				              </c:when>
				              <c:otherwise>
				                <span class="badge bg-secondary">미사용</span>
				              </c:otherwise>
				            </c:choose>
				          </td>
				          <td>${coupon.userCpnCnt}</td>
				        </tr>
				      </c:forEach>
				      <c:if test="${empty couponList}">
				        <tr><td colspan="8">등록된 쿠폰이 없습니다.</td></tr>
				      </c:if>
				    </tbody>
				  </table>
			    </div>
			</div>

			<%-- 예약 내역 --%><!-- ------------------체크인/아웃 수정필요------------------ -->
            <div id="reservation-content" class="content-area hidden">
                <div class="welcome-message">예약 내역</div>
                <div class="sub-message">회원님이 예약 내역 목록입니다.</div>
                <div class="detail-content">
                    <h3>예약 내역</h3>
					<c:if test="${empty reservations}">
					    <div class="alert alert-info text-center">예약 내역이 없습니다.</div>
					  </c:if>
					
					  <c:if test="${not empty reservations}">
					    <table class="table table-bordered">
					      <thead>
					        <tr>
					          <th>예약번호</th>
					          <th>객실유형</th>
					          <th>체크인</th>
					          <th>체크아웃</th>
					          <th>상태</th>
					          <th>결제상태</th>
					          <th>총금액</th>
					        </tr>
					      </thead>
					      <tbody>
					        <c:forEach var="r" items="${reservations}">
					          <tr>
					            <td>${r.rsvSeq}</td>
					            <td>${r.roomTypeSeq}</td>
					            <td><fmt:formatDate value="${r.rsvCheckInDateObj}" pattern="yyyy-MM-dd"/></td>
					            <td><fmt:formatDate value="${r.rsvCheckOutDateObj}" pattern="yyyy-MM-dd"/></td>
					            <td>
					              <c:choose>
					                <c:when test="${r.rsvStat eq 'CONFIRMED'}">예약완료</c:when>
					                <c:when test="${r.rsvStat eq '취소'}">예약취소</c:when>
					                <c:when test="${r.rsvStat eq 'PENDING'}">결제대기</c:when>
					                <c:otherwise>-</c:otherwise>
					              </c:choose>
					            </td>
					            <td>
					              <c:choose>
					                <c:when test="${r.rsvPaymentStat eq 'PAID'}">결제완료</c:when>
					                <c:when test="${r.rsvPaymentStat eq 'UNPAID'}">미결제</c:when>
					                <c:when test="${r.rsvPaymentStat eq '취소'}">예약취소</c:when>
					                <c:otherwise>-</c:otherwise>
					              </c:choose>
					            </td>
					            <td class="amount">
					              <fmt:formatNumber value="${r.finalAmt}" groupingUsed="true"/> 원
					              <c:if test="${r.rsvStat eq 'CONFIRMED'}">
					                <form action="${pageContext.request.contextPath}/reservation/cancel" method="post" onsubmit="return confirm('정말 취소하시겠습니까?')">
					                  <input type="hidden" name="rsvSeq" value="${r.rsvSeq}" />
					                  <button type="submit" class="btn btn-sm btn-danger">환불</button>
					                </form>
					              </c:if>
					            </td>
					          </tr>
					        </c:forEach>
					      </tbody>
					    </table>
					  </c:if>
                </div>
            </div>
            
           <%-- 마일리지 충전 내역 --%>
            <div id="mile-content" class="content-area hidden">
                <div class="welcome-message">마일리지 충전 내역</div>
                <div class="sub-message">마일리지 충전하신 내역을 확인하실 수 있습니다.</div>
                <div class="detail-content">
                    <h3>마일리지 충전 내역</h3>
                    <div class="info-item">
                    </div>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>거래 일시</th>
                                <th>거래 유형</th>
                                <th>거래 금액</th>                                
                                <th>거래 후 잔액</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty mileHistory}">
                                    <c:forEach var="mile" items="${mileHistory}" varStatus="status">
                                        <tr>
                                        	<td>${status.count}</td>
                                            <td><fmt:formatDate value="${mile.trxDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                            <td data-type="${mile.trxType}"></td>
                                            <td><fmt:formatNumber value="${mile.trxAmt}" pattern="#,###"/>원</td>
                                            <td><fmt:formatNumber value="${mile.balanceAfterTrx}" pattern="#,###"/>원</td>
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

			<%-- 내가 쓴 게시글 --%>
            <div id="posts-content" class="content-area hidden">
                <div class="welcome-message">내가 쓴 게시글</div>
                <div class="sub-message">회원님이 작성하신 게시글 목록입니다.</div>
                <div class="detail-content">
                    <h3>내가 쓴 게시글</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                            	<th>번호</th>
                                <th>제목</th>
                                <th>작성일</th>
                                <th>조회수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${!empty freeBoard}">
								<c:forEach var="post" items="${freeBoard}" varStatus="status">
								    <tr>
								    	<td>${status.count}</td>
								        <td><a href="/board/view?freeBoardSeq=${post.freeBoardSeq}">${post.freeBoardTitle}</a></td>
								        <td>${post.regDt}</td>
								        <td><fmt:formatNumber value="${post.freeBoardViews}" pattern="#,###"/></td>
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

			<%-- 위시리스트 --%>
            <div id="wishlist-content" class="content-area hidden">
	            <div class="welcome-message">위시리스트</div>
	            <div class="sub-message">회원님의 위시리스트 목록입니다.</div>
				<div class="container">
				<div class="detail-content">
					 <h3>위시리스트</h3>
					  <c:if test="${empty wishList}">
					    <p>위시리스트 목록이 없습니다.</p>
					  </c:if>
				
					  <div id="wishlistBody">
					    <c:forEach var="room" items="${wishList}">
						  <div class="wishlist-item">
						  	  <a href="/room/roomDetailSh">
							  <!-- <a href="/room/detail?roomSeq=${room.roomSeq}">  -->
							    <img src="/resources/upload/room/main/${room.roomImgName}" 
								     onerror="this.src='/resources/upload/room/main/default-room.png'" 
								     alt="${room.roomTitle}" 
								     class="wishlist-thumb">
							  </a>
							
							  <div class="wishlist-details">
							    <a href="/room/roomDetail?roomSeq=${room.roomSeq}" class="wishlist-title" title="${room.roomTitle}">
							      ${room.roomTitle}
							    </a>
							
							    <div class="wishlist-info">
							      <div>
							        <div class="wishlist-location">
									    ${room.region} / <strong><fmt:formatNumber value="${room.weekdayAmt}" pattern="#,###" />원~</strong>
									</div>
							        <div class="room-rating">⭐ ${room.averageRating} (${room.reviewCount}명)</div>
							      </div>
							      
							
							      <!-- ❤️ 우측하단 꽉 찬 빨간 하트 아이콘 (클릭 시 삭제) -->
									<button class="wish-heart" 
										     data-wished="true"                
										     onclick="toggleWish(${room.roomSeq}, this)" >
								      <i class="fas fa-heart wished"></i>
								    </button>
							    </div>
							  </div>
							</div>
						</c:forEach>
						</div>
					</div>
				</div>
            </div> 

			<%-- 장바구니 --%>
			<div id="cart-content" class="content-area  hidden">
			<div class="welcome-message">장바구니</div>
			<div class="sub-message">회원님의 장바구니 목록입니다.</div>
			<div  class=container>
			  <div class="detail-content">
			  	<h3>장바구니</h3>
			  <form action="${pageContext.request.contextPath}/cart/checkout" method="post"><br/>
			    <label>
			      <input type="checkbox" id="selectAll"/> 전체선택
			    </label><br/><br/>
			
			    <c:forEach var="cart" items="${cartList}">
			      <div class="cart-card">
			        <input type="checkbox"
			               class="cart-checkbox itemCheckbox"
			               name="cartSeqs"
			               value="${cart.cartSeq}"
			               data-amt="${cart.cartTotalAmt}"/>
			
			        <div class="cart-img">
			          <img src="/resources/upload/roomtype/main/${cart.roomTypeImgName}"
			               alt="숙소 이미지"/>
			        </div>
			        <div class="cart-info">
			          <div class="room-title">${cart.roomTitle}</div>
			          <div class="cart-location">
			            ${cart.roomCatName} &nbsp;/&nbsp; ${cart.roomAddr}
			          </div>
			          <div class="divider"></div>
			          <div class="type-title">${cart.roomTypeTitle}</div>
			
			          <fmt:parseDate var="inDate"
			                         value="${cart.cartCheckInDt}"
			                         pattern="yyyyMMdd"/>
			          <fmt:parseDate var="outDate"
			                         value="${cart.cartCheckOutDt}"
			                         pattern="yyyyMMdd"/>
			          <fmt:parseDate var="inTime"
			                         value="${cart.cartCheckInTime}"
			                         pattern="HHmm"/>
			          <fmt:parseDate var="outTime"
			                         value="${cart.cartCheckOutTime}"
			                         pattern="HHmm"/>
			
			          <div class="cart-meta">
			            <fmt:formatDate value="${inDate}" pattern="yyyy년 M월 d일"/> ~
			            <fmt:formatDate value="${outDate}" pattern="yyyy년 M월 d일"/>
			            &nbsp;|&nbsp;
			            <fmt:formatDate value="${inTime}" pattern="a h시"/> ~
			            <fmt:formatDate value="${outTime}" pattern="a h시"/>
			            &nbsp;|&nbsp; ${cart.cartGuestsNum}명
			          </div>
			
			          <div class="cart-price">
			            <fmt:formatNumber value="${cart.cartTotalAmt}" type="number"/>원
			          </div>
			          <div class="cancel-rule">(${cart.cancelPolicy})</div>
			          <div class="cart-actions">
			            <a href="javascript:;" class="btn-delete"
			               onclick="deleteCart(${cart.cartSeq})">&times; 삭제</a>
			          </div>
			        </div>
			      </div>
			    </c:forEach>
			
			    <div class="cart-summary">
			      <span>총 <strong id="summaryCnt">0</strong>건</span>
			      <span>결제 예상 금액
			        <strong class="total-amt" id="summaryAmt">0</strong>원
			      </span>
			      <button type="submit" id="btnCheckout" class="btn-buy" disabled>
			        구매하기
			      </button>
			    </div>
			  </form>
			  </div>
			</div>
			</div>

            
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
        	location.href = "/user/updateForm";	
        });
        
        $("#btnDelete").on("click",function(){
        	location.href = "/user/deleteForm";	
        });
    });

    
</script>
</body>
</html>       