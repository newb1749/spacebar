<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방</title>
<style>
    #chat-container { width: 500px; margin: auto; border: 1px solid #ccc; padding: 10px; }
    #chat-messages { height: 600px; border: 1px solid #eee; overflow-y: scroll; padding: 10px; margin-bottom: 10px; }
    .message { margin-bottom: 10px; padding: 8px; border-radius: 5px; max-width: 70%; display: flex; flex-direction: column; }
    .my-message { background-color: #FFEB33; align-self: flex-end; margin-left: auto; }
    .other-message { background-color: #f1f1f1; align-self: flex-start; }
    #chat-form { display: flex; }
    #message-input { flex-grow: 1; padding: 10px; border: 1px solid #ccc; }
    #send-btn { padding: 10px 20px; border: none; background-color: #007bff; color: white; cursor: pointer; }
</style>
</head>
<body>	

    <div id="chat-container">
        <h1>채팅방 No.${chatRoomSeq}</h1>
        <div id="chat-messages">
            </div>
        
        <div id="chat-form">
            <input type="text" id="message-input" placeholder="메시지를 입력하세요...">
            <button id="send-btn">전송</button>
        </div>
    </div>

<script>
// [수정] 컨트롤러가 모델에 담아준 사용자 객체에서 ID와 닉네임을 가져와 JS 상수로 선언합니다.
const CHAT_ROOM_SEQ = "${chatRoomSeq}";
const USER_ID = "${loginUser.userId}";
const USER_NICKNAME = "${loginUserNickname}";

let stompClient = null;

// 새로 받은 메시지 1개를 화면에 추가하는 함수
function showMessage(message) {
    const chatMessagesDiv = $('#chat-messages');
    const sendDate = new Date(message.sendDate);
    const formattedDate = sendDate.toLocaleString('ko-KR', {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false
    });

    // 내가 보낸 메시지인지 확인
    let messageClass = message.senderId === USER_ID ? 'my-message' : 'other-message';
    
    // JSP EL과의 충돌을 피하기 위해 문자열 더하기(+) 방식으로 HTML 생성
    let messageHtml = '<div class="message ' + messageClass + '">' +
                      '    <strong>' + message.senderName + '</strong>: ' + message.messageContent +
                      '    <br/><small>' + formattedDate + '</small>' +
                      '</div>';

    chatMessagesDiv.append(messageHtml);
    chatMessagesDiv.scrollTop(chatMessagesDiv[0].scrollHeight);
}

// WebSocket 연결 및 STOMP 클라이언트 생성
function connect() {
    const socket = new SockJS('/ws-chat');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function(frame) {
        console.log('Connected: ' + frame);

        stompClient.subscribe('/topic/chat/room/' + CHAT_ROOM_SEQ, function(message) {
            showMessage(JSON.parse(message.body));
        });
    });
}

// 메시지 전송 함수
function sendMessage() {
    const messageContent = $('#message-input').val();
    if (!messageContent.trim()) {
        return;
    }

    // [수정] 메시지 전송 시, 하드코딩 대신 위에서 선언한 JS 상수를 사용합니다.
    const chatMessage = {
        senderId: USER_ID,
        senderName: USER_NICKNAME,
        messageContent: messageContent
    };

    stompClient.send("/app/chat/sendMessage/" + CHAT_ROOM_SEQ, {}, JSON.stringify(chatMessage));
    $('#message-input').val('');
}

// 최초 메시지 목록을 불러오는 AJAX 함수
function loadInitialMessages() {
    $.ajax({
        url: "/chat/message?chatRoomSeq=" + CHAT_ROOM_SEQ,
        type: "GET",
        success: function(response) {
            if (response.code === 0 && response.data) {
                // 최초 메시지 목록은 한번에 렌더링
                const chatMessagesDiv = $('#chat-messages');
                chatMessagesDiv.empty(); 
                response.data.forEach(function(msg) {
                    showMessage(msg);
                });
            }
        }
    });
}

// === 이벤트 핸들러 및 초기화 ===
$(document).ready(function() {
    connect();

    loadInitialMessages();

    $('#send-btn').on('click', sendMessage);
    $('#message-input').on('keypress', function(e) {
        if (e.which === 13) {
            sendMessage();
        }
    });
});
</script>

</body>
</html>