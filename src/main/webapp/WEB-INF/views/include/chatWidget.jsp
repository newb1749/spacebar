<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<c:if test="${sessionScope.sessionUserId != null}">
	<%-- ======================================================== --%>
	<%-- ===========  채팅 위젯 HTML, CSS, JAVASCRIPT 시작   =========== --%>
	<%-- ======================================================== --%>
	
	<!-- SockJS와 STOMP 라이브러리 추가 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	
	<div id="chat-fab">💬</div>
	
	<div id="chat-modal" style="display: none;">
	    <div class="chat-modal-header">
	        <h3 id="chat-modal-title">대화 목록</h3>
	        <div class="chat-modal-actions">
	            <span id="back-to-list-btn" style="display: none;">‹</span>
	            <span id="search-user-btn">🔍</span>
	            <span id="close-chat-modal-btn">✖</span>
	        </div>
	    </div>
	    <div id="chat-modal-content">
	        </div>
	    <div id="chat-input-container" style="display: none;">
	         <input type="text" id="chat-message-input" placeholder="메시지를 입력하세요...">
	         <button id="chat-send-btn">전송</button>
	    </div>
	</div>
	
	<style>
	    /* 플로팅 아이콘 스타일 */
	    #chat-fab {
	        position: fixed;
	        bottom: 30px;
	        right: 30px;
	        width: 60px;
	        height: 60px;
	        background-color: #007bff;
	        color: white;
	        border-radius: 50%;
	        display: flex;
	        justify-content: center;
	        align-items: center;
	        font-size: 30px;
	        cursor: pointer;
	        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
	        z-index: 999;
	        transition: transform 0.2s;
	    }
	    #chat-fab:hover {
	        transform: scale(1.1);
	    }

	    /* 채팅 모달 스타일 */
	    #chat-modal {
	        position: fixed;
	        bottom: 100px;
	        right: 30px;
	        width: 380px;
	        height: 600px;
	        background-color: #f9f9f9;
	        border-radius: 15px;
	        box-shadow: 0 5px 25px rgba(0,0,0,0.2);
	        display: flex;
	        flex-direction: column;
	        z-index: 1000;
	        overflow: hidden;
	    }
	    .chat-modal-header {
	        display: flex;
	        justify-content: space-between;
	        align-items: center;
	        padding: 15px 20px;
	        border-bottom: 1px solid #eee;
	        background-color: white;
	    }
	    .chat-modal-header h3 {
	        margin: 0;
	        font-size: 18px;
	    }
	    .chat-modal-actions span {
	        font-size: 20px;
	        cursor: pointer;
	        margin-left: 15px;
	        color: #888;
	    }
	    .chat-modal-actions span:hover {
	        color: #000;
	    }
	    #chat-modal-content {
	        flex-grow: 1;
	        overflow-y: auto;
	        padding: 10px;
	    }
	    #chat-input-container {
	        display: flex;
	        padding: 10px;
	        border-top: 1px solid #eee;
	        background-color: white;
	    }
	    #chat-message-input {
	        flex-grow: 1;
	        padding: 10px;
	        border: 1px solid #ccc;
	        border-radius: 20px;
	        margin-right: 10px;
	    }
	    #chat-send-btn {
	        border: none;
	        background: #007bff;
	        color: white;
	        font-weight: bold;
	        padding: 0 15px;
	        border-radius: 20px;
	        cursor: pointer;
	    }
	    
	    /* 메시지 스타일 추가 */
	    .message {
	        margin-bottom: 10px;
	        padding: 8px 12px;
	        border-radius: 8px;
	        max-width: 80%;
	    }
	    .my-message {
	        background-color: #007bff;
	        color: white;
	        margin-left: auto;
	        text-align: right;
	    }
	    .other-message {
	        background-color: #e9ecef;
	        color: #333;
	        margin-right: auto;
	    }
	    .message small {
	        opacity: 0.7;
	        font-size: 0.8em;
	    }
	</style>
	
