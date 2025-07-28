<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<%@ page trimDirectiveWhitespaces="true" %>
<!-- 해당 ROOM 상세보기에 속해 있는 리뷰 페이지, 비동기 -->



<input type="hidden" id="roomSeq" value="${roomSeq}" />
<div id="reviewListContainer">
<c:forEach var="review" items="${reviewList}">
    <div class="review" data-review-seq="${review.reviewSeq}">
        <h3>${review.reviewTitle}</h3>
        <div class="star-rating">
		  <c:forEach begin="1" end="5" var="i">
		    <i class="${i <= review.rating ? 'fas' : 'far'} fa-star"></i>
		  </c:forEach>
		</div>
		<p>
			<c:choose>
			  <c:when test="${not empty review.profImgExt}">
			    <img src="/resources/upload/userprofile/${review.userId}.${review.profImgExt}" class="profile-img" alt="프로필 이미지" />
			  </c:when>
			  <c:otherwise>
			    <img src="/resources/upload/userprofile/default_profile.png" class="profile-img" alt="기본 프로필 이미지" />
			  </c:otherwise>
			</c:choose>
	        작성자: ${review.userNickname} | 평점: ${review.rating} | 작성일: ${review.regDt}
        </p>
		<%
		    // controller에서 처리하는 것이 더 좋지만, jsp에서 처리한다면 scriptlet을 사용해 newline 문자를 정의할 수 있습니다.
		    pageContext.setAttribute("brTag", "<br/>");
		    pageContext.setAttribute("newLineChar", "\n");
		%>
        <c:forEach var="img" items="${review.reviewImageList}">
            <img src="/resources/upload/review/${img.reviewImgName}" style="max-width: 300px;">
        </c:forEach>
        <div class="review-content">
		    <c:out value="${review.reviewContent}" escapeXml="false"/>
		</div>

   
	<div class="comment-section">

	
	  <!-- 이건 항상 출력 -->
	  <div class="comment-list" id="comment-list-${review.reviewSeq}"></div>
	
	  <!-- 작성은 호스트만 -->
	  <c:if test="${review.hostAuthor}">
	    <form class="comment-form" data-review-seq="${review.reviewSeq}">
	      <textarea name="reviewCmtContent"></textarea>
	      <button type="submit">댓글 작성</button>
	    </form>
	  </c:if>
	</div>

    </div>
</c:forEach>

<c:if test="${not empty reviewPaging}">
    <div class="paging text-center mt-4">
      <nav>
        <ul class="pagination justify-content-center">
          <c:if test="${reviewPaging.prevBlockPage gt 0}">
            <li class="page-item">
              <a href="javascript:void(0);" class="page-link" onclick="loadReviewList(${i})">${i}</a>
            </li>
          </c:if>

          <c:forEach var="i" begin="${reviewPaging.startPage}" end="${reviewPaging.endPage}">
            <li class="page-item ${i eq reviewCurPage ? 'active' : ''}">
              <a href="javascript:void(0);" class="page-link" onclick="loadReviewList(${i})">${i}</a>
            </li>
          </c:forEach>

          <c:if test="${reviewPaging.nextBlockPage gt 0}">
            <li class="page-item">
              <a class="page-link" href="?roomSeq=${roomSeq}&reviewCurPage=${reviewPaging.nextBlockPage}">다음</a>
            </li>
          </c:if>
        </ul>
      </nav>
    </div>
</c:if>


