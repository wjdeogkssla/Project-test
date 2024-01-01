<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   

<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<%@include file="../myinclude/myheader.jsp" %>

<style>
/*th {text-align: center;}*/
</style>

<div id="page-wrapper">
    <div class="row">
        <div class="col-lg-12">
            <h3 class="page-header">Board - List</h3>
        </div><%-- /.col-lg-12 --%>
    </div><%-- /.row --%>
    <div class="row">
        <div class="col-lg-12">
        
            <div class="panel panel-default">
                <div class="panel-heading">
					<div class="row">
						<div class="col-md-6" style="font-size:20px; height: 45px; padding-top:10px;">게시글 목록</div>
						<div class="col-md-6" style="padding-top:8px;">
							<button type="button" id="btnToRegister" class="btn btn-primary btn-sm pull-right">새글 등록</button>
						</div>
					</div>
				</div><%-- /.panel-heading --%>
   
<form class="form-inline" id="frmSendValue" action="${contextPath }/myboard/list" method="get" name="frmSendValue">
	<div class="form-group">
	     <label class="sr-only">frmSendValues</label>
	     <select class="form-control" id="selectAmount" name="rowAmountPerPage">
	        <option value="10" ${(pagingCreator.myboardPaging.rowAmountPerPage == 10) ? "selected" : "" }>10개</option>
	        <option value="20" ${(pagingCreator.myboardPaging.rowAmountPerPage == 20) ? "selected" : "" }>20개</option>
	        <option value="50" ${(pagingCreator.myboardPaging.rowAmountPerPage == 50) ? "selected" : "" }>50개</option>
	        <option value="100" ${(pagingCreator.myboardPaging.rowAmountPerPage == 100) ? "selected" : "" }>100개</option>
	     </select>
	     
	     <select class="form-control" id="selectScope" name="scope">
	     	<option value="" ${(pagingCreator.myboardPaging.scope == null) ? "selected" : "" }>범위선택</option>
	     	<option value="T" ${(pagingCreator.myboardPaging.scope == "T") ? "selected" : "" }>제목</option>
	     	<option value="C" ${(pagingCreator.myboardPaging.scope == "C") ? "selected" : "" }>내용</option>
	     	<option value="W" ${(pagingCreator.myboardPaging.scope == "W") ? "selected" : "" }>작성자</option>
	     	<option value="TC" ${(pagingCreator.myboardPaging.scope == "TC") ? "selected" : "" }>제목+내용</option>
	     	<option value="TCW" ${(pagingCreator.myboardPaging.scope == "TCW") ? "selected" : "" }>제목+내용+작성자</option>
	     </select>
	    
	  <div class="input-group"><!-- 검색어 입력 -->
         <input class="form-control" id="keyword" name="keyword" type="text" placeholder="검색어를 입력하세요"
               value='<c:out value="${pagingCreator.myboardPaging.keyword}" />' />
         <span class="input-group-btn"><!-- 전송버튼 -->
            <button class="btn btn-warning" type="button" id="btnSearchGo"
            			>검색 &nbsp;<i class="fa fa-search"></i>
            </button>
         </span>
      </div>
      
      <div class="input-group"><!-- 검색 초기화 버튼 -->
         <button id="btnReset" class="btn btn-info" type="button">검색초기화
         	<span class="glyphicon glyphicon-remove"></span>
         </button>
      </div> 
   </div>
		
	<div class="form-group pull-left">
		<input class="form-control" id="beginDate" name="beginDate" type="date"
			   value="${pagingCreator.myboardPaging.beginDate}" 
			   />
		<input class="form-control" id="endDate" name="endDate" type="date"
			   value="${pagingCreator.myboardPaging.endDate}" 
			   />

		<button type="button" class="btn btn-primary mybtns" 
				id="btnIntervalSearch" >기간검색</button>
	</div> 
	
	<input type="hidden" id="pageNum" name="pageNum" value="${pagingCreator.myboardPaging.pageNum }" ><%-- 
	<input type="hidden" id="rowAmountPerPage" name="rowAmountPerPage" value="${pagingCreator.myboardPaging.rowAmountPerPage }" > --%>
	<input type="hidden" id="lastPageNum" name="lastPageNum" value="${pagingCreator.lastPageNum }" >
	