<script>
$(document).ready(function() {
    // ========================================================
    // 전역 변수 및 jQuery 객체
    // ========================================================
    let stompClient = null;
    let currentSubscription = null;
    let currentRoomSeq = null;

    const chatModal = $('#chat-modal');
    const chatModalContent = $('#chat-modal-content');
    const chatModalTitle = $('#chat-modal-title');
    const chatInputContainer = $('#chat-input-container');
    const chatMessageInput = $('#chat-message-input');
    const backToListBtn = $('#back-to-list-btn');
    
    // 로그인한 사용자 정보 (JSP 내장객체를 통해 가져옴)
    const USER_ID = "${sessionScope.sessionUserId}";
    const USER_NICKNAME = "<%= ((com.sist.web.model.User_mj)session.getAttribute("loginUser")) != null ? ((com.sist.web.model.User_mj)session.getAttribute("loginUser")).getNickName() : "" %>";

    // ========================================================
    // UI 렌더링 함수
    // ========================================================

    function renderChatList(rooms) {
        chatModalContent.empty();
        if (!rooms || rooms.length === 0) {
            chatModalContent.html('<div style="text-align:center; padding-top: 50px; color:#888;">대화중인 방이 없습니다.</div>');
            return;
        }
        let listHtml = '<ul class="chat-list-modal" style="list-style:none; padding:0;">';
        rooms.forEach(function(room) {
            listHtml += '<li style="padding:15px; border-bottom:1px solid #eee; cursor:pointer;" class="enter-chat-room" ' +
                        'data-room-seq="' + room.chatRoomSeq + '" ' +
                        'data-room-title="' + room.otherUserNickname + '님과의 대화">' +
                        '<strong style="font-size:16px;">' + room.otherUserNickname + '</strong>' +
                        '</li>';
        });
        listHtml += '</ul>';
        chatModalContent.html(listHtml);
    }

    function renderUserList(users) {
        const userListDiv = $('#user-search-results');
        userListDiv.empty();
        if (!users || users.length === 0) {
            userListDiv.html('<div style="text-align:center; padding: 20px; color:#888;">검색된 사용자가 없습니다.</div>');
            return;
        }
        let userListHtml = '<ul class="chat-list-modal" style="list-style:none; padding:0;">';
        users.forEach(function(user) {
            userListHtml += '<li style="padding:15px; border-bottom:1px solid #eee; cursor:pointer;" class="start-chat-with-user" data-user-id="' + user.userId + '">' +
                            '<strong style="font-size:16px;">' + user.nickName + '</strong> (' + user.userId + ')' +
                            '</li>';
        });
        userListHtml += '</ul>';
        userListDiv.html(userListHtml);
    }

    function createMessageHtml(message) {
        const sendDate = new Date(message.sendDate);
        const formattedDate = sendDate.toLocaleString('ko-KR');
        let messageClass = message.senderId === USER_ID ? 'my-message' : 'other-message';
        return '<div class="message ' + messageClass + '">' +
               '    <strong>' + message.senderName + '</strong>: ' + message.messageContent +
               '    <br/><small>' + formattedDate + '</small>' +
               '</div>';
    }

    function renderChatRoom(roomSeq, roomTitle, messages) {
        chatModalTitle.text(roomTitle);
        backToListBtn.show();
        chatInputContainer.show();
        let messagesHtml = '';
        if (messages && messages.length > 0) {
            messages.forEach(function(msg) {
                messagesHtml += createMessageHtml(msg);
            });
        }
        chatModalContent.html(messagesHtml);
        chatModalContent.scrollTop(chatModalContent[0].scrollHeight);
    }

    // ========================================================
    // 서버 통신 함수
    // ========================================================
    
    function fetchChatList() {
        chatModalTitle.text('대화 목록');
        chatInputContainer.hide();
        backToListBtn.hide();
        $.ajax({
            url: "/chat/list.json", type: "GET",
            success: function(response) {
                if (response.code === 0) { renderChatList(response.data); } 
                else { alert(response.msg); }
            }
        });
    }

    function fetchUserList(keyword) {
        $.ajax({
            url: "/chat/userList.json", type: "GET", data: { searchKeyword: keyword },
            success: function(response) {
                if (response.code === 0) { renderUserList(response.data); } 
                else { alert(response.msg); }
            }
        });
    }

    function enterChatRoom(roomSeq, roomTitle) {
        currentRoomSeq = roomSeq;
        $.ajax({
            url: "/chat/message", type: "GET", data: { chatRoomSeq: roomSeq },
            success: function(response) {
                if (response.code === 0 && response.data) {
                    renderChatRoom(roomSeq, roomTitle, response.data);
                    connectAndSubscribe();
                }
            }
        });
    }

    function connectAndSubscribe() {
        if (stompClient && stompClient.connected) {
            subscribeToRoom();
            return;
        }
        const socket = new SockJS('/ws-chat');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
            subscribeToRoom();
        });
    }

    function subscribeToRoom() {
        if (currentSubscription) { currentSubscription.unsubscribe(); }
        currentSubscription = stompClient.subscribe('/topic/chat/room/' + currentRoomSeq, function(message) {
            const newMessage = JSON.parse(message.body);
            chatModalContent.append(createMessageHtml(newMessage));
            chatModalContent.scrollTop(chatModalContent[0].scrollHeight);
        });
    }

    function sendStompMessage() {
        const messageContent = chatMessageInput.val();
        if (!messageContent.trim()) return;
        const chatMessage = {
            senderId: USER_ID,
            senderName: USER_NICKNAME,
            messageContent: messageContent
        };
        stompClient.send("/app/chat/sendMessage/" + currentRoomSeq, {}, JSON.stringify(chatMessage));
        chatMessageInput.val('');
    }

    // ========================================================
    // 이벤트 핸들러 바인딩
    // ========================================================
    
    $('#chat-fab').on('click', function() {
        if (chatModal.is(':visible')) {
            chatModal.fadeOut(200);
        } else {
            fetchChatList();
            chatModal.fadeIn(200);
        }
    });

    $('#close-chat-modal-btn').on('click', function() {
        chatModal.fadeOut(200);
        if (stompClient && stompClient.connected) {
            stompClient.disconnect();
            stompClient = null;
            console.log("Disconnected.");
        }
    });

    backToListBtn.on('click', function() {
        if (currentSubscription) { currentSubscription.unsubscribe(); }
        fetchChatList();
    });

    $('#search-user-btn').on('click', function() {
        chatModalTitle.text('대화 상대 검색');
        chatInputContainer.hide();
        backToListBtn.show();
        const searchHtml = '<div style="padding:10px;">' +
                           '<form id="user-search-form" style="display:flex; gap:10px; margin-bottom:10px;">' +
                           '<input type="text" id="user-search-keyword" placeholder="아이디 또는 닉네임" style="flex-grow:1; padding:8px;">' +
                           '<button type="submit" style="padding:8px 15px;">검색</button>' +
                           '</form><div id="user-search-results"></div></div>';
        chatModalContent.html(searchHtml);
    });

    chatModalContent.on('submit', '#user-search-form', function(e) {
        e.preventDefault();
        fetchUserList($('#user-search-keyword').val());
    });

    chatModalContent.on('click', '.enter-chat-room', function() {
        enterChatRoom($(this).data('room-seq'), $(this).data('room-title'));
    });

    chatModalContent.on('click', '.start-chat-with-user', function() {
        window.location.href = "/chat/start?otherUserId=" + $(this).data('user-id');
    });

    $('#chat-send-btn').on('click', sendStompMessage);
    chatInputContainer.on('keypress', '#chat-message-input', function(e) {
        if (e.which === 13) { sendStompMessage(); }
    });
});
</script>

</c:if>