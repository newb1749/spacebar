<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
   pageContext.setAttribute("newLine", "\n");
%>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <style>
  /*----------------------------------
    1. 공통 변수
  -----------------------------------*/
  :root {
    --clr-primary:    #007bff;  /* 답글·수정 */
    --clr-danger:     #dc3545;  /* 삭제 */
    --clr-border:     #dee2e6;
    --clr-text:       #212529;
    --clr-muted:      #6c757d;
    --space:          0.5rem;
    --small:          0.75rem;
  }

  /*----------------------------------
    2. 기존 스타일 유지 부분
  -----------------------------------*/
  body {
    padding-top: 120px;
    background: #f8f9fa;
    font-family: 'Noto Sans KR', sans-serif;
    color: var(--clr-text);
    line-height: 1.4;
  }
  .container { max-width: 1300px; margin: 0 auto; padding: var(--space); }
  .view-card {
    background: #fff;
    border: 1px solid var(--clr-border);
    border-radius: 0.25rem;
    padding: 1rem;
    margin-bottom: 1rem;
  }
  .view-title { font-size: 1.5rem; color: var(--clr-primary); margin-bottom: .25rem; }
  .view-meta {
    font-size: var(--small);
    color: var(--clr-muted);
    margin-bottom: .75rem;
  }
  .view-content {
    background: #fdfdfe;
    border: 1px solid var(--clr-border);
    border-radius: 0.25rem;
    padding: .75rem;
    font-size: 1rem;
  }

  /* 액션 버튼 (리스트/최상위 답글) */
  .action-buttons-wrapper .btn-clean {
    background: var(--clr-primary);
    color: #fff !important;
    font-size: .75rem;
    padding: .25rem .6rem;
    margin-right: var(--space);
  }
  .action-buttons-wrapper .btn-list { background: var(--clr-muted); }
  .action-buttons-wrapper .btn-clean:hover { opacity: .85; }

  /*----------------------------------
    3. 댓글 구분선만
  -----------------------------------*/
  .comment-box { margin-top: 1rem; }
  .comment-item {
    background: none;
    border: none;
    border-bottom: 1px dotted var(--clr-border);
    padding: .75rem 0;
    margin: 0;
  }

  .comment-info-and-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .comment-author { font-weight: bold; color: var(--clr-primary); }
  .comment-date   { font-size: var(--small); color: var(--clr-muted); }

  /*----------------------------------
    4. 댓글 버튼 → 텍스트 링크 형태
  -----------------------------------*/
  .comment-buttons button {
    background: none !important;
    border: none;
    padding: 0;
    margin-left: var(--space);
    font-size: var(--small);
    cursor: pointer;
    transition: color .15s;
  }
  .comment-buttons .btn-reply { color: var(--clr-primary); }
  .comment-buttons .btn-edit  { color: var(--clr-primary); }
  .comment-buttons .btn-delete{ color: var(--clr-danger); }

  .comment-buttons button:hover {
    text-decoration: underline;
    opacity: .8;
  }

  /*----------------------------------
    5. 답글/수정 textarea + 버튼
  -----------------------------------*/
  .reply-edit-form-wrapper {
    margin-top: var(--space);
  }
  textarea {
    width: 100%;
    padding: .5rem;
    font-size: .9rem;
    border: 1px solid var(--clr-border);
    border-radius: 0.25rem;
    resize: vertical;
    box-sizing: border-box;
  }
  .reply-edit-form-buttons {
    text-align: right;
    margin-top: .5rem;
  }
  .reply-edit-form-buttons .btn-clean {
    background: var(--clr-primary);
    color: #fff !important;
    font-size: .75rem;
    padding: .25rem .6rem;
    margin-left: var(--space);
  }
  .reply-edit-form-buttons .btn-cancel {
    background: var(--clr-muted);
  }

  </style>
</head>


<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container view-wrapper">
   <h2 class="mb-4">QnA게시판</h2>

   <div class="view-card">
      <div class="view-title"><c:out value="${qna.qnaTitle}" /></div>
      <div class="view-meta">
         작성자: <c:out value="${qna.userName}" /> 
         <c:out value="(${qna.userEmail})" /> 
         <br/>
         등록일: <c:out value="${qna.regDt}" /> |
         답변상황:
         <c:choose>
         	<c:when test="${qna.qnaCmtSeq > 0}">
         		답변완료
         	</c:when>
         	<c:otherwise>
         		답변대기중
         	</c:otherwise>
         </c:choose>
      </div>
      <div class="view-content">
         <c:out value="${qna.qnaContent}" />
      </div>
   </div>

	<%-- 게시물 하단 액션 버튼 그룹 --%>
	<div class="action-buttons-wrapper">
	    <button type="button" id="btnList" class="btn-clean btn-list">리스트</button>
	    <c:if test="${boardMe eq 'Y'}">
	        <button type="button" id="btnDelete" class="btn-clean btn-delete">삭제</button>
	    </c:if>
	</div>

<c:if test="${!empty qnaComment}">
	<c:if test="${!empty qnaComment}">
	  <div style="border-top:1px solid #dee2e6; padding:1rem 0; margin-top:1rem;">
	    <div style="font-weight:bold; color:#007bff; margin-bottom:0.5rem;">
	      관리자 답변
	    </div>
	    <div style="background:#fdfdfe; border:1px solid #dee2e6; border-radius:4px; padding:0.75rem;">
	      <c:out value="${qnaComment.qnaCmtContent}" escapeXml="false"/>
	    </div>
	  </div>
	</c:if>
</c:if>
</div>
<form name="bbsForm" id="bbsForm" method="post">
   <input type="hidden" name="qnaSeq" value="${qnaSeq}" />
   <input type="hidden" name="searchValue" value="${searchValue}" />
   <input type="hidden" name="curPage" value="${curPage}" />
</form>




<script type="text/javascript">
$(document).ready(function() {

   $("#btnList").on("click", function(){
      document.bbsForm.action = "/qna/list";
      document.bbsForm.submit();
   });
	
   $("#btnDelete").on("click", function(){
      if(confirm("해당 게시물을 삭제하시겠습니까?")) {
         $.ajax({
            type: "POST",
            url: "/qna/delete",
            data: {
               qnaSeq: <c:out value="${qnaSeq}"/>
            },
            dataType: "JSON",
            beforeSend: function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
               if(response.code == 0) {
                  alert("게시물이 삭제되었습니다.");
                  location.href = "/qna/list";
               } else {
                  alert("삭제에 실패했습니다. 코드: " + response.code);
               }
            },
            error: function(xhr, status, error) {
               alert("오류 발생: " + error);
            }
         });
      }
   });

});

</script>

</body>
</html>