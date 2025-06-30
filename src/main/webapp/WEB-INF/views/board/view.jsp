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
   
    .deleted-comment {
    color: #999;
    font-style: italic;
    margin-bottom: 5px;
  }
</style>

</head>
<body>

<div class="container view-wrapper">
   <h2 class="mb-4">📄 게시물 보기</h2>

   <div class="view-card">
      <div class="view-title"><c:out value="${freeBoard.freeBoardTitle}" /></div>
      <div class="view-meta">
         작성자: <c:out value="${freeBoard.userName}" /> 
         <c:out value="(${freeBoard.userEmail})" /> 
         <br/>
         등록일: <c:out value="${freeBoard.regDt}" /> |
         조회수: <fmt:formatNumber value="${freeBoard.freeBoardViews}" type="number" groupingUsed="true" />
      </div>
      <div class="view-content">
         <c:out value="${freeBoard.freeBoardContent}" />
      </div>
   </div>

   <div class="btn-group-custom">
      <button type="button" id="btnList" class="btn btn-secondary">리스트</button>
      <button type="button" id="btnReply" class="btn btn-outline-primary">답글</button> <%-- ✅ 이걸 추가해야 함 --%>
     <!-- 답글 입력 폼 (처음엔 숨김 처리) -->
	 <div id="topReplyArea" style="display:none; margin-top: 20px;">
        <textarea id="replyContent-0" rows="1" style="width:100%;" placeholder="답글 내용을 입력하세요"></textarea>
        <br/>
        <button type="button" id="btnReplySubmit" class="btn btn-primary btn-reply-submit" data-parent="0" style="margin-top: 5px;">답글 등록</button>
        <button type="button" id="btnReplyCancel" class="btn btn-secondary" style="margin-top: 5px;">취소</button>
    </div>

    <c:if test="${boardMe eq 'Y'}">
        <button type="button" id="btnUpdate" class="btn btn-warning text-white">수정</button>
        <button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
    </c:if>
	</div>

<c:if test="${!empty freeBoardComment}">
	<div class="comment-box">
	
		<c:forEach var="freeBoardComment" items="${freeBoardComment}">
		  <div class="comment-item" style="padding-left: ${freeBoardComment.depth * 20}px">
		  
		    <c:choose>
		      <c:when test="${freeBoardComment.freeBoardCmtStat eq 'N'}">
		        <div class="deleted-comment">삭제된 댓글입니다.</div>
		      </c:when>
		      
		      <c:otherwise>
		        <span class="comment-author">${freeBoardComment.userName}</span>
		        <span class="comment-date">${freeBoardComment.createDt}</span>
		        <div class="comment-content">${freeBoardComment.freeBoardCmtContent}</div>
		
		        <button type="button" class="btn btn-sm btn-link btn-reply" data-parent="${freeBoardComment.freeBoardCmtSeq}">답글</button>
		        
		        <c:if test="${boardMe eq 'Y'}">
		          <button type="button" class="btn btn-warning text-white btn-edit" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">수정</button>
		          <div id="editArea-${freeBoardComment.freeBoardCmtSeq}" style="display:none; margin-top:10px;">
				    <textarea id="editContent-${freeBoardComment.freeBoardCmtSeq}" rows="1" style="width:100%;">${freeBoardComment.freeBoardCmtContent}</textarea><br/>
				    <button type="button" class="btn btn-primary btn-edit-submit" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">수정 완료</button>
				    <button type="button" class="btn btn-secondary btn-edit-cancel" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">취소</button>
				</div>
		          <button type="button" class="btn btn-danger btn-cmt-delete" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">삭제</button>
		        </c:if>
		
		        <div id="replyArea-${freeBoardComment.freeBoardCmtSeq}" class="reply-area" style="display:none; margin-top:10px;">
		          <textarea id="replyContent-${freeBoardComment.freeBoardCmtSeq}" rows="1" style="width:100%;" placeholder="답글 내용을 입력하세요"></textarea><br/>
		          <button type="button" class="btn btn-primary btn-reply-submit" data-parent="${freeBoardComment.freeBoardCmtSeq}">답글 등록</button>
		          <button type="button" class="btn btn-secondary btn-reply-cancel" data-parent="${freeBoardComment.freeBoardCmtSeq}">취소</button>
		        </div>
		      </c:otherwise>
	    	</c:choose>
		  
		  </div>
		</c:forEach>

	</div>