<!-- JS: 댓글 불러오기/작성 -->
<script>
document.querySelectorAll('.comment-section').forEach(function (sectionEl) {
  const reviewSeq = sectionEl.closest('.review').dataset.reviewSeq;
  const listEl = sectionEl.querySelector('.comment-list');
  const form = sectionEl.querySelector('.comment-form');

  async function loadComments() {
    try {
      const sessionUserId = "${sessionScope.SESSION_USER_ID}";
      const res = await fetch("/review/comment/list?reviewSeq=" + reviewSeq);
      const data = await res.json();

      if (data.code === 0) {
        listEl.innerHTML = '';
        data.data.forEach(function (c) {
          const div = document.createElement('div');
          div.className = 'comment';
          div.dataset.reviewCmtSeq = c.reviewCmtSeq;

          const left = document.createElement('div');
          left.className = 'comment-left';

          const img = document.createElement('img');
          img.className = 'profile-img'; 
          img.src = (c.profImgExt && c.profImgExt.trim() !== '')
          ? "/resources/upload/userprofile/" + c.userId + "." + c.profImgExt
          : "/resources/upload/userprofile/회원.png";
          left.appendChild(img);

          const body = document.createElement('div');
          body.className = 'comment-body';

          const nickname = document.createElement('div');
          nickname.className = 'comment-nickname';
          nickname.textContent = c.userNickname;

          const content = document.createElement('p');
          content.className = 'comment-content';
          content.textContent = c.reviewCmtContent;

          const textarea = document.createElement('textarea');
          textarea.className = 'edit-content';
          textarea.style.display = 'none';

          const meta = document.createElement('div');
          meta.className = 'comment-meta';

          const date = document.createElement('div');
          date.className = 'comment-date';
          date.textContent = c.createDt;

          const buttons = document.createElement('div');
          buttons.className = 'comment-buttons';

          if (c.userId === sessionUserId) {
            const editBtn = document.createElement('button');
            editBtn.className = 'btn-edit';
            editBtn.textContent = '수정';

            const updateBtn = document.createElement('button');
            updateBtn.className = 'btn-update';
            updateBtn.textContent = '수정 완료';
            updateBtn.style.display = 'none';

            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'btn-delete';
            deleteBtn.textContent = '삭제';
            deleteBtn.dataset.reviewCmtSeq = c.reviewCmtSeq;

            buttons.append(editBtn, updateBtn, deleteBtn);
          }

          meta.append(date, buttons);
          body.append(meta, nickname, content, textarea);

          div.append(left, body);
          listEl.append(div);
        });

     	// 수정 버튼
        listEl.querySelectorAll('.btn-edit').forEach(function (btn) {
            btn.addEventListener('click', function () {
                const commentDiv = btn.closest('.comment');
                const contentEl = commentDiv.querySelector('.comment-content');
                const textarea = commentDiv.querySelector('.edit-content');
                const updateBtn = commentDiv.querySelector('.btn-update');

                if (textarea && contentEl) {
                    textarea.value = contentEl.textContent.trim(); // ✅ 기존 댓글 내용 넣기
                    textarea.style.display = 'block';
                    updateBtn.style.display = 'inline-block';
                    btn.style.display = 'none';
                    contentEl.style.display = 'none';
                } else {
                    console.warn("수정 버튼 클릭 시 DOM 요소 못찾음");
                }
            });
        });


        listEl.querySelectorAll('.btn-update').forEach(function (btn) {
          btn.addEventListener('click', async function () {
            const comment = btn.closest('.comment');
            const commentSeq = comment.dataset.reviewCmtSeq;
            const content = comment.querySelector('.edit-content').value.trim();
            if (!content) return;

            const res = await fetch('/review/comment/update', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ reviewCmtSeq: Number(commentSeq), reviewCmtContent: content })
            });
            const result = await res.json();
            if (result.code === 0) loadComments();
            else alert(result.msg);
          });
        });

        listEl.querySelectorAll('.btn-delete').forEach(function (btn) {
          btn.addEventListener('click', async function () {
            const commentSeq = btn.dataset.reviewCmtSeq;
            if (!confirm("정말 삭제하시겠습니까?")) return;

            const res = await fetch('/review/comment/delete', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ reviewCmtSeq: Number(commentSeq) })
            });
            const result = await res.json();
            if (result.code === 0) loadComments();
            else alert(result.msg);
          });
        });
      }
    } catch (err) {
      console.error(err);
    }
  }

  loadComments();

  if (form) {
    form.addEventListener('submit', async function (e) {
      e.preventDefault();
      const textarea = form.querySelector('textarea');
      const content = textarea.value.trim();
      if (!content) return;

      const res = await fetch('/review/comment/write', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reviewSeq: Number(reviewSeq), reviewCmtContent: content })
      });

      const data = await res.json();
      if (res.ok && data.code === 0) {
        textarea.value = '';
        loadComments();
      } else {
        alert(data.msg || "댓글 작성 실패");
      }
    });
  }
});
</script>




