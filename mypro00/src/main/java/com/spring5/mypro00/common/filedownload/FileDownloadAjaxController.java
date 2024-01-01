package com.spring5.mypro00.common.filedownload;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class FileDownloadAjaxController {
	
	@GetMapping(value = "/displayThumbnail")
	public ResponseEntity<byte[]> sendThumbnail(String fileName){
		
		File thmbnailFile = new File(fileName);
		
		ResponseEntity<byte[]> result = null ; 
		
		HttpHeaders httpHeaders = new HttpHeaders();
		
		try {
			httpHeaders.add("Content-Type", Files.probeContentType(thmbnailFile.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(thmbnailFile),
					                            httpHeaders,
					                            HttpStatus.OK);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		return result;
	}
	
	@GetMapping(value = "/fileDownloadAjax",
			    produces = {"application/octet-stream"})
	@ResponseBody
	public ResponseEntity<Resource> fileDownloadAjaxAction(String fileName 
//			                                               ,@RequestHeader("User-Agent") String userAgent
			                                               ){
	
//		System.out.println("fileName: " + fileName);
//		System.out.println("userAgent: " + userAgent);
		
		Resource myResource = new FileSystemResource(fileName);
		
		if(!myResource.exists()) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		String downloadName = myResource.getFilename() ;
		//System.out.println("downloadName1: " + downloadName);
		//2121fdsfdsf12-123sfsd-f12sdfsdfds7_업로드 테스트압축파일.txt
		
		//UUID가 제거된 파일이름
		downloadName = downloadName.substring(downloadName.indexOf("_") + 1);
		//System.out.println("downloadName2: " + downloadName);
		
		HttpHeaders httpHeaders = new HttpHeaders();
		
		String _downloadName = null ;
		
		try {
			//_downloadName = URLEncoder.encode(downloadName, "utf-8");  //IE, OLD-Edg				
			downloadName = new String(downloadName.getBytes("UTF-8"), "ISO-8859-1");
			
		} catch (UnsupportedEncodingException e) {
			e.getMessage();
		}
		
		httpHeaders.add("Content-Disposition", "attachment; fileName=" + downloadName);
		
		return new ResponseEntity<Resource>(myResource, httpHeaders ,HttpStatus.OK);
	}
	
	/*
	 * //서버에 저장된 업로드 파일 삭제
	 * 
	 * @PostMapping("/deleteFile") public ResponseEntity<String> deleteFile(String
	 * fileName, String fileType){ // System.out.println("fileName: " + fileName);
	 * // System.out.println("fileType: " + fileType);
	 * 
	 * try { fileName = URLDecoder.decode(fileName, "utf-8");
	 * System.out.println("fileName: " + fileName);
	 * 
	 * } catch (UnsupportedEncodingException e) { // TODO Auto-generated catch block
	 * e.printStackTrace(); }
	 * 
	 * File delFile = new File(fileName);
	 * 
	 * boolean delResult = delFile.delete() ;
	 * 
	 * //정상삭제: true 반환, 삭제실패: false 반환 if(!delResult) { return new
	 * ResponseEntity<String>("F", HttpStatus.NOT_FOUND) ; //일반파일과 썸네일 파일 삭제 }
	 * 
	 * if(fileType.equals("I")) { delFile = new File(fileName.replaceFirst("s_",
	 * "")); delResult = delFile.delete() ; }
	 * 
	 * System.out.println("delResult: " + delResult);
	 * 
	 * // if(!delResult) { // return new ResponseEntity<String>("F",
	 * HttpStatus.NOT_FOUND); // }else { // return new ResponseEntity<String>("S",
	 * HttpStatus.NOT_FOUND); // }
	 * 
	 * return delResult ? new ResponseEntity<String>("S", HttpStatus.OK) : new
	 * ResponseEntity<String>("F", HttpStatus.OK) ;
	 * 
	 * }
	 */

}
