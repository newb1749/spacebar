<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>숙소 등록N</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    body {
        background-color: #f8f9fa;
    }
    .container-fluid {
        padding: 2rem;
    }
    .card {
        border-radius: 0.75rem;
        box-shadow: 0 0.5rem 1rem rgba(0,0,0,.15);
    }
    .card-header {
        font-weight: 600;
        font-size: 1.25rem;
        background-color: #fff;
        border-bottom: 1px solid #dee2e6;
    }
    .form-label {
        font-weight: 500;
    }
    .right-panel {
        position: sticky;
        top: 2rem;
    }
    .room-type-block {
        border: 1px solid #d1d1d1;
        border-radius: 0.5rem;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        background-color: #fff;
    }
    .btn-remove-room-type {
        float: right;
    }
    /* ========== [추가] 카테고리 버튼 스타일 ========== */
	.category-group-title {
	    font-size: 0.9rem;
	    color: #6c757d;
	    margin-bottom: 0.5rem;
	}
	.category-tag {
	    display: inline-block;
	    padding: 0.5rem 1rem;
	    margin: 0.25rem;
	    border: 1px solid #ced4da;
	    border-radius: 20px;
	    font-size: 0.95rem;
	    cursor: pointer;
	    transition: all 0.2s ease-in-out;
	}
	.category-tag:hover {
	    background-color: #e9ecef;
	}
	.category-tag.active {
	    background-color: #0d6efd; /* Bootstrap primary color */
	    color: #fff;
	    border-color: #0d6efd;
	    font-weight: 500;
	}
/* ============================================= */
</style>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container-fluid">
    <form name="addForm" id="addForm" action="/room/addProc" method="post" enctype="multipart/form-data">
        <div class="row">
            <!-- /////////////// 왼쪽 영역 (70%) /////////////// -->
            <div class="col-md-8">
                
                <!-- 1. 숙소 기본 정보 -->
                <div class="card mb-4">
                    <div class="card-header">
                        숙소 기본 정보
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="roomTitle" class="form-label">숙소 이름</label>
                            <input type="text" class="form-control" id="roomTitle" name="roomTitle" placeholder="숙소의 이름을 입력하세요" required>
                        </div>
                        <div class="mb-3">
                        
                        <div class="mb-3">
					    <label class="form-label">카테고리</label>
					    <input type="hidden" id="roomCategory" name="roomCategory" value="">
					    
					    <div class="category-selection-area">
					        <p class="category-group-title">공간 대여</p>
					        <div class="category-group">
					            <span class="category-tag" data-value="PARTY_ROOM">파티룸</span>
					            <span class="category-tag" data-value="CAFE">카페</span>
					            <span class="category-tag" data-value="PRACTICE_ROOM">연습실</span>
					            <span class="category-tag" data-value="STUDIO">스튜디오</span>
					            <span class="category-tag" data-value="MEETING_ROOM">회의실</span>
					            <span class="category-tag" data-value="RECORDING_STUDIO">녹음실</span>
					            <span class="category-tag" data-value="GYM">운동시설</span>
					        </div>
					        
					        <p class="category-group-title mt-3">숙박</p>
					        <div class="category-group">
					            <span class="category-tag" data-value="POOL_VILLA">풀빌라</span>
					            <span class="category-tag" data-value="HOTEL">호텔</span>
					            <span class="category-tag" data-value="PENSION">팬션</span>
					            <span class="category-tag" data-value="GUEST_HOUSE">민박</span>
					            <span class="category-tag" data-value="RESORT">리조트</span>
					            <span class="category-tag" data-value="HOME">주택</span>
					            <span class="category-tag" data-value="CAMPING">캠핑장</span>
					        </div>
					    </div>
					</div>
                            <label for="roomAddr" class="form-label">주소</label>
                            <input type="text" class="form-control" id="roomAddr" name="roomAddr" placeholder="숙소의 주소를 입력하세요" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="roomDesc" class="form-label">숙소 설명</label>
                            <textarea class="form-control" id="roomDesc" name="roomDesc" rows="5" placeholder="숙소에 대한 상세한 설명을 작성해주세요."></textarea>
                        </div>
	
						
						<!-- 지역 -->
						<div class="mb-3">
						    <label for="region" class="form-label">지역</label>
						    <input type="text" class="form-control" id="region" name="region" value="서울특별시">
						</div>
						
						<!-- 자동 승인 여부 -->
						<div class="mb-3">
						    <label for="autoConfirmYn" class="form-label">자동 승인 여부</label>
						    <select class="form-select" id="autoConfirmYn" name="autoConfirmYn">
						        <option value="Y" selected>Y</option>
						        <option value="N">N</option>
						    </select>
						</div>
						
						<!-- 취소 정책 -->
						<div class="mb-3">
						    <label for="cancelPolicy" class="form-label">취소 정책</label>
						    <input type="text" class="form-control" id="cancelPolicy" name="cancelPolicy" value="FREE_CANCEL_1DAY">
						</div>
						
						
						<!-- 최소/최대 예약 일수 -->
						<div class="mb-3">
						    <label for="minTimes" class="form-label">최소 숙박일수</label>
						    <input type="number" class="form-control" id="minTimes" name="minTimes" value="1">
						</div>
						<div class="mb-3">
						    <label for="maxTimes" class="form-label">최대 숙박일수</label>
						    <input type="number" class="form-control" id="maxTimes" name="maxTimes" value="30">
						</div>

                        <hr/>
                        
                        <div class="mb-3">
                            <label for="roomMainImage" class="form-label">대표 이미지 (1개)</label>
                            <input class="form-control" type="file" id="roomMainImage" name="roomMainImage" accept="image/*">
                        </div>

                        <div class="mb-3">
                            <label for="roomDetailImages" class="form-label">상세 이미지 (여러 개 선택 가능)</label>
                            <input class="form-control" type="file" id="roomDetailImages" name="roomDetailImages" multiple accept="image/*">
                        </div>
                    </div>
                </div>

                <!-- 2. 객실 타입 정보 (동적으로 추가될 영역) -->
                <div id="roomTypeContainer">
                    <!-- 자바스크립트로 이곳에 객실 타입 블록이 추가됩니다. -->
                </div>

            </div>

            <!-- /////////////// 오른쪽 영역 (30%) /////////////// -->
            <div class="col-md-4">
                <div class="card right-panel">
                    <div class="card-body">
                        <p class="card-text">
                            숙소의 기본 정보와 객실 타입을 입력해주세요. 객실 타입은 최소 1개 이상 등록해야 합니다.
                        </p>
                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-secondary" id="btnAddRoomType">
                                <i class="fas fa-plus"></i> 객실 타입 추가
                            </button>
                            <hr/>
                            <button type="submit" class="btn btn-primary btn-lg" id="btnSubmit">
                                <i class="fas fa-save"></i> 최종 숙소 등록
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>


