<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>새로운 숙소 등록</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    :root {
        --bs-primary-rgb: 86, 128, 233; /* 커스텀 프라이머리 컬러 */
        --bs-secondary-rgb: 108, 117, 125;
    }

    body {
        background-color: #f4f7f6;
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, "Helvetica Neue", "Segoe UI", "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif;
    }
    .container-fluid {
        padding: 2rem 3rem;
    }
    .main-title {
        font-weight: 700;
        margin-bottom: 2rem;
    }
    .card {
        border: none;
        border-radius: 0.75rem;
        box-shadow: 0 0.5rem 1.5rem rgba(0,0,0,.08);
        overflow: hidden;
    }
    .card-header {
        font-weight: 600;
        font-size: 1.1rem;
        background-color: #fff;
        padding: 1rem 1.5rem;
        border-bottom: 1px solid #e9ecef;
    }
    .card-header .fa-solid {
        color: rgba(var(--bs-primary-rgb), 0.8);
        margin-right: 0.5rem;
    }
    .card-body {
        padding: 1.5rem;
    }
    .form-label {
        font-weight: 500;
        color: #495057;
    }
    .form-text {
        font-size: 0.85rem;
    }

    /* 오른쪽 고정 패널 */
    .right-panel {
        position: sticky;
        top: 2rem;
    }

    /* 카테고리 태그 */
    .category-group-title {
        font-size: 0.9rem;
        font-weight: 500;
        color: #6c757d;
        margin-bottom: 0.5rem;
    }
    .category-tag {
        display: inline-block;
        padding: 0.5rem 1.25rem;
        margin: 0.25rem;
        border: 1px solid #ced4da;
        border-radius: 20px;
        font-size: 0.95rem;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
    }
    .category-tag:hover {
        background-color: #e9ecef;
        transform: translateY(-2px);
    }
    .category-tag.active {
        background-color: rgb(var(--bs-primary-rgb));
        color: #fff;
        border-color: rgb(var(--bs-primary-rgb));
        font-weight: 500;
        box-shadow: 0 4px 8px rgba(var(--bs-primary-rgb), 0.2);
    }

    /* 편의시설 선택 박스 */
    .facility-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 1rem;
    }
    .facility-box {
        border: 2px solid #e9ecef;
        border-radius: 0.5rem;
        padding: 1rem;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    .facility-box:hover {
        border-color: rgba(var(--bs-primary-rgb), 0.5);
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .facility-box.active {
        border-color: rgb(var(--bs-primary-rgb));
        background-color: rgba(var(--bs-primary-rgb), 0.05);
        font-weight: 600;
    }
    .facility-box .fa-solid, .facility-box .fa-regular, .facility-box .fa-brands {
        font-size: 1.5rem;
        margin-bottom: 0.5rem;
        color: #495057;
    }
    .facility-box.active .fa-solid, .facility-box.active .fa-regular, .facility-box.active .fa-brands {
        color: rgb(var(--bs-primary-rgb));
    }
    .facility-box input[type="checkbox"] {
        display: none;
    }

    /* 이미지 미리보기 */
    .image-preview-container {
        display: flex;
        flex-wrap: wrap;
        gap: 1rem;
        margin-top: 1rem;
        padding: 1rem;
        border-radius: 0.5rem;
        background-color: #f8f9fa;
        min-height: 120px;
    }
    .image-preview-item {
        position: relative;
        width: 120px;
        height: 120px;
    }
    .image-preview-item img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 0.5rem;
        border: 1px solid #dee2e6;
    }

    /* 객실 타입 블록 */
    .room-type-block {
        border: 1px solid #dee2e6;
        border-radius: 0.75rem;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        background-color: #fff;
        position: relative;
    }
     .btn-remove-room-type {
        position: absolute;
        top: 1rem;
        right: 1rem;
        background-color: #f8f9fa;
        border-radius: 50%;
    }
</style>

</head>
<body>

<div class="container-fluid">
    <h1 class="main-title">새로운 숙소 등록</h1>
    <form name="addForm" id="addForm" action="/room/addProc" method="post" enctype="multipart/form-data">
        <div class="row">
            <div class="col-lg-8">
                
                <div class="card mb-4">
                    <div class="card-header"><i class="fa-solid fa-building-user"></i>숙소 기본 정보</div>
                    <div class="card-body">
                        <div class="mb-4">
                            <label for="roomTitle" class="form-label">숙소 이름</label>
                            <input type="text" class="form-control" id="roomTitle" name="roomTitle" placeholder="게스트에게 보여질 숙소의 이름을 입력하세요" required>
                            <div class="form-text">예: 도심 속 힐링, 남산타워가 보이는 아늑한 공간</div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">카테고리</label>
                            <input type="hidden" id="roomCatSeq" name="roomCatSeq" value="">
                            <div class="category-selection-area">
                                <p class="category-group-title">공간 대여</p>
                                <div class="category-group">
                                    <span class="category-tag" data-value="1">파티룸</span><span class="category-tag" data-value="2">카페</span><span class="category-tag" data-value="3">연습실</span><span class="category-tag" data-value="4">스튜디오</span><span class="category-tag" data-value="5">회의실</span><span class="category-tag" data-value="6">녹음실</span><span class="category-tag" data-value="7">운동시설</span>
                                </div>
                                <p class="category-group-title mt-3">숙박</p>
                                <div class="category-group">
                                    <span class="category-tag" data-value="8">풀빌라</span><span class="category-tag" data-value="9">호텔</span><span class="category-tag" data-value="10">팬션</span><span class="category-tag" data-value="11">민박</span><span class="category-tag" data-value="12">리조트</span><span class="category-tag" data-value="13">주택</span><span class="category-tag" data-value="14">캠핑장</span>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="roomDesc" class="form-label">숙소 설명</label>
                            <textarea class="form-control" id="roomDesc" name="roomDesc" rows="5" placeholder="숙소의 특징, 주변 환경, 게스트에게 제공하는 특별한 경험 등을 상세히 작성해주세요."></textarea>
                        </div>
                    </div>
                </div>

				<div class="card mb-4">
				    <div class="card-header"><i class="fa-solid fa-map-location-dot"></i>위치 및 운영 정책</div>
				    <div class="card-body">
				        <div class="mb-3">
				            <label for="roomAddr" class="form-label">주소</label>
				            <input type="text" class="form-control" id="roomAddr" name="roomAddr" value="${room.roomAddr}" required>
				            <!-- 위도/경도 hidden 필드 -->
							<input type="hidden" id="latitude" name="latitude" />
							<input type="hidden" id="longitude" name="longitude" />
							
							<!-- 버튼 + 결과 출력 -->
							<div class="d-flex align-items-center gap-2 mt-2">
							    <button type="button" class="btn btn-outline-primary btn-sm" id="btnConvertLatLng">
							        주소 → 위도/경도 변환
							    </button>
							    <span class="form-text text-success" id="latLngResult"></span>
							</div>
				            
				        </div>
				        <div class="mb-3">
				            <label for="region" class="form-label">지역</label>
				            <select class="form-select" id="region" name="region" required>
				                <option value="">지역 선택</option>
				                <option value="강원" <c:if test="${room.region eq '강원'}">selected</c:if>>강원</option>
				                <option value="경기" <c:if test="${room.region eq '경기'}">selected</c:if>>경기</option>
				                <option value="경남" <c:if test="${room.region eq '경남'}">selected</c:if>>경남</option>
				                <option value="경북" <c:if test="${room.region eq '경북'}">selected</c:if>>경북</option>
				                <option value="광주" <c:if test="${room.region eq '광주'}">selected</c:if>>광주</option>
				                <option value="대구" <c:if test="${room.region eq '대구'}">selected</c:if>>대구</option>
				                <option value="대전" <c:if test="${room.region eq '대전'}">selected</c:if>>대전</option>
				                <option value="부산" <c:if test="${room.region eq '부산'}">selected</c:if>>부산</option>
				                <option value="서울" <c:if test="${room.region eq '서울'}">selected</c:if>>서울</option>
				                <option value="울산" <c:if test="${room.region eq '울산'}">selected</c:if>>울산</option>
				                <option value="인천" <c:if test="${room.region eq '인천'}">selected</c:if>>인천</option>
				                <option value="전남" <c:if test="${room.region eq '전남'}">selected</c:if>>전남</option>
				                <option value="전북" <c:if test="${room.region eq '전북'}">selected</c:if>>전북</option>
				                <option value="제주" <c:if test="${room.region eq '제주'}">selected</c:if>>제주</option>
				                <option value="충남" <c:if test="${room.region eq '충남'}">selected</c:if>>충남</option>
				                <option value="충북" <c:if test="${room.region eq '충북'}">selected</c:if>>충북</option>
				            </select>
				        </div>
				        <!--<div class="form-check mb-3">
				            <c:choose>
				                <c:when test="${room.autoConfirmYn eq 'Y'}">
				                    <input class="form-check-input" type="checkbox" id="autoConfirmYn" name="autoConfirmYn" value="Y" checked>
				                </c:when>
				                <c:otherwise>
				                    <input class="form-check-input" type="checkbox" id="autoConfirmYn" name="autoConfirmYn" value="Y">
				                </c:otherwise>
				            </c:choose>
				              <label class="form-check-label" for="autoConfirmYn">
				                예약 자동 승인 사용
				            </label>
				        </div>-->
				    </div>
				</div>

                
				<div class="card mb-4">
				    <div class="card-header"><i class="fa-solid fa-person-shelter"></i>편의시설</div>
				    <div class="card-body">
				        <div class="facility-grid">
				            <div class="facility-box" data-value="1"><input type="checkbox" name="facilitySeqs" value="1"><img src="/resources/upload/facility/1.png" alt="이미지" style="height:40px; margin-right:8px;"><span>와이파이</span></div>
				            <div class="facility-box" data-value="2"><input type="checkbox" name="facilitySeqs" value="2"><img src="/resources/upload/facility/2.png" alt="이미지" style="height:40px; margin-right:8px;"><span>냉장고</span></div>
				            <div class="facility-box" data-value="3"><input type="checkbox" name="facilitySeqs" value="3"><img src="/resources/upload/facility/3.png" alt="이미지" style="height:40px; margin-right:8px;"><span>전자레인지</span></div>
				            <div class="facility-box" data-value="4"><input type="checkbox" name="facilitySeqs" value="4"><img src="/resources/upload/facility/4.png" alt="이미지" style="height:40px; margin-right:8px;"><span>정수기</span></div>
				            <div class="facility-box" data-value="5"><input type="checkbox" name="facilitySeqs" value="5"><img src="/resources/upload/facility/5.png" alt="이미지" style="height:40px; margin-right:8px;"><span>에어컨/난방</span></div>
				            <div class="facility-box" data-value="6"><input type="checkbox" name="facilitySeqs" value="6"><img src="/resources/upload/facility/6.png" alt="이미지" style="height:40px; margin-right:8px;"><span>드라이기</span></div>
				            <div class="facility-box" data-value="7"><input type="checkbox" name="facilitySeqs" value="7"><img src="/resources/upload/facility/7.png" alt="이미지" style="height:40px; margin-right:8px;"><span>다리미</span></div>
				            <div class="facility-box" data-value="8"><input type="checkbox" name="facilitySeqs" value="8"><img src="/resources/upload/facility/8.png" alt="이미지" style="height:40px; margin-right:8px;"><span>거울</span></div>
				            <div class="facility-box" data-value="9"><input type="checkbox" name="facilitySeqs" value="9"><img src="/resources/upload/facility/9.png" alt="이미지" style="height:40px; margin-right:8px;"><span>침구</span></div>
				            <div class="facility-box" data-value="10"><input type="checkbox" name="facilitySeqs" value="10"><img src="/resources/upload/facility/10.png" alt="이미지" style="height:40px; margin-right:8px;"><span>욕실용품</span></div>
				            <div class="facility-box" data-value="11"><input type="checkbox" name="facilitySeqs" value="11"><img src="/resources/upload/facility/11.png" alt="이미지" style="height:40px; margin-right:8px;"><span>옷걸이/행거</span></div>
				            <div class="facility-box" data-value="12"><input type="checkbox" name="facilitySeqs" value="12"><img src="/resources/upload/facility/12.png" alt="이미지" style="height:40px; margin-right:8px;"><span>TV (OTT)</span></div>
				            <div class="facility-box" data-value="13"><input type="checkbox" name="facilitySeqs" value="13"><img src="/resources/upload/facility/13.png" alt="이미지" style="height:40px; margin-right:8px;"><span>세탁기/건조기</span></div>
				            <div class="facility-box" data-value="14"><input type="checkbox" name="facilitySeqs" value="14"><img src="/resources/upload/facility/14.png" alt="이미지" style="height:40px; margin-right:8px;"><span>취사도구</span></div>
				            <div class="facility-box" data-value="15"><input type="checkbox" name="facilitySeqs" value="15"><img src="/resources/upload/facility/15.png" alt="이미지" style="height:40px; margin-right:8px;"><span>바베큐 시설</span></div>
				            <div class="facility-box" data-value="16"><input type="checkbox" name="facilitySeqs" value="16"><img src="/resources/upload/facility/16.png" alt="이미지" style="height:40px; margin-right:8px;"><span>수영장</span></div>
				            <div class="facility-box" data-value="17"><input type="checkbox" name="facilitySeqs" value="17"><img src="/resources/upload/facility/17.png" alt="이미지" style="height:40px; margin-right:8px;"><span>방음 시설</span></div>
				            <div class="facility-box" data-value="18"><input type="checkbox" name="facilitySeqs" value="18"><img src="/resources/upload/facility/18.png" alt="이미지" style="height:40px; margin-right:8px;"><span>마이크/오디오</span></div>
				            <div class="facility-box" data-value="19"><input type="checkbox" name="facilitySeqs" value="19"><img src="/resources/upload/facility/19.png" alt="이미지" style="height:40px; margin-right:8px;"><span>앰프/스피커</span></div>
				            <div class="facility-box" data-value="20"><input type="checkbox" name="facilitySeqs" value="20"><img src="/resources/upload/facility/20.png" alt="이미지" style="height:40px; margin-right:8px;"><span>조명 장비</span></div>
				            <div class="facility-box" data-value="21"><input type="checkbox" name="facilitySeqs" value="21"><img src="/resources/upload/facility/21.png" alt="이미지" style="height:40px; margin-right:8px;"><span>삼각대/촬영 장비</span></div>
				            <div class="facility-box" data-value="22"><input type="checkbox" name="facilitySeqs" value="22"><img src="/resources/upload/facility/22.png" alt="이미지" style="height:40px; margin-right:8px;"><span>블루투스 스피커</span></div>
				            <div class="facility-box" data-value="23"><input type="checkbox" name="facilitySeqs" value="23"><img src="/resources/upload/facility/23.png" alt="이미지" style="height:40px; margin-right:8px;"><span>악기류</span></div>
				            <div class="facility-box" data-value="24"><input type="checkbox" name="facilitySeqs" value="24"><img src="/resources/upload/facility/24.png" alt="이미지" style="height:40px; margin-right:8px;"><span>빔프로젝터</span></div>
				            <div class="facility-box" data-value="25"><input type="checkbox" name="facilitySeqs" value="25"><img src="/resources/upload/facility/25.png" alt="이미지" style="height:40px; margin-right:8px;"><span>TV 모니터</span></div>
				            <div class="facility-box" data-value="26"><input type="checkbox" name="facilitySeqs" value="26"><img src="/resources/upload/facility/26.png" alt="이미지" style="height:40px; margin-right:8px;"><span>화이트보드</span></div>
				            <div class="facility-box" data-value="27"><input type="checkbox" name="facilitySeqs" value="27"><img src="/resources/upload/facility/27.png" alt="이미지" style="height:40px; margin-right:8px;"><span>프린터/복합기</span></div>
				            <div class="facility-box" data-value="28"><input type="checkbox" name="facilitySeqs" value="28"><img src="/resources/upload/facility/28.png" alt="이미지" style="height:40px; margin-right:8px;"><span>의자/책상</span></div>
				            <div class="facility-box" data-value="29"><input type="checkbox" name="facilitySeqs" value="29"><img src="/resources/upload/facility/29.png" alt="이미지" style="height:40px; margin-right:8px;"><span>커피머신</span></div>
				            <div class="facility-box" data-value="30"><input type="checkbox" name="facilitySeqs" value="30"><img src="/resources/upload/facility/30.png" alt="이미지" style="height:40px; margin-right:8px;"><span>화장실/샤워실</span></div>
				            <div class="facility-box" data-value="31"><input type="checkbox" name="facilitySeqs" value="31"><img src="/resources/upload/facility/31.png" alt="이미지" style="height:40px; margin-right:8px;"><span>취사장/개수대</span></div>
				            <div class="facility-box" data-value="32"><input type="checkbox" name="facilitySeqs" value="32"><img src="/resources/upload/facility/32.png" alt="이미지" style="height:40px; margin-right:8px;"><span>전기 공급</span></div>
				            <div class="facility-box" data-value="33"><input type="checkbox" name="facilitySeqs" value="33"><img src="/resources/upload/facility/33.png" alt="이미지" style="height:40px; margin-right:8px;"><span>텐트/타프</span></div>
				            <div class="facility-box" data-value="34"><input type="checkbox" name="facilitySeqs" value="34"><img src="/resources/upload/facility/34.png" alt="이미지" style="height:40px; margin-right:8px;"><span>캠프파이어</span></div>
				            <div class="facility-box" data-value="35"><input type="checkbox" name="facilitySeqs" value="35"><img src="/resources/upload/facility/35.png" alt="이미지" style="height:40px; margin-right:8px;"><span>야외 테이블/의자</span></div>
				            <div class="facility-box" data-value="36"><input type="checkbox" name="facilitySeqs" value="36"><img src="/resources/upload/facility/36.png" alt="이미지" style="height:40px; margin-right:8px;"><span>벌레퇴치용품</span></div>
				        </div>
				    </div>
				</div>


                <div class="card mb-4">
                    <div class="card-header"><i class="fa-solid fa-images"></i>숙소 이미지</div>
                    <div class="card-body">
                        <div class="mb-4">
                            <label for="roomMainImage" class="form-label">대표 이미지 (첫 화면에 보일 가장 중요한 사진 1장)</label>
                            <input class="form-control" type="file" id="roomMainImage" name="roomMainImage" accept="image/*">
                            <div id="roomMainImagePreview" class="image-preview-container"></div>
                        </div>
                        <div class="mb-3">
                            <label for="roomDetailImages" class="form-label">상세 이미지 (숙소의 매력을 보여줄 여러 장의 사진)</label>
                            <input class="form-control" type="file" id="roomDetailImages" name="roomDetailImages" multiple accept="image/*">
                            <div id="roomDetailImagesPreview" class="image-preview-container"></div>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                     <div class="card-header"><i class="fa-solid fa-bed"></i>객실 타입 등록</div>
                     <div class="card-body" id="roomTypeContainer">
                        </div>
                </div>

            </div>

            <div class="col-lg-4">
                <div class="card right-panel">
                     <div class="card-body">
                        <h5 class="card-title">등록 진행</h5>
                        <p class="card-text text-muted small">
                            숙소의 기본 정보와 객실 타입을 입력해주세요. 객실 타입은 최소 1개 이상 등록해야 합니다. 모든 항목을 꼼꼼히 확인 후 최종 등록 버튼을 눌러주세요.
                        </p>
                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-outline-secondary" id="btnAddRoomType">
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

<div id="roomTypeTemplate" style="display: none;">
    <div class="room-type-block">
        <button type="button" class="btn-close btn-remove-room-type" aria-label="Close"></button>
        <h5 class="mb-3">새 객실 타입</h5>
        <div class="row">
            <div class="col-12 mb-3"><label class="form-label">객실 이름</label><input type="text" class="form-control" name="roomTypeTitle" required></div>
            <div class="col-md-6 mb-3"><label class="form-label">평일 가격</label><input type="number" class="form-control" name="weekdayAmt" required></div>
            <div class="col-md-6 mb-3"><label class="form-label">주말 가격</label><input type="number" class="form-control" name="weekendAmt" required></div>
	    
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크인 날짜</label>
			    <input type="text" class="form-control"
			           name="roomCheckInDt"
			           value="20250701"
			           pattern="\d{8}"
			           maxlength="8"
			           inputmode="numeric"
			           placeholder="예: 20250701"
			           required>
			</div>
			
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크아웃 날짜</label>
			    <input type="text" class="form-control"
			           name="roomCheckOutDt"
			           value="20251231"
			           pattern="\d{8}"
			           maxlength="8"
			           inputmode="numeric"
			           placeholder="예: 20251231"
			           required>
			</div>


            <div class="col-md-6 mb-3">
			    <label class="form-label">체크인 시간</label>
			    <select class="form-select" name="roomCheckInTime">
			        <option value="0000">00:00</option>
			        <option value="0100">01:00</option>
			        <option value="0200">02:00</option>
			        <option value="0300">03:00</option>
			        <option value="0400">04:00</option>
			        <option value="0500">05:00</option>
			        <option value="0600">06:00</option>
			        <option value="0700">07:00</option>
			        <option value="0800">08:00</option>
			        <option value="0900">09:00</option>
			        <option value="1000">10:00</option>
			        <option value="1100">11:00</option>
			        <option value="1200">12:00</option>
			        <option value="1300">13:00</option>
			        <option value="1400">14:00</option>
			        <option value="1500" selected>15:00</option> <option value="1600">16:00</option>
			        <option value="1700">17:00</option>
			        <option value="1800">18:00</option>
			        <option value="1900">19:00</option>
			        <option value="2000">20:00</option>
			        <option value="2100">21:00</option>
			        <option value="2200">22:00</option>
			        <option value="2300">23:00</option>
			    </select>
			</div>
			<div class="col-md-6 mb-3">
			    <label class="form-label">체크아웃 시간</label>
			    <select class="form-select" name="roomCheckOutTime">
			        <option value="0000">00:00</option>
			        <option value="0100">01:00</option>
			        <option value="0200">02:00</option>
			        <option value="0300">03:00</option>
			        <option value="0400">04:00</option>
			        <option value="0500">05:00</option>
			        <option value="0600">06:00</option>
			        <option value="0700">07:00</option>
			        <option value="0800">08:00</option>
			        <option value="0900">09:00</option>
			        <option value="1000">10:00</option>
			        <option value="1100" selected>11:00</option> <option value="1200">12:00</option>
			        <option value="1300">13:00</option>
			        <option value="1400">14:00</option>
			        <option value="1500">15:00</option>
			        <option value="1600">16:00</option>
			        <option value="1700">17:00</option>
			        <option value="1800">18:00</option>
			        <option value="1900">19:00</option>
			        <option value="2000">20:00</option>
			        <option value="2100">21:00</option>
			        <option value="2200">22:00</option>
			        <option value="2300">23:00</option>
			    </select>
			</div>
            <div class="col-md-6 mb-3"><label class="form-label">최소 숙박일수</label><input type="number" class="form-control" name="minDay" value="1" required></div>
            <div class="col-md-6 mb-3"><label class="form-label">최대 숙박일수</label><input type="number" class="form-control" name="maxDay" value="30" required></div>
            <div class="col-md-6 mb-3"><label class="form-label">최대 인원</label><input type="number" class="form-control" name="maxGuests" required></div>
            <div class="col-12 mb-3"><label class="form-label">객실 설명</label><textarea class="form-control" name="roomTypeDesc" rows="3"></textarea></div>
            <hr class="my-3"/>
            <div class="col-12 mb-3"><label class="form-label">객실 대표 이미지</label><input class="form-control" type="file" name="roomTypeMainImage_INDEX" accept="image/*"></div>
            <div class="col-12 mb-3"><label class="form-label">객실 이미지</label><input class="form-control" type="file" name="roomTypeDetailImages_INDEX" multiple accept="image/*"></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    
    let roomTypeIndex = 0;

    // "객실 타입 추가" 버튼 클릭 이벤트
    $("#btnAddRoomType").on("click", function() {
        let template = $("#roomTypeTemplate .room-type-block").clone();
        
        // name 속성 인덱싱
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
        template.find('[name="roomTypeMainImage_INDEX"]').attr('name', 'roomTypeMainImage_' + roomTypeIndex);
        template.find('[name="roomTypeDetailImages_INDEX"]').attr('name', 'roomTypeDetailImages_' + roomTypeIndex);

        $("#roomTypeContainer").append(template);
        roomTypeIndex++;
    });

    // "객실 타입 삭제" 버튼 클릭 이벤트
    $("#roomTypeContainer").on("click", ".btn-remove-room-type", function() {
        $(this).closest(".room-type-block").remove();
    });

    // 카테고리 선택 이벤트
    $(".category-selection-area").on("click", ".category-tag", function () {
        const categorySeq = parseInt($(this).data("value"));

        $("#roomCatSeq").val(categorySeq);
        $(".category-tag").removeClass("active");
        $(this).addClass("active");

       
        if (categorySeq >= 1 && categorySeq <= 7) {          // 1~7
            $("#minTimes, #maxTimes").prop("disabled", false)
                                     .val("");              // 선택값도 초기화(선택)
            $("#usageTimeContainer").addClass("disabled");   // 시각적 구분용(선택)
        } else {                                             // 8~14
            $("#minTimes, #maxTimes").prop("disabled", true);
            $("#usageTimeContainer").removeClass("disabled");
        }
    });

    // 편의시설 선택 이벤트
    $(".facility-grid").on("click", ".facility-box", function() {
        const $checkbox = $(this).find('input[type="checkbox"]');
        $checkbox.prop('checked', !$checkbox.prop('checked'));
        $(this).toggleClass("active", $checkbox.prop('checked'));
    });

   	  // 이미지 미리보기 함수
	  // 공통 미리보기 함수(선택한 input 옆에 자동으로 preview div 생성)
	  function previewImagesDynamic(fileInput) {
	    let $preview = $(fileInput).siblings(".image-preview-container");
	    if (!$preview.length) {
	      $preview = $('<div class="image-preview-container mt-2"></div>');
	      $(fileInput).after($preview);
	    }
	    $preview.empty();
	
	    Array.from(fileInput.files).forEach((file) => {
	      const reader = new FileReader();
	      reader.onload = (e) => {
	        const item = `<div class="image-preview-item"><img src="${e.target.result}" alt="preview"></div>`;
	        $preview.append(item);
	      };
	      reader.readAsDataURL(file);
	    });
	  }
	
	  /* (1) 기존 숙소 대표/상세 이미지 */
	  $("#roomMainImage").on("change", function () {
	    previewImagesDynamic(this);
	  });
	  $("#roomDetailImages").on("change", function () {
	    previewImagesDynamic(this);
	  });
	
	  /* (2) 동적으로 추가되는 객실타입 이미지 → 이벤트 위임 */
	  $(document).on(
	    "change",
	    'input[type="file"][name^="roomTypeMainImage_"], input[type="file"][name^="roomTypeDetailImages_"]',
	    function () {
	      previewImagesDynamic(this);
	    }
	  );


    // 폼 제출 시 유효성 검사
    $("#addForm").on("submit", function() {
        // --- 1. 숙소 기본 정보 유효성 검사 ---
        if ($("#roomTitle").val().trim() === '') {
            alert("숙소 이름을 입력해주세요.");
            $("#roomTitle").focus();
            return false;
        }

        if ($("#roomCatSeq").val() === '') {
            alert("카테고리를 선택해주세요.");
            document.querySelector('.category-selection-area').scrollIntoView({ behavior: 'smooth' });
            return false;
        }
        
        if ($("#roomAddr").val().trim() === '') {
            alert("주소를 입력해주세요.");
            $("#roomAddr").focus();
            return false;
        }

        if ($("#roomMainImage")[0].files.length === 0) {
            alert("대표 이미지를 1개 이상 등록해야 합니다.");
            $("#roomMainImage").focus();
            return false;
        }
        
        // --- 2. 객실 타입 유효성 검사 ---
        const roomTypes = $("#roomTypeContainer .room-type-block");
        if (roomTypes.length === 0) {
            alert("객실 타입은 최소 1개 이상 등록해야 합니다.");
            $("#btnAddRoomType").focus();
            return false;
        }
        
        let allRoomTypesValid = true;
        roomTypes.each(function(index) {
            const $block = $(this);
            const roomNumber = index + 1;

            if ($block.find("[name^='roomTypeTitle_']").val().trim() === '') {
                alert(roomNumber + "번째 객실 타입의 이름을 입력해주세요.");
                $block.find("[name^='roomTypeTitle_']").focus();
                allRoomTypesValid = false;
                return false; // .each 루프 중단
            }

            if ($block.find("[name^='weekdayAmt_']").val().trim() === '') {
                alert(roomNumber + "번째 객실 타입의 평일 가격을 입력해주세요.");
                $block.find("[name^='weekdayAmt_']").focus();
                allRoomTypesValid = false;
                return false;
            }
            
            if ($block.find("[name^='maxGuests_']").val().trim() === '') {
                alert(roomNumber + "번째 객실 타입의 최대 인원을 입력해주세요.");
                $block.find("[name^='maxGuests_']").focus();
                allRoomTypesValid = false;
                return false;
            }

            if ($block.find("[name^='roomTypeMainImage_']")[0].files.length === 0) {
                alert(roomNumber + "번째 객실 타입의 대표 이미지를 등록해주세요.");
                $block.find("[name^='roomTypeMainImage_']").focus();
                allRoomTypesValid = false;
                return false;
            }
        });

        if (!allRoomTypesValid) {
            return false;
        }

        alert("숙소 등록을 진행합니다.");
        return true;
    });
    
    // 페이지 로드 시 기본적으로 객실 타입 1개를 추가
    $("#btnAddRoomType").trigger("click");

}); 
</script>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${initParam.KAKAO_MAP_KEY}&libraries=services"></script>

<script>
    $("#btnConvertLatLng").on("click", function () {
        const address = $("#roomAddr").val().trim();
        if (address === "") {
            alert("주소를 입력해주세요.");
            $("#roomAddr").focus();
            return;
        }

        const geocoder = new kakao.maps.services.Geocoder();
        geocoder.addressSearch(address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const lat = result[0].y;
                const lng = result[0].x;

                $("#latitude").val(lat);
                $("#longitude").val(lng);

                $("#latLngResult").text("위도: " + lat + ", 경도: " + lng);
            } else {
                alert("주소 변환에 실패했습니다.");
            }
        });
    });
</script>


</body>
</html>
