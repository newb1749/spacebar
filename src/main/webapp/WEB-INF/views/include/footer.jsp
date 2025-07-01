<%@ page contentType="text/html; charset=UTF-8" %>
<div class="site-footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4">
                <div class="widget">
                    <h3>Contact</h3>
                    <address>43 Raymouth Rd. Baltemoer, London 3910</address>
                    <ul class="list-unstyled links">
                        <li><a href="tel://11234567890">+1(123)-456-7890</a></li>
                        <li><a href="mailto:info@mydomain.com">info@mydomain.com</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="widget">
                    <h3>Links</h3>
                    <ul class="list-unstyled float-start links">
                        <li><a href="#">About us</a></li>
                        <li><a href="#">Services</a></li>
                        <li><a href="#">Vision</a></li>
                        <li><a href="#">Mission</a></li>
                    </ul>
                    <ul class="list-unstyled float-start links">
                        <li><a href="#">Partners</a></li>
                        <li><a href="#">Careers</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">FAQ</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="widget">
                    <h3>Follow Us</h3>
                    <ul class="list-unstyled social">
                        <li><a href="#"><span class="icon-instagram"></span></a></li>
                        <li><a href="#"><span class="icon-twitter"></span></a></li>
                        <li><a href="#"><span class="icon-facebook"></span></a></li>
                        <li><a href="#"><span class="icon-linkedin"></span></a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-12 text-center">
                <p>
                    &copy;
                    <script>document.write(new Date().getFullYear());</script>
                    All Rights Reserved. &mdash; Designed by <a href="https://untree.co">Untree.co</a>
                    | Distributed by <a href="https://themewagon.com/" target="_blank">Themewagon</a>
                </p>
            </div>
        </div>
    </div>
</div>