<!-- /////////////// 객실 타입 템플릿 (숨겨져 있음) /////////////// -->
<div id="roomTypeTemplate" style="display: none;">
    <div class="room-type-block">
        <button type="button" class="btn-close btn-remove-room-type" aria-label="Close"></button>
        <h5 class="mb-3">객실 타입 정보</h5>
        <div class="row">
            <div class="col-12 mb-3">
                <label class="form-label">객실 이름</label>
                <input type="text" class="form-control" name="roomTypeTitle" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">평일 가격</label>
                <input type="number" class="form-control" name="weekdayAmt" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">주말 가격</label>
                <input type="number" class="form-control" name="weekendAmt" required>
            </div>

            <!-- 체크인/아웃 날짜 -->
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크인 날짜</label>
			    <input type="text" class="form-control" name="roomCheckInDt" value="20250701">
			</div>
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크아웃 날짜</label>
			    <input type="text" class="form-control" name="roomCheckOutDt" value="20250703">
			</div>
			
			<!-- 체크인/아웃 시간 -->
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크인 시간</label>
			    <input type="text" class="form-control" name="roomCheckInTime" value="1500">
			</div>
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크아웃 시간</label>
			    <input type="text" class="form-control" name="roomCheckOutTime" value="1100">
			</div>         
            <div class="col-md-6 mb-3">
                <label class="form-label">최소 숙박일수</label>
                <input type="number" class="form-control" name="minDay" value="1" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">최대 숙박일수</label>
                <input type="number" class="form-control" name="maxDay" value="30" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">최대 인원</label>
                <input type="number" class="form-control" name="maxGuests" required>
            </div>  
            
             <div class="col-12 mb-3">
                <label class="form-label">객실 설명</label>
                <textarea class="form-control" name="roomTypeDesc" rows="3"></textarea>
            </div>
            <hr class="my-3"/>
            <div class="col-12 mb-3">
                <label class="form-label">객실 대표 이미지 (1개)</label>
                <input class="form-control" type="file" name="roomTypeMainImage_INDEX" accept="image/*">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">객실 상세 이미지 (여러 개)</label>
                <input class="form-control" type="file" name="roomTypeDetailImages_INDEX" multiple accept="image/*">
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    
    let roomTypeIndex = 0;
	
    // "객실 타입 추가" 버튼 클릭 이벤트
    $("#btnAddRoomType").on("click", function() {
        // 1. 숨겨진 템플릿을 복사합니다.
        let template = $("#roomTypeTemplate .room-type-block").clone();

        // 2. 템플릿 내부의 input들의 name 속성을 동적으로 변경합니다.
        //    (예: roomTypeMainImage_INDEX -> roomTypeMainImage_0)
        template.find('[name="roomTypeMainImage_INDEX"]').attr('name', 'roomTypeMainImage_' + roomTypeIndex);
        template.find('[name="roomTypeDetailImages_INDEX"]').attr('name', 'roomTypeDetailImages_' + roomTypeIndex);
        // 모든 input name 인덱싱 추가
        template.find('[name="roomTypeTitle"]').attr('name', 'roomTypeTitle_' + roomTypeIndex);
        template.find('[name="weekdayAmt"]').attr('name', 'weekdayAmt_' + roomTypeIndex);
        template.find('[name="weekendAmt"]').attr('name', 'weekendAmt_' + roomTypeIndex);
        template.find('[name="maxGuests"]').attr('name', 'maxGuests_' + roomTypeIndex);
        template.find('[name="minDay"]').attr('name', 'minDay_' + roomTypeIndex);
        template.find('[name="maxDay"]').attr('name', 'maxDay_' + roomTypeIndex);
        template.find('[name="roomTypeDesc"]').attr('name', 'roomTypeDesc_' + roomTypeIndex);
        template.find('[name="roomCheckInDt"]').attr('name', 'roomCheckInDt_' + roomTypeIndex);
        template.find('[name="roomCheckOutDt"]').attr('name', 'roomCheckOutDt_' + roomTypeIndex);
        template.find('[name="roomCheckInTime"]').attr('name', 'roomCheckInTime_' + roomTypeIndex);
        template.find('[name="roomCheckOutTime"]').attr('name', 'roomCheckOutTime_' + roomTypeIndex);
        
        // 3. 복사된 템플릿을 컨테이너에 추가합니다.
        $("#roomTypeContainer").append(template);
        
        // 4. 다음 객실 타입을 위해 인덱스를 1 증가시킵니다.
        roomTypeIndex++;
    });

    // "객실 타입 삭제" 버튼 클릭 이벤트 (동적으로 생성된 버튼에 대한 이벤트 처리)
    $("#roomTypeContainer").on("click", ".btn-remove-room-type", function() {
        // 클릭된 버튼의 가장 가까운 .room-type-block 부모 요소를 찾아서 삭제합니다.
        $(this).closest(".room-type-block").remove();
    });

    // 폼 제출 전 유효성 검사
    $("#addForm").on("submit", function() {
        if ($("#roomTypeContainer .room-type-block").length === 0) {
            alert("객실 타입은 최소 1개 이상 등록해야 합니다.");
            return false; // 폼 제출 중단
        }
        
        // 여기에 다른 필수 입력값들에 대한 유효성 검사를 추가할 수 있습니다.
        
        // 모든 검사를 통과하면 폼을 제출합니다.
        return true;
    });
    
	 // ========== [추가] 카테고리 버튼 클릭 이벤트 ==========
	    $(".category-selection-area").on("click", ".category-tag", function() {
	        // 클릭한 태그의 data-value 속성 값 가져오기
	        const selectedValue = $(this).data("value");
	
	        // 숨겨진 input에 값 설정
	        $("#roomCategory").val(selectedValue);
	
	        // 모든 태그에서 active 클래스 제거
	        $(".category-tag").removeClass("active");
	
	        // 클릭한 태그에만 active 클래스 추가
	        $(this).addClass("active");
	    });
    // =============================================
    
    // 페이지 로드 시 기본적으로 객실 타입 1개를 추가해줍니다.
    $("#btnAddRoomType").trigger("click");

});
</script>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
