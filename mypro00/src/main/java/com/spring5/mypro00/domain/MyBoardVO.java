package com.spring5.mypro00.domain;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

//@AllArgsConstructor
@Getter
@Setter
@NoArgsConstructor
//@EqualsAndHashCode
@ToString
//@Data
public class MyBoardVO {
	private long bno ;             //글번호
	private String btitle ;        //제목
	private String bcontent ;      //글내용
	private String bwriter ;       //글작성자
	private Date bregDate ;        //글작성일
	private Timestamp bmodDate;    //글 수정일
	private int bviewsCnt;         //조회수
	private int breplyCnt;         //댓글수
	private int bdelFlag; //0: 유지, 1: 삭제요청됨
	
	private List<MyBoardAttachFileVO> attachFileList ; 
	

}
