package com.spring5.mypro00.common.security;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

public class MyLoginSucessHandler2 extends SavedRequestAwareAuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws ServletException, IOException {

		System.out.println("Authentication 구현객체 정보: " + authentication);
		
		// 로그인 실패 후 성공 시 남아있는 에러 세션 제거
		HttpSession session = request.getSession(false) ;
		
		if(session != null) {
			session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
		}
				
		//로그인을 요구한 요청 URL 정보를 가져 가져오는 코드 시작
		//RequestCache에 대하여 https://www.inflearn.com/questions/35556 페이지 설명 참고
		//로그인이 요청된 브라우저의 URL을 메모리에 저장
		RequestCache requestCache = new HttpSessionRequestCache() ;
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		Set<String> authNameList =
				AuthorityUtils.authorityListToSet(authentication.getAuthorities());
		
		if(savedRequest == null) {
			if(authNameList.contains("ADMIN")) {
				response.sendRedirect("/mypro00/myboard/list");
			} else {
				response.sendRedirect("/mypro00/");
			}
		} else {
			super.onAuthenticationSuccess(request, response, authentication);
		}
		
	}
	
	
	

}
