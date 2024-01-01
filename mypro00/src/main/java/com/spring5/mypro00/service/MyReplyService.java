package com.spring5.mypro00.service;

import java.util.List;

import com.spring5.mypro00.common.paging.domain.MyReplyPagingCreatorDTO;
import com.spring5.mypro00.common.paging.domain.MyReplyPagingDTO;
import com.spring5.mypro00.domain.MyReplyVO;

public interface MyReplyService {
	
	//특정 게시물에 대한 댓글 목록 조회: 페이징 고려
	public MyReplyPagingCreatorDTO getReplyList(MyReplyPagingDTO myreplyPaging);	
	
	//특정 게시물에 대한 댓글 등록(prno: null)
	public Long registerReplyForBoard(MyReplyVO myreply);
	
	//댓글에 대한 답글 등록(prno: null rno 값)
	public Long registerReplyForReply(MyReplyVO myreply);
	
	//특정 게시물에 대한 특정 댓글/답글 조회
	public MyReplyVO getMyReply(long bno, long rno);
	
	//특정 게시물에 대한 특정 댓글/답글 수정
	public boolean modifyMyReply(MyReplyVO myreply);
	
	//특정 게시물에 대한 특정 댓글/답글 삭제(rdelFlag를 1로 업데이트)
	public boolean modifyRdelFlag(long bno, long rno);
	
	//특정 게시물에 대한 모든 댓글 삭제: 삭제 행수가 반환됨
	public int removeAllMyReply(long bno);
		
	}
