/** /resources/js/roomList.js
 * /host/fragment/roomList.jsp 에 사용
 */
 
$(document).ready(function () {
    console.log("roomList.js 로드됨");

    // 판매 중지
    $(document).on("click", ".btn-stop", function () {
        const roomSeq = $(this).data("room-seq");
        if (!confirm("판매를 중지하시겠습니까?")) return;

        $.post("/host/room/stopSelling", { roomSeq }, function (res) {
            if (res === "success") {
                alert("판매가 중지되었습니다.");
                loadRoomsContent(true); // 페이지 유지하면서 reload
            } else {
                alert("오류 발생");
            }
        });
    });

    // 판매 재개
    $(document).on("click", ".btn-resume", function () {
        const roomSeq = $(this).data("room-seq");
        if (!confirm("판매를 재개하시겠습니까?")) return;

        $.post("/host/room/resumeSelling", { roomSeq }, function (res) {
            if (res === "success") {
                alert("판매가 재개되었습니다.");
                loadRoomsContent(true);
            } else {
                alert("오류 발생");
            }
        });
    });

    // 삭제
    $(document).on("click", ".btn-delete", function () {
        const roomSeq = $(this).data("room-seq");
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.post("/host/room/delete", { roomSeq }, function (res) {
            if (res === "success") {
                alert("삭제되었습니다.");
                loadRoomsContent(true);
            } else {
                alert("오류 발생");
            }
        });
    });
});

