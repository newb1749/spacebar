package com.sist.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.Cart;
import com.sist.web.model.Coupon;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.Reservation;
import com.sist.web.model.Response;
import com.sist.web.model.Room;
import com.sist.web.model.RoomType;
import com.sist.web.model.User;
import com.sist.web.model.Wishlist;
import com.sist.web.service.CartService;
import com.sist.web.service.CouponServiceJY;
import com.sist.web.service.FreeBoardService;
import com.sist.web.service.MileageHistoryService;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomServiceSh;
import com.sist.web.service.RoomTypeService;
import com.sist.web.service.UserService_mj;
import com.sist.web.service.WishlistService;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;


@Controller("userController")
public class UserController
{
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserService_mj userService;
	
	@Autowired
	private RoomServiceSh roomServiceSh;
	
	@Autowired
	private CouponServiceJY couponService;
	
	@Autowired
	private ReservationServiceJY reservationService;
	
    @Autowired
    private RoomTypeService roomTypeService;

    @Autowired
    private ReservationDao reservationDao;
	
	@Autowired
	private MileageHistoryService mileageHistoryService;
	
    @Autowired
    private MileageHistoryDao mileageHistoryDao;
	
	@Autowired
	private MileageServiceJY mileageService;
	
	@Autowired
	private WishlistService wishlistService;
	
	@Autowired 
	private CartService cartService;
	
	@Autowired
	private FreeBoardService freeBoardService;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.profile.dir']}")
	private String UPLOAD_PROFILE_DIR;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;

	@Value("${kakao.client.id}")
	String clientId;
	
	@Value("${kakao.redirect.uri}")
	String redirectUri;
	
	@Value("${kakao.client.secret}")
	String clientSecret;
	
