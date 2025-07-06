/*
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
import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("userController")
public class UserController 
{
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserService userService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.profile.dir']}")
	private String UPLOAD_PROFILE_DIR;
	
	public static final String AUTH_SESSION_NAME = "sessionUserId";
	
	//로그인
	@RequestMapping(value="/user/login", method=RequestMethod.POST)
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
					if(StringUtil.equals(user.getUserStat(), "Y"))
					{
						request.getSession().setAttribute(AUTH_SESSION_NAME, userId);
						
						String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
						
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
				else
				{
					user.setProfImgExt("none");
				}
				
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
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response)
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
					CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
					ajaxRes.setResponse(404, "not found");
				}
			}
			else
			{
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxRes.setResponse(430, "id information is dirrerent");
			}
		}
		else
		{
			ajaxRes.setResponse(410, "loging failed");
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
}

*/




