<c:if test="${sessionScope.sessionUserId != null}">
	<%-- ======================================================== --%>
	<%-- ===========  채팅 위젯 HTML, CSS, JAVASCRIPT 시작   =========== --%>
	<%-- ======================================================== --%>
	
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
	</style>
	
	<script>
	// ========================================================
	// 전역 변수 선언
	// ========================================================
	let stompClient = null;
	let currentSubscription = null; // 현재 구독 정보를 저장할 변수
	let currentRoomSeq = null;      // 현재 입장한 방 번호를 저장할 변수
	
	// ========================================================
	// jQuery 객체 캐싱 (자주 사용하는 요소를 변수에 담아두어 성능 향상)
	// ========================================================
	const chatModal = $('#chat-modal');
	const chatModalContent = $('#chat-modal-content');
	const chatModalTitle = $('#chat-modal-title');
	const chatInputContainer = $('#chat-input-container');
	const chatMessageInput = $('#chat-message-input');
	const backToListBtn = $('#back-to-list-btn');
	
	
	// ========================================================
	// UI를 그려주는 함수들
	// ========================================================
	
	// 1. 채팅방 목록을 그리는 함수
	function renderChatList(rooms) {
	    chatModalContent.empty();
	    if (!rooms || rooms.length === 0) {
	        chatModalContent.html('<div style="text-align:center; padding-top: 50px; color:#888;">대화중인 방이 없습니다.</div>');
	        return;
	    }
	
	    let listHtml = '<ul class="chat-list-modal" style="list-style:none; padding:0;">';
	    rooms.forEach(function(room) {
	        listHtml += `<li style="padding:15px; border-bottom:1px solid #eee; cursor:pointer;" class="enter-chat-room" 
	                        data-room-seq="${room.chatRoomSeq}" 
	                        data-room-title="${room.otherUserNickname}님과의 대화">
	                        <strong style="font-size:16px;">${room.otherUserNickname}</strong>
	                    </li>`;
	    });
	    listHtml += '</ul>';
	    chatModalContent.html(listHtml);
	}

	// 2. 사용자 검색 결과 목록을 그리는 함수
	function renderUserList(users) {
	    const userListDiv = $('#user-search-results');
	    userListDiv.empty();

	    if (!users || users.length === 0) {
	        userListDiv.html('<div style="text-align:center; padding: 20px; color:#888;">검색된 사용자가 없습니다.</div>');
	        return;
	    }

	    let userListHtml = '<ul class="chat-list-modal" style="list-style:none; padding:0;">';
	    users.forEach(function(user) {
	        // [최종 수정] JSP와 충돌을 피하기 위해 문자열 더하기 방식으로 변경
	        userListHtml += '<li style="padding:15px; border-bottom:1px solid #eee; cursor:pointer;" class="start-chat-with-user" data-user-id="' + user.userId + '">' +
	                        '    <strong style="font-size:16px;">' + user.nickName + '</strong> (' + user.userId + ')' +
	                        '</li>';
	    });
	    userListHtml += '</ul>';
	    userListDiv.html(userListHtml);
	}
	
	// 3. 실제 채팅방 화면을 그리는 함수
	function renderChatRoom(roomSeq, roomTitle, messages) {
	    chatModalTitle.text(roomTitle);
	    backToListBtn.show();
	    chatInputContainer.show();
	    
	    let messagesHtml = '';
	    messages.forEach(function(msg) {
	        messagesHtml += createMessageHtml(msg);
	    });
	    
	    chatModalContent.html(messagesHtml);
	    chatModalContent.scrollTop(chatModalContent[0].scrollHeight);
	}
	

	
	
	// ========================================================
	// 서버와 통신(AJAX, WebSocket)하는 함수들
	// ========================================================
	
	// 1. 채팅방 목록을 서버에 요청하는 함수
	function fetchChatList() {
	    chatModalTitle.text('대화 목록');
	    chatInputContainer.hide();
	    backToListBtn.hide();
	    
	    $.ajax({
	        url: "/chat/list.json",
	        type: "GET",
	        success: function(response) {
	            if (response.code === 0) {
	                renderChatList(response.data);
	            } else {
	                alert(response.msg);
	            }
	        }
	    });
	}
	
	// 2. 사용자 검색을 서버에 요청하는 함수
	function fetchUserList(keyword) {
	    $.ajax({
	        url: "/chat/userList.json",
	        type: "GET",
	        data: { searchKeyword: keyword },
	        success: function(response) {
	            if (response.code === 0) {
	                renderUserList(response.data);
	            } else {
	                alert(response.msg);
	            }
	        }
	    });
	}
	
	// 3. 특정 채팅방 입장을 위해 서버에 요청하는 함수
	function enterChatRoom(roomSeq, roomTitle) {
	    currentRoomSeq = roomSeq; // 현재 방 번호 저장
	    
	    // 기존 대화내역을 AJAX로 불러와서 화면을 먼저 그림
	    $.ajax({
	        url: "/chat/message",
	        type: "GET",
	        data: { chatRoomSeq: roomSeq },
	        success: function(response) {
	            if (response.code === 0 && response.data) {
	                renderChatRoom(roomSeq, roomTitle, response.data);
	                // 화면을 그린 후, 웹소켓 연결 및 구독 시작
	                connectAndSubscribe();
	            }
	        }
	    });
	}
	
	// 4. WebSocket 연결 및 구독 함수
	function connectAndSubscribe() {
	    // 이미 연결된 상태면 구독만 변경
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
	
	// 5. 특정 채팅방 토픽을 구독하는 함수
	function subscribeToRoom() {
	    // 기존에 다른 방을 구독하고 있었다면, 먼저 구독을 취소
	    if (currentSubscription) {
	        currentSubscription.unsubscribe();
	    }
	    
	    // 새로운 방을 구독
	    currentSubscription = stompClient.subscribe('/topic/chat/room/' + currentRoomSeq, function(message) {
	        const newMessage = JSON.parse(message.body);
	        const messageHtml = createMessageHtml(newMessage);
	        chatModalContent.append(messageHtml);
	        chatModalContent.scrollTop(chatModalContent[0].scrollHeight);
	    });
	}
	

	
	
	// ========================================================
	// 이벤트 핸들러 및 초기화
	// ========================================================
	$(document).ready(function() {
		
        const USER_ID = "${sessionScope.sessionUserId}";
        const USER_NICKNAME = "${loginUser.nickName}"; 
        
    	// 메시지 1개에 대한 HTML을 생성하는 함수
    	function createMessageHtml(message) {
    	    const sendDate = new Date(message.sendDate);
    	    const formattedDate = sendDate.toLocaleString('ko-KR');
    	    let messageClass = message.senderId === USER_ID ? 'my-message' : 'other-message';
            
    	    return '<div class="message ' + messageClass + '">' +
    	           '    <strong>' + message.senderName + '</strong>: ' + message.messageContent +
    	           '    <br/><small>' + formattedDate + '</small>' +
    	           '</div>';
    	}
    	
    	
    	// STOMP로 메시지를 전송하는 함수
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
    	
    	
	    // 플로팅 아이콘 클릭
	    $('#chat-fab').on('click', function() {
	        if (chatModal.is(':visible')) {
	            chatModal.fadeOut(200);
	        } else {
	            fetchChatList();
	            chatModal.fadeIn(200);
	        }
	    });
	
	    // 모달 닫기
	    $('#close-chat-modal-btn').on('click', function() {
	        chatModal.fadeOut(200);
	        // 연결된 웹소켓이 있다면 해제
	        if (stompClient && stompClient.connected) {
	            stompClient.disconnect();
	            stompClient = null;
	            console.log("Disconnected.");
	        }
	    });
	
	    // 뒤로가기 버튼 (대화 목록으로)
	    backToListBtn.on('click', function() {
	        if (currentSubscription) {
	            currentSubscription.unsubscribe();
	        }
	        fetchChatList();
	    });
	
	    // 검색 아이콘 클릭 -> 사용자 검색 UI 표시
	    $('#search-user-btn').on('click', function() {
	        chatModalTitle.text('대화 상대 검색');
	        chatInputContainer.hide();
	        backToListBtn.show();
	        
	        const searchHtml = `
	            <div style="padding:10px;">
	                <form id="user-search-form" style="display:flex; gap:10px; margin-bottom:10px;">
	                    <input type="text" id="user-search-keyword" placeholder="아이디 또는 닉네임" style="flex-grow:1; padding:8px;">
	                    <button type="submit" style="padding:8px 15px;">검색</button>
	                </form>
	                <div id="user-search-results"></div>
	            </div>`;
	        chatModalContent.html(searchHtml);
	    });
	
	    // [이벤트 위임] 사용자 검색 폼 제출
	    chatModalContent.on('submit', '#user-search-form', function(e) {
	        e.preventDefault(); // 폼 기본 동작(페이지 새로고침) 방지
	        const keyword = $('#user-search-keyword').val();
	        fetchUserList(keyword);
	    });
	
	    // [이벤트 위임] 채팅방 목록에서 방 클릭
	    chatModalContent.on('click', '.enter-chat-room', function() {
	        const roomSeq = $(this).data('room-seq');
	        const roomTitle = $(this).data('room-title');
	        enterChatRoom(roomSeq, roomTitle);
	    });
	
	    
	 	// [이벤트 위임] 사용자 검색 결과에서 사용자 클릭
		chatModalContent.on('click', '.start-chat-with-user', function() {
	        // [수정 1] .data() 대신 .attr()로 직접 속성 값을 읽어옵니다.
	        // [수정 2] .trim()을 사용하여 앞뒤 공백을 확실히 제거합니다.
		    const otherUserId = $(this).attr('data-user-id').trim(); 
		    
		    console.log('정리된 사용자 ID:', otherUserId);
		    
	        // [수정 3] 만약 ID가 비어있다면, 요청을 보내지 않고 경고합니다.
		    if (!otherUserId) {
		        alert('사용자 ID가 올바르지 않아 채팅을 시작할 수 없습니다.');
		        return; // 함수 실행 중단
		    }

		    // 페이지를 새로고침하며 채팅방 생성/입장
		    window.location.href = "/chat/start?otherUserId=" + otherUserId;
		});
	
	    // 메시지 전송 버튼 클릭
	    $('#chat-send-btn').on('click', sendStompMessage);
	    // 메시지 입력창 엔터
	    chatInputContainer.on('keypress', '#chat-message-input', function(e) {
	        if (e.which === 13) {
	            sendStompMessage();
	        }
	    });
	
	});
	</script>

</c:if>