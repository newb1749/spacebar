// /resources/js/host/reviewManage.js

// 필터 기능
$(document).on('change', '#roomFilter', function () {
    const selectedRoom = $(this).val();

    $('#reviewTableContainer tbody tr').each(function () {
        const roomSeq = $(this).data('room-seq') + '';
        if (!selectedRoom || roomSeq === selectedRoom) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

// 리뷰 클릭 시 새 탭 이동
$(document).on('click', '.review-row', function () {
    const roomSeq = $(this).data('room-seq');
    if (roomSeq) {
        const url = '/room/roomDetail?roomSeq=' + roomSeq;
        window.open(url, '_blank');
    }
});
