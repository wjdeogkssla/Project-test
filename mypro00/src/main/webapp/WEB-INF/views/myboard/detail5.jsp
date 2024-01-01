<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<%@include file="../myinclude/myheader.jsp" %>  

<style>
 th {text-align: center;}
 p {white-space:pre-wrap;}
</style>  

<div id="page-wrapper">
    <div class="row">
        <div class="col-lg-12">
            <h3 class="page-header"
				style="white-space: nowrap;" >Board - Detail
				 <small>
				 	&nbsp;&nbsp;&nbsp;<c:out value="${myboard.bno}"/>번 게시물
				 </small>
			</h3>
        </div><%-- /.col-lg-12 --%>
    </div><%-- /.row --%>
    <div class="row">
        <div class="col-lg-12">
        
            <div class="panel panel-default">
                <div class="panel-heading">
                	<div class="row">
						<div class="col-md-2" style="white-space: nowrap; height: 45px; padding-top:11px;">
							<strong style="font-size:16px;">${myboard.bwriter}님 작성</strong>
						</div>
						<div class="col-md-3" style="white-space: nowrap; height: 45px; padding-top:16px;">
							<span class="text-primary" style="font-size: smaller; height: 45px; padding-top: 19px;">
								<span>
									<span>등록일:&nbsp;</span>
									<strong><fmt:formatDate 
												pattern="yyyy-MM-dd HH:mm:ss"
												value="${myboard.bregDate}"
											 /></strong>
									<span>&nbsp;&nbsp;</span>
								</span>
								<span>조회수:&nbsp;<strong><c:out value="${myboard.bviewsCnt}"/></strong>
								</span>
							</span>
						</div>
						<div class="col-md-7" style="height: 45px; padding-top:6px;"><%-- vertical-align: middle; --%>
							<div class="button-group pull-right">


<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="username"/>
		<c:if test="${username eq myboard.bwriter }">
							<button type="button" id="btnToModify" data-oper="modify"
									class="btn btn-primary"><span>수정페이지로 이동</span></button>
		</c:if>
</sec:authorize>
									
							<button type="button" id="btnToList" data-oper="list"
									class="btn btn-warning"><span>목록페이지로 이동</span></button>
							</div>
						</div>
					</div>
                </div><!-- /.panel-heading --><%-- /.panel-heading --%>
                
                <div class="panel-body form-horizontal">

	
	<div class="form-group">
	    <label class="col-sm-2 control-label" style="white-space: nowrap;">글제목</label>
	    <div class="col-sm-10">
	    	<input class="form-control" name="btitle" id="btitle" 
	    		   value="${myboard.btitle }" readonly="readonly">
		</div>
	</div>
	<div class="form-group">
	    <label class="col-sm-2 control-label" style="white-space: nowrap;">글내용</label>
	    <%-- <textarea>와 </textarea>는 표시 내용과 붙어있어야 필요없는 공백이 포함되지 않음 --%>
	    <div class="col-sm-10">
	    	<textarea class="form-control" rows="3" name="bcontent" id="bcontent"
	    			  style="resize: none;"
	    			  readonly="readonly"><c:out value="${myboard.bcontent}"/></textarea>
		</div>	    			  
	</div>

	<div class="form-group">
	    <label class="col-sm-2 control-label" style="white-space: nowrap;">최종수정일</label>
	    <div class="col-sm-10">
	    	<input class="form-control" name="bmodDate" id="bmodDate" 
	      		   value='<fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${myboard.bmodDate }"/>' readonly="readonly">
		</div>
	</div>

<%-- Modal: 게시물 수정 후, 수정 결과 표시 모달 --%>
<div class="modal fade" id="yourModal" tabindex="-1" role="dialog" aria-labelledby="yourModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="yourModalLabel">Modal title</h4>
            </div>
            <div class="modal-body" id="yourModal-body">메시지</div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
            </div>
        </div><%-- /.modal-content --%>
    </div><%-- /.modal-dialog --%>
</div><%-- /.modal --%>

<form id="frmSendValue">
	<input type="hidden" name="pageNum" value="${myboardPaging.pageNum }" >
	<input type="hidden" name="rowAmountPerPage" value="${myboardPaging.rowAmountPerPage }" >
	<input type="hidden" name="scope" value="${myboardPaging.scope }" >
	<input type="hidden" name="keyword" value="${myboardPaging.keyword }" >
	<input type="hidden" name="beginDate" value="${myboardPaging.beginDate }" >
	<input type="hidden" name="endDate" value="${myboardPaging.endDate }" >
