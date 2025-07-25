<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>

  <meta charset="UTF-8" />
  <title>공지사항 상세</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <style>
  /* -------------------- 공통/레이아웃 -------------------- */
  .site-nav .container{
    max-width:none !important;
    width:1330px;
    margin:0 auto !important;
    padding:0 !important;
  }
  body{
    padding-top:100px;
    background:#f9f9f9;
    font-family:'Pretendard','Noto Sans KR',sans-serif;
  }
  .container{
    max-width:980px;
    margin:0 auto;
  }

  .section-block{
    padding:40px 0 80px;
  }
  .section-heading{
     font-size:1.9rem !important;
    font-weight:700;
    margin:60px 0 1.2rem;
    padding-bottom:.4rem;
    border-bottom:3px solid #007bff;
    display:inline-block;
    color:#222;
  }

  /* -------------------- 공지 상세 -------------------- */
  .notice-box{
    border:1px solid #e3e6ea;
    background:#fff;
    padding:44px 50px;
    border-radius:10px;
    box-shadow:0 2px 6px rgba(0,0,0,.04);
  }
  .notice-title{
    font-size:2.35rem !important;
    font-weight:700;
    color:#111;
    margin:0;
     margin-bottom:.9rem;
  }
  .notice-divider{
    border:0;
    height:1px;
    background:#e5e5e5;
    margin:18px 0 24px;
  }
  .notice-meta{
    font-size:.9rem;
    color:#888;
    margin-bottom:4px;
  }
  .notice-content{
    font-size:1.18rem;
    line-height:1.8;
    color:#333;
    white-space:pre-wrap; /* 기본 줄바꿈은 유지 */
  }

  /* -------------------- 댓글 -------------------- */
  .reply-section{
    margin-top:64px;
  }
  .reply-list{
    list-style:none;
    padding:0;
    margin:0;
  }
  .reply-list li{
    border-bottom:1px solid #eee;
    padding:14px 0;
  }
  .reply-header{
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
    margin-bottom:.35rem;
    gap:8px;
  }
  .reply-meta{
    display:flex;
    align-items:center;
    gap:.5rem;
    font-size:.99rem;
  }
  .reply-user{
    font-weight:600;
    color:#007bff;
  }
  .reply-date{
    font-size:.85rem;
    color:#999;
  }
  .reply-content{
    white-space:pre-wrap;
    line-height:1.55;
    color:#333;
    font-size:1.1rem;
    margin-top:4px;
  }

  /* 댓글 폼 */
  .reply-form textarea{
    width:100%;
    min-height:110px;
    padding:10px 12px;
    border:1px solid #ced4da;
    border-radius:6px;
    resize:vertical;
    font-size:1rem;
  }

  /* -------------------- 버튼 스타일 -------------------- */
  .btn-line{
    display:inline-block;
    padding:.50rem 1rem;
    font-size:.95rem;
    line-height:1.25;
    border:1px solid #ced4da;
    color:#555;
    background:#fff;
    border-radius:7px;
    cursor:pointer;
    transition:all .15s;
    text-decoration:none;
  }
  .btn-line:hover{ background:#f8f9fa; color:#000; }

  .btn-line.primary{
    border-color:#007bff;
    color:#007bff;
  }
  .btn-line.primary:hover{
    background:#007bff;
    color:#fff;
  }
  .btn-line.danger{
    border-color:#dc3545;
    color:#dc3545;
  }
  .btn-line.danger:hover{
    background:#dc3545;
    color:#fff;
  }
  .btn-line.warning{
    border-color:#ffc107;
    color:#b8860b;
  }
  .btn-line.warning:hover{
    background:#ffc107;
    color:#000;
  }
  .btn-line.sm{   padding:.45rem .9rem !important;
  font-size:.87rem !important; }

  .reply-actions{
    margin-top:.5rem;
    text-align:right;
    display:flex;
    justify-content:flex-end;
    gap:.4rem;
  }

  /* 저장/취소 내부 textarea */
  .edit-reply-text{
    width:100%;
    min-height:60px;
    padding:8px;
    margin:6px 0;
    border:1px solid #ccc;
    border-radius:6px;
    resize:vertical;
    font-size:.9rem;
  }

  /* 목록 버튼 영역 */
  .notice-footer-btns{
    margin-top:48px;
    text-align:right;
  }

  /* '.' 자동줄바꿈 적용 시 강조(선택사항) */
  .dot-break { white-space:normal; }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container section-block">

  <h2 class="section-heading">공지사항 상세</h2>

  <!-- 공지 박스 -->
  <div class="notice-box">
    <h1 class="notice-title">${notice.noticeTitle}</h1>
    <hr class="notice-divider" />
    <div class="notice-meta">
      작성자: ${notice.adminId} &nbsp;|&nbsp;
      등록일: <fmt:formatDate value="${notice.regDt}" pattern="yyyy-MM-dd" />
    </div>

    <!-- noticeContent -->
    <!-- 기본은 pre-wrap, 필요 시 '.' 기반 줄바꿈은 JS가 처리 -->
    <div id="noticeContent" class="notice-content">
      <c:out value="${notice.noticeContent}" escapeXml="true" />
    </div>
  </div>

  <!-- 댓글 -->
  <div class="reply-section">
    <h3 class="section-heading" style="border-color:#28a745;">댓글 목록</h3>

    <ul class="reply-list">
      <c:forEach var="r" items="${noticeReplies}">
        <li data-reply-seq="${r.replySeq}">
          <div class="reply-header">
            <div class="reply-meta">
              <span class="reply-user">${r.userId}</span>
              <span class="reply-date">
                (<fmt:formatDate value="${r.regDt}" pattern="yyyy-MM-dd HH:mm" />)
              </span>
            </div>

            <c:if test="${sessionScope.SESSION_USER_ID eq r.userId}">
              <div class="reply-controls">
                <button type="button" class="btn-line sm btn-edit-reply">수정</button>
                <button type="button" class="btn-line sm danger btn-delete-reply">삭제</button>
              </div>
            </c:if>
          </div>

          <div class="reply-body">
            <div class="reply-content">${r.replyContent}</div>
          </div>
          <!-- edit textarea + save/cancel 버튼은 JS로 삽입 -->
        </li>
      </c:forEach>

      <c:if test="${empty noticeReplies}">
        <li>등록된 댓글이 없습니다.</li>
      </c:if>
    </ul>

    <!-- 댓글 작성 -->
    <c:if test="${not empty sessionScope.SESSION_USER_ID}">
      <form action="/notice/reply" method="post" class="reply-form" style="margin-top:18px;">
        <input type="hidden" name="noticeSeq" value="${notice.noticeSeq}" />
        <textarea name="replyContent" placeholder="댓글을 입력하세요." required></textarea>
        <button type="submit" class="btn-line primary sm" style="margin-top:8px;">댓글 등록</button>
      </form>
    </c:if>
    <c:if test="${empty sessionScope.SESSION_USER_ID}">
      <p style="margin-top:12px;color:#777;">댓글 작성은 로그인 후 이용 가능합니다.</p>
    </c:if>
  </div>

  <div class="notice-footer-btns">
    <a href="/notice/list" class="btn-line sm">목록으로</a>
  </div>

</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>

<script>
$(function(){
  const ctx = '${pageContext.request.contextPath}';

  /* -------------------- '.' 기준 줄바꿈 (원하면 true) -------------------- */
  const DOT_BREAK = true;
  if(DOT_BREAK){
    const $nc = $('#noticeContent');
    // 원본 텍스트 가져와서 '.' 뒤에 <br> 삽입
    const raw = $nc.text();
    const replaced = raw.replace(/\. ?/g, '.<br>');
    $nc.html(replaced).addClass('dot-break');
  }

  /* -------------------- 댓글 수정/삭제 -------------------- */

  // 수정 클릭
  $('.reply-list').on('click', '.btn-edit-reply', function(e){
    e.preventDefault();
    const $li = $(this).closest('li');
    if($li.data('editing')) return;
    $li.data('editing', true);

    const $content = $li.find('.reply-content');
    const origText = $content.text().trim();
    $li.data('orig-text', origText);

    $content.hide();

    $('<textarea class="edit-reply-text">')
      .val(origText)
      .insertAfter($content);

    $('<div class="reply-actions">\
        <button class="btn-line primary sm reply-action-save">저장</button>\
        <button class="btn-line warning sm reply-action-cancel">취소</button>\
      </div>').insertAfter($li.find('.edit-reply-text'));
  });

  // 저장
  $('.reply-list').on('click', '.reply-action-save', function(e){
    e.preventDefault();
    const $li = $(this).closest('li');
    const newText = $li.find('.edit-reply-text').val().trim();
    if(!newText){ Swal.fire('알림','댓글을 입력하세요.','warning'); return; }

    $.post(`${ctx}/notice/reply/editProc`, {
      replySeq: $li.data('reply-seq'),
      replyContent: newText
    }).done(function(res){
      $li.find('.reply-content').text(newText).show();
      $li.find('.edit-reply-text').remove();
      $li.find('.reply-actions').remove();
      $li.removeData('editing').removeData('orig-text');
    }).fail(function(){
      Swal.fire('오류','수정 중 오류가 발생했습니다.','error');
    });
  });

  // 취소
  $('.reply-list').on('click', '.reply-action-cancel', function(e){
    e.preventDefault();
    const $li = $(this).closest('li');
    const origText = $li.data('orig-text');
    $li.find('.reply-content').text(origText).show();
    $li.find('.edit-reply-text').remove();
    $li.find('.reply-actions').remove();
    $li.removeData('editing').removeData('orig-text');
  });

  // 삭제
  $('.reply-list').on('click', '.btn-delete-reply', function(e){
    e.preventDefault();
    const $li = $(this).closest('li');

    Swal.fire({
      title:'삭제할까요?',
      text:'삭제 후에는 복구할 수 없습니다.',
      icon:'warning',
      showCancelButton:true,
      confirmButtonText:'삭제',
      cancelButtonText:'취소',
      confirmButtonColor:'#dc3545'
    }).then((result)=>{
      if(result.isConfirmed){
        $.post(`${ctx}/notice/reply/deleteProc`, {
          replySeq: $li.data('reply-seq')
        }).done(function(){
          $li.remove();
        }).fail(function(){
          Swal.fire('오류','삭제 중 오류가 발생했습니다.','error');
        });
      }
    });
  });

});
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
