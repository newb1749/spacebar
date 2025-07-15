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

	<%-- 게시물 하단 액션 버튼 그룹 --%>
	<div class="action-buttons-wrapper">
	    <button type="button" id="btnList" class="btn-clean btn-list">리스트</button>
	    <button type="button" id="btnReply" class="btn-clean btn-reply">답글</button>
	    <c:if test="${boardMe eq 'Y'}">
	        <button type="button" id="btnUpdate" class="btn-clean btn-edit">수정</button>
	        <button type="button" id="btnDelete" class="btn-clean btn-delete">삭제</button>
	    </c:if>
	</div>

	<div id="topReplyArea" class="reply-edit-form-wrapper" style="display:none;">
	    <textarea id="replyContent-0" rows="3" style="width:100%;" placeholder="답글 내용을 입력하세요"></textarea>
	    <div class="reply-edit-form-buttons">
	        <button type="button" id="btnReplySubmit" class="btn-clean btn-reply-submit" data-parent="0">답글 등록</button>
	        <button type="button" id="btnReplyCancel" class="btn-clean btn-cancel">취소</button>
	    </div>
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
		        <%-- 새로 추가된 부분: 댓글 정보와 버튼을 같은 줄에 배치하기 위한 컨테이너 --%>
		        <div class="comment-info-and-buttons">
		          <div> <%-- 작성자, 날짜 정보를 묶는 div --%>
		            <span class="comment-author">${freeBoardComment.userName}</span>
		            <span class="comment-date">${freeBoardComment.createDt}</span>
		          </div>
		          <div class="comment-buttons"> <%-- 버튼들을 묶는 div --%>
		            <button type="button" class="btn-clean btn-reply btn-reply" data-parent="${freeBoardComment.freeBoardCmtSeq}">답글</button>
		
		            <c:if test="${sessionUserId eq freeBoardComment.userId}">
		              <button type="button" class="btn-clean btn-edit btn-cmt-edit" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">수정</button>
		              <button type="button" class="btn-clean btn-delete btn-cmt-delete" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">삭제</button>
		            </c:if>
		          </div>
		        </div>
		        <div class="comment-content">${freeBoardComment.freeBoardCmtContent}</div> <%-- 댓글 내용은 별도의 줄에 표시 --%>
		
		        <%-- 수정 폼 --%>
		        <div id="editArea-${freeBoardComment.freeBoardCmtSeq}" class="reply-edit-form-wrapper" style="display:none;">
		          <textarea id="editContent-${freeBoardComment.freeBoardCmtSeq}" rows="3" style="width:100%;">${freeBoardComment.freeBoardCmtContent}</textarea><br/>
		          <div class="reply-edit-form-buttons">
		            <button type="button" class="btn-clean btn-edit-submit" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">수정 완료</button>
		            <button type="button" class="btn-clean btn-cancel btn-edit-cancel" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">취소</button>
		          </div>
		        </div>
		
		        <%-- 답글 폼 --%>
		        <div id="replyArea-${freeBoardComment.freeBoardCmtSeq}" class="reply-area reply-edit-form-wrapper" style="display:none;">
		          <textarea id="replyContent-${freeBoardComment.freeBoardCmtSeq}" rows="3" style="width:100%;" placeholder="답글 내용을 입력하세요"></textarea><br/>
		          <div class="reply-edit-form-buttons">
		            <button type="button" class="btn-clean btn-reply-submit" data-parent="${freeBoardComment.freeBoardCmtSeq}">답글 등록</button>
		            <button type="button" class="btn-clean btn-cancel btn-reply-cancel" data-parent="${freeBoardComment.freeBoardCmtSeq}">취소</button>
		          </div>
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
	  $("#topReplyArea").slideToggle();
	});

    // 최상위 댓글 "취소" 버튼
    $("#btnReplyCancel").on("click", function() {
        $("#topReplyArea").slideUp();
    });
    
    // 대댓글 "답글" 버튼 → 해당 입력창만 보여줌
    $(document).on("click", ".btn-reply", function() {
    	var parentCmtSeq = $(this).data("parent");
	    var $areas  = $('#replyArea-' + parentCmtSeq);
	    // 다른 열려 있는 editArea 닫기
	   $("[id^='replyArea-']").not($areas).slideUp();
	    // 이 댓글의 editArea 토글
	   $areas.slideToggle();
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
    
    $(function(){
    	  // (1) “수정” 버튼 클릭 → 해당 댓글만 토글
    	  $(document).on('click', '.btn-cmt-edit', function(){
    	    var cmtSeq = $(this).data('cmt-seq');
    	    var $area  = $('#editArea-' + cmtSeq);
    	    // 다른 열려 있는 editArea 닫기
    	   $("[id^='editArea-']").not($area).slideUp();
    	    // 이 댓글의 editArea 토글
    	   $area.slideToggle();
    	  });

    	  // (2) “취소” 버튼 클릭 → 해당 댓글 editArea 닫기
    	  $(document).on('click', '.btn-edit-cancel', function(){
    	    var cmtSeq = $(this).data('cmt-seq');
    	    $("#editArea-" + cmtSeq).slideUp();
    	  });

    	  // (3) “수정 완료” 버튼 클릭 → AJAX 호출
    	  $(document).on('click', '.btn-edit-submit', function(){
    	    const cmtSeq    = $(this).data('cmt-seq');
    	    const newContent = $("#editContent-" + cmtSeq).val().trim();
    	    if (!newContent) {
    	      alert("수정할 내용을 입력하세요.");
    	      return;
    	    }
    	    $.post("/board/commentUpdate", {
    	      freeBoardCmtSeq:      cmtSeq,
    	      freeBoardCmtContent:  newContent
    	    }, function(res){
    	      if (res.code === 0) {
    	        alert("댓글이 수정되었습니다.");
    	        location.reload();
    	      } else {
    	        alert("수정 실패: " + res.message);
    	      }
    	    }, "json").fail(function(xhr, status, err){
    	      alert("오류 발생: " + err);
    	    });
    	  });
    	});
    
   $("#btnList").on("click", function(){
      document.bbsForm.action = "/board/list";
      document.bbsForm.submit();
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

});

</script>

</body>
</html>