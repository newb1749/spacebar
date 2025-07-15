
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<style>
.section-block {
  padding: 40px 0;
  margin-bottom: 40px;
  border-top: 2px solid #e9ecef;
}

.section-heading {
  font-size: 1.75rem;
  font-weight: 600;
  margin-bottom: 1rem;
  padding-bottom: .5rem;
  border-bottom: 3px solid #007bff;
  display: inline-block;
}

.section-bg-light {
  background-color: #f8f9fa;
}
.hero.page-inner {
  /* 기존 overlay 클래스는 지웠다고 가정합니다 */
  width: calc(100% - 40px) !important;
  margin: 0 auto !important;

  /* 배경 이미지 고해상도로 꽉 채우기 */
  background-size: cover !important;
  background-position: center !important;
  background-repeat: no-repeat !important;

  /* height를 조금 더 크게 조정 (예: 300px → 400px 또는 뷰포트 비율) */
  min-height: 400px !important;
  /* 또는 화면의 절반 높이를 사용하려면
  height: 50vh !important;
  */

  /* 브라우저 스케일 품질 최적화 (크롬 등에서 고해상도 렌더링) */
  image-rendering: auto;
  image-rendering: -webkit-optimize-contrast; /* WebKit 전용 */
}


  /* 1) 부모를 기준으로 절대 위치 */
.property-slider-wrap {
  position: relative !important;
}

/* 2) 컨트롤 박스를 슬라이더 전체 높이에 걸쳐서 flex 컨테이너로 */
.property-slider-wrap .tns-outer > .tns-controls {
  position: absolute !important;
  top: 0 !important;
  bottom: 0 !important;
  left: 0 !important;
  right: 0 !important;
  display: flex !important;
  align-items: center !important;       /* 수직 중앙 */
  justify-content: space-between !important; /* 좌우 끝으로 */
  pointer-events: none !important;      /* 배경 클릭 방해 안 함 */
  z-index: 100 !important;
}

/* 3) 버튼만 클릭 가능하도록 */
.property-slider-wrap .tns-outer > .tns-controls button {
  pointer-events: auto !important;
  background: none !important;
  border: none !important;
  padding: 0 !important;
  transform: translateY(-50px) !important;
}

/* 4) 이미지 크기 */
.property-slider-wrap .tns-outer > .tns-controls button img {
  display: block !important;
  width: 32px !important;
  height: 32px !important;
}

.sticky-tabs {
  position: relative;     /* 처음엔 문서 흐름에 따라 위치 */
  top: auto;
  left: 0;
  right: 0;
  background: #fff;
  border-bottom: 1px solid #eee;
  z-index: 200;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  transition: box-shadow .2s;
}

.sticky-tabs.fixed {
  position: fixed;        /* fixed 클래스가 붙으면 고정 */
  top: 0px;              /* 네비게이션바 높이만큼 아래로 */
  width: 100%;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
/* 탭 리스트 */
.tabs-list {
  display: flex;
  justify-content: center; /* 가운데 정렬 */
  gap: 1rem;
  margin: 0;
  padding: 0.5rem 1rem;
  list-style: none;
}

/* 각 탭 */
.tabs-list li a {
  display: block;
  padding: 0.5rem 1rem;
  color: #333;
  font-weight: 500;
  text-decoration: none;
  border-bottom: 2px solid transparent;
  transition: color 0.2s, border-color 0.2s;
}

.tabs-list li a.active,
.tabs-list li a:hover {
  color: #007bff;
  border-color: #007bff;
}

#mainContent {
  /* 헤더(56px) + 탭바 높이(48px) */
  padding-top: calc(0px + 48px);
}
</style>  
<script type="text/javascript">
function fn_list(curPage) {
	   const roomSeq = $("#roomSeq").val();
	   // 현재 iframe 안이니까 부모의 iframe을 직접 제어
	   if (window.parent && window.parent.document) 
	   {
	     const iframe = window.parent.document.getElementById("qnaIframe");
	     iframe.src = "/room/qnaList?roomSeq=" + roomSeq + "&curPage=" + curPage;
	   }
	}
</script>
</head>
<body>

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
			    <a href="/room/qnaUpdateForm?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-warning btn">
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
	                     <a href="/room/qnaCmtForm?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-primary">
	                       ✏ 답글 작성하기
	                     </a>
	                </c:if> 
	                <!-- 답글 수정 버튼 -->
				    <c:if test="${user.userType =='H' and !empty qna.roomQnaComment}">
				      <a href="/room/qnaCmtUpdateForm?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}&roomQnaCmtSeq=${qna.roomQnaComment.roomQnaCmtSeq}" class="btn btn-outline-warning btn">
				        ✏ 답글 수정하기
				      </a>
				    </c:if>                      
	              </div>
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
<form id="roomQnaForm">
  <input type="hidden" id="roomSeq" name="roomSeq" value="${roomSeq}" />
  <input type="hidden" id="curPage" name="curPage" value="${curPage}" />
</form>
</body>
</html>