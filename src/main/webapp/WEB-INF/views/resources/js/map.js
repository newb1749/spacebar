/**
 * mapModule.jsp와 함께 사용되는 지도 스크립트
 * id="map"인 div의 data-address 값과 data-room-name을 읽어와 지도를 표시한다.
 */
document.addEventListener("DOMContentLoaded", function() {

    const mapContainer = document.getElementById('map'); // 지도를 표시할 div

    // div가 없으면 실행 중단
    if (!mapContainer) {
        return;
    }
    
    // div의 data속성 값들을 가져온다.
    const address = mapContainer.dataset.address;
    const roomName = mapContainer.dataset.roomName;

    // 주소 값이 없으면 실행 중단
    if (!address) {
        mapContainer.innerHTML = "표시할 주소가 없습니다.";
        return;
    }

    const mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 기본 중심좌표
        level: 3 // 지도의 확대 레벨
    };

    // 지도를 생성합니다
    const map = new kakao.maps.Map(mapContainer, mapOption);

    // 주소-좌표 변환 객체를 생성합니다
    const geocoder = new kakao.maps.services.Geocoder();

	const cleanAddress = address.replace(/,/g, '').trim();
	console.log("변환용 주소:", cleanAddress);

    // 주소로 좌표를 검색합니다
    geocoder.addressSearch(address, function(result, status) {
        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK) {
            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            // 결과값으로 받은 위치를 마커로 표시합니다
            const marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });
            
			// 인포윈도우로 장소에 대한 설명을 표시합니다
               const infoContent = `
                <div style="padding:10px; min-width:200px; font-size:14px; text-align:center; box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);">
                    <div style="font-weight:bold; margin-bottom:5px;">${roomName}</div>
                </div>
            `;

            // 3. 위에서 동적으로 만든 infoContent 변수를 content 속성에 전달합니다.
            const infowindow = new kakao.maps.InfoWindow({
                content: infoContent,
                removable: false 
            });

            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });

            map.setCenter(coords);
        }else {
        console.error("주소 변환 실패:", status);
        mapContainer.innerHTML = "주소를 찾을 수 없습니다.";
    }
    });
});