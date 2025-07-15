<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 수정</title>
<style>
    /* writeForm.jsp와 동일한 스타일을 적용하여 일관성을 유지합니다. */
    body { font-family: Arial, sans-serif; padding: 20px; }
    h1 { margin-bottom: 20px; }
    form p { margin-bottom: 15px; }
    input[type="text"], textarea { width: 100%; max-width: 500px; padding: 8px; box-sizing: border-box; }
    button { padding: 10px 20px; cursor: pointer; border: 1px solid #ccc; border-radius: 4px; background-color: #f0f0f0; }
    button[type="submit"] { background-color: #007bff; color: white; border-color: #007bff; }
    
    .rating {
        display: inline-block;
        direction: rtl; /* 별을 오른쪽부터 채우도록 설정 (중요ㅋ) */
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
    
    .image-list-item { display: inline-block; text-align: center; margin: 10px; border: 1px solid #eee; padding: 5px; }
</style>
</head>
<body>

    <h1>리뷰 수정 ✏️</h1>
    
    <form action="/review/updateProc" method="post" enctype="multipart/form-data">
    
        <%-- 수정할 리뷰의 reviewSeq를 hidden 값으로 반드시 포함해야 합니다. --%>
        <input type="hidden" name="reviewSeq" value="${review.reviewSeq}" />

		<!-- ────────── ⭐ 별점 영역 ────────── -->
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
            <%-- value 속성에 기존 제목을 채워줍니다. --%>
            <input type="text" name="reviewTitle" value="${review.reviewTitle}" placeholder="리뷰 제목을 입력하세요" required />
        </p>
        
        <p>
            <strong>내용:</strong><br/>
            <%-- textarea는 태그 사이에 기존 내용을 채워줍니다. --%>
            <textarea name="reviewContent" rows="10" placeholder="리뷰 내용을 입력하세요" required>${review.reviewContent}</textarea>
        </p>
        
        <c:if test="${not empty review.reviewImageList}">
            <p>
                <strong>기존 이미지 (삭제할 이미지 체크):</strong><br/>
                <c:forEach var="img" items="${review.reviewImageList}">
                    <div class="image-list-item">
                        <img src="/resources/upload/review/${img.reviewImgName}" alt="${img.reviewImgOrigName}" style="width:100px; height:100px; object-fit:cover;">
                        <br>
                        <%-- 삭제를 위해 컨트롤러로 이미지 시퀀스(reviewImgSeq)를 넘겨줍니다. --%>
                        <input type="checkbox" name="deleteImgSeqs" value="${img.reviewImgSeq}"> 삭제
                    </div>
                </c:forEach>
            </p>
        </c:if>
        
        <p>
            <strong>새 이미지 추가:</strong><br/>
            <input type="file" name="files" multiple="multiple" />
        </p>
        
        <br/>
        <button type="submit">수정 완료</button>
        <button type="button" onclick="location.href='/review/myList'">취소</button>
        
    </form>
</body>
</html>