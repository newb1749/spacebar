/**
 * <pre>
 * 프로젝트명 : HBoard
 * 패키지명   : com.icia.web.interceptor
 * 파일명     : AuthInterceptor.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
//import com.sist.web.model.User;
//import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;
import com.sist.web.util.SessionUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.interceptor
 * 파일명     : AuthInterceptor.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * 설명       :
 * </pre>
 */
public class AuthInterceptor extends HandlerInterceptorAdapter
{
	private static Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);
	
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
	private String AJAX_HEADER_NAME;
	
//	@Autowired
//	private UserService userService;
	
	// 인증체크 안해도 되는 url 리스트
	private List<String> authExcludeUrlList;
	
	/**
	 * 생성자
	 */
	public AuthInterceptor()
	{
		this(null, null, null);
	}
	
	/**
	 * 생성자
	 * 
	 * @param authExcludeUrlList 인증 체크에서 제외될 URL 리스트
	 */
	public AuthInterceptor(String authCookieName, String ajaxHeaderName, List<String> authExcludeUrlList)
	{
		this.AUTH_COOKIE_NAME = authCookieName;
		this.AJAX_HEADER_NAME = ajaxHeaderName;
		this.authExcludeUrlList = authExcludeUrlList;
		
		if(logger.isDebugEnabled())
		{
			logger.debug("############################################################################");
			logger.debug("# AuthInterceptor                                                          #");
			logger.debug("############################################################################");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// Auth Cookie Name                             //");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// " + AUTH_COOKIE_NAME);
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// Ajax Header Name                             //");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// " + AJAX_HEADER_NAME);
			logger.debug("//////////////////////////////////////////////////");
			
		}
		
		if(this.authExcludeUrlList != null && this.authExcludeUrlList.size() > 0)
		{
			if(logger.isDebugEnabled())
			{
				logger.debug("//////////////////////////////////////////////////");
				logger.debug("// Auth Exclude Url                             //");
				logger.debug("//////////////////////////////////////////////////");
				
				for(int i=0; i<this.authExcludeUrlList.size(); i++)
				{
					logger.debug("// " + StringUtil.nvl(this.authExcludeUrlList.get(i)));
				}
				
				logger.debug("//////////////////////////////////////////////////");
			}
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("############################################################################");
		}
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception
    {
		boolean bFlag = true;
		boolean ajaxFlag = HttpUtil.isAjax(request, AJAX_HEADER_NAME);
		String url = request.getRequestURI();
		
		// 로그 기록 시작
		if(logger.isDebugEnabled())
		{
			request.setAttribute("_http_logger_start_time", String.valueOf(System.currentTimeMillis()));
			
			logger.debug("############################################################################");
			logger.debug("# Logging start ["+url+"]");
			logger.debug("############################################################################");
			logger.debug(HttpUtil.requestLogString(request));
			logger.debug("############################################################################");
		}
		
		// 인증이 필요 없는 URL인지 체크
		if(!isExcludeUrl(url))
		{
			logger.debug("# [" + url + "] : [인증체크] ");
			
			// =======================================================
			// [수정] 쿠키 기반 인증 로직을 세션 기반으로 변경
            // =======================================================
            
            // 1. 세션을 가져옵니다.
			HttpSession session = request.getSession();
            
            // 2. 세션에 "sessionUserId" 값이 있는지 확인합니다.
			if(SessionUtil.getSession(session, AUTH_SESSION_NAME) != null)
			{
				String userId = (String)SessionUtil.getSession(session, AUTH_SESSION_NAME);
				
				if(!StringUtil.isEmpty(userId))
				{
					// 세션에 아이디가 있으면 인증 성공
					logger.debug("# [Session] : [" + userId + "] - 인증 성공");
					bFlag = true;
				}
				else
				{
					// 세션에 값은 있는데 비어있는 경우, 인증 실패
					logger.debug("# [Session] : [내용이 비어있음] - 인증 실패");
					bFlag = false;
				}
			}
			else
			{
				// 세션에 값이 아예 없으면 인증 실패
				logger.debug("# [Session] : [세션 없음] - 인증 실패");
				bFlag = false;
			}
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("############################################################################");
		}
		
		if(bFlag == false) 
		{
			if(ajaxFlag == true)
			{
				// AJAX 요청일 경우 JSON 에러 응답
				Response<Object> ajaxResponse = new Response<Object>(HttpStatus.UNAUTHORIZED.value(), "인증되지 않은 사용자입니다. 로그인 후 이용하세요.");
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(JsonUtil.toJson(ajaxResponse));
			}
			else
			{
				response.sendRedirect("/");
			}
		}
		
		return bFlag;
    }
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception
	{
		if(logger.isDebugEnabled())
        {
        	long start_time = StringUtil.stringToLong((String)request.getAttribute("_http_logger_start_time"), 0);
        	long end_time = System.currentTimeMillis() - start_time;
        	
        	logger.debug("############################################################################");
        	logger.debug("# Logging end                                                              #");
        	logger.debug("############################################################################");
        	logger.debug("# [request url]          : [" + request.getRequestURI() + "]");
        	logger.debug("# [elapse time (second)] : [" + String.format("%.3f", (end_time / 1000.0f)) + "]");
        	logger.debug("############################################################################");
        }
	}
	
	/**
	 * <pre>
	 * 메소드명   : isExcludeUrl
	 * 작성일     : 2021. 1. 19.
	 * 작성자     : daekk
	 * 설명       : 인증하지 않아도 되는 URL 인지 체크 한다.
	 *              (true-인증체크 안함, false: 인증체크 해야됨)
	 * </pre>
	 * @param url 호출 url
	 * @return boolean
	 */
	private boolean isExcludeUrl(String url) {
        // [수정] 테스트를 위해 막아뒀던 로직을 다시 활성화합니다.
		if(authExcludeUrlList != null && authExcludeUrlList.size() > 0 && !StringUtil.isEmpty(url)) {
			for(int i=0; i<authExcludeUrlList.size(); i++) {
				String chkUrl = StringUtil.trim(StringUtil.nvl(authExcludeUrlList.get(i)));
				
				if(!StringUtil.isEmpty(chkUrl) && url.startsWith(chkUrl)) {
                    logger.debug("# [" + url + "] : [인증 제외]");
					return true; // 인증 제외 대상 URL이면 true 반환
				}
			}
		}
		
		return false; // 인증이 필요한 URL이면 false 반환
	}
}