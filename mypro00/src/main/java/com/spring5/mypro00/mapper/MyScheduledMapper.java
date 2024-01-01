package com.spring5.mypro00.mapper;

import java.util.List;

import com.spring5.mypro00.domain.MyBoardAttachFileVO;

public interface MyScheduledMapper {
	
	//하루 전 날짜 까지 업로된 파일 정보
	public List<MyBoardAttachFileVO> selectAttachFilesUntilBeforeOneDay();
	
	//하루 전 날짜 동안 업로된 파일 정보
	public List<MyBoardAttachFileVO> selectAttachFilesDuringBeforeOneDay();

}
