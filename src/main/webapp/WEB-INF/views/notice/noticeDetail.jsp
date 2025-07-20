<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
  const ctx = '${pageContext.request.contextPath}';

  // 1) 수정 버튼 클릭
  $('.reply-list').on('click', '.btn-edit-reply', function(e){
    e.preventDefault();
    const $li      = $(this).closest('li');
    if ($li.data('editing')) return;       // 이미 열려 있으면 무시
    $li.data('editing', true);

    // 원본과 원본 텍스트 저장
    const $content = $li.find('.reply-content');
    const origText = $content.text().trim();
    $li.data('orig-text', origText);

    // 숨기고 textarea 삽입
    $content.hide();
    $('<textarea>')
      .addClass('edit-reply-text form-control')
      .val(origText)
      .insertAfter($content);

    // 저장/취소 링크
    $(`
      <div class="reply-actions">
        <a href="#" class="reply-action save">저장</a>
        <a href="#" class="reply-action cancel">취소</a>
      </div>
    `).appendTo($li);
  });

  // 2) 저장 클릭
  $('.reply-list').on('click', '.reply-action.save', function(e){
    e.preventDefault();
    const $li     = $(this).closest('li');
    const newText = $li.find('.edit-reply-text').val().trim();
    if (!newText) { alert('댓글을 입력하세요.'); return; }

    $.post(`${ctx}/notice/reply/editProc`, {
      replySeq: $li.data('reply-seq'),
      replyContent: newText
    })
    .done(function(res){
      // 본문 갱신
      $li.find('.reply-content')
         .text(newText)
         .show();

      // 편집 요소 제거
      $li.find('.edit-reply-text').remove();
      $li.find('.reply-actions').remove();
      $li.removeData('editing').removeData('orig-text');
    })
    .fail(function(){
      alert('수정 중 오류 발생');
    });
  });

  // 3) 취소 클릭
  $('.reply-list').on('click', '.reply-action.cancel', function(e){
    e.preventDefault();
    const $li      = $(this).closest('li');
    const origText = $li.data('orig-text');

    // 원본 복원
    $li.find('.reply-content')
       .text(origText)
       .show();

    // 편집 요소 제거
    $li.find('.edit-reply-text').remove();
    $li.find('.reply-actions').remove();
    $li.removeData('editing').removeData('orig-text');
  });
  
  //삭제처리
  $('.reply-list').on('click', '.btn-delete-reply', function(e){
	    e.preventDefault();
	    if (!confirm('정말 이 댓글을 삭제하시겠습니까?')) return;
	    const $li = $(this).closest('li');
	    $.post(`${ctx}/notice/reply/deleteProc`, {
	      replySeq: $li.data('reply-seq')
	    })
	    .done(function(){
	      $li.remove();
	    })
	    .fail(function(){
	      alert('삭제 중 오류 발생');
	    });
	  });
});
</script>


  <meta charset="UTF-8">
  <title>공지사항 상세</title>
  <style>
    /* 기존 스타일 유지 */
    
    .reply-controls button {
  background: none;
  border: none;
  color: #007bff;
  cursor: pointer;
  font-size: 0.9rem;
  margin-left: 0.75rem;
}
.btn-delete-reply {
  color: #dc3545; /* 빨간 삭제 버튼 */
}
    
    .reply-body {
  margin-top: 8px;
}
.reply-content {
  white-space: pre-wrap;
  line-height: 1.5;
  color: #333;
}
    .section-block {
      padding: 40px 0;
      margin-bottom: 40px;
      border-top: 2px solid #e9ecef;
    }
    .section-heading {
      font-size: 1.75rem;
      font-weight: 600;
      margin: 70px 0 1rem 0;
      padding-bottom: .5rem;
      border-bottom: 3px solid #007bff;
      display: inline-block;
    }
    .notice-info {
      margin-top: 20px;
      border: 1px solid #dee2e6;
      padding: 20px;
      background-color: #f9f9f9;
    }
    .notice-title {
  font-size: 2rem;       /* 기존 1.5rem → 2rem 으로 확대 */
  font-weight: 700;      /* 더 굵게 */
  margin-bottom: 0.75rem;
    }
    .notice-meta {
      margin-bottom: 4px;
    }
    .notice-content {
  font-size: 1.125rem;   /* 기존 1rem → 1.125rem 으로 약간 확대 */
  font-weight: 500;
  line-height: 1.6;
  margin-top: 0.5rem;
    }
    .btn-primary {
      display: inline-block;
      margin-top: 20px;
    }
    .reply-section {
      margin-top: 40px;
    }
    .reply-list {
  list-style: none;
  padding: 0;
  margin: 0;
    }
    .reply-list li {
   border-bottom: 1px solid #eee;
  padding: 12px 0;
    }
    
    .reply-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}
    .reply-user {
      font-weight: 600;
      color: #007bff;
      margin-right: 10px;
    }
    .reply-date {
      font-size: 0.8rem;
      color: #999;
    }
    .reply-content {
      margin-top: 5px;
      white-space: pre-wrap;
    }
    .reply-form textarea {
      width: 100%;
      min-height: 80px;
      margin-bottom: 10px;
      padding: 8px;
      border: 1px solid #ccc;
      resize: vertical;
    }
    
    .reply-item {
  flex: 1;
}

