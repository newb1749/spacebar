package com.sist.web.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.ChatMessage;
import com.sist.web.model.ChatRoom;
import com.sist.web.model.Response;
import com.sist.web.model.User_mj;
import com.sist.web.service.ChatService;
import com.sist.web.service.UserService_ks;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.SessionUtil;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;

@Controller("chatController")
public class ChatController {
	private static Logger logger = LoggerFactory.getLogger(ChatController.class);
	
	@Autowired
	private ChatService chatService;
	
	@Autowired
	private UserService_mj userService;
	
	@Autowired
	private UserService_ks userService_ks;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
	
	
	/**
	 * 특정 사용자와 1:1 채팅 시작(방 없으면 생성)
	 * @param otherUserId 상대방 유저
	 * @param request
	 * @return 성공 -> 채팅 방으로 / 실패 -> 에러 페이지
	 
	@RequestMapping(value="/chat/start", method=RequestMethod.GET)
	public String startChat(@RequestParam("otherUserId") String otherUserId, HttpServletRequest request)
	{
		HttpSession session = request.getSession();      
		String currentUserId  = (String) SessionUtil.getSession(session, AUTH_SESSION_NAME);
		
	    // 유효성 검사 추가
	    if (otherUserId == null || otherUserId.trim().isEmpty()) {
	        throw new IllegalArgumentException("상대방 사용자 ID가 필요합니다.");
	    }
	    
	    if (currentUserId == null || currentUserId.trim().isEmpty()) {
	        throw new IllegalArgumentException("로그인이 필요합니다.");
	    }
	    
        // 나와 상대방의 아이디가 같으면 채팅을 시작할 수 없음
        if (StringUtil.equals(otherUserId, currentUserId)) {
            return "redirect:/somewhere/error"; // 에러 페이지로 리다이렉트
        }
        
        ChatRoom chatRoom = chatService.findOrCreateChatRoom(currentUserId, otherUserId);
        
        // 생성,조회된 채팅방 페이지로 리다이렉트
        return "redirect:/chat/room?chatRoomSeq=" + chatRoom.getChatRoomSeq();		
	}
	*/

	/**
	 * <pre>
	 * 메소드명: startChatApi
	 * 설명: 사용자와의 채팅을 시작하고, 생성된 채팅방 정보를 JSON으로 반환합니다. (모달용)
	 * </pre>
	 * @param request HttpServletRequest
	 * @return ResponseEntity<Response<ChatRoom>>
	 */
	@RequestMapping(value="/chat/start.json", method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Response<ChatRoom>> startChatApi(HttpServletRequest request) {
	    String otherUserId = HttpUtil.get(request, "otherUserId", "");
	    String currentUserId = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
	    
	    logger.debug("otherUserId11111111111111111111 : " + otherUserId);
	    
	    if (StringUtil.isEmpty(currentUserId)) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(new Response<ChatRoom>(HttpStatus.UNAUTHORIZED.value(), "로그인이 필요합니다."));
	    }
	    
	    if (StringUtil.isEmpty(otherUserId)) {
	        return ResponseEntity.badRequest().body(new Response<ChatRoom>(400, "상대방 정보가 없습니다."));
	    }

	    if (StringUtil.equals(otherUserId, currentUserId)) {
	        return ResponseEntity.badRequest().body(new Response<ChatRoom>(400, "자기 자신과는 대화할 수 없습니다."));
	    }
	    
	    ChatRoom chatRoom = chatService.findOrCreateChatRoom(currentUserId, otherUserId);
	    
	    // 상대방 닉네임을 찾아서 ChatRoom 객체에 추가해줍니다.
	    User_mj otherUser = userService.userSelect(otherUserId);
	    if(otherUser != null) {
	        chatRoom.setOtherUserNickname(otherUser.getNickName());
	    }

	    return ResponseEntity.ok(new Response<ChatRoom>(0, "SUCCESS", chatRoom));
	}
	/**
	 * 채팅방 페이지로 이동
	 * @param chatRoomSeq
	 * @param model ("chatRoomSeq", chatRoomSeq) ("loginUser", loginUser)  ("loginUserNickname", loginUser.getNickName())
	 * @param request
	 * @return "/chat/room"
	 
	@RequestMapping(value="/chat/room", method=RequestMethod.GET)
    public String chatRoomPage(@RequestParam("chatRoomSeq") int chatRoomSeq, Model model, HttpServletRequest request) 
	{
        String userId = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
        
        User_mj loginUser = userService.userSelect(userId);
        
        model.addAttribute("chatRoomSeq", chatRoomSeq);
        
        if(loginUser != null)
        {
        	model.addAttribute("loginUser", loginUser);
        	model.addAttribute("loginUserNickname", loginUser.getNickName());
        }
        
        return "/chat/room"; 
    }
	*/
	/**
	 * <pre>
	 * 메소드명: getMessages
	 * 설명: 특정 채팅방의 메시지 목록을 조회합니다. (AJAX)
	 * </pre>
	 * @param chatRoomSeq 채팅방 시퀀스
	 * @param request HttpServletRequest
	 * @return ResponseEntity<Response<List<ChatMessage>>>
	 */
	@RequestMapping(value="/chat/message", method=RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<Response<List<ChatMessage>>> getMessages(@RequestParam(value="chatRoomSeq", required=false) Integer chatRoomSeq, HttpServletRequest request) {
		
	    if (chatRoomSeq == null) {
	        logger.warn("chatRoomSeq is missing from the request.");
	        // 파라미터가 없다는 명시적인 에러 메시지를 클라이언트로 보냄
	        return ResponseEntity.badRequest().body(new Response<>(400, "chatRoomSeq 파라미터가 누락되었습니다."));
	    }
        
	    String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);

	    if (userId == null) {
            // 이 부분은 Response(int code, String msg) 생성자를 사용하므로 기존 코드 유지
	        return ResponseEntity.status(401).body(new Response<>(401, "Unauthorized"));
	    }
	    
	    List<ChatMessage> messages = chatService.findMessagesByRoomSeq(chatRoomSeq, userId);
	    
	    // 성공 시 code(0)와 msg("SUCCESS")를 함께 전달
	    return ResponseEntity.ok(new Response<>(0, "SUCCESS", messages));
	}
	
	
	/**
	 * 
	 * @param model  ("myChatRooms", myChatRooms)
	 * @param request
	 * @return "/chat/list"
	 
	@RequestMapping(value="/chat/list", method=RequestMethod.GET)
	public String chatListPage(Model model, HttpServletRequest request)
	{	
		HttpSession session = request.getSession();
		String userId = (String) SessionUtil.getSession(session, AUTH_SESSION_NAME);

		List<ChatRoom> myChatRooms = chatService.findMyChatRooms(userId);
		model.addAttribute("myChatRooms", myChatRooms);
		
		return "/chat/list";
	}
	*/	
	
