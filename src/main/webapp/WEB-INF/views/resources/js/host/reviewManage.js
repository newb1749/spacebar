// /resources/js/host/reviewManage.js
$(function () {
    $('#roomFilter').on('change', function () {
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
    
    // 클릭 시 상세 페이지 이동
    $(document).on('click', '.review-row', function () {
        const roomSeq = $(this).data('room-seq');
        if (roomSeq) {
            const url = '/room/roomDetail?roomSeq=' + roomSeq;
            window.open(url, '_blank'); 
        }
    });
});
