<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>${review.reviewTitle}</title>
</head>
<body>
    <h1>${review.roomTitle} - ${review.roomTypeTitle}</h1>
    <hr>
    
    <%-- 리뷰 상세 정보 표시 --%>
    <h2>${review.reviewTitle}</h2>
    <p>작성자: ${review.userNickname} | 평점: ${review.rating} | 작성일: ${review.regDt}</p>
    
    <%-- 리뷰 이미지 표시 --%>
    <c:forEach var="img" items="${review.reviewImageList}">
        <img src="/resources/upload/review/${img.reviewImgName}" alt="${img.reviewImgOrigName}" style="max-width:300px; margin:5px;">
    </c:forEach>
    
    <%-- 리뷰 내용 표시 --%>
    <div style="margin-top:20px; padding:15px; background-color:#f8f8f8;">
        ${review.reviewContent}
    </div>

<%-- 이 코드는 리뷰 상세 페이지에 포함될 댓글 섹션입니다. --%>

<%-- ======================================================= --%>
<%--                리뷰 댓글 섹션 HTML & CSS                  --%>
<%-- ======================================================= --%>

<div class="comment-section">
    <h3>댓글</h3>
    
    <div id="comment-list"></div>

    <form id="comment-form">
        <textarea id="comment-content" placeholder="게스트에게 댓글을 남겨주세요..." required></textarea>
        <button type="submit">작성</button>
    </form>
</div>


<%-- ======================================================= --%>
<%--             리뷰 댓글 처리 JavaScript (AJAX)             --%>
<%-- ======================================================= --%>
<script>
// (중요) 이 값들은 JSP에서 모델 데이터를 사용해 설정해야 합니다.
const reviewSeq = ${review.reviewSeq}; // 현재 보고 있는 리뷰의 번호
const loginUserId = "${sessionScope.sessionUserId}"; // 현재 로그인한 사용자의 ID

// HTML 요소 가져오기
const commentListEl = document.getElementById('comment-list');
const commentForm = document.getElementById('comment-form');
const commentContentInput = document.getElementById('comment-content');

/**
 * 댓글 목록을 서버에서 불러와 화면에 그리는 함수
 */
async function loadComments() {
    try {
        const response = await fetch(`/review/comment/list?reviewSeq=${reviewSeq}`);
        const result = await response.json();

        if (result.code === 0) {
            commentListEl.innerHTML = ''; // 기존 목록 초기화
            result.data.forEach(comment => {
                const div = document.createElement('div');
                div.className = 'comment-item';
                // 각 댓글에 고유 ID를 data 속성으로 저장
                div.dataset.cmtSeq = comment.reviewCmtSeq; 
                div.dataset.userId = comment.userId;
                
                let buttons = '';
                // 로그인한 사용자와 댓글 작성자가 같을 때만 버튼 표시
                if (comment.userId === loginUserId) {
                    buttons = `<div class="comment-buttons">
                                   <button class="edit-btn">수정</button>
                                   <button class="delete-btn">삭제</button>
                               </div>`;
                }

                div.innerHTML = `
                    <div class="comment-header">
                        <strong>${comment.userNickname}</strong>
                        <small>${comment.createDt}</small>
                        ${buttons}
                    </div>
                    <p class="comment-content">${comment.reviewCmtContent}</p>`;
                commentListEl.appendChild(div);
            });
        }
    } catch (error) {
        console.error('댓글 로딩 실패:', error);
    }
}

/**
 * 댓글 작성 폼 제출 이벤트 처리
 */
commentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const content = commentContentInput.value.trim();
    if (!content) {
        alert('댓글 내용을 입력하세요.');
        return;
    }

    try {
        const response = await fetch('/review/comment/write', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                reviewSeq: reviewSeq,
                reviewCmtContent: content
            })
        });
        const result = await response.json();
        
        if (response.ok) {
            commentContentInput.value = ''; // 입력창 비우기
            loadComments(); // 목록 새로고침
        } else {
            alert(result.msg); // "권한이 없습니다" 등 서버 메시지 표시
        }
    } catch (error) {
        console.error('댓글 작성 실패:', error);
    }
});

/**
 * 댓글 수정 및 삭제 이벤트 처리 (이벤트 위임)
 */
commentListEl.addEventListener('click', async (e) => {
    const target = e.target;
    const commentItem = target.closest('.comment-item');
    if (!commentItem) return;
    
    const cmtSeq = commentItem.dataset.cmtSeq;

    // 삭제 버튼 클릭 시
    if (target.classList.contains('delete-btn')) {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        
        const response = await fetch('/review/comment/delete', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ reviewCmtSeq: cmtSeq })
        });
        const result = await response.json();

        if (response.ok) {
            loadComments();
        } else {
            alert(result.msg);
        }
    }
    
    // 수정 버튼 클릭 시
    if (target.classList.contains('edit-btn')) {
        const currentContent = commentItem.querySelector('p.comment-content').innerText;
        const newContent = prompt('수정할 내용을 입력하세요.', currentContent);
        
        if (newContent && newContent.trim() !== '') {
            const response = await fetch('/review/comment/update', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ 
                    reviewCmtSeq: cmtSeq,
                    reviewCmtContent: newContent
                })
            });
            const result = await response.json();

            if (response.ok) {
                loadComments();
            } else {
                alert(result.msg);
            }
        }
    }
});

// 페이지가 처음 로드될 때 댓글 목록을 불러옵니다.
document.addEventListener('DOMContentLoaded', loadComments);
</script>
    
	<style>
	    .comment-section { max-width: 800px; margin: 40px auto; padding-top: 20px; border-top: 1px solid #eee; }
	    .comment-section h3 { margin-bottom: 20px; }
	    #comment-form { display: flex; gap: 10px; margin-bottom: 30px; }
	    #comment-form textarea { flex-grow: 1; border: 1px solid #ccc; border-radius: 5px; padding: 10px; resize: vertical; min-height: 60px; }
	    #comment-form button { width: 80px; background-color: #333; color: white; border: none; border-radius: 5px; cursor: pointer; }
	    
	    .comment-item { padding: 15px 0; border-bottom: 1px solid #f0f0f0; }
	    .comment-item:last-child { border-bottom: none; }
	    .comment-header { display: flex; align-items: center; margin-bottom: 8px; }
	    .comment-header strong { font-size: 1.1em; }
	    .comment-header small { color: #888; margin-left: 10px; }
	    .comment-buttons { margin-left: auto; }
	    .comment-buttons button { background: none; border: none; color: #888; cursor: pointer; font-size: 0.9em; padding: 2px 5px;}
	    .comment-content { padding-left: 5px; }
	</style>

    <div class="comment-section">
        <h3>댓글</h3>
        <div id="comment-list"></div>
        <form id="comment-form">
            <textarea id="comment-content" placeholder="게스트에게 댓글을 남겨주세요..." required></textarea>
            <button type="submit">작성</button>
        </form>
    </div>

    <script>
    // (중요) JSP 모델 데이터를 JavaScript 변수로 설정
    const reviewSeq = ${review.reviewSeq};
    const loginUserId = "${sessionScope.sessionUserId}"; // 세션에서 로그인 사용자 ID 가져오기

    // ... 이전에 만들었던 댓글 JavaScript 로직 전체 ...
    // (loadComments, submit 이벤트, click 이벤트 등)
    </script>
    
</body>
</html>

