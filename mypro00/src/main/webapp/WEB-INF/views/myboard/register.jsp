<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<%@include file="../myinclude/myheader.jsp" %>

<style>
/*th {text-align: center;}*/
</style>

<div id="page-wrapper"> 
    <div class="row">
        <div class="col-lg-12">
            <h3 class="page-header">Board - Register</h3>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
            
                <div class="panel-heading"><h4>게시물 등록</h4></div>
                <!-- /.panel-heading -->
                             
                <div class="panel-body">


<form role="form" action="${contextPath }/myboard/register" 
      method="post" name="frmBoard" id="frmBoard">
	<div class="form-group">
	    <label>글제목</label>
	    <input class="form-control" name="btitle" id="btitle" placeholder="제목을 입력하세요.">
	</div>
	<div class="form-group">
        <label>글내용</label>
        <textarea class="form-control" rows="3" name="bcontent" id="bcontent" placeholder="내용을 입력하세요."></textarea>
    </div>
    <div class="form-group">
	    <label>작성자</label><!-- 
	    <input class="form-control" name="bwriter" id="bwriter" placeholder="작성자를 입력하세요."> -->
	    <input class="form-control" name="bwriter" id="bwriter" readonly="readonly" 
	           value='<sec:authentication property="principal.username"/>' />
	</div>
	<!-- 
	<button type="button" class="btn btn-primary" onclick="sendBoard();" id="btnRegister">등록</button> -->
	<button type="button" class="btn btn-primary" id="btnRegister">등록</button>
	<button type="button" class="btn btn-warning"
			onclick="location.href='${contextPath}/myboard/list';">취소</button>
	<%-- 		
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" /> --%>
	<sec:csrfInput/>
    
</form>

	</div>
	</div>
    
<%-- 첨부파일 결과 표시 --%>
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">파일첨부</div><!-- /.panel-heading -->
                <div class="panel-body">
                  <div class="form-group uploadDiv">
                      <input id="inputFile" class="btn btn-primary inputFile" type="file" name="uploadFiles" multiple="multiple" /><br>
               	  </div>
	              <div class="form-group fileUploadResult">
	                  <ul>
	                      <%-- 업로드 후 처리결과가 표시될 영역 --%>
	                  </ul>
	              </div>
                </div><!-- /.panel-body -->
            </div><!-- /.panel -->
        </div><!-- /.col-lg-12 -->
    </div><!-- /.row -->
    
</div>
        <!-- /#page-wrapper -->

<script>


//수정된 게시물 입력값 유무 확인 함수
function checkBoardValues() {
	
    var btitle = document.getElementById("btitle").value ;
    var bcontent = document.getElementById("bcontent").value ;
    var bwriter = document.getElementById("bwriter").value ;

    if (btitle.length == 0 || bcontent.length == 0 || bwriter.length == 0) {
        return false ;
        
    } else {   	
    	return true ; 	
    }      
}

$("#btnRegister").on("click", function() {
	
	if (!checkBoardValues()){
		alert("글제목/내용/작성자을 모두 입력하세요.") ;
		return ;
	}
	
//	var frmBoard = document.getElementById("frmBoard") ; //제이쿼리 append() 동작안됨
	var frmBoard = $("#frmBoard") ;
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
	
//	alert("attachFileInputHTML: " +  attachFileInputHTML);
	
	if (attachFileInputHTML != ""){
		frmBoard.append(attachFileInputHTML);
	}
	
	frmBoard.submit();
	
});

</script>
<%-- <<<<<<<첨부파일 관련 코드 >>>>>>>--%>
<script>
//input 초기화를 위해 div 요소의 비어있는 input 요소를 복사해서 저장함.
//var cloneFileInput = $(".uploadDiv").clone(); //clone(): 선택된 요소의 자식요소가 복사됨
<%-- 업로드 파일에 대한 확장자 및 크기 제한 --%>
function checkUploadFile(fileName, fileSize) {
	
	var allowedMaxSize = 104857600;
	
	//var regExpForbiddenFileExtension = /[.]{0}((\.)(exe|dll|sh|c|zip|alz|tar))?/i ;
	//var regExpForbiddenFileExtension = /^.*(\.)(exe|dll|sh|c|zip|alz|tar)$/i
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

var bnoValue = '<c:out value="${myboard.bno}"/>';

function showUploadResult(uploadResult){
	
	if(!uploadResult || uploadResult.length == 0){
		return ; 
	}
	
	var fileUploadResult = $(".fileUploadResult ul");
	var htmlStr = "";

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
//	    		+  "      <a href='${contextPath}/fileDownloadAjax?fileName=" + fullFileName + "'>"
		    	+  "          <img src='${contextPath}/resources/img/icon-attach.png' style='width:25px;' >"
		    	+  "          &nbsp;&nbsp;" + attachFile.fileName 
//		    	+  "      </a>"
		    	+  "  <span data-filename='" + fullFileName + "' data-filetype='F'>[삭제]</span>"
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
//	    	+  "      <a href='${contextPath}/fileDownloadAjax?fileName=" + fullFileName + "'>" //다운로드
//	    	+  "      <a href=\"javascript:showImage('" + fullFileName + "')\">"
	    	+  "          <img src='${contextPath}/displayThumbnail?fileName=" + thumbnail + "'>"
	    	+  "          &nbsp;&nbsp;" +  attachFile.fileName 
//	    	+  "      </a>"
	    	+  "  <span data-filename='" + thumbnail + "' data-filetype='I'>[삭제]</span>"
	    	+  "</li>" ;
	    	
	    }
	    
	}); <%--foreach- end--%>
	