</form>
                </div><%-- /.panel-body --%>
                
            </div><%-- /.panel --%>
        </div><%-- /.col-lg-12 --%>
    </div><%-- /.row --%>

<%-- 첨부파일 결과 표시 --%>    
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                	<strong style="font-size:16px;">첨부 파일</strong>
                </div><!-- /.panel-heading -->
                <div class="panel-body"><!-- 
                    <div class="form-group uploadDiv">
                        <input id="inputFile" class="btn btn-primary inputFile" type="file" name="uploadFiles" multiple="multiple" /><br>
                    </div> -->
	                <div class="form-group fileUploadResult">
	                    <ul>
<%-- 업로드 후 처리결과가 표시될 영역 --%>
<c:choose>
<c:when test="${empty myboard.attachFileList }">
	<li style="font-size: 12pt;">첨부파일이 없습니다</li>
</c:when>
<c:otherwise>
	<c:forEach var="attachFile" items="${myboard.attachFileList }">
		<c:choose>
		<c:when test="${attachFile.fileType == 'F' }">
			<li class="attachLi" 
				data-repopath = "${attachFile.repoPath }"
			    data-uploadpath = "${attachFile.uploadPath }" 
			    data-uuid = "${attachFile.uuid }" 
			    data-filename = "${attachFile.fileName }" 
			    data-filetype = "F" >
			        <img src='${contextPath}/resources/img/icon-attach.png' style='width:25px;'>
			        &nbsp;&nbsp;${attachFile.fileName}
			</li>
		</c:when>
		<c:otherwise>
			<c:set var="thumbnail" value="${attachFile.repoPath}/${attachFile.uploadPath}/s_${attachFile.uuid}_${attachFile.fileName}"/>
			<li class="attachLi" 
				data-repopath = "${attachFile.repoPath }"
			    data-uploadpath = "${attachFile.uploadPath }" 
			    data-uuid = "${attachFile.uuid }" 
			    data-filename = "${attachFile.fileName }" 
			    data-filetype = "I" >
			        <img src='${contextPath}/displayThumbnail?fileName=${thumbnail}' style='width:25px;'>
			        &nbsp;&nbsp;${attachFile.fileName}
			</li>
			<c:remove var="thumbnail"/>
		</c:otherwise>
		</c:choose>
	</c:forEach>
</c:otherwise>
</c:choose>
	                    </ul>
	                </div>
                </div><!-- /.panel-body -->
            </div><!-- /.panel -->
        </div><!-- /.col-lg-12 -->
    </div><!-- /.row -->

<%-- Modal: 첨부파일 이미지 표시 --%>
<div class="modal fade" id="attachModal" tabindex="-1" role="dialog" aria-labelledby="attachModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body" id="attachModal-body">
            	<%--이미지표시 --%>
            </div>
        </div><%-- /.modal-content --%>
    </div><%-- /.modal-dialog --%>
</div><%-- /.modal --%>
    
<%-- 댓글 요소 시작 --%>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default" >
			<div class="panel-heading">
				<div style="margin-bottom: 0px; font-size: 16px;">
					<strong style="padding-top: 2px;">
						<span>댓글&nbsp;<c:out value="${myboard.breplyCnt}"/>개</span>
						<span id="replyTotal"></span>
						<span>&nbsp;</span>
<sec:authorize access="isAuthenticated()">						
						<button type="button" id="btnChgCmtReg" class="btn btn-info btn-sm">댓글 작성</button>
												
						<button type="button" id="btnRegCmt" class="btn btn-warning btn-sm"
								style="display:none">댓글 등록</button>
						<button type="button" id="btnCancelRegCmt" class="btn btn-warning btn-sm"
								style="display:none">취소</button>&nbsp;&nbsp;&nbsp;
</sec:authorize>

<sec:authorize access="isAuthenticated()">
						<span id="spanLoginUser" style="display:none">
							<strong><sec:authentication property="principal.username"/> 님 작성</strong>
						</span>	
</sec:authorize>		
						
									
					</strong>
				</div>
			</div> <%-- /.panel-heading --%>
			<div class="panel-body">

<sec:authorize access="isAuthenticated()">
			<%-- 댓글 입력창 div 시작 --%>
				<div class="form-group" style="margin-bottom: 5px;">
					<textarea class="form-control txtBoxCmt" name="rcontent"
							  placeholder="댓글작성을 원하시면,&#10;댓글 작성 버튼을 클릭해주세요."
							  readonly="readonly"
							 ></textarea>
				</div>
