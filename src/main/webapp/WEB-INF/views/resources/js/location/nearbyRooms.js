let map;
let userMarker;
let roomMarkers = [];
let orderBy = 'distance';
let selectedCategory = '';
let isInitialLoad = true; 

document.addEventListener("DOMContentLoaded", function () {
    const waitForKakao = setInterval(function () {
        if (window.kakao && kakao.maps) {
            clearInterval(waitForKakao);
            initializeMap();
            setupFilterEvents();
            startLocation(); // 페이지 로딩 시 바로 위치 기반 검색 시작
        }
    }, 100);
});

// 1. 지도 초기화 (최초 한 번만 실행)
function initializeMap() {
    const mapContainer = document.getElementById("map");
    const mapOptions = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 기본 위치: 서울 시청
        level: 7
    };
    map = new kakao.maps.Map(mapContainer, mapOptions);

    // 사용자 위치 마커 이미지
    const userMarkerImage = new kakao.maps.MarkerImage(
        "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png",
        new kakao.maps.Size(24, 35), { offset: new kakao.maps.Point(12, 35) }
    );

    // 사용자 마커 초기화 (위치는 나중에 설정)
    userMarker = new kakao.maps.Marker({
        position: map.getCenter(),
        image: userMarkerImage,
        zIndex: 3
    });
}

// 2. 필터 이벤트 설정
function setupFilterEvents() {
    // 정렬 버튼 이벤트 (기존과 동일)
    document.querySelectorAll(".filter-btn").forEach(btn => {
        btn.addEventListener("click", function () {
            document.querySelectorAll(".filter-btn").forEach(b => b.classList.remove("active"));
            this.classList.add("active");
            orderBy = this.dataset.sort;
            startLocation();
        });
    });

    // ▼▼▼ [수정] 지도 위 카테고리 버튼 이벤트 ▼▼▼
    document.querySelectorAll(".map-cat-btn").forEach(btn => {
        btn.addEventListener("click", function() {
            // 모든 카테고리 버튼의 active 클래스 제거
            document.querySelectorAll(".map-cat-btn").forEach(b => b.classList.remove("active"));
            
            // 현재 클릭한 버튼에 active 클래스 추가
            this.classList.add("active");
            
            // 선택된 카테고리 번호 저장
            selectedCategory = this.dataset.catSeq;
            
            // 데이터 다시 불러오기
            startLocation();
        });
    });
    // ▲▲▲ [수정] 지도 위 카테고리 버튼 이벤트 ▲▲▲
}

// 3. 위치 정보 가져오기 시작
function startLocation() {
    if (!navigator.geolocation) {
        alert("위치 정보 사용이 불가능한 브라우저입니다.");
        return;
    }
    
    // 로딩 표시
    document.getElementById("roomList").innerHTML = "<p>위치 정보를 가져오는 중...</p>";

    navigator.geolocation.getCurrentPosition(
        (position) => fetchNearbyRooms(position.coords.latitude, position.coords.longitude),
        (error) => {
            alert("위치 정보를 가져올 수 없습니다.");
            console.error(error);
            document.getElementById("roomList").innerHTML = "<p>위치를 찾을 수 없습니다.</p>";
        },
        { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
    );
}

// 4. 서버에 주변 숙소 데이터 요청
function fetchNearbyRooms(lat, lng) {
    document.getElementById("roomList").innerHTML = "<p>주변 숙소를 검색 중...</p>";
    
    $.ajax({
        url: "/location/nearby",
        method: "GET",
        data: {
            latitude: lat,
            longitude: lng,
            limit: 20,
            categorySeq: selectedCategory || null, // 빈 문자열 대신 null
            orderBy: orderBy
        },
        success: (data) => {
            updateMapAndList(lat, lng, data);
        },
        error: (xhr) => {
            alert("숙소 정보를 불러오지 못했습니다.");
            console.error(xhr);
            document.getElementById("roomList").innerHTML = "<p>정보 로딩에 실패했습니다.</p>";
        }
    });
}

// 5. 지도와 목록 업데이트
function updateMapAndList(userLat, userLng, rooms) {
    const userPosition = new kakao.maps.LatLng(userLat, userLng);

    // 사용자 위치 마커 업데이트 및 지도 이동
    userMarker.setPosition(userPosition);
    userMarker.setMap(map);
    if (isInitialLoad) {
        map.setCenter(userPosition);
        map.setLevel(6, { animate: true });
        isInitialLoad = false; // 첫 로딩이 끝났으므로 false로 변경
    }

    // 기존 숙소 마커 제거
    roomMarkers.forEach(marker => marker.setMap(null));
    roomMarkers = [];
    
    // 새 숙소 마커 추가
    rooms.forEach(room => {
        const pos = new kakao.maps.LatLng(room.latitude, room.longitude);
        const marker = new kakao.maps.Marker({ position: pos });
        marker.setMap(map);
        roomMarkers.push(marker);

        const info = new kakao.maps.InfoWindow({
            content: `<div style="padding:5px; font-size:12px;"><b>${room.roomTitle}</b><br>거리: ${room.distance.toFixed(2)}km</div>`,
            removable: true
        });

        kakao.maps.event.addListener(marker, 'click', () => info.open(map, marker));
    });

    // 목록 렌더링
    renderRoomList(rooms);
    setTimeout(() => map.relayout(), 100);
}

function renderRoomList(rooms) {
    const listEl = document.getElementById("roomList");
    listEl.innerHTML = "";

    if (!rooms || rooms.length === 0) {
        listEl.innerHTML = "<p>주변에 숙소가 없습니다.</p>";
        return;
    }

    const ul = document.createElement("ul");
    ul.className = "room-list";

    rooms.forEach(r => {
        const li = document.createElement("li");
        li.onclick = () => window.open("/room/roomDetail?roomSeq=" + r.roomSeq, "_blank");
        
        li.innerHTML = `
            <img src="${r.thumbnailImg || '/resources/images/default.png'}" alt="숙소 썸네일">
            <div class="room-info">
                <strong>${r.roomTitle}</strong>
                <span>거리: ${r.distance.toFixed(2)}km</span><br>
                <span>⭐ ${r.averageRating != null ? r.averageRating.toFixed(1) : 'N/A'} (${r.reviewCount || 0}건)</span>
            </div>
        `;
        ul.appendChild(li);
    });

    listEl.appendChild(ul);
}