	//로그인 화면
	@RequestMapping(value="/user/loginForm", method=RequestMethod.GET)
	public String loginForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/loginForm";
	}
	
	//로그인
	@RequestMapping(value="/user/loginProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> longin(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			User user = userService.userSelect(userId);
			
			if(user != null)
			{
				if(StringUtil.equals(userPwd, user.getUserPwd()))
				{
					//호스트일때
					if(StringUtil.equals(user.getUserType(), "H"))
					{
						//승인 받았을때
						if(StringUtil.equals(user.getApprovStat(), "Y"))
						{
							request.getSession().setAttribute("SESSION_USER_ID", userId);
							
							String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
	
							// "loginUser" 라는 이름으로 사용자 객체 전체를 세션에 추가로 저장
							request.getSession().setAttribute("loginUser", user);
							
							logger.debug("userId : " + userId);
							logger.debug("sessionUserId : " + sessionUserId);
							logger.debug("userPwd : " + userPwd);

		                    ajaxRes.setResponse(0, "success");
		                    ajaxRes.setData("/host/main"); 
						}
						//미승인일때
						else
						{
							ajaxRes.setResponse(-98, "host not approved");
						}
					}
					//게스트일때
					else
					{
						request.getSession().setAttribute("SESSION_USER_ID", userId);
						request.getSession().setAttribute("loginUser", user);
						
						String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
						logger.debug("userId : " + userId);
						logger.debug("sessionUserId : " + sessionUserId);
						logger.debug("userPwd : " + userPwd);
						
						if(StringUtil.equals(user.getUserStat(), "Y"))
						{
							ajaxRes.setResponse(0, "success");
							ajaxRes.setData("/");
						}
						else
						{
							ajaxRes.setResponse(-99, "status error");
						}

					}
				}
				else
				{
					ajaxRes.setResponse(-1, "password mismath");
				}
			}
			else
			{
				ajaxRes.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxRes.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/login response \n" + JsonUtil.toJsonPretty(ajaxRes));
		}
		
		return ajaxRes;
	}
	
	//회원가입 화면
	@RequestMapping(value="/user/regForm", method=RequestMethod.GET)
	public String regForm(HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(!StringUtil.isEmpty(sessionUserId))
		{
			request.getSession().invalidate();
			return "redirect:/";
		}
		else
		{
			return "/user/regForm";
		}	
	}
	
	//아이디 중복 체크
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if(!StringUtil.isEmpty(userId))
		{
			if(userService.userSelect(userId) == null)
			{
				ajaxRes.setResponse(0, "success");
			}
			else
			{
				ajaxRes.setResponse(100, "duplicate id");
			}
		}
		else
		{
			ajaxRes.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/idCheck response \n" + JsonUtil.toJsonPretty(ajaxRes));
		}
		
		return ajaxRes;
	}
	
	//닉네임 중복 체크
	@RequestMapping(value="/user/nickNameCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> nickNameCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String nickName = HttpUtil.get(request, "nickName");
		
		if(!StringUtil.isEmpty(nickName))
		{
			if(userService.nickNameSelect(nickName) == null)
			{
				ajaxRes.setResponse(0, "success");
			}
			else
			{
				ajaxRes.setResponse(100, "duplicate nickName");
			}
		}
		else
		{
			ajaxRes.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/nickNameCheck response \n" + JsonUtil.toJsonPretty(ajaxRes));
		}
		
		return ajaxRes;
	}
	
	//회원가입
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId"); 
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String nickName = HttpUtil.get(request, "nickName");
		String email = HttpUtil.get(request, "email");
		String phone = HttpUtil.get(request, "phone");
		String gender = HttpUtil.get(request, "gender");
		String birthDt = HttpUtil.get(request, "birthDt");
		String userAddr = HttpUtil.get(request, "userAddr");
		String userType = HttpUtil.get(request, "userType");
		
		FileData fileData = HttpUtil.getFile(request, "profImgExt", UPLOAD_PROFILE_DIR, userId);
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(nickName) && !StringUtil.isEmpty(email) && 
				!StringUtil.isEmpty(phone) && !StringUtil.isEmpty(gender) && !StringUtil.isEmpty(birthDt) && !StringUtil.isEmpty(userAddr) && !StringUtil.isEmpty(userType))
		{
			if(userService.userSelect(userId) == null)
			{
				User user = new User();
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setEmail(email);
				user.setPhone(phone);
				user.setUserAddr(userAddr);
				user.setNickName(nickName);
				user.setGrade("일반");
				user.setGender(gender);
				user.setBirthDt(birthDt);
				user.setUserType(userType);
				user.setApprovStat("N");
				user.setUserStat("Y");
				user.setMile(0);
				
				if(fileData != null && !StringUtil.isEmpty(fileData.getFileExt()))
				{
					user.setProfImgExt(fileData.getFileExt());
				}
//				else
//				{
//					user.setProfImgExt("none");
//				}
				
				if(userService.userInsert(user) > 0)
				{
					ajaxRes.setResponse(0, "success");
				}
				else
				{
					ajaxRes.setResponse(500, "internal server error");
				}
			}
			
			else
			{
				ajaxRes.setResponse(100, "duplicate id");
			}
		}
		else
		{
			ajaxRes.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/regProc response \n" + JsonUtil.toJsonPretty(ajaxRes));
		}
		
		return ajaxRes;
	}
	
	//회원정보수정화면
	@RequestMapping(value="/user/updateForm", method=RequestMethod.GET)
	public String updateFrom(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User user = userService.userSelect(sessionUserId);
		model.addAttribute("user", user);
		
		return "/user/updateForm";
	}
	
	//회원정보수정
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String email = HttpUtil.get(request, "email");
		String phone = HttpUtil.get(request, "phone");
		String userAddr = HttpUtil.get(request, "userAddr");
		String nickName = HttpUtil.get(request, "nickName");
		
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		FileData fileData = HttpUtil.getFile(request, "profImgExt", UPLOAD_PROFILE_DIR, userId);
		
		if(!StringUtil.isEmpty(sessionUserId))
		{
			if(StringUtil.equals(userId, sessionUserId))
			{
				User user = userService.userSelect(sessionUserId);
				
				if(user != null)
				{
					if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(nickName) && 
							!StringUtil.isEmpty(email) && !StringUtil.isEmpty(phone) && !StringUtil.isEmpty(userAddr))
					{
						user.setUserPwd(userPwd);
						user.setUserName(userName);
						user.setEmail(email);
						user.setPhone(phone);
						user.setUserAddr(userAddr);
						user.setNickName(nickName);
						
						if(fileData != null && fileData.getFileSize() > 0)
						{
							if(!StringUtil.isEmpty(user.getProfImgExt()) && !StringUtil.equals(user.getProfImgExt(), "") && !StringUtil.equals(user.getProfImgExt(), fileData.getFileExt()))
							{
								FileUtil.deleteFile(UPLOAD_PROFILE_DIR + FileUtil.getFileSeparator() + userId + "." + user.getProfImgExt());
							}
								
						}
						
						if(fileData != null && !StringUtil.isEmpty(fileData.getFileExt()))
						{
							user.setProfImgExt(fileData.getFileExt());
						}
//						else
//						{
//							user.setProfImgExt("none");
//						}
						
						if(userService.userUpdate(user) > 0)
						{
							ajaxRes.setResponse(0, "success");
						}
						else
						{
							ajaxRes.setResponse(500, "internal server error");
						}
					}
					else
					{
						ajaxRes.setResponse(400, "bad request");
					}
				}
				else
				{
					request.getSession().invalidate();
					ajaxRes.setResponse(404, "not found");
				}
			}
			else
			{
				request.getSession().invalidate();
				ajaxRes.setResponse(430, "id information is different");
			}
		}
		else
		{
			ajaxRes.setResponse(410, "login failed");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController]/user/userProc response \n" + JsonUtil.toJsonPretty(ajaxRes));
		}
		
		return ajaxRes;
	}
	
	//로그아웃
	@RequestMapping(value="/user/loginOut", method=RequestMethod.GET)
	public String loginOut(HttpServletRequest request, HttpServletResponse response)
	{	
		request.getSession().invalidate();
		
		return "redirect:/";
	}
	
	//회원탈퇴 화면
	@RequestMapping(value="/user/deleteForm", method=RequestMethod.GET)
	public String deleteForm(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirete:/";
		}
		
		User user = userService.userSelect(sessionUserId);
		model.addAttribute("user", user);
		
		return "/user/deleteForm";
	}
	
	//회원탈퇴 
	@RequestMapping(value="/user/deleteProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userDelete(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		FileData fileData = HttpUtil.getFile(request, "profImgExt", UPLOAD_PROFILE_DIR, userId);
		
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(!StringUtil.isEmpty(sessionUserId))
		{
			//userId와 sessionUserId가 같이 않을때
			if(!StringUtil.equals(userId, sessionUserId))
			{
				 ajaxRes.setResponse(430, "id information is different");
				 request.getSession().invalidate();
				 return ajaxRes;
			}
			
			User user = userService.userSelect(sessionUserId);
			
			if(user != null)
			{
				if(fileData != null && fileData.getFileSize() > 0)
				{
					if(!StringUtil.isEmpty(user.getProfImgExt()) && !StringUtil.equals(user.getProfImgExt(), "") && !StringUtil.equals(user.getProfImgExt(), fileData.getFileExt()))
					{
						FileUtil.deleteFile(UPLOAD_PROFILE_DIR + FileUtil.getFileSeparator() + userId + "." + user.getProfImgExt());
					}					
				}
				
				if(userService.userDelete(user) > 0)
				{
					request.getSession().invalidate();
					ajaxRes.setResponse(0, "success");
				}
				else
				{
					ajaxRes.setResponse(500, "internal server error");
				}
			}
			else
			{
				request.getSession().invalidate();
				ajaxRes.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxRes.setResponse(410, "loging failed");
		}
		
		return ajaxRes;
	}
	
	//아이디 찾기 화면
	@RequestMapping(value="/user/findIdForm", method=RequestMethod.GET)
	public String findIdForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/findIdForm";
	}
	
	//아이디 찾기
	@RequestMapping(value="/user/searchResultId", method=RequestMethod.POST)
	public String searchResultId(Model model,HttpServletRequest request, HttpServletResponse response)
	{
		String userName = HttpUtil.get(request, "userName");
		String phone = HttpUtil.get(request, "phone");
				
		User user = new User();
		user.setUserName(userName);
		user.setPhone(phone);
		
		User result = userService.searchId(user);

		if(result != null)
		{			
			model.addAttribute("userId", result.getUserId());
		}
		else
		{
			model.addAttribute("msg", "일치하는 회원정보가 없습니다.");
		}
		return "/user/searchResultId";
	}
	
	//비밀번호 찾기 
	@RequestMapping(value="/user/findPwdForm", method=RequestMethod.GET)
	public String findPwdForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/findPwdForm";
	}

	//비밀번호 찾기
	@RequestMapping(value="/user/searchResultPwd", method=RequestMethod.POST)
	public String searchResultPwd(Model model,HttpServletRequest request, HttpServletResponse response)
	{
		String userId = HttpUtil.get(request, "userId");
		String userName = HttpUtil.get(request, "userName");
		String phone = HttpUtil.get(request, "phone");
				
		User user = new User();
		user.setUserId(userId);
		user.setUserName(userName);
		user.setPhone(phone);
		
		User result = userService.searchPwd(user);

		if(result != null)
		{			
			model.addAttribute("userPwd", result.getUserPwd());
		}
		else
		{
			model.addAttribute("msg", "일치하는 회원정보가 없습니다.");
		}
		return "/user/searchResultPwd";
	}

	
	//마이페이지
	@RequestMapping(value="/user/myPage", method=RequestMethod.GET)
	public String myPageForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		int roomTypeSeq = HttpUtil.get(request, "roomTypeSeq", 0);
		
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		//회원 정보
		User user = userService.userSelect(sessionUserId);
		model.addAttribute("user", user);
		
		//쿠폰 정보
		List<Coupon> couponList = couponService.couponListByUser(sessionUserId);		
		model.addAttribute("couponList", couponList);

		int couponCount = couponService.couponCountByUser(sessionUserId);
		model.addAttribute("couponCount", couponCount);		

		//예약 정보
        List<Reservation> reservations = reservationService.getReservationsByGuestId(sessionUserId);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        
        for (Reservation r : reservations) 
        {
        	roomTypeSeq = r.getRoomTypeSeq();
        	
        	RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
        	
        	if(roomType != null)
        	{
        		r.setRoomTypeTitle(roomType.getRoomTypeTitle());
        		r.setRoomSeq(roomType.getRoomSeq()); 
        	}
        	
            try 
            {
                if (r.getRsvCheckInDt() != null) 
                {
                    Date checkInDate = sdf.parse(r.getRsvCheckInDt());
                    r.setRsvCheckInDateObj(checkInDate);
                }
                
                if (r.getRsvCheckOutDt() != null) 
                {
                    Date checkOutDate = sdf.parse(r.getRsvCheckOutDt());
                    r.setRsvCheckOutDateObj(checkOutDate);
                }
            } 
            catch (Exception e) 
            {
                // 필요시 로그 기록
            }

        }
		model.addAttribute("reservations", reservations);
		
		//마일리지 충전 내역
		List<MileageHistory> mileHistory = mileageHistoryService.getMileageHistory(sessionUserId);
		model.addAttribute("mileHistory", mileHistory);		
		
		//게시글 정보
		FreeBoard freeboard = new FreeBoard();
		freeboard.setUserId(sessionUserId);
		
		List<FreeBoard> freeBoard = freeBoardService.boardListByUser(sessionUserId);
		model.addAttribute("freeBoard", freeBoard);
		
		//위시리스트 정보
	    Wishlist wishlist = new Wishlist();
	    wishlist.setUserId(sessionUserId);
	    
	    List<Wishlist> wishList = wishlistService.wishlist(wishlist);
	    model.addAttribute("wishList", wishList);
		
		//장바구니 정보
	    List<Cart> cartList = cartService.cartList(sessionUserId);

	    // 총 금액 계산
	    int cartTotalAmt = 0;
	    if (cartList != null && !cartList.isEmpty()) 
	    {
	        cartTotalAmt = cartList.stream().mapToInt(Cart::getCartTotalAmt).sum();
	    }

	    model.addAttribute("cartList", cartList);
	    model.addAttribute("cartTotalAmt", cartTotalAmt);
	    model.addAttribute("roomTypeSeq", roomTypeSeq);
		
		return "/user/myPage";
	}
	
	// 마이페이지 - 장바구니에서 구매하기 눌렀을때
	@RequestMapping(value = "/user/myPage/checkout", method = {RequestMethod.GET, RequestMethod.POST})
	public String checkout(
	    HttpServletRequest request,
	    RedirectAttributes rt
	) {
	    HttpSession session = request.getSession();
	    String userId = (String) session.getAttribute(AUTH_SESSION_NAME);
	    if (userId == null) {
	        return "redirect:/user/login";
	    }
	    
	    // 파라미터 직접 받기
	    String[] cartSeqsArray = request.getParameterValues("cartSeqs");
	    if (cartSeqsArray == null || cartSeqsArray.length == 0) {
	        rt.addFlashAttribute("error", "선택된 장바구니 항목이 없습니다.");
	        return "redirect:/user/myPage";
	    }
	    
	    // String 배열을 Integer 리스트로 변환
	    List<Integer> cartSeqs = new ArrayList<>();
	    for (String seq : cartSeqsArray) {
	        try {
	            cartSeqs.add(Integer.parseInt(seq));
	        } catch (NumberFormatException e) {
	            rt.addFlashAttribute("error", "잘못된 장바구니 항목입니다.");
	            return "redirect:/user/myPage";
	        }
	    }

	    // 1) Cart 목록 조회
	    List<Cart> carts = cartService.getCartsBySeqs(cartSeqs, userId);
	    if (carts.size() != cartSeqs.size()) {
	        rt.addFlashAttribute("error", "유효하지 않은 장바구니 항목이 있습니다.");
	        return "redirect:/user/myPage";  // 마이페이지로 리다이렉트
	    }

	    // 2) 총 금액 합산
	    int totalAmt = 0;
	    for (int i = 0; i < carts.size(); i++) {
	        totalAmt += carts.get(i).getCartTotalAmt();
	    }

	    // 3) 마일리지 체크
	    int userMileage = mileageService.getUserMileage(userId);
	    if (userMileage < totalAmt) {
	        rt.addFlashAttribute("error", "마일리지가 부족합니다.");
	        return "redirect:/user/myPage";  // 마이페이지로 리다이렉트
	    }

	    // 4) 마일리지 차감
	    if (!mileageService.deductMileage(userId, totalAmt)) {
	        rt.addFlashAttribute("error", "마일리지 결제 오류");
	        return "redirect:/user/myPage";
	    }
	    
	    /* 마일리지 이력 등록 */
	    int updatedRows = mileageHistoryDao.updateMileageDeduct(userId, totalAmt);
	    if (updatedRows > 0) {
	        MileageHistory history = new MileageHistory();
	        history.setUserId(userId);
	        history.setTrxType("결제");
	        history.setTrxAmt(-totalAmt);
	        history.setBalanceAfterTrx(userMileage - totalAmt);
	        mileageHistoryDao.insertMileageHistory(history);
	    }
	    
	    SimpleDateFormat inSdf = new SimpleDateFormat("yyyyMMdd");

	    // 5) Cart → ReservationJY 변환 & 저장
	    for (Cart c : carts) {
	        Reservation r = new Reservation();
	        r.setGuestId(userId);
	        r.setRoomTypeSeq(c.getRoomTypeSeq());
	        r.setRsvCheckInDt(c.getCartCheckInDt());
	        r.setRsvCheckOutDt(c.getCartCheckOutDt());
	        r.setRsvCheckInTime(c.getCartCheckInTime());
	        r.setRsvCheckOutTime(c.getCartCheckOutTime());
	        r.setNumGuests(c.getCartGuestsNum());
	        r.setTotalAmt(c.getCartTotalAmt());
	        r.setFinalAmt(c.getCartTotalAmt());
	        r.setRsvStat("CONFIRMED");
	        r.setRsvPaymentStat("PAID");

	        try {
	            // 날짜 파싱해서 Date 객체 셋팅
	            Date inDate  = inSdf.parse(c.getCartCheckInDt());
	            Date outDate = inSdf.parse(c.getCartCheckOutDt());
	            r.setRsvCheckInDateObj(inDate);
	            r.setRsvCheckOutDateObj(outDate);

	            // HostId 세팅
	            RoomType rtObj = roomTypeService.getRoomType(c.getRoomTypeSeq());
	            String hostId = (rtObj != null ? rtObj.getHostId() : null);
	            if (hostId == null || hostId.trim().isEmpty()) {
	                hostId = reservationDao.selectHostIdByRoomSeq(rtObj.getRoomSeq());
	            }
	            r.setHostId(hostId);

	            // 예약 저장
	            reservationService.insertReservation(r);

	        } catch (ParseException pe) {
	            rt.addFlashAttribute("error", "날짜 형식 오류: " + c.getCartCheckInDt() + " / " + c.getCartCheckOutDt());
	            return "redirect:/user/myPage";
	        } catch (Exception e) {
	            rt.addFlashAttribute("error", "예약 저장 중 오류 발생: " + e.getMessage());
	            return "redirect:/user/myPage";
	        }
	    }

	    // 6) 저장 성공 시 장바구니 항목 일괄 삭제
	    cartService.deleteCarts(cartSeqs, userId);

	    rt.addFlashAttribute("msg", "예약이 완료되었습니다.");
	    return "redirect:/user/myPage";  // 마이페이지로 리다이렉트 (예약 목록 확인 가능)
	}
}