</sec:authorize>
				<hr style="margin-top: 10px; margin-bottom: 10px;"><%-- 댓글 입력창 div 끝 --%>

<ul class="chat" id="chat">

<%-- 댓글 목록 표시 영역 - JavaScript로 내용이 생성되어 표시됩니다.--%><%-- 
	<li class="left clearfix commentLi" data-bno="123456" data-rno="12">
		<div>
			<div>
				<span class="header info-rwriter">
					<strong class="primary-font">user00</strong>
					<span>&nbsp;</span>
					<small class="text-muted">2018-01-01 13:13</small>
				</span>
				<p>앞으로 사용할 댓글 표시 기본 템플릿입니다.</p>
			</div>
			
			<div class="btnsComment" style="margin-bottom:10px">
				<button type="button" style="display:in-block"
						class="btn btn-primary btn-xs btnChgReg">답글 작성</button>
				<button type="button" style="display:none"
						class="btn btn-warning btn-xs btnRegCmt">답글 등록</button>
				<hr class="txtBoxCmtHr" style="margin-top:10px; margin-bottom:10px">
				<textarea class="form-control txtBoxCmtMod" name="rcontent" 
						  style="margin-bottom:10px"
						  placeholder="답글작성을 원하시면,&#10;답글 작성 버튼을 클릭해주세요."
						 ></textarea>
			</div>
		</div>
	</li> --%>
	
</ul><%-- /.chat --%>

			</div><%-- /.panel-body --%>
			<div class="panel-footer text-center" id="showCmtPagingNums">
				<%-- 댓글 목록의 페이징 번호 표시 영역 - JavaScript로 내용이 생성되어 표시됩니다.--%>
			</div>
		</div><%-- /.panel --%>
	</div><%-- .col-lg-12 --%>
</div><%-- .row : 댓글 화면 표시 끝 --%>

<form id = "frmCmtPagingValue">
	<input type="hidden" name="pageNum" value="">
	<input type="hidden" name="rowAmountPerPage" value="">
</form>

</div><%-- /#page-wrapper --%>


<%-- 게시물 상세 자바스크립트 시작 --%>
<script>

var frmSendValue = $("#frmSendValue") ;

<%-- 게시물 목록 페이지 이동 --%>
$("#btnToList").on("click", function(){
<%--
	window.location.href="${contextPath}/myboard/list" ;
--%>
	frmSendValue.attr("action", "${contextPath}/myboard/list").attr("method", "get") ;
	frmSendValue.submit() ;
});

<%-- 게시물 수정-삭제 페이지 이동 --%>
$("#btnToModify").on("click", function(){
<%--
	window.location.href='${contextPath}/myboard/modify?bno=<c:out value="${myboard.bno}"/>' ;
--%>

	var bno = '<c:out value="${myboard.bno}"/>' ;
	
	frmSendValue.append("<input type='hidden' name='bno' value='" + bno + "'/>") ;
	frmSendValue.attr("action", "${contextPath}/myboard/modify").attr("method", "get") ;
	frmSendValue.submit() ;
});


var result = '<c:out value="${result}" />' ;

function runModal(result) {
//	if (result.length == 0|| history.state) {
	if (result.length == 0) {
		return ;
	
	} else if ( result == "successModify" ) {
		var myMsg =  "게시글이 수정되었습니다. " ;
		
	}  
//모달 사용 시
	$("#yourModal-body").html(myMsg) ;
	
	$("#yourModal").modal("show") ;
	
	myMsg = "" ;
}
</script>


<%-- 첨부파일 이미지 표시 --%>
<script>
$(".attachLi").on("click", function(){
	var objLi = $(this) ;
	
	var myFileName = objLi.data("repopath") + "/" + objLi.data("uploadpath") + "/" 
				   + objLi.data("uuid") + "_" + objLi.data("filename") ;
	
	var myFileType = objLi.data("filetype") ;
	
	if(myFileType == "I") {
		$("#attachModal-body").html("<img src='${contextPath}/fileDownloadAjax?fileName=" 
										      + encodeURI(myFileName) 
										      + "' style='width:100%;'>") ;
		$("#attachModal").modal("show") ;
	
	} else {
		self.location.href ="${contextPath}/fileDownloadAjax?fileName="  + encodeURI(myFileName) ;
	}
	
});

<%-- 표시된 이미지 모달 감추기 --%>
$("#attachModal").on("click", function(){
	$("#attachModal").modal("hide") ;
});


</script>

