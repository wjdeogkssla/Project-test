package com.spring5.mypro00.common.fileupload;

import java.io.File;
import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

//@Controller
public class FileUploadAjaxControllerV1 {
	
	private String uploadFileRepoDir = "C:/myupload" ;
	
	//form을 통한 다중 파일 업로드  //uploadFiles
	
	//1. 파일 업로드 요청 JSP 페이지 호출
	//@GetMapping(value = {"/fileUploadAjax"})
	public String callFileUploadFormPage() {
		System.out.println("'Ajax을 통한 업로드 테스트' JSP 페이지 호출=========== ");
		return "sample/fileUploadAjax";
		
	}
	
	//2. 파일 업로드 처리
	//@PostMapping(value = "/fileUploadAjaxAction")
	@ResponseBody
	public String fileUploadActionForm(MultipartFile[] yourUploadFiles) {
		String originalFileName = null ;
		
		for(MultipartFile uploadFile : yourUploadFiles) {
			System.out.println("===========================");
			System.out.println("Upload FileName: " + uploadFile.getOriginalFilename());
			System.out.println("Upload File Size: " + uploadFile.getSize());
			
//			File saveuploadFile = new File(uploadFileRepoDir, uploadFile.getOriginalFilename());
			
			originalFileName = uploadFile.getOriginalFilename();
			// 파일이름.확장자, 경로명\파일이름.확장자, 파일이름만 남기는 처리.
			originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
			
			File saveuploadFile = new File(uploadFileRepoDir, originalFileName);
			
			try {
				uploadFile.transferTo(saveuploadFile);
				
			} catch (IllegalStateException | IOException e) {
				System.out.println("error: " + e.getMessage());
			} 
			
		}
		
		return "yourSuccess" ;
	}
	
	
}