//	fileUploadResult.html(htmlStr); 
	fileUploadResult.append(htmlStr); 
}

var myCsrfHeaderName = "${_csrf.headerName}" ;
var myCsrfToken = "${_csrf.token}" ;

<%-- 업로드 처리 --%>
<%-- 파일 업로드 처리: 파일 input 요소의 "내용이 바뀌면" 업로드가 수행되도록 수정 --%>
$("#inputFile").on("change", function(){
	//FormData() Ajax 파일 전송 시에 사용되는 Web API 클래스의 생성자
	var formData = new FormData() ;

	//name 속성값이 uploadFiles 인 모든 input 요소를 변수에 저장
	var fileInputs = $("input[name='uploadFiles']") ; 

	//fileInputs 변수에 대입된 input들에 저장된 파일들을 yourFiles 변수에 저장.
	//file 타입의 input 요소에는 files 속성에 파일이 저장됩니다.
	//fileInputs[0]은 첫번쨰 input 요소를 의미(input 요소가 하나만 있더라고 [0]을 명시해야 합니다.)
	//[문제] input 요소가 여러개일 떄, 파일정보를 담아보세요.

	//fileInpits 변수에 여러개의 input이 대입된 경우
	var yourFiles = [];
	
	for(var i = 0; i < fileInputs.length ; i++){
		yourFiles = fileInputs[i].files ;
		
		if(yourFiles == null || yourFiles.length == 0){
			continue ;
		}
		
		for (var j = 0; j < yourFiles.length; j++){
			//console.log("yourFiles 정보======") ;
			//console.log(yourFiles[j]);			
		
			//파일 크기 검사
			if(!checkUploadFile(yourFiles[i].name, yourFiles[i].size)){
				console.log("파일이름: " + yourFiles[i].name);
				console.log("파일이름: " + yourFiles[i].size);
				return ;
			}		
			
			formData.append("yourUploadFiles", yourFiles[j]);
		
		} //for-end
	}

		console.log("=============================");
		console.log(formData.get("yourUploadFiles"));
	
	if( formData.get("yourUploadFiles") == null ){
		alert("파일을 선택하시오..");
		return;
	} 
	
	//FormData() 객체에 input의 파일을 모두 저장함
/* 	for(var i = 0 ; i < yourFiles.length ; i++) {

		}*/

	//FormData() 객체(formData)를 서버로 전송(By Ajax)
	//url 키에 명시된 주소의 컨트롤러에게 formData 객체를 POST 방식으로 전송.
	$.ajax({
		type: "post" , 
		url: "${contextPath}/fileUploadAjaxAction" ,
		data: formData ,
		contentType: false , //contentType에 MIME 타입을 지정하지 않음.
		processData: false , //contentType에 설정된 형식으로 data를 처리하지 않음.
		dataType: "json" ,
		beforeSend: function(xhr){
			xhr.setRequestHeader(myCsrfHeaderName, myCsrfToken);
		} ,
		success: function(uploadResult, status){
			console.log(uploadResult);

//			$(".uploadDiv").html(cloneFileInput.html());
			$(".inputFile").val("") ;
			
			showUploadResult(uploadResult);
		}
	});
	
});

<%-- 업로드 파일 삭제: 서버에 업로드 된 파일이 삭제되고, 이를 화면에 반영해 주어야 함 --%>
<%-- body > div.fileUploadResult > ul > li:nth-child(3) > span --%>
$(".fileUploadResult ul").on("click", "li span", function(e){
	var FileName = $(this).data("filename");
	var FileType = $(this).data("filetype");
	
	var parentLi = $(this).parent() ;
	
	$.ajax({
		type: "post" ,
		url: "${contextPath}/deleteFile" ,
		data: {fileName: FileName, fileType: FileType} , 
		dataType : "text" ,
		beforeSend: function(xhr){
			xhr.setRequestHeader(myCsrfHeaderName, myCsrfToken);
		},
		success: function(result){
			if(result == "S"){
				alert("파일이 삭제되었습니다.");	
				parentLi.remove() ; 
			} else {
				if(confirm("파일이 존재하지 않습니다. 해당 항목을 삭제하시겠습니까?") ) {
					parentLi.remove() ; 
					alert("파일이 삭제되었습니다.");	
				}		
			}
		} //success-end
	}); // ajax-end
});

</script>

       
        

<%@include file="../myinclude/myfooter.jsp" %>

