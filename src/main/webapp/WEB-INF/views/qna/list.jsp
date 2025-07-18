<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<style>
.deleted-title {
  color: gray;
  font-style: italic;
}

body {
  padding-top: 120px; /* ← 네비게이션 높이만큼 설정 (네비 높이 + 상하 패딩 합산) */
}

.nav-tabs .nav-link {
  color: #555;
  font-weight: 500;
}
.nav-tabs .nav-link.active {
  color: #007bff;
  border-color: #007bff #007bff transparent;
}
</style>


<script type="text/javascript">
$(document).ready(function(){
	$("#btnSearch").on("click", function(){
		document.bbsForm.qnaSeq.value = "";
		document.bbsForm.searchValue.value = $("#_searchValue").val();
		document.bbsForm.curPage.value = "1";
		document.bbsForm.action = "/qna/list";
		document.bbsForm.submit();
	});

	$("#btnWrite").on("click", function(){
		document.bbsForm.qnaSeq.value = "";
		document.bbsForm.action = "/qna/writeForm";
		document.bbsForm.submit();
	});
});


function fn_view(qnaSeq)
{
	document.bbsForm.qnaSeq.value = qnaSeq;
	document.bbsForm.action = "/qna/view"; 
	document.bbsForm.submit();
}

function fn_list(curPage)
{
	document.bbsForm.qnaSeq.value = "";
	document.bbsForm.curPage.value = curPage;
	document.bbsForm.action = "/qna/list";
	document.bbsForm.submit();
	
}

</script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mb-4">
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link ${boardType=='free' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/board/list">
        자유게시판
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${boardType=='qna' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/qna/list">
        Q&amp;A 게시판
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${boardType=='faq' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/faq/list">
        자주 묻는 질문
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${boardType=='voice' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/voice/list">
        고객의 소리
      </a>
    </li>
  </ul>
</div>

<div class="container">
   
   <div class="container">
  <!-- 게시판 제목과 검색창 영역 분리 -->
  <div class="row align-items-center mb-3">
    
    <!-- 왼쪽: 제목 -->
    <div class="col-6">
      <h2>QnA게시판</h2>
    </div>

     <!-- 오른쪽: 검색창 전체 우측 정렬 -->

    <div class="col-6 d-flex justify-content-end">
      <div class="d-flex align-items-center" style="gap: 10px;">

<%--         <!-- 조회 항목 드롭다운 -->
        <select name="_searchType" id="_searchType"
                class="form-select"
                style="width: 160px; height: 38px; font-size: 14px;">
          <option value="" disabled selected>조회 항목</option>
          <option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>작성자</option>
          <option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>제목</option>
          <option value="3" <c:if test='${searchType eq "3"}'>selected</c:if>>내용</option>
          <option value="4" <c:if test='${searchType eq "4"}'>selected</c:if>>제목+내용</option>
        </select> --%>

        <!-- 검색어 입력 -->
        <input type="text" name="_searchValue" id="_searchValue"
               value="${searchValue}"
               class="form-control"
               maxlength="20"
               placeholder="조회값을 입력하세요."
               style="width: 250px; height: 38px; font-size: 14px;" />

        <!-- 조회 버튼 -->
        <button type="button" id="btnSearch"
                class="btn"
                style="background-color: #00564E; color: white; height: 38px; font-size: 14px; padding: 6px 20px;">
          조회
        </button>

      </div>
    </div> 
    
  </div>

   </div>
   <table class="table table-hover">
      <thead>
      <tr style="background-color: #dee2e6;">
         <th scope="col" class="text-center" style="width:10%">번호</th>
         <th scope="col" class="text-center" style="width:55%">제목</th>
         <th scope="col" class="text-center" style="width:10%">작성자</th>
         <th scope="col" class="text-center" style="width:15%">날짜</th>
         <th scope="col" class="text-center" style="width:10%">답변상황</th>
      </tr>
      </thead>
      <tbody>
 
<c:if test="${!empty list}">
	<!-- var:for문 내부에서 사용할 변수, items: 리스트가 받아올 배열이름, varStatus: 상태용 변수 -->
	<c:forEach var="qna" items="${list}" varStatus="status">
      <tr>
         <td class="text-center">${qna.qnaSeq}</td>
         <td class="text-left">
		  <c:choose>
		    <c:when test="${qna.qnaStat eq 'N'}">
		      <span class="deleted-title">삭제된 게시물입니다.</span>
		    </c:when>
		    <c:otherwise>
		      <a href="javascript:void(0)" onclick="fn_view(${qna.qnaSeq})">            
		          <c:out value="${qna.qnaTitle}" /> 
		      </a>
		    </c:otherwise>
		  </c:choose>
		</td>
         <td class="text-center">${qna.userName}</td>
         <td class="text-center">${qna.regDt}</td>
         <td class="text-center">
         <c:choose>
    	    <c:when test="${qna.qnaStat eq 'N'}">
         		질문 삭제
         	</c:when>
         	<c:when test="${qna.qnaCmtSeq > 0}">
         		답변완료
         	</c:when>
         	<c:otherwise>
         		답변대기중
         	</c:otherwise>
         </c:choose>
         </td>
      </tr>
     </c:forEach>
</c:if>
    
      </tbody>
      <c:if test="${empty list}">
		  <tr>
		    <td colspan="5" class="text-center">등록된 게시물이 없습니다.</td>
		  </tr>
		</c:if>
   </table>
   <nav>
      <ul class="pagination justify-content-center">
<c:if test="${!empty paging}">
	<c:if test="${paging.prevBlockPage gt 0}">
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
     </c:if>    
	<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
		<c:choose>
			<c:when test="${i ne curPage}">
        	 <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
        	</c:when>
        	<c:otherwise> 
        	 <li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;">${i}</a></li>
        	</c:otherwise>
         </c:choose>
    </c:forEach>
   
   <c:if test="${paging.nextBlockPage gt 0}"> 
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
   </c:if>
</c:if>
      </ul>
   </nav>
   
   <button type="button" id="btnWrite" class="btn btn-secondary mb-3">질문하기</button>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="qnaSeq" value="${qnaSeq}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage"  value="${curPage}" />
	</form>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>


</html>