</c:if>
</div>
<form name="bbsForm" id="bbsForm" method="post">
   <input type="hidden" name="freeBoardSeq" value="${freeBoardSeq}" />
   <input type="hidden" name="searchType" value="${searchType}" />
   <input type="hidden" name="searchValue" value="${searchValue}" />
   <input type="hidden" name="curPage" value="${curPage}" />
</form>




<script type="text/javascript">
$(document).ready(function() {
	
    // 최상위 댓글 "답글" 버튼
    $("#btnReply").on("click", function() {
        $("#topReplyArea").slideDown();
    });

    // 최상위 댓글 "취소" 버튼
    $("#btnReplyCancel").on("click", function() {
        $("#topReplyArea").slideUp();
    });
    
    // 대댓글 "답글" 버튼 → 해당 입력창만 보여줌
    $(document).on("click", ".btn-reply", function() {
	    var parentCmtSeq = $(this).data("parent");
	    // 1. 모든 replyArea 감춤
	    $(".reply-area").slideUp();
		
	    // 2. 해당 댓글의 입력창만 보여줌
	    $('#replyArea-' + parentCmtSeq).slideDown();
		});
	
	    // 대댓글 "취소" 버튼
	    $(document).on("click", ".btn-reply-cancel", function() {
	        var parentCmtSeq = $(this).data("parent");
	        $('#replyArea-' + parentCmtSeq).slideUp();
    });
	
    $(document).on("click", ".btn-reply-submit", function() {
        var parentCmtSeq = $(this).data("parent"); // 0이면 최상위
        var content = $('#replyContent-' + parentCmtSeq).val().trim();
        var boardSeq = $("input[name='freeBoardSeq']").val();

        if (content === "") {
            alert("내용을 입력하세요.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "/board/commentInsert", // 너의 Controller URL
            data: {
                freeBoardSeq: boardSeq,
                parentCmtSeq: parentCmtSeq,
                freeBoardCmtContent: content
            },
            dataType: "json",
            success: function(res) {
                if (res.code === 0) {
                    location.reload(); // 등록 후 새로고침
                } else {
                    alert("댓글 등록 실패: " + res.message);
                }
            },
            error: function(xhr, status, error) {
                alert("오류 발생: " + error);
            }
        });
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
   
   $(document).on("click", ".btn-cmt-delete", function(){
	    if(confirm("해당 댓글을 삭제하시겠습니까?")) {
	        let cmtSeq = $(this).data("cmt-seq");
	        $.ajax({
	            type: "POST",
	            url: "/board/cmtDelete",
	            data: {
	                freeBoardCmtSeq: cmtSeq
	            },
	            dataType: "JSON",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("AJAX", "true");
	            },
	            success: function(response) {
	                if(response.code == 0) {
	                    alert("댓글이 삭제되었습니다.");
	                    location.reload(); // 혹은 list로 이동
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
   
   $(document).on("click", ".btn-edit", function() {
	    var cmtSeq = $(this).data("cmt-seq");
	    
	    // 다른 수정 폼 닫기
	    $("[id^='editArea-']").slideUp();
	    
	    // 해당 수정 폼 열기
	    $('#editArea-' + cmtSeq).slideDown();
	});
   $(document).on("click", ".btn-edit-cancel", function() {
	    var cmtSeq = $(this).data("cmt-seq");
	    $('#editArea-' + cmtSeq).slideUp();
	});
	
   $(document).on("click", ".btn-edit-submit", function() {
	    var cmtSeq = $(this).data("cmt-seq");
	    var newContent = $('#editContent-' + cmtSeq).val().trim();

	    if (newContent === "") {
	        alert("수정할 내용을 입력하세요.");
	        return;
	    }

	    $.ajax({
	        type: "POST",
	        url: "/board/commentUpdate",  // Controller 매핑
	        data: {
	            freeBoardCmtSeq: cmtSeq,
	            freeBoardCmtContent: newContent
	        },
	        dataType: "json",
	        success: function(res) {
	            if (res.code === 0) {
	                alert("댓글이 수정되었습니다.");
	                location.reload();
	            } else {
	                alert("수정 실패: " + res.message);
	            }
	        },
	        error: function(xhr, status, error) {
	            alert("오류 발생: " + error);
	        }
	    });
	});



   </c:if>
});

</script>

</body>
</html>
