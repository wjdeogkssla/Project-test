package com.spring5.mypro00.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class MyBoardAttachFileVO {
	
	private String uuid;
	private String uploadPath ;
	private String fileName ;
	private String fileType ;
	private Long bno ;
	private String repoPath = "C:/myupload" ; 
	
	

}
