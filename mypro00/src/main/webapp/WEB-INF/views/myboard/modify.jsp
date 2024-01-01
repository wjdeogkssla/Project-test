<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>   

<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<%@include file="../myinclude/myheader.jsp" %>

<style>
/*th {text-align: center;}*/
</style>

<div id="page-wrapper"> 
    <div class="row">
        <div class="col-lg-12">
            <h3 class="page-header">Board - Modify</h3>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
            
                <div class="panel-heading"><h4>게시물 수정 삭제 </h4></div>
                <!-- /.panel-heading -->
                             
                <div class="panel-body">

<form role="form" method="post" name="frmModify" id="frmModify">
    
	<div class="form-group">
	    <label>글번호</label>
	    <input class="form-control" name="bno" id="bno"
	           value='<c:out value="${myboard.bno }"/>' readonly="readonly" />
	</div>
	<div class="form-group">
	    <label>글제목</label>
	    <input class="form-control" name="btitle" id="btitle"
	           value="${myboard.btitle }" />
	</div>
	<div class="form-group">
        <label>글내용</label>
	    <textarea class="form-control" rows="3" name="bcontent" id="bcontent"
	    				>${myboard.bcontent}</textarea>
    </div>
    <div class="form-group">
	    <label>작성자</label>
	    <input class="form-control" name="bwriter" id="bwriter" 
	           value="${myboard.bwriter }" readonly="readonly" />
	</div>
	    <div class="form-group">
	    <label>최종수정일</label> [등록일시: <fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${myboard.bmodDate}"/>]
	   	<input class="form-control" name="bmodDate" id="bmodDate" 
	           value='<fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${myboard.bmodDate }"/>' 
	           disabled="disabled" />  <!-- yyyy-MM-dd로 변경 readonly="readonly -->
			
	</div> 
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="username"/>
	<c:if test="${username == myboard.bwriter }">
		<button type="button" class="btn btn-primary mybtns" id="btnModify" data-oper="modify">수정</button>
		<button type="button" class="btn btn-primary mybtns" id="btnRemove" data-oper="remove">삭제</button>
	</c:if>
</sec:authorize>	

	<button type="button" class="btn btn-warning mybtns" id="btnList" data-oper="list">취소</button>
	
	<input type="hidden"  id="pageNum" name="pageNum" value="${myBoardPagingDTO.pageNum }">
	<input type="hidden" id="rowAmountPerPage" name="rowAmountPerPage" value="${myBoardPagingDTO.rowAmountPerPage }">
	<input type="hidden" id="scope" name="scope" value="${myBoardPagingDTO.scope}">
	<input type="hidden" id="keyword" name="keyword" value="${myBoardPagingDTO.keyword}">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form>

                </div><!-- /.panel-body -->
            </div><!-- /.panel -->
        </div><!-- /.col-lg-12 -->
    </div><!-- /.row -->
    
    
<%-- 첨부파일 결과 표시 --%>
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">파일첨부</div><!-- /.panel-heading -->
                <div class="panel-body">
<sec:authorize access="isAuthenticated()">
<sec:authentication property="principal.username" var="username"/>
<c:if test="${username == myboard.bwriter }">
                  <div class="form-group uploadDiv">
                      <input id="inputFile" class="btn btn-primary inputFile" type="file" name="uploadFiles" multiple="multiple" /><br>
               	  </div>
</c:if>
</sec:authorize>
	              <div class="form-group fileUploadResult">
	                  <ul>
	                      <%-- 업로드 후 처리결과가 표시될 영역 --%>
	                  </ul>
	              </div>
                </div><!-- /.panel-body -->
            </div><!-- /.panel -->
        </div><!-- /.col-lg-12 -->
    </div><!-- /.row -->   
    
</div><!-- /#page-wrapper --> 
      
<script>

var myCsrfHeaderName = "${_csrf.headerName}" ;
var myCsrfToken = "${_csrf.token}" ;

<%--
$(document).ajaxSend(function(e, xhr){
   xhr.setRequestHeader(myCsrfHeaderName, myCsrfToken) ;
       
});
--%>

var frmModify = $("#frmModify");
 
var loginUser = "";

<sec:authorize access="isAuthenticated()">
	loginUser = '<sec:authentication property="principal.username"/>' ;
</sec:authorize> 
	
<%-- 수정된 게시물 입력값 유무 확인 함수 --%>
 function checkBoardValues() {
 	
     var btitle = document.getElementById("btitle").value ;
     var bcontent = document.getElementById("bcontent").value ;

     if (btitle.length == 0 || bcontent.length == 0) {
         return false ;
         
     } else {   	
     	return true ; 	
     }      
 }
 
$(".mybtns").on("click", function(){
	
		if (!checkBoardValues()){
			alert("글제목/글내용을 모두 입력해야 합니다.") ;
			return ;
		}
		
		var operation = $(this).data("oper") ;
		//alert("operation: " + operation) ;
		
		var bwriter = '<c:out value="${myboard.bwriter}" />';
		
		if (operation == "modify") {
			
			if(!loginUser || bwriter != loginUser){
				alert("글 작성자만 수정이 가능합니다.");			
				return ;
			}
				
			var emptyLi = $(".fileUploadResult ul li") ;
			
			if(emptyLi.data("filename") == undefined){
				emptyLi.remove() ;	
		}
		
		var attachFileInputHTML = "";
		
		<%-- li요소의 값들을 읽어와서 hidden input을 생성하는 텍스트를 만드는 함수 --%>
		<%--div.form-group.fileUploadResult > ul > li:nth-child(1) --%>
		$("div.fileUploadResult ul li").each(function(i, obj){

			var objLi = $(obj) ; 
			//alert(objLi);
			if(objLi == null){
				return ;
			}

			attachFileInputHTML
			    +="<input type='hidden' name='attachFileList[" + i + "].uuid' value='" + objLi.data("uuid") + "'>" 
		        + "<input type='hidden' name='attachFileList[" + i + "].uploadPath' value='" + objLi.data("uploadpath") + "'>" 
		        + "<input type='hidden' name='attachFileList[" + i + "].fileName' value='" + objLi.data("filename") + "'>" 
			    + "<input type='hidden' name='attachFileList[" + i + "].fileType' value='" + objLi.data("filetype") + "'>" ;
			    
		}); //each-end
				
		if (attachFileInputHTML != ""){
			frmModify.append(attachFileInputHTML);
		}
		
			frmModify.attr("action", "${contextPath}/myboard/modify") ;
		
		} else if (operation == "remove"){
			
			if(!loginUser || bwriter != loginUser){
//				alert("글 작성자인 경우에만 삭제가 가능합니다.");			
				return ;
			}
			
			frmModify.attr("action", "${contextPath}/myboard/remove") ;
		
		} else {  //else if (operation == "list"){
			
			var pageNumInput = $("#pageNum").clone() ;
			var rowAmountPerPageInput = $("input[name='rowAmountPerPage']").clone() ;
			var scopeInput = $("#scope").clone() ;
			var keywordInput = $("#keyword").clone() ;
			
			frmModify.empty() ;
			
			frmModify.append(pageNumInput) ;
			frmModify.append(rowAmountPerPageInput) ;
			frmModify.append(scopeInput) ;
			frmModify.append(keywordInput) ;
			
			
			frmModify.attr("action", "${contextPath}/myboard/list").attr("method", "get") ; 
		}
		
		frmModify.submit() ;
	});
</script>


<script> 
<%-- <<<<첨부파일 관련 코드>>>> --%>

var bno = '<c:out value="${myboard.bno }"/>' ; 

<%-- 수정페이지의 게시물 표시 후, ajax로 첨부파일 정보를 가져오는 함수를 작성 --%>
function getAttachFileInfo(){
   
   $.ajax({
      
      type:"get" ,
      url: "${contextPath}/myboard/getFiles" ,
      data: {bno: bno} ,
      dataType: "json" ,
      beforeSend: function(xhr){
    		xhr.setRequestHeader(myCsrfHeaderName, myCsrfToken);  
      },
      success: function(uploadResult){
         showUploadResult(uploadResult) ;
      }
   }); <%--ajax-end--%>
   
}<%--getAttachFileInfo-end--%>


function showUploadResult(uploadResult){
 	
	var fileUploadResult = $(".fileUploadResult ul");
	
	var htmlStr = "";
	
 	if(!uploadResult || uploadResult.length == 0){
 			
 		htmlStr +="<li style='font-size: 12pt;'>첨부파일이 없습니다</li>"
 		
 	} else {
 		
		$(uploadResult).each(function(i, attachFile){
			
			var fullFileName = encodeURI(attachFile.repoPath + "/" + 
					                     attachFile.uploadPath + "/" + 
										 attachFile.uuid + "_" +
										 attachFile.fileName);
			
		    if(attachFile.fileType == "F") {
		    	htmlStr 
		    		+= "<li data-uploadpath='" + attachFile.uploadPath + "'"
		    		+  "    data-uuid='" + attachFile.uuid + "'"
		    		+  "    data-filename='" + attachFile.fileName + "'"
		    		+  "    data-filetype='F'>"
			    	+  "          <img src='${contextPath}/resources/img/icon-attach.png' style='width:25px;' >"
			    	+  "          &nbsp;&nbsp;" + attachFile.fileName ;
<sec:authorize access="isAuthenticated()">
<sec:authentication property="principal.username" var="username"/>
<c:if test="${username == myboard.bwriter }">			    	
				htmlStr 
			    	+=  "  <button type='button' class='btn btn-danger btn-xs' data-filename='" + fullFileName + "' data-filetype='F'>X</button>"
</c:if>
</sec:authorize>		
			    	+  " </li>" ;
		    	
		    } else { //else if(attachFile.fileType == "I") {
		    	
		    	var thumbnail = encodeURI(attachFile.repoPath + "/" + 
	                    				  attachFile.uploadPath + "/s_" + 
						 				  attachFile.uuid + "_" +
						 				  attachFile.fileName) ;
		    	
		    
		    	htmlStr 
		    	+= "<li data-uploadpath='" + attachFile.uploadPath + "'"
		    	+  "    data-uuid='" + attachFile.uuid + "'"
		    	+  "    data-filename='" + attachFile.fileName + "'"
		    	+  "    data-filetype='I'>"
		    	+  "          <img src='${contextPath}/displayThumbnail?fileName=" + thumbnail + "'>"
		    	+  "          &nbsp;&nbsp;" +  attachFile.fileName ;
<sec:authorize access="isAuthenticated()">
<sec:authentication property="principal.username" var="username"/>
<c:if test="${username == myboard.bwriter }">			    	
  					htmlStr      	
				+=  "  <button type='button' class='btn btn-danger btn-xs' data-filename='" + thumbnail + "' data-filetype='I'>X</button>"
</c:if>
</sec:authorize>	
				+  "</li>" ;
		    	
		    }
		    
		}); <%--foreach- end--%>
 	 
 	}
		
 	fileUploadResult.append(htmlStr); 
 }
 	
<%-- 업로드 파일에 대한 확장자 크기 제한 --%> 
function checkUploadFile(fileName, fileSize) {
		
		var allowedMaxSize = 104857600;

	 	  var regExpForbiddenFileExtension = /((\.(exe|dll|sh|c|zip|alz|tar)$)|^[^.]+$|(^\..{1,}$))/i ;
		//파일이름.확장자(image.jpg)
		
		if(fileSize > allowedMaxSize){
			alert("업로드 파일이 제한된 크기(1MB)를 초과했습니다.");
			return false ;
		}
		//확장자 검사
		if(regExpForbiddenFileExtension.test(fileName)){
			alert("확장명이 없거나 [exe,dll,sh,c,zip,tar] 형식 파일들은\n업로드 할 수 없습니다.");
			return false;
		}
		

		return true;
	}
 	
<%-- 업로드 처리 --%>
<%-- 파일 업로드 처리: 파일 input 요소의 "내용이 바뀌면" 업로드가 수행되도록 수정 --%>	
$("#inputFile").on("change", function(){
	
	var emptyLi = $(".fileUploadResult ul li") ;
	
	if(emptyLi.data("filename") == undefined){
		//$(".fileUploadResult ul li").remove() ;
		emptyLi.remove() ;
	
	}
	
	//FormData() Ajax 파일 전송 시에 사용되는 Web API 클래스의 생성자
	var formData = new FormData() ;

	//name 속성값이 uploadFiles 인 모든 input 요소를 변수에 저장
	var fileInputs = $("input[name='uploadFiles']") ; 

	//fileInpits 변수에 여러개의 input이 대입된 경우
	var yourFiles = fileInputs[0].files ;
	
	console.log(yourFiles) ;
	
	if(yourFiles == null || yourFiles.length == 0) {
		alert("파일을 선택하세요");
		return ;
	}


	<%--FormData() 객체에 input의 파일을 모두 저장함--%>
	for(var i = 0 ; i < yourFiles.length ; i++) {
		
		<%--업로드 파일의 파일 크기/확장자 제한 검사--%>
		if(!checkUploadFile(yourFiles[i].name, yourFiles[i].size)){
			console.log("파일이름: " + yourFiles[i].name) ;
			console.log("파일크기: " + yourFiles[i].size) ;
			return ;
		}
		
		formData.append("yourUploadFiles", yourFiles[i])
		
	}


<%--FormData() 객체(formData)를 서버로 전송(By Ajax)
	url 키에 명시된 주소의 컨트롤러에게 formData 객체를 POST 방식으로 전송.--%>
	$.ajax({
		type: "post" ,
		url: "${contextPath}/fileUploadAjaxAction" ,
		data: formData ,
		contentType: false , <%--contentType에 MIME 타입을 지정하지 않음.--%>
		processData: false , <%--contentType에 설정된 형식으로 data를 처리하지 않음. --%>
		dataType: "json" ,
	    beforeSend: function(xhr){
	    		xhr.setRequestHeader(myCsrfHeaderName, myCsrfToken);  
	     },
		success: function(uploadResult, status){
			
<%--		//복사된 file-input을 삽입하는 경우, 첨부파일 삭제/추가 시에는, 초기화 되지 않음.
			$(".uploadDiv").html(cloneFileInput.html()) ;
--%>			
			$(".inputFile").val("") ;
			
			showUploadResult(uploadResult);
		}
	});
	
}) ;
 
<%-- 업로드 파일 삭제: 취소 기능을 고려해서 화면의 삭제를 클릭 시에는 화면의 항목만 삭제되도록 수정 --%>
<%-- body > div.fileUploadResult > ul > li:nth-child(3) > span --%>
$(".fileUploadResult ul").on("click", "li button", function(e){
	
	var parentLi = $(this).parent() ; 
<%--
	var parentLi = $(this).closest("li") ;
--%>	
	if(confirm("이 파일을 삭제하시겠습니까? ") ) {
		parentLi.remove() ; 
		alert("파일이 삭제되었습니다.");
	}
	
});

$(document).ready(function(){
	   
	   getAttachFileInfo() ;
	   
}) ;
  
</script>

<%@include file="../myinclude/myfooter.jsp" %>

