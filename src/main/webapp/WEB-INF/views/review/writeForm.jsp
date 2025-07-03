<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<c:if test="${not empty message}">
    <script>
        alert('${message}');
    </script>
</c:if>

<c:if test="${not empty errorMessage}">
    <script>
        alert('${errorMessage}');
    </script>
</c:if>

<style>
    body {
        font-family: Arial, sans-serif;
        padding: 20px;
    }
    h1 {
        margin-bottom: 20px;
    }
    form p {
        margin-bottom: 15px;
    }
    input[type="text"], textarea {
        width: 100%;
        max-width: 500px;
        padding: 8px;
        box-sizing: border-box;
    }
    button {
        padding: 10px 20px;
        cursor: pointer;
        border: 1px solid #ccc;
        border-radius: 4px;
        background-color: #f0f0f0;
    }
    button[type="submit"] {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
    }
    
    
		/* 별점 컨테이너 */
		.rating{
		    display:inline-flex;
		    flex-direction:row;      /* 왼→오 */
		    gap:4px;
		}
		
		/* radio 숨김 */
		.rating input{
		    display:none;
		}
		
		/* 빈 별 아이콘(☆) – 원하는 폰트/이미지로 교체 가능 */
		.rating label::before{
		    content:"☆";
		    font-size:2.3rem;
		    color:#ddd;
		    cursor:pointer;
		    transition:color .15s;
		}
		
		/* 마우스 hover ─ 현재 label 과 그 이전 label 들 */
		.rating label:hover::before,
		.rating label:hover~label::before{
		    color:#f7b731;           /* 채워질 색 */
		    content:"★";
		}
		
		/* 선택(checked)  ─ 현재 radio 다음부터 모든 label */
		.rating input:checked~label::before{
		    color:#f7b731;
		    content:"★";
		}

</style>
</head>
<body>

    <h1>리뷰 작성 📝</h1>
    
        <!-- 성공/오류 메시지 표시 -->
    <c:if test="${not empty message}">
        <div class="message success-message">${message}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="message error-message">${errorMessage}</div>
    </c:if>
    
    <form action="/review/writeProc" method="post" enctype="multipart/form-data">
    
        <%-- 컨트롤러로부터 받은 rsvSeq를 hidden input으로 가지고 있다가 폼 전송 시 서버로 보냅니다. --%>
        <input type="hidden" name="rsvSeq" value="${rsvSeq}" />

		<!-- ────────── ⭐ 별점 영역 ────────── -->
		<p>
		    <strong>평점:</strong>
		    <div id="starRating" class="rating">
		        <!-- radio → hidden, label 순서를 왼→오 1~5 → CSS는 LTR -->
		        <input type="radio" id="rate1" name="rating" value="1" required>
		        <label for="rate1" title="1점"></label>
		
		        <input type="radio" id="rate2" name="rating" value="2">
		        <label for="rate2" title="2점"></label>
		
		        <input type="radio" id="rate3" name="rating" value="3">
		        <label for="rate3" title="3점"></label>
		
		        <input type="radio" id="rate4" name="rating" value="4">
		        <label for="rate4" title="4점"></label>
		
		        <input type="radio" id="rate5" name="rating" value="5">
		        <label for="rate5" title="5점"></label>
		    </div>
		</p>


        <p>
            <strong>제목:</strong><br/>
            <input type="text" name="reviewTitle" placeholder="리뷰 제목을 입력하세요" required />
        </p>
        
        <p>
            <strong>내용:</strong><br/>
            <textarea name="reviewContent" rows="10" placeholder="리뷰 내용을 입력하세요" required></textarea>
        </p>
        
        <p>
            <strong>리뷰 사진 첨부 (여러 장 가능):</strong><br/>
            <input type="file" name="files" multiple="multiple" />
        </p>
        
        <br/>
        <button type="submit">리뷰 등록</button>
        <button type="button" onclick="history.back();">취소</button>
        
    </form>

</body>
</html>