<%-- 댓글/답글 자바스크립트 시작--%>
<script type="text/javascript" src="${contextPath }/resources/js/mycomment.js"></script>
<script type="text/javascript" >

var myCsrfHeaderName = "${_csrf.headerName}" ;
var myCsrfToken = "${_csrf.token}" ;

$(document).ajaxSend(function(e, xhr){
	xhr.setRequestHeader(myCsrfHeaderName, myCsrfToken) ;
		
});



var bnoValue = '<c:out value="${myboard.bno}"/>' ;

var commentUL = $("#chat") ;

var frmCmtPagingValue = $("#frmCmtPagingValue") ;

var loginUser = "" ;

<sec:authorize access="isAuthenticated()">
	loginUser = '<sec:authentication property="principal.username"/>' ;
</sec:authorize>

<%-- 댓글 페이징 번호 표시 --%>
function showCmtPagingNums(replyTotCnt, pageNum, rowAmountPerPage) {
	
	var pagingNumCnt = 3 ;
	
	var endPagingNum = Math.ceil(pageNum / pagingNumCnt) * pagingNumCnt ;
	//alert(Math.ceil(pageNum / pagingNumCnt)) ;
	var startPagingNum = endPagingNum - (pagingNumCnt-1) ;
	
	var lastPagingNum = Math.ceil(replyTotCnt/rowAmountPerPage) ;
	
	if(lastPagingNum < endPagingNum) {
		endPagingNum = lastPagingNum ;
	}
	
	var prev = startPagingNum > 1 ;
	var next = endPagingNum < lastPagingNum ;
	
	var pagingDisplayHTML
		= '<div style="text-align: center;">'
		+ '   <ul class="pagination pagination-sm" >' ;
                
	if(prev) {
               
	pagingDisplayHTML 
		<%-- 맨 앞으로 --%>
	    +='        <li class="pagination-button">'
		+ '            <a href="1" aria-label="Previous">'
		+ '                <span aria-hidden="true">&laquo</span>'
		+ '            </a>'
		+ '        </li>'
		<%-- 이전 페이징 번호 그룹 --%>
		+ '        <li class="pagination-button">'
		+ '            <a href="' + (startPagingNum-1) + '" aria-label="Previous">'
		+ '                <span aria-hidden="true">이전</span>'
		+ '            </a>'
		+ '        </li>' ;
	}      
	        
	for(var i = startPagingNum ; i <= endPagingNum ; i++) {
		    
		var active = ((pageNum == i) ? "active" : "") ;
	pagingDisplayHTML
	   += '        <li class="pagination-button ' + active + '" >'  
	   +  '            <a href="' + i + '">' + i + '</a>'
       +  '        </li>' ;
	}
	
	if(next) {
        
	pagingDisplayHTML
		<%-- 다음 페이징 번호 그룹 --%>
		+='        <li class="pagination-button">'
		+ '            <a href="' + (endPagingNum + 1) + '" aria-label="Next">'
		+ '                <span aria-hidden="true">다음</span>'
		+ '            </a>'
		+ '        </li>' 
		<%-- 맨 뒤로 --%>
	    + '        <li class="pagination-button">'
		+ '            <a href="' + lastPagingNum + '" aria-label="Next">'
		+ '                <span aria-hidden="true">&raquo</span>'
		+ '            </a>'
		+ '        </li>' ;
		}
	
	pagingDisplayHTML 
        +='    </ul>'
        + '</div>' ;
            
		$("#showCmtPagingNums").html(pagingDisplayHTML);
}

<%-- 선택된 페이징 번호 클릭 시, 댓글목록 가져오는 함수: 이벤트 전파 이용 --%>
<%-- #showCmtPagingNums > div > ul > li:nth-child(2) > a --%>
$("#showCmtPagingNums").on("click","div ul li a", function(e){
	e.preventDefault() ;
	var targetPageNum = $(this).attr("href") ;
	showCmtList(targetPageNum) ;
});


