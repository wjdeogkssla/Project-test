package com.spring5.mypro00.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring5.mypro00.common.fileupload.domain.AttachFileDTO;
import com.spring5.mypro00.common.paging.domain.MyBoardPagingCreatorDTO;
import com.spring5.mypro00.common.paging.domain.MyBoardPagingDTO;
import com.spring5.mypro00.domain.MyBoardAttachFileVO;
import com.spring5.mypro00.domain.MyBoardVO;
import com.spring5.mypro00.service.MyBoardService;

import lombok.Setter;

@Controller
@RequestMapping("/myboard")
public class MyBoardController {
	
//	@Setter(onMethod_ = @Autowired)
	private MyBoardService myBoardService ; 
	
	//(단일 생성자를 이용한 주입: 생성자가 여러개 이고, 기본 생성자가 포함되어 있으면, 무조건 기본 생성자를 사용함)
	public MyBoardController(MyBoardService myBoarService) {
		this.myBoardService = myBoarService ;
		//System.out.println("MyBoardController의 모든 필드 초기화 생성자 입니다.");
	}
	
	
//  (Setter를 이용한 주입) 
//  public MyBoardController() {
//     System.out.println("MyBoardController의 기본 생성자 입니다.");
//  }
//  
//  @Autowired
//  public void setMyBoardService(MyBoardService myBoardService) {
//     this.myBoardService = myBoardService ;
//  }
	
//	//게시물 목록 조회
//	@GetMapping("/list")
//	public String showBoardList(MyBoardPegingDTO myboardPaging, Model model) {
//		List<MyBoardVO> myBoardList = myBoardService.getBoardList(myboardPaging);
//		System.out.println("myBoardList: " + myBoardList);
//		
//		model.addAttribute("myBoardList", myBoardList);
//		
//		return "myboard/list" ;
//	}
	
	
	//수정
	@GetMapping("/list")
	public String showBoardList(MyBoardPagingDTO myboardPaging, Model model) {
		System.out.println("myboardPaging: " + myboardPaging);
		MyBoardPagingCreatorDTO pagingCreator =  myBoardService.getBoardList(myboardPaging) ;
		System.out.println("컨트롤러에 전달된 myboardPagingCreator: \n" + pagingCreator);
		
		model.addAttribute("pagingCreator", pagingCreator) ;
		
		return "myboard/list" ;
	}
	
//	등록 페이지 호출
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String showBoardRegisterPage() {
		System.out.println("등록페이지 호출........");
		
		return "myboard/register" ;
	}
	
//	게시물 등록 처리
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String registerNewBoard(MyBoardVO myboard ,
			                       RedirectAttributes redirectAttr) {
		
		List<MyBoardAttachFileVO> myAttachFileList = myboard.getAttachFileList();
		
		if(myAttachFileList != null) {
			myAttachFileList.forEach(attachFile -> System.out.println(attachFile.toString()));
		} else {
			System.out.println("<<<<<<<<<<<<<<<<<<<<< 첨부파일 없음 >>>>>>>>>>>>>>>>>>>>>>>>>>>");
		}
		System.out.println();
		
		
		long bno = myBoardService.registerBoard(myboard);
		
		//return "redirect:/myboard/list?bno=" + bno ;
		
		redirectAttr.addFlashAttribute("result", bno) ;
		System.out.println("result: " + redirectAttr.getFlashAttributes());
		
		return "redirect:/myboard/list";
		
	}
	
	//특정 게시물 조회 페이지 , 수정 후 조회 페이지
	@GetMapping("/detail")
	public String showBoardDetail(Long bno, Model model, String result,
			  					  @ModelAttribute("myboardPaging") MyBoardPagingDTO myboardPaging) {

		MyBoardVO myboard = null ;
		
		System.out.println("Detail.jsp-수정삭제 후: result: " + result) ;
		System.out.println("Detail.jsp-수정삭제 후: bno: " + bno);
		
		myboard = myBoardService.getBoard(bno, result) ;	
		
		model.addAttribute("myboard", myboard) ;
		model.addAttribute("result", result) ;
		
		System.out.println("model: " + model);
		
		return "myboard/detail" ;
	}
	
	
//	특정 게시물 수정삭제 페이지 호출
	@GetMapping("/modify")
	@PreAuthorize("isAuthenticated() && principal.username == #bwriter")
	public String showBoardModify(Long bno, String bwriter, Model model,
			                      MyBoardPagingDTO myboardPaging) {
		MyBoardVO myboard = myBoardService.getBoard2(bno) ;
		
		model.addAttribute("myboard", myboard) ;
			
		return "myboard/modify" ;
	}
	
//	특정 게시물 수정
	@PostMapping("/modify")
	@PreAuthorize("isAuthenticated() && principal.username == #myboard.bwriter")
	public String modifyBoard(MyBoardVO myboard,
		                      RedirectAttributes redirectAttr,
		                      MyBoardPagingDTO myboardPaging) {

		boolean modifyResult = myBoardService.modifyBoard(myboard) ;
		
		if(modifyResult) {
		redirectAttr.addAttribute("result", "successModify") ;
		
		} else {
		redirectAttr.addAttribute("result", "failModify") ;
		}
		
		redirectAttr.addAttribute("bno", myboard.getBno()) ;
		redirectAttr.addAttribute("pageNum", myboardPaging.getPageNum());
		redirectAttr.addAttribute("rowAmountPerPage", myboardPaging.getRowAmountPerPage()) ;
		redirectAttr.addAttribute("scope", myboardPaging.getScope()) ;
		redirectAttr.addAttribute("keyword", myboardPaging.getKeyword());
		
		return "redirect:/myboard/detail" ;
	}
	
	
	
//	특정 게시물 삭제 POST /myboard/remove
	@PostMapping("/remove")
	@PreAuthorize("isAuthenticated() && principal.username == #myboard.bwriter")
	public String removeBoard(MyBoardVO myboard, 
							  RedirectAttributes redirectAttr,
							  MyBoardPagingDTO myboardPaging) {
		
		//boolean removeResult = myBoardService.removeBoard(bno);
		
		if(myBoardService.modifyBdelFlag(myboard.getBno())) { //게시물 블라인드처리 시 ㅏ용
//		if(myBoardService.removeBoard(bno)) { //게시물 삭제 시 사용(댓글이 없는 경우에만 동작, 엽습용)
		//if(myBoardService.removeBoard(bno)) {
			redirectAttr.addFlashAttribute("result", "successRemove");
		
		} else {
			redirectAttr.addFlashAttribute("result", "failRemove");
		}
		
		redirectAttr.addAttribute("pageNum", myboardPaging.getPageNum()) ;
		redirectAttr.addAttribute("rowAmountPerPage", myboardPaging.getRowAmountPerPage()) ;
		redirectAttr.addAttribute("scope", myboardPaging.getScope()) ;
		redirectAttr.addAttribute("keyword", myboardPaging.getKeyword());
		redirectAttr.addAttribute("beginDate", myboardPaging.getBeginDate()) ;
		redirectAttr.addAttribute("endDate", myboardPaging.getEndDate()) ;
		
		return "redirect:/myboard/list";
	}
	
	//특정 게시물의 첨부파일 정보를 JSON으로 전달(특정 게시물의 수정페이지에서 사용) ###########################
	@GetMapping(value = "/getFiles" , produces = {"application/json; charset=utf-8"})
	public @ResponseBody ResponseEntity<List<MyBoardAttachFileVO>> showAttachFiles(Long bno) {
		return new ResponseEntity<List<MyBoardAttachFileVO>>(myBoardService.getAttachFileList(bno), HttpStatus.OK);

	}
	
	
}
