package com.spring5.mypro00.common.fileupload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring5.mypro00.common.fileupload.domain.AttachFileDTO;

import net.coobird.thumbnailator.Thumbnailator;

//@Controller
public class FileUploadAjaxControllerV5my {
	
	private String uploadFileRepoDir = "C:/myupload" ;
	
	//form을 통한 다중 파일 업로드  //uploadFiles
	
	//1. 파일 업로드 요청 JSP 페이지 호출
//	@GetMapping(value = {"/fileUploadAjax"})
	public String callFileUploadAjaxPage() {
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
		
		SimpleDateFormat  sdf = new SimpleDateFormat("yyyy/MM/dd");		
		Date date = new Date();	
		String str = sdf.format(date);	
		
		return str.replace("//", File.separator);
	
	}
	
	
	//2. 파일 업로드 처리
//	@PostMapping(value = "/fileUploadAjaxAction",
//			     produces = "application/json; charset=utf-8")
	@ResponseBody
	public List<AttachFileDTO> fileUploadAction(MultipartFile[] yourUploadFiles) {
		
		List<AttachFileDTO> attachFileList = new ArrayList<AttachFileDTO>();	
		
		AttachFileDTO attachFile = null;
		
		//파일이름이 저장되는 변수
		String fileName = null ;
		
		//UUID를 이용한 고유한 파일이름 적용
		String myUuid = null;
		
		//날짜 형식 폴더 구조 생성
		String dateFmtStr = getFolder();
		
		//폴더생성
		File uploadPath = new File(uploadFileRepoDir, getFolder());
		
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}


		
		for(MultipartFile uploadFile : yourUploadFiles) {
			System.out.println("===========================");
			System.out.println("Upload FileName: " + uploadFile.getOriginalFilename());
			System.out.println("Upload File Size: " + uploadFile.getSize());
			
			attachFile = new AttachFileDTO();
			
			attachFile.setUploadPath(getFolder());
			attachFile.setRepoPath(uploadFileRepoDir);
			
//			File saveuploadFile = new File(uploadFileRepoDir, uploadFile.getOriginalFilename());
			
			fileName = uploadFile.getOriginalFilename();
			// 파일이름.확장자, 경로명\파일이름.확장자, 파일이름만 남기는 처리.
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			
			attachFile.setFileName(fileName);
			
			//UUID를 이용한 고유한 파일이름 적용
			myUuid = UUID.randomUUID().toString() ;
			
			attachFile.setUuid(myUuid);
			
			fileName = myUuid + "_" + fileName ;  
					
			File saveUploadFile = new File(uploadPath, fileName);
			
			try {
				uploadFile.transferTo(saveUploadFile);	
				//이미지파일이면 썸네일 생성
				
				if(isImageFile(saveUploadFile)) {
				
					attachFile.getUploadPath();
					
					//File thumBnameFile = new File(uploadPath, "s_" + fileName);
					
					FileOutputStream myFos = 
							new FileOutputStream(uploadPath + "/s_" + fileName);
							//new FileOutputStream(thumBnameFile);
					
					InputStream myIs = uploadFile.getInputStream();
					
					Thumbnailator.createThumbnail(myIs, myFos, 20, 20);
					
					attachFile.setFileType("I");
					
					myIs.close();
					myFos.flush() ;
					myFos.close() ;
				} else {
					attachFile.setFileType("F");
				}
			} catch (IllegalStateException | IOException e) {
				System.out.println("error: " + e.getMessage());
			} 
			
			attachFileList.add(attachFile);
			
		} //for-end
		
		return attachFileList ;
	}
	
	
}