</form>     
                
                <div class="panel-body">
                    <table class="table table-striped table-bordered table-hover" 
                           style="width:100%;text-align: center;">
                        <thead>
                            <tr>
                                <th>글번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>수정일</th>
                                <th>조회수</th>
                            </tr>
                        </thead>
                        <tbody>

<c:choose>
<c:when test="${not empty pagingCreator.myboardList }">
	<c:forEach var="myboard" items="${pagingCreator.myboardList}">
		<c:choose>
			<c:when test="${myboard.bdelFlag == 1 }">
				<tr style="background-color: Moccasin; text-align: center">
             		<td>${myboard.bno }</td>
             		<td colspan="6"><em>작성자에 의해서 삭제된 게시글입니다.</em></td>
         		</tr>
			</c:when>
			<c:otherwise>
				<tr class="moveDetail" data-bno="${myboard.bno }">
					<td><c:out value="${myboard.bno }"/></td><%-- 
					<td style="text-align: left"><a href="${contextPath }/myboard/detail?bno=${myboard.bno}" ><c:out value="${myboard.btitle }"/></a></td> --%>
					<td style="text-align: left">
						<c:out value="${myboard.btitle }"/>
						<small>[댓글수: <strong><c:out value="${myboard.breplyCnt}"/></strong>]</small>	
					</td>
					<td>${myboard.bwriter }</td>
					<td class="center"><fmt:formatDate value="${myboard.bregDate }" pattern="yyyy/MM/dd HH:mm:ss"/></td>
					<td class="center"><fmt:formatDate value="${myboard.bmodDate }" pattern="yyyy/MM/dd HH:mm:ss"/></td>
					<td class="center"><c:out value="${myboard.bviewsCnt }"/></td>
		 		</tr>
			</c:otherwise>		
		</c:choose>			
	</c:forEach>
</c:when>
<c:otherwise>
		<tr class="odd gradeX">
			<td colspan="6">등록된 게시물이 없습니다.</td>
		 </tr>
</c:otherwise>
</c:choose>                                     
                     
                            
                        </tbody>
                    </table><%-- /.table-responsive --%>

<div style="text-align: center;">
	<ul class="pagination pagination-sm" >
		<c:if test="${pagingCreator.prev }">
			<li class="pagination-button">
				<a href="1" aria-label="Previous">
					<span aria-hidden="true">&laquo</span>
				</a>
			</li>
		</c:if>
		<c:if test="${pagingCreator.prev }">
			<li class="pagination-button">
				<a href="${pagingCreator.startPagingNum - 1 }" aria-label="Previous">
					<span aria-hidden="true">이전</span>
				</a>
			</li>
		</c:if>
		<c:forEach begin="${pagingCreator.startPagingNum }" 
		           end="${pagingCreator.endPagingNum }" 
		           var="pagingNum">
			
			<li class='pagination-button ${(pagingNum == pagingCreator.myboardPaging.pageNum) ? "active" : ""}'>
				<a href="${pagingNum }">${pagingNum }</a>
			</li>     
		</c:forEach>
		<c:if test="${pagingCreator.next }">
			<li class="pagination-button">
				<a href="${pagingCreator.endPagingNum + 1 }" aria-label="Next">
					<span aria-hidden="true">다음</span>
				</a>
			</li>
		</c:if>
		<c:if test="${pagingCreator.next }">
			<li class="pagination-button">
				<a href="${pagingCreator.lastPageNum }" aria-label="Next">
					<span aria-hidden="true">&raquo</span>
				</a>
			</li>
		</c:if>
		
	  
	</ul>
</div>

                    
                </div><%-- /.panel-body --%>
                
            </div><%-- /.panel --%>
        </div><%-- /.col-lg-12 --%>
    </div><%-- /.row --%>
    
    

  

</div><%-- /#page-wrapper --%>

     
<%-- Modal 모달 시작 --%>
<div class="modal fade" id="yourModal" tabindex="-1" role="dialog" aria-labelledby="yourModalLabel" aria-hidden="true">
 <div class="modal-dialog">
 <div class="modal-content">
 <div class="modal-header">
 <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
 <h4 class="modal-title" id="yourModalLabel">처리결과</h4>
 </div>
 <div class="modal-body" id="yourModal-body">메시지</div>
 	
 <div class="modal-footer">
 <button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
 </div>
</div><%-- END .modal-content --%>
</div><%-- END .modal-dialog --%>
</div><%-- END .modal --%>  
       
                
        
<script>