<%--댓글목록 표시 함수: 서버로부터 전달된 데이터를 이용해서 댓글 목록을 표시하는 JS 함수--%>
function showCmtList(pageNum){
	
	myReplyClsr.getCmtList(
		{bno: bnoValue, pageNum: pageNum || 1} ,
		
		function(myReplyPagingCreator){
			
			$("#replyTotal").html("댓글&nbsp;" + myReplyPagingCreator.replyTotCnt + "개") ;
			
			frmCmtPagingValue.find("input[name='pageNum']").val(pageNum) ;
			frmCmtPagingValue.find("input[name='rowAmountPerPage']").val(myReplyPagingCreator.myreplyPaging.rowAmountPerPage) ;
			
			var str = '' ;
			
			if(!myReplyPagingCreator.myreplyList || myReplyPagingCreator.myreplyList.length == 0){
				str += '<li class="left clearfix commentLi" '
					+ ' 	style="text-align: center; background-color: lightCyan;'
					+ ' 	height: 35px;margin-bottom: 0px;padding-bottom:0px;'
					+ ' 	padding-top:6px;border: 1px dotted;">'
					+ ' 	<strong>등록된 댓글이 없습니다.</strong></li>';
				
				commentUL.html(str) ;
				return ;
			} 
			
			for(var i = 0, len = myReplyPagingCreator.myreplyList.length; i < len ; i++) {
				if(myReplyPagingCreator.myreplyList[i].rdelFlag == 1) {
				str +='<li class="left clearfix commentLi">'
					+ ' <div style="background-color: Moccasin; text-align: center">'
				    + '     <em>작성자에 의해서 삭제글입니다.</em>'
					+ ' </div>'
					+ '</li>';
				
				} else {
				str +='<li class="left clearfix commentLi" '
				    + '    data-bno="' + bnoValue + '" '
				    + '    data-rno="' + myReplyPagingCreator.myreplyList[i].rno + '" '
				    + '    data-rwriter="' + myReplyPagingCreator.myreplyList[i].rwriter + '" '
				    + '    data-rdelflag="' + myReplyPagingCreator.myreplyList[i].rdelFlag + '">' ;
					<%-- 댓글 답글 들여쓰기 --%>
					if(myReplyPagingCreator.myreplyList[i].lvl == 1){
				
				str += '<div>' ;
				
					} else if (myReplyPagingCreator.myreplyList[i].lvl == 2){
				str += '<div style="padding-left: 25px;">' ;
					
					} else if (myReplyPagingCreator.myreplyList[i].lvl == 3){
				str += '<div style="padding-left: 50px;">' ;		
					
					} else if (myReplyPagingCreator.myreplyList[i].lvl == 4){
				str += '<div style="padding-left: 70px;">' ;
					
					} else { <%-- 답글의 레벨이 5이상이면 동일한 들여쓰기 --%>
				str += '<div style="padding-left: 100px;">' ;
						
					}
				<%-- 답글에 대한 아이콘 표시  --%>	
				if(myReplyPagingCreator.myreplyList[i].lvl > 1) {
				str += '    <i class="fa fa-reply fa-fw"></i>&nbsp;';
				
				}	

				str +='    <span class="header info-rwriter">'
				    + '        <strong class="primary-font">' + myReplyPagingCreator.myreplyList[i].rwriter + '</strong>&nbsp;&nbsp;'
				    + '        <small class="text-muted">' 
				    +              myReplyClsr.myDateTimeFmt(myReplyPagingCreator.myreplyList[i].rmodDate) 
				    + '        </small>'
				    + '    </span>'<%-- 
				    + '    <p style="white-space:pre-wrap;" data-bno="' + myReplyPagingCreator.myreplyList[i].bno + '"' --%> 
				    + '    <p class="rcontent-p" style="white-space:pre-wrap;"'
				    + '       data-bno="' + myReplyPagingCreator.myreplyList[i].bno + '"'
				    + '       data-rno="' + myReplyPagingCreator.myreplyList[i].rno + '">'
				    +         myReplyPagingCreator.myreplyList[i].rcontent + '</p>'
				    + '</div>' ;

<sec:authorize access="isAuthenticated()">

				 str+='    <button type="button" style="display:in-block;" ' 
				    + '            class="btn btn-primary btn-xs btnChgReplyReg">답글작성</button>' ;
</sec:authorize>				

				 str+='</li>' ;
				}

			}<%--for-end--%>
			
			commentUL.html(str) ;
			
			showCmtPagingNums(myReplyPagingCreator.replyTotCnt, 
							  myReplyPagingCreator.myreplyPaging.pageNum,
							  myReplyPagingCreator.myreplyPaging.rowAmountPerPage);
			
		}<%--callback-function-end --%>
			
	); <%--myReplyClsr.getCmtList(); 완료--%>
	
	
}<%--showCmtList-end --%>

<%--댓글 추가 초기화 함수 --%>
function resetCmtRegElements(){
	$("#btnChgCmtReg").attr("style", "display:in-block;") ;
	$("#btnRegCmt").attr("style", "display:none") ;
	$("#btnCancelRegCmt").attr("style", "display:none;") ;
	$(".txtBoxCmt").val("")
				   .attr("readonly", true)
				   .attr("placeholder", "댓글작성을 원하시면,\n댓글 작성 버튼을 클릭해주세요.") ;
	
	$("#spanLoginUser").attr("style", "display:none;") ;

}

