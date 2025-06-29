<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방</title>
	<!-- WebSocket 접속하고 STOMP 프로토콜 사용 -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
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
// JSP를 통해 컨트롤러에서 전달받은 값들을 JavaScript 변수로 선언
const CHAT_ROOM_SEQ = "${chatRoomSeq}";
const USER_ID = "${sessionScope.USER_ID}";
let stompClient = null; 	// STOMP 클라이언트

// 메시지 목록을 렌더링하는 함수
function renderMessages(messages) {
    const chatMessagesDiv = $('#chat-messages');
    chatMessagesDiv.empty(); 

    messages.forEach(function(msg) {
        const sendDate = new Date(msg.sendDate);
        const formattedDate = sendDate.toLocaleString('ko-KR', {
            year: 'numeric', month: '2-digit', day: '2-digit',
            hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false
        });

        let messageClass = msg.senderId === USER_ID ? 'my-message' : 'other-message';
        
        let messageHtml = '<div class="message ' + messageClass + '">' +
                          '    <strong>' + msg.senderName + '</strong>: ' + msg.messageContent +
                          '    <br/><small>' + formattedDate + '</small>' +
                          '</div>';

        chatMessagesDiv.append(messageHtml);
    });

    chatMessagesDiv.scrollTop(chatMessagesDiv[0].scrollHeight);
}

//새로 받은 메시지 1개를 화면에 추가하는 함수
function showMessage(message) {
    const chatMessagesDiv = $('#chat-messages');
    const sendDate = new Date(message.sendDate);
    const formattedDate = sendDate.toLocaleString('ko-KR');
    let messageClass = message.senderId === USER_ID ? 'my-message' : 'other-message';
    
    let messageHtml = '<div class="message ' + messageClass + '">' +
                      '    <strong>' + message.senderName + '</strong>: ' + message.messageContent +
                      '    <br/><small>' + formattedDate + '</small>' +
                      '</div>';

    chatMessagesDiv.append(messageHtml);
    chatMessagesDiv.scrollTop(chatMessagesDiv[0].scrollHeight);
}


// WebSocket 연결 및 STOMP 클라이언트 생성
function connect() {
    const socket = new SockJS('/ws-chat'); // 1. WebSocket 접속 EndPoint
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function(frame) {
        console.log('Connected: ' + frame);

        // 2. 채팅방 구독(Subscribe)
        stompClient.subscribe('/topic/chat/room/' + CHAT_ROOM_SEQ, function(message) {
            // 메시지를 받으면 showMessage 함수를 호출하여 화면에 표시
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

    const chatMessage = {
        senderName: "테스트A", // 실제로는 세션의 사용자 이름 사용
        messageContent: messageContent
    };

    // 3. STOMP 클라이언트를 통해 메시지 전송
    stompClient.send("/app/chat/sendMessage/" + CHAT_ROOM_SEQ, {}, JSON.stringify(chatMessage));
    $('#message-input').val('');
}

// 최초 메시지 목록을 불러오는 AJAX 함수 (이전 방식)
function loadInitialMessages() {
    $.ajax({
        url: "/chat/message?chatRoomSeq=" + CHAT_ROOM_SEQ,
        type: "GET",
        success: function(response) {
            if (response.code === 0 && response.data) {
                // 최초 메시지 목록은 기존 renderMessages 함수로 렌더링
                renderMessages(response.data);
            }
        }
    });
}

$(document).ready(function() {
    // WebSocket 연결 시작
    connect();

    // 페이지 로딩 시, 이전 대화 내역을 불러오기 위해 최초 1회만 AJAX 호출
    loadInitialMessages();

    // 전송 버튼 이벤트
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