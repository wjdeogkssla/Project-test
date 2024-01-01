package com.spring5.mypro00.common.fileupload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnailator;

//@Controller
public class FileUploadAjaxControllerV4 {
	
	private String uploadFileRepoDir = "C:/myupload" ;
	
	//form을 통한 다중 파일 업로드  //uploadFiles
	
	//1. 파일 업로드 요청 JSP 페이지 호출
//	@GetMapping(value = {"/fileUploadAjax"})
	public String callFileUploadFormPage() {
		System.out.println("'Ajax을 통한 업로드 테스트' JSP 페이지 호출=========== ");
		return "sample/fileUploadAjax";
		
	}
	
	//이미지파일에 대한 썸네일이미지 저장
	//Step1: 업로드파일에 대한 이미지 파일여부 검사 메소드
	private boolean isImageFile(File yourFile) {
	
		String yourFileContentType = null;
		try {
			yourFileContentType = Files.probeContentType(yourFile.toPath());
			System.out.println("fileContentType: " + yourFileContentType);

			return yourFileContentType.startsWith("image");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("오류 : " + e.getMessage());
		}
		
		return false;
	}
	//날짜 형식 폴더 함수 생성
	private String getFolder() {
		
		SimpleDateFormat  sdf = new SimpleDateFormat("yyyy-MM-dd");		
		Date date = new Date();	
		String str = sdf.format(date);	
		
		return str.replace("-", File.separator);
	
	}
	
	
	//2. 파일 업로드 처리
//	@PostMapping(value = "/fileUploadAjaxAction")
	@ResponseBody
	public String fileUploadActionForm(MultipartFile[] yourUploadFiles) {
		
		String fileName = null ;
		
		File uploadPath = new File(uploadFileRepoDir, getFolder());
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		//UUID를 이용한 고유한 파일이름 적용
		String myUuid = null;
		
		for(MultipartFile uploadFile : yourUploadFiles) {
			System.out.println("===========================");
			System.out.println("Upload FileName: " + uploadFile.getOriginalFilename());
			System.out.println("Upload File Size: " + uploadFile.getSize());
			
//			File saveuploadFile = new File(uploadFileRepoDir, uploadFile.getOriginalFilename());
			
			fileName = uploadFile.getOriginalFilename();
			// 파일이름.확장자, 경로명\파일이름.확장자, 파일이름만 남기는 처리.
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			
			//UUID를 이용한 고유한 파일이름 적용
			myUuid = UUID.randomUUID().toString() ;
			
			fileName = myUuid + "_" + fileName ;  
					
			File saveUploadFile = new File(uploadPath, fileName);
			
			try {
				uploadFile.transferTo(saveUploadFile);	
				//이미지파일이면 썸네일 생성
				
				if(isImageFile(saveUploadFile)) {
					
					//File thumBnameFile = new File(uploadPath, "s_" + fileName);
					
					FileOutputStream myFos = 
							new FileOutputStream(uploadPath + "/s_" + fileName);
							//new FileOutputStream(thumBnameFile);
					
			
					Thumbnailator.createThumbnail(uploadFile.getInputStream(), myFos, 20, 20);
					
					myFos.flush() ;
					myFos.close() ;
				}		
			} catch (IllegalStateException | IOException e) {
				System.out.println("error: " + e.getMessage());
			} 
			
		}
		
		return "yourSuccess" ;
	}
	
	
}