<%-- 댓글 작성 버튼 클릭 처리 --%>
$("#btnChgCmtReg").on("click", function(){
	
	resetRelyRegElements() ;
	resetReplyModElements() ;
	
	$(this).attr("style", "display:none;") ;
	$("#btnRegCmt").attr("style", "display:in-block; margin-right:2px") ;
	$("#btnCancelRegCmt").attr("style", "display:in-block;") ;
	$(".txtBoxCmt").attr("placeholder", "").attr("readonly", false) ;
	$("#spanLoginUser").attr("style", "display:in-block") ;
	
});

<%-- 댓글 등록 버튼 클릭 처리: 이벤트 전파 --%>
$("#btnRegCmt").on("click", function(){
	
	var rcontent = $(".txtBoxCmt").val() ;
//	var loginUser = "슈퍼맨" ;
		
	var reply = {bno: bnoValue, rcontent: rcontent, rwriter: loginUser } ;
	
	myReplyClsr.registerCmt(
			reply,
			function(result){
				if (result != null) {
					alert(result + "번 댓글이 등록되었습니다.") ;	
				} else {
					alert("서버 장애로 댓글 등록이 취소되었습니다.") ;
				}
				
				resetCmtRegElements() ;
				
				showCmtList(-10) ;
			}
	);//
	
});

<%-- 댓글 등록 "취소" 버튼 클릭 처리 --%>
$("#btnCancelRegCmt").on("click", "", function(){
<%--
	$("#btnChgCmtReg").attr("style", "display:in-block;") ;
	$("#btnRegCmt").attr("style", "display:none") ;
	$("#btnCancelRegCmt").attr("style", "display:none;") ;
	$(".txtBoxCmt").val("")
				   .attr("readonly", true)
				   .attr("placeholder", "댓글작성을 원하시면,\n댓글 작성 버튼을 클릭해주세요.") ; 
--%>
	resetCmtRegElements() ;
	
});


<%--답글 작성 초기화 함수 --%>
function resetRelyRegElements() {
	$(".btnRegReply").remove() ;
	$(".btnCancelRegReply").remove() ;
	$(".txtBoxReply").remove() ;
	$(".btnChgReplyReg").attr("style", "display: in-block;") ;
	$("#replyloginUserSpan").attr("style", "display: none;") ;
	$("#replyloginUserSpan").remove();
}

<%--답글 작성 버튼 클릭 처리:이벤트 전파
   #chat > li:nth-child(1) > button  --%>
$("#chat").on("click","li .btnChgReplyReg" , function(){
	
	resetCmtRegElements(); <%--댓글 등록 작업 초기화 --%>
	resetRelyRegElements() ; <%--다른 답글 등록 작업 초기화 --%>
	resetReplyModElements() ; <%--다른 답글 수정 작업 초기화 --%>
	
<%--로그인 하지 않은 경우--%>
	if(!loginUser) {
		return ;
	}
	
<%--로그인 계정이 자신의 댓글/답글에 답글 등록을 하려는 경우를 방지 --%>	
	var rwriter = $(this).closest("li").data("rwriter") ;
	
	if(loginUser == rwriter){
		return ;
	}
	
	<sec:authorize access="isAuthenticated()">
	
	var strTxtBoxReply = "" ;
	
	strTxtBoxReply
		+='<span id="replyloginUserSpan" style="display:in-block">'  
		+ '    <strong><sec:authentication property="principal.username"/>님 작성</strong>'
		+ '</span>' ;
	</sec:authorize>
	strTxtBoxReply
		+='<textarea class="form-control txtBoxReply" name="rcontent" style="margin-bottom:10px;"'
		+ '		 placeholder="답글작성을 원하시면, &#10;답글 작성 버튼을 클릭해주세요."'
		+ '			></textarea>'
		+ '<button type="button" class="btn btn-warning btn-xs btnRegReply">답글 등록</button>'
		+ '<button type="button" class="btn btn-danger btn-xs btnCancelRegReply"'
		+ ' 	   style="margin-left:4px;">취소</button>';

	$(this).after(strTxtBoxReply);
	$(this).attr("style", "display:none;")
		
});