var frmSendValue = $("#frmSendValue") ;       
var result = '<c:out value="${result}" />' ; 
//alert("length(result): " + result.length);


//등록페이지 이동
$("#btnToRegister").on("click",function(){
	window.location.href = "${contextPath}/myboard/register" ; //권장
//	location.href = "${contextPath}/myboard/register" ;
//	self.location.href = "${contextPath}/myboard/register" ;
//	self.location = "${contextPath}/myboard/register" ;	
});

//상세페이지 이동
$(".moveDetail").on("click", function() {
	var bno = $(this).data("bno") ;
	
//	window.location.href = "${contextPath}/myboard/detail?bno=" + bno ;
		
	frmSendValue.append("<input type='hidden' name='bno' value=' " + bno + " '/>");
	frmSendValue.attr("action", "${contextPath}/myboard/detail").attr("method", "get");
	frmSendValue.submit();
	frmSendValue.find('input[name="bno"]').remove(); //웹 브라우저 뒤로가기 후, 다른 게시물 상세 이동
	                                                 //bno값이 계속 url에 추가되어 현상 해결
	
});

//모달 호출 함수
function runModal(result) {
	
	if (result.length == 0 ){
		return ;
		
	} else if (result == "successRemove"){
		var myMsg = "게시글이 삭제되었습니다." ;
		
	} else if (parseInt(result) > 0 ){
		var myMsg = result + "번 게시물이 등록되었습니다." ; 
		
	}
	
	//$(".modal-body").html(myMsg) ;
	$("#yourModal-body").html(myMsg) ;
	$("#yourModal").modal("show");
	
	myMsg = "";	
	
}

<%-- 페이지징 처리: 검색 목록 페이지 이동 --%>
$("li.pagination-button a").on("click", function(e){
	e.preventDefault();
	
	frmSendValue.find("input[name='pageNum']").val($(this).attr("href")) ;
	console.log(frmSendValue.find("input[name='pageNum']").val());
	frmSendValue.attr("action", "${contextPath}/myboard/list")
	frmSendValue.attr("method", "get");
	
	frmSendValue.submit();
	
});

<%--검색 관련 요소의 이벤트 처리--%>
<%-- 표시 행수 선택 이벤트 처리 --%>
$("#selectAmount").on("change", function() {
	frmSendValue.find("input[name='pageNum']").val(1);
	frmSendValue.submit();
});

<%--키워드 검색버튼 클릭 이벤트 처리 --%>
$("#btnSearchGo").on("click", function() {
	
	var scope = $("#selectScope").find("option:selected").val();
	
	if(!scope || scope == '' ){
		alert("검색범위를 선택해주세요.");
		return false;
	}
	
	var keyword = $("#keyword").val() ;
	
	if(!keyword || keyword.length == 0){
		alert("검색어를 입력해주세요.");
		return ;		
	}
	
	frmSendValue.find("input[name='pageNum']").val(1);
	frmSendValue.submit();
});



$("#selectScope").on("change", function() {
	$("#pageNum").val(1);
	frmSendValue.submit();
	//frmSendValue.find("input[name='pageNum']").val(1);
});


<%--기간 검색버튼 클릭 이벤트 처리 --%>
$("#btnIntervalSearch").on("click", function(){
	
	var beginDate = $("#beginDate").val() ;
	var endDate = $("#endDate").val() ;
	
//	alert("변환전 endDate: " + endDate);
	
	if (!beginDate || beginDate == "" || !endDate || endDate == "") {
		alert("시작날짜와 끝날짜를 모두 선택하세요") ;
		return ;
	}
/*	
	if (beginDate == endDate) {
		var _endDate = new Date(endDate) ;
		
		_endDate.setDate(_endDate.getDate() + 1) ; //하루 후의 날짜
		
		_endDate = _endDate.toISOString().slice(0, 10) ;

		$("#endDate").val(_endDate);
		
		endDate = $("#endDate").val() ;
		alert("변환후 endDate: " + endDate);
	}
*/	
	frmSendValue.find("input[name='pageNum']").val(1) ;
	frmSendValue.submit() ;
	
});


$(document).ready(function(){
	runModal(result) ;
});

	window.addEventListener("popstate", function(event){
		history.pushState(null, null, location.href);
				
	});

	history.pushState(null, null, location.href);


</script>
        
        

<%@include file="../myinclude/myfooter.jsp" %>












