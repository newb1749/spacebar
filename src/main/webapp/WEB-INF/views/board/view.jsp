<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
   pageContext.setAttribute("newLine", "\n");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
   .view-wrapper {
      margin-top: 50px;
   }

   .view-card {
      border: 1px solid #dee2e6;
      border-radius: 10px;
      background-color: #f9f9f9;
      padding: 25px;
      margin-bottom: 30px;
   }

   .view-title {
      font-size: 1.6rem;
      font-weight: bold;
      color: #003c57;
      margin-bottom: 10px;
   }

   .view-meta {
      font-size: 0.95rem;
      color: #555;
      margin-bottom: 10px;
   }

   .view-content {
	  font-size: 1.1rem;
	  padding: 1px 1px; /* 전체 여백 최소화 */
	  padding-left: 7px; /* ← 왼쪽 여백만 따로 부여 */
	  background-color: #ffffff;
	  border: 1px solid #ccc;
	  border-radius: 8px;
	  min-height: 150px;
	  white-space: pre-line;
	  margin: 0;
	  line-height: 0.7;
	}


   .btn-group-custom {
      margin-top: 30px;
   }

   .btn-group-custom .btn {
      padding: 10px 20px;
      font-size: 1rem;
      margin-right: 10px;
      border-radius: 8px;
   }
</style>

<script type="text/javascript">
$(document).ready(function() {
   $("#btnReply").on("click", function(){
      document.bbsForm.action = "/board/replyForm";
      document.bbsForm.submit();
   });

   $("#btnList").on("click", function(){
      document.bbsForm.action = "/board/list";
      document.bbsForm.submit();
   });

   <c:if test="${boardMe eq 'Y'}">
   $("#btnUpdate").on("click", function(){
      document.bbsForm.action = "/board/updateForm";
      document.bbsForm.submit();
   });

   $("#btnDelete").on("click", function(){
      if(confirm("해당 게시물을 삭제하시겠습니까?")) {
         $.ajax({
            type: "POST",
            url: "/board/delete",
            data: {
               freeBoardSeq: <c:out value="${freeBoardSeq}" />
            },
            dataType: "JSON",
            beforeSend: function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
               if(response.code == 0) {
                  alert("게시물이 삭제되었습니다.");
                  location.href = "/board/list";
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
   </c:if>
});
</script>
</head>
<body>

<div class="container view-wrapper">
   <h2 class="mb-4">📄 게시물 보기</h2>

   <div class="view-card">
      <div class="view-title"><c:out value="${freeBoard.freeBoardTitle}" /></div>
      <div class="view-meta">
         작성자: <c:out value="${freeBoard.userName}" /> 
         (<a href="mailto:${freeBoard.userEmail}">${freeBoard.userEmail}</a>)<br/>
         등록일: <c:out value="${freeBoard.regDt}" /> |
         조회수: <fmt:formatNumber value="${freeBoard.freeBoardViews}" type="number" groupingUsed="true" />
      </div>
      <div class="view-content">
         <c:out value="${freeBoard.freeBoardContent}" />
      </div>
   </div>

   <div class="btn-group-custom">
      <button type="button" id="btnList" class="btn btn-secondary">리스트</button>
      <button type="button" id="btnReply" class="btn btn-primary">답변</button>
   <c:if test="${boardMe eq 'Y'}">
      <button type="button" id="btnUpdate" class="btn btn-warning text-white">수정</button>
      <button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
   </c:if>
   </div>
</div>

<form name="bbsForm" id="bbsForm" method="post">
   <input type="hidden" name="freeBoardSeq" value="${freeBoardSeq}" />
   <input type="hidden" name="searchType" value="${searchType}" />
   <input type="hidden" name="searchValue" value="${searchValue}" />
   <input type="hidden" name="curPage" value="${curPage}" />
</form>

</body>
</html>