<%-- 답글 등록 취소 버튼 클릭 처리: 이벤트 전파 --%>
<%-- #chat > li:nth-child(1) > button.btn.btn-danger.btn-xs.btnCancelRegReply--%><%--
$(".btnCancelRegReply").on("click", function(){--%>
$("#chat").on("click", "li .btnCancelRegReply", function(){
	$(".btnRegReply").remove() ;
	$(".btnCancelRegReply").remove() ;
	$(".txtBoxReply").remove() ;
	$(".btnChgReplyReg").attr("style", "display: in-block;") ;
	$("#replyloginUserSpan").remove();

});


<%-- 답글 등록 버튼 클릭 처리: 이벤트 전파 
#chat > li:nth-child(1) > button.btn.btn-warning.btn-xs.btnRegReply  --%>
$("#chat").on("click", "li .btnRegReply", function(){
	
	var rcontent = $(this).prev().val() ;
//	var loginUser = "홍길동" ;
	var prno = $(this).closest("li").data("rno") ;
	
	var reply = {bno: bnoValue, rcontent: rcontent, rwriter: loginUser, prno:prno } ;
	
	myReplyClsr.registerReply(
			reply,
			function(result){
				alert(result + "번 답글이 등록되었습니다.") ;
				var pageNum = frmCmtPagingValue.find('input[name="pageNum"]').val() ;
				showCmtList(pageNum) ;
			}
	);
});

<%--댓글-답글 수정 초기화 --%>
function resetReplyModElements() {
	
	$("p").attr("style", "display:in-block;white-space:pre;") ;
	$(".btnModCmt").remove() ;
	$(".btnDelCmt").remove() ;
	$(".btnCancelCmt").remove() ;
	$(".txtBoxMod").remove() ;
}



<%-- 댓글/답글 수정: 글내용이 표시된 p를 클릭 시 입력창, 수정, 삭제, 취소 버튼 화면 표시,  --%>
<%-- #chat > li:nth-child(1) > div > p --%><%--
$(".rcontent-p").on("click", function(){  //동작하지 않음 --%>
$("#chat").on("click","li div p", function(){ <%-- 이벤트전파 --%>
<%-- textarea, 수정버튼, 삭제버튼, 취소버튼 표시
	 textarea에 기존 값이 표시되고, 수정거친 후 ajax로 전송
	 답글작성 버튼 감추기 --%>
	resetCmtRegElements() ;
	resetRelyRegElements() ;
	resetReplyModElements();
	
<%--로그인 하지 않은 경우--%>
	if(!loginUser) {
		alert("로그인 후 수정이 가능합니다.") ;
		return ;
	}
	
<%--로그인 계정과 작성자가 다른 경우--%>	
	var rwriter = $(this).closest("li").data("rwriter") ;
	
	if (loginUser != rwriter) {
		return ;
	}

	$(this).parents("li").find(".btnChgReplyReg").attr("style", "display:none") ;
	
	var rcontent = $(this).text() ;

	var strTxtBoxReply =
		  "<textarea class='form-control txtBoxMod' name='rcontent' style='margin-bottom:10px;'"
		+ "         ></textarea>"
		+ "<button type='button' class='btn btn-warning btn-sm btnModCmt'>수정</button> "
		+ "<button type='button' class='btn btn-danger btn-sm btnDelCmt'>삭제</button>"
		+ "<button type='button' class='btn btn-info btn-sm btnCancelCmt' style='margin-left: 4px;'>취소</button>";
	
	$(this).after(strTxtBoxReply) ;
	$(".txtBoxMod").val(rcontent);
	$(this).attr("style", "display:none");
	
<%--예, div#id1 > div#id2 > ul > li > p : $("p").closest("div") : div#id2--%>
<%--예, div#id1 > div#id2 > ul > li > p : $("p").parents() : div#id1, div#id2, ul, li--%>
<%--예, div#id1 > div#id2 > ul > li > p : $("p").parents("div") : div#id1, div#id2--%>
<%--예, div#id1 > div#id2 > ul > li > p : $("p").parent() : li--%>
<%--	
//	잘못된 코드: $(this).closest(button): 선택된 p를 기준으로 p의 조상들(부모 포함) 중에 가장 가까운 button 을 찾음
//	$(this).closest("button").attr("style", "display:none") ; 
--%>
}) ;

<%-- 댓글-답글 수정 취소 --%>
<%-- #chat > li:nth-child(1) > div > button.btn.btn-info.btn-sm.btnCancelCmt --%>
$("#chat").on("click","li div button.btnCancelCmt", function(){

	<%--서버로 요청이 전달됨--%><%--
	var _pageNum = frmCmtPagingValue.find("input[name='pageNum']").val() ;
	showCmtList(_pageNum) ; --%>
	
	<%--브라우저에서 처리(서버 요청 없음)--%>
	$(this).parents("li").find("button.btnChgReplyReg").attr("style","in-block" );
	$(this).parents("li").find("p").attr("style", "display:in-block;white-space:pre-wrap;") ;
	$(this).siblings(".btnModCmt").remove();
	$(this).siblings(".btnDelCmt").remove();
	$(this).siblings(".txtBoxMod").remove();
	$(this).remove() ;

});


<%-- 댓글-답글 수정 --%>
<%-- #chat > li:nth-child(1) > div > button.btn.btn-warning.btn-sm.btnModCmt --%>
$("#chat").on("click", "li div button.btnModCmt", function(){
	
	var rcontent = $(this).prev().val() ;
	var rno = $(this).siblings("p").data("rno") ;
	var rwriter = $(this).parents("li").data("rwriter") ;
	
	var cmtReply = {bno: bnoValue, rno: rno, rcontent: rcontent, rwriter: rwriter} ;
	            
	myReplyClsr.modifyCmtReply(
			cmtReply,
			function(result){
				alert("댓글(답글)이 수정되었습니다.") ;
				var _pageNum = frmCmtPagingValue.find("input[name='pageNum']").val() ;
				showCmtList(_pageNum) ;
			}
	
	);
});

	
<%-- 댓글-답글 삭제 --%>
<%-- #chat > li:nth-child(1) > div > button.btn.btn-danger.btn-sm.btnDelCmt --%>
$("#chat").on("click","li div button.btnDelCmt", function(){
	if(!confirm("삭제하시겠습니까?")){
		return ;
	}
<%--	
	var rno = $(this).parents("li.commentLi").data("rno"); --%>
	var rno = $(this).closest("li.commentLi").data("rno") ;
	var rwriter = $(this).parents("li.commentLi").data("rwriter") ;
	
	var myReplyCmt ={bno: bnoValue, rno: rno, rwriter: rwriter} ;
	
	myReplyClsr.removeCmtReply(
			myReplyCmt,
			function(){
				alert("글이 삭제되었습니다.") ;
				
				var _pageNum = frmCmtPagingValue.find("input[name='pageNum']").val() ;
				showCmtList(_pageNum) ;
			}
	);
	
});

</script>


<script>
$(document).ready(function(){
	runModal(result) ;
	
	window.addEventListener("popstate", function (event) {
		history.pushState(null, null, location.href) ;
	}) ;
	
	history.pushState(null, null, location.href) ;

	showCmtList(1) ;<%--댓글-답글 표시 --%>
});
</script>

<%@include file="../myinclude/myfooter.jsp" %>   

<%-- 
//$(".btnModCmt").remove() ;
//$(".btnDelCmt").remove() ;
//$(".btnCancelCmt").remove() ;
//$(".txtBoxMod").remove() ; --%>


<%-- mycomment.js 클로저 메서드 테스트 코드 --%>
<%--

console.log(myReplyClsr.myDateTimeFmt(1636701192000));

//229374
myReplyClsr.removeAllReply(
		229374 ,
		function (result){
			console.log(result) ;
		}
);


myReplyClsr.removeCmtReply(
	{bno: bnoValue, rno: 144} ,
	function(result) {
		console.log(result) ;
	}
);


myReplyClsr.modifyCmtReply(
		{bno: bnoValue, rno: 1, rcontent:"JS클로저댓글답글수정---"} ,
		function(result) {
			console.log(result) ;
		}
);



myReplyClsr.getCmtReply(
	{bno: bnoValue, rno: 1} ,
	function (reply) {
		console.log(reply) ;
	}
);


myReplyClsr.registerReply(
		{bno: bnoValue, rcontent: "JS댓글등록1", rwriter: "user7", prno: 1} ,
		function(result) {
			console.log("서버등록 결과: " + result) ;
		}
	);
	

myReplyClsr.registerCmt(
	{bno: 229374, rcontent: "JS댓글등록2", rwriter: "user8"} ,
	function(result) {
		console.log("서버등록 결과: " + result) ;
	}
);



//댓글 목록 클로저 처리 테스트
myReplyClsr.getCmtList(
		{bno: bnoValue} ,
		function(myReplayPagingCreator){
			console.log(myReplayPagingCreator.replyTotCnt);
			for(var reply of myReplayPagingCreator.myreplyList) {
				console.log(reply) ;
				console.log(reply.rregDate);
			}
			
		}
);
--%>