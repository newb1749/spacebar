<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
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
    
    /* 별점 UI를 위한 CSS (중복 제거) */
    .rating {
        display: inline-block;
        direction: rtl; /* 별을 오른쪽부터 채우기 위함 */
        border: 0;
        vertical-align: middle;
    }
    .rating > input {
        display: none;
    }
    .rating > label {
        font-size: 2rem;
        color: #ddd;
        cursor: pointer;
    }
    /* 선택되거나 마우스가 올라간 별과 그 이전 별들 색상 변경 */
    .rating > input:checked ~ label,
    .rating > label:hover,
    .rating > label:hover ~ label {
        color: #f7b731;
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

        <p>
            <strong>평점:</strong>
            <fieldset class="rating">
                <input type="radio" id="star5" name="rating" value="5" required /><label for="star5">⭐</label>
                <input type="radio" id="star4" name="rating" value="4" /><label for="star4">⭐</label>
                <input type="radio" id="star3" name="rating" value="3" /><label for="star3">⭐</label>
                <input type="radio" id="star2" name="rating" value="2" /><label for="star2">⭐</label>
                <input type="radio" id="star1" name="rating" value="1" /><label for="star1">⭐</label>
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

</body>
</html>