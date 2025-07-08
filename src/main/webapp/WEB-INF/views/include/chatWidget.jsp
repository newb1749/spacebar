<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:eval expression="@env['auth.session.name']" var="AUTH_SESSION_NAME" />
<c:set var="userId" value="${sessionScope['SESSION_USER_ID']}" />

<c:if test="${not empty sessionScope[AUTH_SESSION_NAME]}">
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

		.profile-img, .profile-placeholder {
		    width: 50px;
		    height: 50px;
		    border-radius: 50%;
		    object-fit: cover;
		    background-color: #eee;
		}
		.unread-badge {
		    background-color: #dc3545;
		    color: white;
		    font-size: 12px;
		    padding: 2px 6px;
		    border-radius: 10px;
		    margin-left: 10px;
		    font-weight: bold;
		}
		
		    .chat-profile-img {
	        width: 40px;
	        height: 40px;
	        border-radius: 50%;
	        object-fit: cover;
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
    //const USER_ID = "${sessionScope.sessionUserId}";
    const USER_ID = "${userId}";
    const USER_NICKNAME = "<%= ((com.sist.web.model.User)session.getAttribute("loginUser")) != null ? ((com.sist.web.model.User)session.getAttribute("loginUser")).getNickName() : "" %>";

    // ========================================================
    // UI 렌더링 함수
    // ========================================================

    	
    // 1. 웹소켓 연결 및 개인 알림 채널 구독 (모달 열 때 최초 1회 실행)
    function connect() {
        if (stompClient && stompClient.connected) return;

        const socket = new SockJS('/ws-chat');
        stompClient = Stomp.over(socket);
        
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
            
            // 연결 성공 시, 즉시 내 개인 알림 채널을 구독
            const userPrivateTopic = '/topic/user/' + USER_ID;
            console.log('Subscribing to private topic: ' + userPrivateTopic);
            
            userSubscription = stompClient.subscribe(userPrivateTopic, function(message) {
                console.log("Received chat list update notification:", message.body);
                // "update" 신호가 오면, 채팅 목록을 새로고침합니다.
                // 단, 현재 채팅방에 들어가 있는 상태가 아닐 때만 실행
                if (!currentRoomSeq) {
                    fetchChatList();
                }
            });
        });
    }
    
    function subscribeToRoom() {
    	        if (currentSubscription) { currentSubscription.unsubscribe(); }
    	        
    	        const destination = '/topic/chat/room/' + currentRoomSeq;
    	        console.log("Now subscribing to " + destination);

    	        currentSubscription = stompClient.subscribe(destination, function(message) {
    	            // 서버로부터 받은 JSON 문자열을 JavaScript 객체로 변환
    	            const newMessage = JSON.parse(message.body);
    	            
    	            // [수정] createMessageHtml 함수를 호출하여 새 메시지에 대한 HTML을 생성하고,
    	            //        채팅창 내용 맨 아래에 추가(append)합니다.
    	            $('#chat-modal-content').append(createMessageHtml(newMessage));
    	            
    	            // 새 메시지가 추가되면 스크롤을 맨 아래로 내립니다.
    	            $('#chat-modal-content').scrollTop($('#chat-modal-content')[0].scrollHeight);
    	        });
    	    }

    // 3. 채팅방 입장 로직
    function enterChatRoom(roomSeq, roomTitle) {
        currentRoomSeq = roomSeq;
        $.ajax({
            url: "/chat/message", type: "GET", data: { chatRoomSeq: roomSeq },
            success: function(response) {
                if (response.code === 0 && response.data) {
                    renderChatRoom(roomSeq, roomTitle, response.data);
                    // 웹소켓 연결이 되어있는지 확인하고, 방 구독 시작
                    if (stompClient && stompClient.connected) {
                        subscribeToRoom(roomSeq);
                    } else {
                        // 혹시 연결이 끊겼으면 다시 연결
                        connect();
                        setTimeout(function() { subscribeToRoom(roomSeq); }, 500); // 연결 시간을 기다림
                    }
                }
            }
        });
    }

	// 4. 채팅방 목록을 그리는 함수 수정
	function renderChatList(rooms) {
	    const chatModalContent = $('#chat-modal-content');
	    chatModalContent.empty();
	    if (!rooms || rooms.length === 0) {
	        chatModalContent.html('<div style="text-align:center; padding-top: 50px; color:#888;">대화중인 방이 없습니다.</div>');
	        return;
	    }
	
	    let listHtml = '<ul class="chat-list-modal" style="list-style:none; padding:0;">';
	    rooms.forEach(function(room) {
	        let profileImgHtml = '';
	
	        // [수정] 상대방 프로필 이미지 확장자(otherUserProfileImgExt)가 있는지 확인
	        if (room.otherUserProfileImgExt && room.otherUserProfileImgExt.trim() !== '') {
	            // 확장자가 있으면, 실제 프로필 이미지 경로를 사용합니다.
	            // (주의: otherUserId 필드가 SELECT 쿼리에 포함되어 있어야 합니다.)
	            profileImgHtml = '<img src="/resources/upload/userprofile/' + room.otherUserId + '.' + room.otherUserProfileImgExt + '" class="profile-img" alt="프로필 이미지">';
	        } else {
	            // 확장자가 없으면(null), 기본 이미지 '회원.png'를 사용합니다.
	            // (주의: '/resources/images/' 경로는 실제 프로젝트 구조에 맞게 확인해야 합니다.)
	            profileImgHtml = '<img src="/resources/upload/userprofile/회원.png" class="profile-img" alt="기본 프로필 이미지">';
	        }
	        
	        let unreadBadge = '';
	        if (room.unreadCount > 0) {
	            unreadBadge = '<span class="unread-badge">' + room.unreadCount + '</span>';
	        }
	
	        // [수정] 전체 HTML 구조 변경
	        listHtml += '<li style="display:flex; align-items:center; padding:10px; border-bottom:1px solid #eee; cursor:pointer;" class="enter-chat-room" ' +
	                    'data-room-seq="' + room.chatRoomSeq + '" ' +
	                    'data-room-title="' + room.otherUserNickname + '님과의 대화">' +
	                    profileImgHtml + 
	                    '<div class="chat-room-info" style="flex-grow:1; margin-left:10px;">' +
	                        '<div class="info-header" style="display:flex; justify-content:space-between;">' +
	                            '<strong style="font-size:16px;">' + room.otherUserNickname + '</strong>' +
	                            '<small style="color:#999;">' + new Date(room.lastMessageDate).toLocaleTimeString('ko-KR', {hour:'2-digit', minute:'2-digit'}) + '</small>' +
	                        '</div>' +
	                        '<div class="last-message" style="display:flex; justify-content:space-between; margin-top:4px;">' +
	                            '<span style="color:#555; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + room.lastMessage + '</span>' +
	                            unreadBadge +
	                        '</div>' +
	                    '</div>' +
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

        let profileImgHtml = '';
        // 보낸 사람의 프로필 확장자 정보(message.senderProfileImgExt)가 있는지 확인합니다.
        if (message.senderProfileImgExt) {
            // 확장자가 있으면, 실제 프로필 이미지 경로를 사용합니다.
            profileImgHtml = '<img src="/resources/upload/userprofile/' + message.senderId + '.' + message.senderProfileImgExt + '" class="chat-profile-img">';
        } else {
            // 확장자가 없으면(null), 기본 이미지를 사용합니다.
            profileImgHtml = '<img src="/resources/upload/userprofile/회원.png" class="chat-profile-img">';
        }
        // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲

        // [수정] flexbox를 이용해 이미지와 메시지 내용을 감싸도록 HTML 구조 변경
        if (messageClass === 'my-message') {
            // 내가 보낸 메시지 (내용이 먼저, 이미지는 나중에)
            return '<div class="message ' + messageClass + '" style="display:flex; justify-content:flex-end; align-items:flex-start; gap:8px;">' +
                   '  <div class="message-content">' +
                   '    <strong>' + message.senderName + '</strong><br>' + message.messageContent +
                   '    <br><small>' + formattedDate + '</small>' +
                   '  </div>' +
                   '  ' + profileImgHtml + // 프로필 이미지 추가
                   '</div>';
        } else {
            // 상대방이 보낸 메시지 (이미지가 먼저, 내용은 나중에)
            return '<div class="message ' + messageClass + '" style="display:flex; justify-content:flex-start; align-items:flex-start; gap:8px;">' +
                   '  ' + profileImgHtml + // 프로필 이미지 추가
                   '  <div class="message-content">' +
                   '    <strong>' + message.senderName + '</strong><br>' + message.messageContent +
                   '    <br><small>' + formattedDate + '</small>' +
                   '  </div>' +
                   '</div>';
        }
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


    function connectAndSubscribe() {
        if (stompClient && stompClient.connected) {
            subscribeToRoom();
            return;
        }
        const socket = new SockJS('/ws-chat');
        stompClient = Stomp.over(socket);
        
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
            
            // 1. 기존의 채팅방 토픽을 구독합니다 (이 부분은 enterChatRoom에서 호출될 때만 실행됨).
            //    따라서 이 함수 자체를 수정하기보다, 구독 로직을 분리하는 것이 좋습니다.
            //    하지만 현재 구조를 유지하기 위해, 여기서는 개인 채널 구독만 추가합니다.
            
            // 2. [추가] 내 개인 알림 채널을 구독합니다.
            // 이 채널은 채팅 위젯이 열리는 동안 항상 연결을 유지합니다.
            const userPrivateTopic = '/topic/user/' + USER_ID; // 전역 변수 USER_ID 사용
            console.log('Subscribing to private topic: ' + userPrivateTopic);
            
            stompClient.subscribe(userPrivateTopic, function(message) {
                // 이 채널로 "update" 신호가 오면,
                console.log("Received chat list update notification:", message.body);
                
                // 그냥 채팅방 목록 API를 다시 호출하여 화면을 새로고침합니다.
                fetchChatList();
            });

            // 만약 채팅방에 이미 들어가 있는 상태라면, 해당 방도 구독합니다.
            if(currentRoomSeq) {
                subscribeToRoom();
            }
        });
    }



    function sendStompMessage() {
        const messageInput = $('#chat-message-input');
        const messageContent = messageInput.val();
        if (!messageContent.trim() || !stompClient || !stompClient.connected) return;
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
        $('#chat-modal').fadeOut(200);
        if (stompClient && stompClient.connected) {
            stompClient.disconnect(function() {
                console.log("Disconnected.");
            });
            stompClient = null;
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
	
    /*
    chatModalContent.on('click', '.start-chat-with-user', function() {
        window.location.href = "/chat/start?otherUserId=" + $(this).data('user-id');
    });
    */
    chatModalContent.on('click', '.start-chat-with-user', function() {
        const otherUserId = $(this).data('user-id');
        
        // [수정] 페이지 이동 대신 AJAX로 채팅방 생성을 요청합니다.
        $.ajax({
            url: "/chat/start.json",
            type: "POST",
            data: {
                otherUserId: otherUserId
            },
            success: function(response) {
                if (response.code === 0 && response.data) {
                    const chatRoom = response.data;
                    // 채팅방이 성공적으로 생성/조회되면, enterChatRoom 함수를 호출하여
                    // 모달 안에서 바로 채팅방으로 들어갑니다.
                    enterChatRoom(chatRoom.chatRoomSeq, chatRoom.otherUserNickname + "님과의 대화");
                } else {
                    alert(response.msg || "대화방 입장에 실패했습니다.");
                }
            },
            error: function() {
                alert("오류가 발생했습니다.");
            }
        });
    });

    $('#chat-send-btn').on('click', sendStompMessage);
    chatInputContainer.on('keypress', '#chat-message-input', function(e) {
        if (e.which === 13) { sendStompMessage(); }
    });
});
</script>

</c:if>