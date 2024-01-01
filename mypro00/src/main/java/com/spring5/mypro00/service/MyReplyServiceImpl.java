package com.spring5.mypro00.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring5.mypro00.common.paging.domain.MyReplyPagingCreatorDTO;
import com.spring5.mypro00.common.paging.domain.MyReplyPagingDTO;
import com.spring5.mypro00.domain.MyReplyVO;
import com.spring5.mypro00.mapper.MyBoardMapper;
import com.spring5.mypro00.mapper.MyReplyMapper;


@Service
public class MyReplyServiceImpl implements MyReplyService{
		
		private MyReplyMapper myReplyMapper;
		private MyBoardMapper myBoardMapper;
		
		//자동주입 방법1: 단일 생성자 자동 주입 방식으로 주입 시
		public MyReplyServiceImpl(MyReplyMapper myReplyMapper,
				                  MyBoardMapper myBoardMapper) {
			this.myReplyMapper = myReplyMapper ;
			this.myBoardMapper = myBoardMapper ;
		}
	
		//자동주입 방법2: Setter의 @Autowired를 이용한 자동 주입
//		private MyReplyMapper myReplyMapper;
//		
//		public MyReplyServiceImpl() {		
//		}
//	
//		@Autowired
//		public void setMyReplyMapper(MyReplyMapper myReplyMapper) {
//			this.myReplyMapper = myReplyMapper;
//		}
	
		//자동주입 방법3: Setter의 @Autowired를 이용한 자동 주입(setter 자동 주입과 동일)
//		@Autowired
//		private MyReplyMapper myReplyMapper;
//		
//		public MyReplyServiceImpl() {			
//		}
//		
//		//특정 게시물에 대한 댓글 목록 조회
		@Override
		public MyReplyPagingCreatorDTO getReplyList(MyReplyPagingDTO myreplyPaging){
								
			long replyTotCnt = myReplyMapper.selectRowTotal(myreplyPaging.getBno());
			
			int pageNum = myreplyPaging.getPageNum();
			
			if(pageNum == -10) {
				
				pageNum = (int) Math.ceil((double) replyTotCnt / myreplyPaging.getRowAmountPerPage()) ;
				myreplyPaging.setPageNum(pageNum);
			}
			
			List<MyReplyVO> myreplyList = myReplyMapper.selectMyReplyList(myreplyPaging);
			
			
			MyReplyPagingCreatorDTO myreplyPagingCreator 
				= new MyReplyPagingCreatorDTO(myreplyList, replyTotCnt, myreplyPaging);
			
			return myreplyPagingCreator;		
	}
		
	//특정 게시물에 대한 댓글 등록(prno: null)
	@Transactional
	@Override
	public Long registerReplyForBoard(MyReplyVO myreply) {
		
		myReplyMapper.insertMyReplyForBoard(myreply);
		myBoardMapper.updateBReplyCnt(myreply.getBno(), 1);
		
		return myreply.getBno();
	}
	
	//댓글에 대한 답글 등록(prno: null rno 값)
	
	@Override
	@Transactional
	public Long registerReplyForReply(MyReplyVO myreply) {
	
		myReplyMapper.insertMyReplyForReply(myreply);
		myBoardMapper.updateBReplyCnt(myreply.getBno(), 1);
		 
		return myreply.getBno();
	}

	//특정 게시물에 대한 특정 댓글/답글 조회
	@Override
	public MyReplyVO getMyReply(long bno, long rno) {
		return myReplyMapper.selectMyReply(bno, rno);
	}

	//특정 게시물에 대한 특정 댓글/답글 수정
	@Override
	public boolean modifyMyReply(MyReplyVO myreply) {
		  return myReplyMapper.updateMyReply(myreply) == 1;
	}
	
	//특정 게시물에 대한 특정 댓글/답글 삭제(rdelFlag를 1로 업데이트)
	@Override
	@Transactional
	public boolean modifyRdelFlag(long bno, long rno) {
		
		int deleteRowCnt = myReplyMapper.updateRdelFlag(bno, rno) ;
		
	 	 myBoardMapper.updateBReplyCnt(bno, -1);
	 	
	 	 return deleteRowCnt == 1 ;
	 	 
//		 return	myReplyMapper.updateRdelFlag(bno, rno) == 1;
	}
	
	//특정 게시물에 대한 모든 댓글 삭제: 삭제 행수가 반환됨
	@Override
	public int removeAllMyReply(long bno) {
		return myReplyMapper.deleteAllReply(bno);
				
	}
	
	
}