.btn-edit-reply {
  background: none;
  border: none;
  color: #007bff;
  cursor: pointer;
  font-size: 0.9rem;
  padding: 4px 8px;
}
.reply-meta {
  display: flex;
  align-items: center;
  gap: 0.5rem; /* user와 date 사이 간격 */
}

  .edit-reply-container {
    display: flex;
    align-items: flex-start;
    margin-top: 8px;
  }
  .edit-reply-text {
    flex: 1;
    margin-right: 8px;
    min-height: 60px;
  }
  .edit-reply-container .btn {
    margin-left: 4px;
  }
  
  .reply-body textarea.edit-reply-text {
  width: 100%;
  min-height: 60px;
  padding: 8px;
  margin-bottom: 8px;
  border: 1px solid #ccc;
  resize: vertical;
}

.reply-action {
  margin-left: 1rem;
  color: #007bff;
  text-decoration: underline;
  cursor: pointer;
  font-size: 0.9rem;
}
.reply-action.cancel {
    color: #d39e00;
}

.reply-actions {
  margin-top: 0.5rem;
  text-align: right;
}

.reply-actions .btn {
   padding: 0.5rem 1rem;
  line-height: 1.25;     /* 텍스트가 중앙 정렬되도록 */
  font-size: 0.875rem;   /* 버튼 글자 크기 */

}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container section-block">
  <h2 class="section-heading">공지사항 상세</h2>

  <div class="notice-info">
    <div class="notice-title">${notice.noticeTitle}</div>
    <div class="notice-meta">
      작성자: ${notice.adminId} | 등록일: <fmt:formatDate value="${notice.regDt}" pattern="yyyy-MM-dd" />
    </div>
    <div class="notice-content">${notice.noticeContent}</div>
  </div>
  

  <div class="reply-section">
    <h3 class="section-heading" style="border-color:#28a745;">댓글 목록</h3>
		<ul class="reply-list">
		  <c:forEach var="r" items="${noticeReplies}">
		    <li data-reply-seq="${r.replySeq}">
		      <div class="reply-header">
		        <!-- 1) user + date 묶음 -->
		        <div class="reply-meta">
		          <span class="reply-user">${r.userId}</span>
		          <span class="reply-date">
		            (<fmt:formatDate value="${r.regDt}" pattern="yyyy-MM-dd HH:mm"/>)
		          </span>
		        </div>
		        <!-- 2) controls 묶음: 수정 + 삭제 -->
		        <c:if test="${sessionScope.SESSION_USER_ID eq r.userId}">
		        <div class="reply-controls">
		          <button type="button" class="btn-edit-reply">수정</button>
		          <button type="button" class="btn-delete-reply">삭제</button>
		        </div>
		        </c:if>
		      </div>
		      <div class="reply-body">
		        <div class="reply-content">${r.replyContent}</div>
		      </div>
		      <!-- textarea, .reply-actions는 JS로 동적으로 삽입됩니다 -->
		    </li>
		  </c:forEach>
		  <c:if test="${empty noticeReplies}">
		    <li>등록된 댓글이 없습니다.</li>
		  </c:if>
		</ul>

    <c:if test="${not empty sessionScope.SESSION_USER_ID}">
      <form action="/notice/reply" method="post" class="reply-form">
        <input type="hidden" name="noticeSeq" value="${notice.noticeSeq}" />
        <textarea name="replyContent" placeholder="댓글을 입력하세요." required></textarea>
        <button type="submit" class="btn btn-primary">댓글 등록</button>
      </form>
    </c:if>
    <c:if test="${empty sessionScope.SESSION_USER_ID}">
      <p>댓글 작성은 로그인 후 이용 가능합니다.</p>
    </c:if>
  </div>

  <a href="/notice/list" class="btn btn-primary">목록으로 돌아가기</a>
</div>

<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>

</body>
</html>
