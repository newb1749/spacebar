package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User_mj;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;
import com.sist.web.util.SessionUtil;

@Controller("userController_mj")
public class UserController_mj 
{
	private static Logger logger = LoggerFactory.getLogger(UserController_mj.class);
	
	@Autowired
	private UserService_mj userService_mj;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.profile.dir']}")
	private String UPLOAD_PROFILE_DIR;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
	
	//로그인 화면
	@RequestMapping(value="/user/loginForm_mj", method=RequestMethod.GET)
	public String loginForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/loginForm_mj";
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
			User_mj user = userService_mj.userSelect(userId);
			
			if(user != null)
			{
				if(StringUtil.equals(userPwd, user.getUserPwd()))
				{
					if(StringUtil.equals(user.getUserStat(), "Y"))
					{
						request.getSession().setAttribute("SESSION_USER_ID", userId);
						
						String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
						// "loginUser" 라는 이름으로 사용자 객체 전체를 세션에 추가로 저장
						request.getSession().setAttribute("loginUser", user);
						
						logger.debug("userId : " + userId);
						logger.debug("sessionUserId : " + sessionUserId);
						logger.debug("userPwd : " + userPwd);
						ajaxRes.setResponse(0, "success");
					}
					else
					{
						ajaxRes.setResponse(-99, "status error");
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
	@RequestMapping(value="/user/regForm_mj", method=RequestMethod.GET)
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
			return "/user/regForm_mj";
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
			if(userService_mj.userSelect(userId) == null)
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
			if(userService_mj.nickNameSelect(nickName) == null)
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
			if(userService_mj.userSelect(userId) == null)
			{
				User_mj user = new User_mj();
				
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
				
				if(userService_mj.userInsert(user) > 0)
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
	@RequestMapping(value="/user/updateForm_mj", method=RequestMethod.GET)
	public String updateFrom(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User_mj user = userService_mj.userSelect(sessionUserId);
		model.addAttribute("user", user);
		
		return "/user/updateForm_mj";
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
				User_mj user = userService_mj.userSelect(sessionUserId);
				
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
						
						if(userService_mj.userUpdate(user) > 0)
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
	@RequestMapping(value="/user/deleteForm_mj", method=RequestMethod.GET)
	public String deleteForm(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirete:/";
		}
		
		User_mj user = userService_mj.userSelect(sessionUserId);
		model.addAttribute("user", user);
		
		return "/user/deleteForm_mj";
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
			
			User_mj user = userService_mj.userSelect(sessionUserId);
			
			if(user != null)
			{
				if(fileData != null && fileData.getFileSize() > 0)
				{
					if(!StringUtil.isEmpty(user.getProfImgExt()) && !StringUtil.equals(user.getProfImgExt(), "") && !StringUtil.equals(user.getProfImgExt(), fileData.getFileExt()))
					{
						FileUtil.deleteFile(UPLOAD_PROFILE_DIR + FileUtil.getFileSeparator() + userId + "." + user.getProfImgExt());
					}					
				}
				
				if(userService_mj.userDelete(user) > 0)
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
	
	//아이디 찾기 
	@RequestMapping(value="/user/findIdForm", method=RequestMethod.GET)
	public String findIdForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/findIdForm_mj";
	}
	
	//비밀번호 찾기 
	@RequestMapping(value="/user/findPwdForm", method=RequestMethod.GET)
	public String findPwdForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/findPwdForm";
	}
	
	
	
	
	
	//마이페이지
	@RequestMapping(value="/user/myPage_mj", method=RequestMethod.GET)
	public String myPageForm(Model model ,HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User_mj user = userService_mj.userSelect(sessionUserId);
		model.addAttribute("user", user);
		
		return "/user/myPage_mj";
	}
}