</div>


<style>
.review {
    border: 1px solid #ddd;
    padding: 20px;
    margin-bottom: 80px;  /* ← 여기 간격 조절 */
}

.review-box {
    border: 1px solid #ddd;
    padding: 20px;
    margin-bottom: 40px;
}

.review-content {
    margin-top: 15px;
    background: #f9f9f9;
    padding: 10px;
    word-break: break-word;
    white-space: normal;
    overflow-wrap: break-word;
    max-width: 100%;
}

.star-rating {
    color: #f5c518;
    margin-bottom: 8px;
}

/* 댓글 전체 영역 */
.comment-section {
    margin-top: 40px;
    border-top: 1px solid #eee;
    padding-top: 20px;
}

.comment {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 15px 0;
    border-bottom: 1px solid #ddd;
    position: relative;
}

/* 왼쪽 프로필 */
.comment-left {
    flex-shrink: 0;
    margin-right: 10px;
}

.profile-img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
}

/* 본문 */
.comment-body {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
}

/* 닉네임과 날짜 */
.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
}

.comment-header .nickname {
    font-weight: bold;
    margin-right: 10px;
}

.comment-header .date {
    font-size: 12px;
    color: #999;
}

/* 댓글 내용 */
.comment-content {
    font-size: 14px;
    margin-top: 5px;
    white-space: pre-wrap;
    word-break: break-word;
}

/* 수정용 textarea */
.edit-content {
    width: 100%;
    margin-top: 6px;
    padding: 8px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

/* 날짜 + 버튼 묶는 메타정보 영역 */
.comment-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
}

/* 날짜 */
.comment-date {
    font-size: 12px;
    color: #999;
    margin-right: 8px;
}

/* 버튼들 */
.comment-buttons {
    display: flex;
    flex-direction: row;
    gap: 8px;
    align-items: center;
}

.comment-buttons button {
    padding: 6px 12px;
    font-size: 13px;
    border-radius: 4px;
    border: none;
    background-color: #f2f2f2;
    cursor: pointer;
}

.comment-buttons .btn-update {
    background-color: #4CAF50;
    color: white;
}

/* 댓글 작성 영역 */
.comment-form {
  margin-top: 15px;
  display: flex;
  flex-direction: column;
  align-items: flex-end;  /* 오른쪽 정렬 */
}
.comment-form textarea {
    width: 100%;
    height: 70px;
    padding: 10px;
    resize: none;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

.comment-nickname {
    font-weight: bold;
    font-size: 16px;  /* ← 크기 조절, 필요시 더 키울 수 있음 */
    margin-bottom: 4px;
}


.comment-form button {
    margin-top: 8px;
    padding: 8px 16px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 14px;
    float: right;
    cursor: pointer;
}

.comment-form button:hover {
    background-color: #0056b3;
}


</style>

<script>
  const reviewList = [];

  <c:forEach var="review" items="${reviewList}">
    reviewList.push({
      userId: "${review.userId}",
      nickname: "${review.userNickname}",
      profImgExt: "${review.profImgExt}",
      regDt: "${review.regDt}",
      reviewSeq: ${review.reviewSeq}
    });
  </c:forEach>

  console.log("==== reviewList 디버깅용 출력 ====");
  console.log(reviewList);
</script>


