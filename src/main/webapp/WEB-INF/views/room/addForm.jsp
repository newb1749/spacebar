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
					    <input type="hidden" id="roomCatSeq" name="roomCatSeq" value="">
					    
					    <div class="category-selection-area">
					        <p class="category-group-title">공간 대여</p>
					        <div class="category-group">
					            <span class="category-tag" data-value="1">파티룸</span>
					            <span class="category-tag" data-value="2">카페</span>
					            <span class="category-tag" data-value="3">연습실</span>
					            <span class="category-tag" data-value="4">스튜디오</span>
					            <span class="category-tag" data-value="5">회의실</span>
					            <span class="category-tag" data-value="6">녹음실</span>
					            <span class="category-tag" data-value="7">운동시설</span>
					        </div>
					        
					        <p class="category-group-title mt-3">숙박</p>
					        <div class="category-group">
					            <span class="category-tag" data-value="8">풀빌라</span>
					            <span class="category-tag" data-value="9">호텔</span>
					            <span class="category-tag" data-value="10">팬션</span>
					            <span class="category-tag" data-value="11">민박</span>
					            <span class="category-tag" data-value="12">리조트</span>
					            <span class="category-tag" data-value="13">주택</span>
					            <span class="category-tag" data-value="14">캠핑장</span>
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
						    <select class="form-select" id="region" name="region" required>
						        <option value="">지역을 선택하세요</option>
						        <option value="강원">강원</option>
						        <option value="경기">경기</option>
						        <option value="경남">경남</option>
						        <option value="경북">경북</option>
						        <option value="광주">광주</option>
						        <option value="대구">대구</option>
						        <option value="대전">대전</option>
						        <option value="부산">부산</option>
						        <option value="서울" selected>서울</option>
						        <option value="울산">울산</option>
						        <option value="인천">인천</option>
						        <option value="전남">전남</option>
						        <option value="전북">전북</option>
						        <option value="제주">제주</option>
						        <option value="충남">충남</option>
						        <option value="충북">충북</option>
						    </select>
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
						
						
						<!-- 최소/최대 이용시간(공간 대여시 가능하게?) -->
						<div class="mb-3">
						    <label for="minTimes" class="form-label">최소 이용시간</label>
						    <input type="number" class="form-control" id="minTimes" name="minTimes" value="1">
						</div>
						<div class="mb-3">
						    <label for="maxTimes" class="form-label">최대 이용시간</label>
						    <input type="number" class="form-control" id="maxTimes" name="maxTimes" value="30">
						</div>
						
						<!-- 편의시설 (필터) -->
						<div class="mb-3">
						    <label class="form-label">편의시설 (중복 선택 가능)</label>
						    <div class="facility-grid">
						        <div class="facility-item">
						            <input type="checkbox" id="fac-1" name="facilitySeqs" value="1">
						            <label for="fac-1"><i class="fas fa-wifi"></i> 와이파이</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-2" name="facilitySeqs" value="2">
						            <label for="fac-2"><i class="fas fa-snowflake"></i> 냉장고</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-3" name="facilitySeqs" value="3">
						            <label for="fac-3"><i class="fas fa-microwave"></i> 전자레인지</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-4" name="facilitySeqs" value="4">
						            <label for="fac-4"><i class="fas fa-faucet"></i> 정수기</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-5" name="facilitySeqs" value="5">
						            <label for="fac-5"><i class="fas fa-thermometer-half"></i> 에어컨 / 난방기</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-6" name="facilitySeqs" value="6">
						            <label for="fac-6"><i class="fas fa-wind"></i> 드라이기</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-7" name="facilitySeqs" value="7">
						            <label for="fac-7"><i class="fas fa-tshirt"></i> 다리미</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-8" name="facilitySeqs" value="8">
						            <label for="fac-8"><i class="fas fa-mirror"></i> 거울</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-9" name="facilitySeqs" value="9">
						            <label for="fac-9"><i class="fas fa-bed"></i> 침구</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-10" name="facilitySeqs" value="10">
						            <label for="fac-10"><i class="fas fa-bath"></i> 욕실용품</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-11" name="facilitySeqs" value="11">
						            <label for="fac-11"><i class="fas fa-hanger"></i> 옷걸이 / 행거</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-12" name="facilitySeqs" value="12">
						            <label for="fac-12"><i class="fas fa-tv"></i> TV (OTT 가능)</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-13" name="facilitySeqs" value="13">
						            <label for="fac-13"><i class="fas fa-jug-detergent"></i> 세탁기 / 건조기</label>
						        </div>
						
						        <div class="facility-item">
						            <input type="checkbox" id="fac-14" name="facilitySeqs" value="14">
						            <label for="fac-14"><i class="fas fa-utensils"></i> 취사도구</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-15" name="facilitySeqs" value="15">
						            <label for="fac-15"><i class="fas fa-fire-burner"></i> 바베큐 시설</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-16" name="facilitySeqs" value="16">
						            <label for="fac-16"><i class="fas fa-swimmer"></i> 수영장</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-17" name="facilitySeqs" value="17">
						            <label for="fac-17"><i class="fas fa-volume-mute"></i> 방음 시설</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-18" name="facilitySeqs" value="18">
						            <label for="fac-18"><i class="fas fa-microphone"></i> 마이크 / 오디오</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-19" name="facilitySeqs" value="19">
						            <label for="fac-19"><i class="fas fa-volume-up"></i> 앰프 / 스피커</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-20" name="facilitySeqs" value="20">
						            <label for="fac-20"><i class="fas fa-lightbulb"></i> 조명 장비</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-21" name="facilitySeqs" value="21">
						            <label for="fac-21"><i class="fas fa-camera"></i> 삼각대 / 촬영 장비</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-22" name="facilitySeqs" value="22">
						            <label for="fac-22"><i class="fab fa-bluetooth-b"></i> 블루투스 스피커</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-23" name="facilitySeqs" value="23">
						            <label for="fac-23"><i class="fas fa-music"></i> 악기류</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-24" name="facilitySeqs" value="24">
						            <label for="fac-24"><i class="fas fa-video"></i> 빔프로젝터 / 스크린</label>
						        </div>
						        
						        <div class="facility-item">
						            <input type="checkbox" id="fac-25" name="facilitySeqs" value="25">
						            <label for="fac-25"><i class="fas fa-desktop"></i> TV 모니터</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-26" name="facilitySeqs" value="26">
						            <label for="fac-26"><i class="fas fa-chalkboard"></i> 화이트보드</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-27" name="facilitySeqs" value="27">
						            <label for="fac-27"><i class="fas fa-print"></i> 프린터 / 복합기</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-28" name="facilitySeqs" value="28">
						            <label for="fac-28"><i class="fas fa-chair"></i> 사무용 의자 / 책상</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-29" name="facilitySeqs" value="29">
						            <label for="fac-29"><i class="fas fa-coffee"></i> 커피머신</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-30" name="facilitySeqs" value="30">
						            <label for="fac-30"><i class="fas fa-shower"></i> 화장실 / 샤워실</label>
						        </div>
						
						        <div class="facility-item">
						            <input type="checkbox" id="fac-31" name="facilitySeqs" value="31">
						            <label for="fac-31"><i class="fas fa-sink"></i> 취사장 / 개수대</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-32" name="facilitySeqs" value="32">
						            <label for="fac-32"><i class="fas fa-plug"></i> 전기 공급</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-33" name="facilitySeqs" value="33">
						            <label for="fac-33"><i class="fas fa-campground"></i> 텐트 / 타프</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-34" name="facilitySeqs" value="34">
						            <label for="fac-34"><i class="fas fa-fire"></i> 캠프파이어 구역</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-35" name="facilitySeqs" value="35">
						            <label for="fac-35"><i class="fas fa-couch"></i> 야외 테이블 / 의자</label>
						        </div>
						        <div class="facility-item">
						            <input type="checkbox" id="fac-36" name="facilitySeqs" value="36">
						            <label for="fac-36"><i class="fas fa-bug"></i> 벌레퇴치용품</label>
						        </div>
						
						    </div>
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
	        $("#roomCatSeq").val(selectedValue);
	
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

</body>
</html>
