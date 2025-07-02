<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    /* 별점 UI를 위한 CSS */
    .rating {
        display: inline-block;
        direction: rtl; /* 별을 오른쪽부터 채우기 위함 */
        border: 0;
    }
    .rating > input {
        display: none;
    }
    .rating > label {
        font-size: 2rem;
        color: #ddd;
        cursor: pointer;
    }
    .rating > input:checked ~ label,
    .rating > label:hover,
    .rating > label:hover ~ label {
        color: #f7b731;
    }
</style>
</head>
<body>

    <h1>리뷰 작성</h1>
    
    <form action="/review/writeProc" method="post" enctype="multipart/form-data">
    
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
            <strong>제목:</strong>
            <input type="text" name="reviewTitle" size="50" required />
        </p>
        
        <p>
            <strong>내용:</strong><br/>
            <textarea name="reviewContent" rows="10" cols="80" required></textarea>
        </p>
        
        <p>
            <strong>리뷰 사진 첨부 (여러장 가능):</strong><br/>
            <input type="file" name="files" multiple="multiple" />
        </p>
        
        <br/>
        <button type="submit">리뷰 등록</button>
        <button type="button" onclick="location.href='/'">취소</button>
        
    </form>

</body>
</html>