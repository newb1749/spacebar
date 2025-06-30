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
	
<style>
/* 네비게이션 바 배경색 (어두운 녹색 계열, #00으로 시작, 순차적으로) */
:root {
  --nav-base-color: #005000;   /* 기본 중간 녹색 (약간 어두운 편) */
  --nav-dark-color: #003300;   /* 가장 어두운 녹색 (삭제 버튼) */
  --nav-light-color: #008000;  /* 기본보다 약간 밝은 녹색 (답글, 수정 등) */
  --nav-lighter-color: #009900; /* 가장 밝은 녹색 (리스트, 취소 등) */
  --white-text: #ffffff;      /* 버튼 텍스트 색상 */
}

/* 네비게이션 높이만큼 본문 전체를 아래로 밀기 */
body {
  padding-top: 80px; /* ← 네비게이션 높이만큼 설정 (네비 높이 + 상하 패딩 합산) */
}
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

.deleted-comment {
  color: #999;
  font-style: italic;
  margin-bottom: 5px;
}
  
/* 공통 버튼 스타일 */
.btn-clean {
  padding: 6px 12px;
  font-size: 13px;
  border-radius: 6px;
  border: none;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  transition: all 0.2s ease-in-out; /* 부드러운 전환 효과 */
  color: var(--white-text) !important; /* 글자색 흰색 강제 적용 */
  white-space: nowrap; /* 버튼 내용이 길어져도 줄바꿈되지 않도록 방지 */
}

.btn-clean:hover {
  filter: brightness(1.1); /* 호버 시 10% 더 밝게 */
}

/* 버튼별 컬러 */
.btn-list {
  background-color: var(--nav-lighter-color) !important; /* 리스트 버튼: 가장 밝은 톤 */
}
.btn-reply {
  background-color: var(--nav-light-color) !important; /* 답글 버튼: 약간 밝은 톤 */
}
.btn-edit {
  background-color: var(--nav-light-color) !important; /* 수정 버튼: 약간 밝은 톤 */
}
.btn-delete {
  background-color: var(--nav-dark-color) !important; /* 삭제 버튼: 가장 어두운 톤 */
}
.btn-cancel {
  background-color: var(--nav-lighter-color) !important; /* 취소 버튼: 가장 밝은 톤 */
}

.btn-reply-submit,
.btn-edit-submit {
  background-color: var(--nav-light-color) !important; /* 답글/수정 완료 버튼: 약간 밝은 톤 */
  color: var(--white-text) !important;
  padding: 6px 12px;
  font-size: 13px;
  border-radius: 6px;
  border: none;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  transition: all 0.2s ease-in-out;
}

.btn-reply-submit:hover,
.btn-edit-submit:hover {
  filter: brightness(1.1);
}

/* 답글 입력창 */
textarea {
  border: 1px solid #ced4da;
  border-radius: 6px;
  padding: 6px;
  font-size: 14px;
  resize: vertical; /* 세로로만 크기 조절 가능하도록 */
  box-sizing: border-box; /* 패딩, 보더가 width에 포함되도록 */
  width: 100%; /* 너비 100% 명시 */
}

/* 댓글 줄여쓰기 및 정렬 */
.comment-item {
  border-bottom: 1px solid #f1f1f1;
  padding: 10px 0;
  margin-bottom: 5px;
}

.comment-author {
  font-weight: bold;
  margin-right: 8px;
}

.comment-date {
  color: #999;
  font-size: 13px;
}

.comment-content {
  margin: 5px 0;
  font-size: 14px;
  white-space: pre-wrap;
}

/* 댓글 정보(작성자, 날짜)와 버튼을 같은 줄에 배치하고 정렬하기 위한 컨테이너 */
.comment-info-and-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 5px;
}

/* 버튼 그룹을 묶을 컨테이너 */
.comment-buttons {
    display: flex;
    gap: 6px;
    white-space: nowrap; /* 버튼들이 줄바꿈되지 않도록 방지 */
}

/* 게시물 하단 액션 버튼들을 감싸는 컨테이너 */
.action-buttons-wrapper {
    display: flex; /* 버튼들을 가로로 나열 */
    gap: 8px; /* 버튼들 사이 간격 */
    margin-top: 20px;
    flex-wrap: wrap; /* 공간이 부족하면 다음 줄로 넘어가도록 설정 */
}

/* 답글/수정 입력 폼 영역의 공통 스타일 */
.reply-edit-form-wrapper {
    margin-top: 10px; /* 위쪽 요소와의 간격 */
    margin-bottom: 10px; /* 아래쪽 요소와의 간격 */
}

/* 답글/수정 폼 내부에 있는 버튼들을 위한 컨테이너 */
.reply-edit-form-buttons {
    display: flex;
    gap: 5px;
    margin-top: 5px; /* textarea 아래 여백 */
    justify-content: flex-end; /* 버튼들을 오른쪽으로 정렬 */
}
</style>
	  
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
		
		            <c:if test="${boardMe eq 'Y'}">
		              <button type="button" class="btn-clean btn-edit btn-edit" data-cmt-seq="${freeBoardComment.freeBoardCmtSeq}">수정</button>
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
   $(document).off("click", ".btn-edit-cancel").on("click", ".btn-edit-cancel", function() {
	    var cmtSeq = $(this).data("cmt-seq");
	    $('#editArea-' + cmtSeq).stop(true, true).slideUp();
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