    /**
     * <pre>
     * 메소드명: chatListApi
     * 설명: 내 채팅방 목록을 JSON으로 반환합니다. (모달용)
     * </pre>
     * @param request HttpServletRequest
     * @return ResponseEntity<Response<List<ChatRoom>>>
     */
    @RequestMapping(value="/chat/list.json", method=RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<Response<List<ChatRoom>>> chatListApi(HttpServletRequest request)
    {
    	String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	
    	if(userId == null)
    	{
    		return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(
    				new Response<List<ChatRoom>>(HttpStatus.UNAUTHORIZED.value(), "인증되지 않은 사용자입니다."));
    	}
    	
    	List<ChatRoom> myChatRooms = chatService.findMyChatRooms(userId);
    	
    	return ResponseEntity.ok(new Response<List<ChatRoom>>(0, "SUCCESS", myChatRooms));
    }
    
	/**
	 *  대화 사용자를 위한 사용자 목록 페이지
	 * @param searchKeyword
	 * @param model   세션 아이디 이용("userList", userList)  ("searchKeyword", searchKeyword)
	 * @param request
	 * @return "/chat/userList"
	 */
	@RequestMapping(value="/chat/userList", method=RequestMethod.GET)
	public String userList(@RequestParam(value="searchKeyword", required=false) String searchKeyword, Model model, HttpServletRequest request)
	{
		String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
		
		List<User_mj> userList = userService_ks.userList(userId, searchKeyword);
		
		model.addAttribute("userList", userList);
		model.addAttribute("searchKeyword", searchKeyword);
		
		return "/chat/userList";
	}
	
    /**
     * <pre>
     * 메소드명: userListApi
     * 설명: 사용자 목록을 JSON으로 반환합니다. (모달의 사용자 검색용)
     * </pre>
     * @param searchKeyword 검색어
     * @param request HttpServletRequest
     * @return ResponseEntity<Response<List<User_mj>>>
     */
    @RequestMapping(value="/chat/userList.json", method=RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<Response<List<User_mj>>> userListApi(@RequestParam(value="searchKeyword", required=false) String searchKeyword, HttpServletRequest request)
    {
    	String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	
    	 if (userId == null) 
    	 {
             return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(
            		 new Response<List<User_mj>>(HttpStatus.UNAUTHORIZED.value(), "인증되지 않은 사용자입니다."));
         }  
    	 List<User_mj> userList = userService_ks.userList(userId, searchKeyword);
    	 
    	 return ResponseEntity.ok(new Response<List<User_mj>>(0, "SUCCESS", userList));
    }
}
