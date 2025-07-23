<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
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
.content-wrapper {
        max-width: 600px;       /* 원하시는 최대 너비 */
        margin: 100px auto 0;    /* 위쪽 여백 40px, 좌우 자동(가운데), 아래 0 */
        padding: 0 20px;        /* 좌우 내부 여백 */
    }
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
    
    
    .rating {
        display: inline-block;
        direction: rtl; /* 별을 오른쪽부터 채우도록 설정 (중요) */
        border: 0;
        vertical-align: middle;
    }
    .rating input {
        display: none; /* 라디오 버튼 숨기기 */
    }
    .rating label {
        cursor: pointer;
    }
    .rating label svg {
        width: 2.2rem;   /* SVG 아이콘 크기 */
        height: 2.2rem;
        fill: #ddd;      /* 기본 별 색상 (비어있음) */
        transition: fill 0.2s; /* 색상 변경 시 부드러운 효과 */
    }

    /* 선택(checked)된 라디오 버튼의 ~ (형제) 라벨들 svg 색상 변경 */
    .rating > input:checked ~ label svg,
    /* 마우스를 올린(:hover) 라벨과 그 형제 라벨들 svg 색상 변경 */
    .rating > label:hover ~ label svg,
    .rating > label:hover svg {
        fill: #f7b731; /* 채워진 별 색상 */
    }
    
    .main-image {
      display: block;            /* 블록 레벨로 배치 */
      width: 100%;               /* 가로 100% */
      max-width: 500px;          /* 최대 너비 500px */
      height: auto;              /* 비율 유지 */
      margin-bottom: 20px;       /* 아래 여백 */
      border-radius: 4px;        /* 둥근 모서리 */
      object-fit: cover;         /* 잘라내기 없이 꽉 채우기 */
    }

</style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="content-wrapper">
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
        <strong>대표 이미지:</strong><br/>
        <!-- 컨트롤러에서 전달된 메인 이미지 URL을 ${mainImageUrl} 변수로 받았다고 가정 -->
        <img src="/resources/upload/roomtype/main/${roomTypeImgName}" alt="메인 이미지" class="main-image"/>
      </p>
		
        <p>
            <strong>평점:</strong>
            <fieldset class="rating">
                <%-- HTML 구조를 5점부터 1점 순서로 배치 (direction: rtl 때문) --%>
                <input type="radio" id="star5" name="rating" value="5" ${review.rating == 5 ? 'checked' : ''} required />
                <label for="star5" title="5점">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </label>
                
                <input type="radio" id="star4" name="rating" value="4" ${review.rating == 4 ? 'checked' : ''} />
                <label for="star4" title="4점">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </label>

                <input type="radio" id="star3" name="rating" value="3" ${review.rating == 3 ? 'checked' : ''} />
                <label for="star3" title="3점">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </label>
                
                <input type="radio" id="star2" name="rating" value="2" ${review.rating == 2 ? 'checked' : ''} />
                <label for="star2" title="2점">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </label>
                
                <input type="radio" id="star1" name="rating" value="1" />
                <label for="star1" title="1점">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </label>
            </fieldset>
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
</div>
</body>
</html>