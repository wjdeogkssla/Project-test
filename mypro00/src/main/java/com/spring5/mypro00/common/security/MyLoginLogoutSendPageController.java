package com.spring5.mypro00.common.security;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MyLoginLogoutSendPageController {
	
	@GetMapping("/myLogin")
	//@GetMapping("/login")
	public String sendLoginPage (String error, String logout, Model model) {
		
		if (error != null) {
			System.out.println("=========:error.length(): " + error.length());      //0
	        System.out.println("=========:error.hashCode(): " + error.hashCode());  
	        model.addAttribute("error", "로그인 오류. 계정명 또는 암호를 확인하세요");
	        
		} else if(logout != null) {
			System.out.println("=========:logout.length(): " + logout.length());    //0
	        System.out.println("=========:logout.hashCode(): " + logout.hashCode());
	        model.addAttribute("logout", "정상적으로 로그아웃 됨.") ;
		
		} else {
			model.addAttribute("normal", "사용자가 로그인 페이지 호출") ;
		} 
		
		return "common/myLogin";
	}
	
	@GetMapping("/myLogout")
	//@GetMapping("/logout")
	public String SendLogoutPage() {
		return "common/myLogout" ;
	}

}
