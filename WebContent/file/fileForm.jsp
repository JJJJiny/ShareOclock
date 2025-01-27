<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
    <head>
    <title>File-DragDrop</title>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <style>
        .upload-btn-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
        }
        .upload-btn-wrapper input[type=file] {
            font-size: 100px;
            position: absolute;
            left:0;
            top: 0;
            opacity: 0;
        }      
        #fileDragDesc {
            width: 100%; 
            height: 100%; 
            margin-left: auto; 
            margin-right: auto; 
            padding: 5px; 
            text-align: center; 
            line-height: 300px; 
            vertical-align:middle;
        }
    </style>
    </head>
    <body>
        <form name="uploadForm" id="uploadForm" enctype="multipart/form-data" method="post">
      <div class="upload-btn-wrapper">      
           <input type="file" id="input_file" name="input_file" multiple="multiple" style="height: 100%;" />
           <button class="upload-btn">파일선택</button>
        </div>
        <br />
            <div id="dropZone" style="width: 700px; height: 300px; border-style: dotted; border-color: gray; margin:auto ">
                <div id="fileDragDesc"> 파일을 드래그 해주세요. </div>
                <table id="fileListTable" width="100%" border="0px">
                    <tbody id="fileTableTbody"></tbody>              
                </table>
            </div>
               <input type="button" onclick="uploadFile(); return false;" id="uploadForm" value="파일 업로드">
        </form>
    </body>
           <script>  
                $("#input_file").on('change', function() {
                    selectFile(this.files);
                });        
            // 파일 리스트 번호
            var fileIndex = 0;
            // 등록할 전체 파일 사이즈
            var totalFileSize = 0;
            // 파일 리스트
            var fileList = new Array();
            // 파일 사이즈 리스트
            var fileSizeList = new Array();
            // 등록 가능한 파일 사이즈 MB
            var uploadSize = 100;
            // 등록 가능한 총 파일 사이즈 MB
            var maxUploadSize = 100;
    
            $(function() {
                // 파일 드롭 다운
                fileDropDown();
            });
            // 파일 드롭 다운
            function fileDropDown() {
                var dropZone = $("#dropZone");
                //Drag기능 
                dropZone.on('dragenter', function(e) {
                    e.stopPropagation();
                    e.preventDefault();
                    // 드롭다운 영역 css
                    dropZone.css('background-color', '#E3F2FC');
                });
                dropZone.on('dragleave', function(e) {
                    e.stopPropagation();
                    e.preventDefault();
                    // 드롭다운 영역 css
                    dropZone.css('background-color', '#FFFFFF');
                });
                dropZone.on('dragover', function(e) {
                    e.stopPropagation();
                    e.preventDefault();
                    // 드롭다운 영역 css
                    dropZone.css('background-color', '#E3F2FC');
                });
                dropZone.on('drop', function(e) {
                    e.preventDefault();
                    // 드롭다운 영역 css
                    dropZone.css('background-color', '#FFFFFF');
    
                    var files = e.originalEvent.dataTransfer.files;
                    if (files != null) {
                        if (files.length < 1) {
                            alert("폴더 업로드 불가");
                            console.log("폴더 업로드 불가");
                            return;
                        } else {
                            selectFile(files)
                        }
                    } else {
                        alert("ERROR");
                    }
                });
            }
            // 파일 선택시
            function selectFile(fileObject) {
                var files = null;
    
                if (fileObject != null) {
                    // 파일 Drag 이용하여 등록시
                    files = fileObject;
                } else {
                    // 직접 파일 등록시
                    files = $('#multipaartFileList_' + fileIndex)[0].files;
                }   
                // 다중파일 등록
                if (files != null) {
                    if (files != null && files.length > 0) {
                        $("#fileDragDesc").hide(); 
                        $("fileListTable").show();
                    } else {
                        $("#fileDragDesc").show(); 
                        $("fileListTable").hide();
                    }
                    for (var i = 0; i < files.length; i++) {
                        // 파일 이름
                        var fileName = files[i].name;
       
                        var fileNameArr = fileName.split("\.");
                        // 확장자
                        var ext = fileNameArr[fileNameArr.length - 1];
                        var fileSize = files[i].size; // 파일 사이즈(단위 :byte)
                        console.log("fileSize="+fileSize);
                        if (fileSize <= 0) {
                            console.log("0kb file return");
                            return;
                        }
                        var fileSizeKb = fileSize / 1024; // 파일 사이즈(단위 :kb)
                        var fileSizeMb = fileSizeKb / 1024;    // 파일 사이즈(단위 :Mb)
                        
                        var fileSizeStr = "";
                        if ((1024*1024) <= fileSize) {    // 파일 용량이 1메가 이상인 경우 
                            console.log("fileSizeMb="+fileSizeMb.toFixed(2));
                            fileSizeStr = fileSizeMb.toFixed(2) + " Mb";
                        } else if ((1024) <= fileSize) {
                            console.log("fileSizeKb="+parseInt(fileSizeKb));
                            fileSizeStr = parseInt(fileSizeKb) + " kb";
                        } else {
                            console.log("fileSize="+parseInt(fileSize));
                            fileSizeStr = parseInt(fileSize) + " byte";
                        }
                        if ($.inArray(ext, [ 'hwp', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'png', 'pdf', 'jpg', 'jpeg', 'gif', 'zip' ]) <= 0) {
                            // 확장자 체크
                            alert("등록이 불가능한 파일 입니다.("+fileName+")");
                        } else if (fileSizeMb > uploadSize) {
                            // 파일 사이즈 체크
                            alert("용량 초과\n업로드 가능 용량 : " + uploadSize + " MB");
                            break;
                        } else {
                            // 전체 파일 사이즈
                            totalFileSize += fileSizeMb;
                            // 파일 배열에 넣기
                            fileList[fileIndex] = files[i];   
                            // 파일 사이즈 배열에 넣기
                            fileSizeList[fileIndex] = fileSizeMb;
                            // 업로드 파일 목록 생성
                            addFileList(fileIndex, fileName, fileSizeStr);
                            // 파일 번호 증가
                            fileIndex++;
                        }
                    }
                } else {
                    alert("ERROR");
                }
            }   
            // 업로드 파일 목록 생성
            function addFileList(fIndex, fileName, fileSizeStr) {
                var html = "";
                html += "<tr id='fileTr_" + fIndex + "'>";
                html += "    <td id='dropZone' class='left' >";
                html += fileName + " (" + fileSizeStr +") " 
                        //+ "<a href='#' onclick='deleteFile(" + fIndex + "); return false;' class='btn small bg_02'> 삭제</a>"
                        
                        + "<input value='삭제' type='button' href='#' onclick='deleteFile(" + fIndex + "); return false;'>"
                html += "    </td>"
                html += "</tr>"
    
                $('#fileTableTbody').append(html);
            } 
            // 업로드 파일 삭제
            function deleteFile(fIndex) {
                console.log("deleteFile.fIndex=" + fIndex);
                // 전체 파일 사이즈 수정
                totalFileSize -= fileSizeList[fIndex];
    
                // 파일 배열에서 삭제
                delete fileList[fIndex];
    
                // 파일 사이즈 배열 삭제
                delete fileSizeList[fIndex];
    
                // 업로드 파일 테이블 목록에서 삭제
                $("#fileTr_" + fIndex).remove();
                
                console.log("totalFileSize="+totalFileSize);
                
                if (totalFileSize > 0) {
                    $("#fileDragDesc").hide(); 
                    $("fileListTable").show();
                } else {
                    $("#fileDragDesc").show(); 
                    $("fileListTable").hide();
                }
            }   
            // 파일 등록
            function uploadFile() {
                // 등록할 파일 리스트
                var uploadFileList = Object.keys(fileList);
                // 파일이 있는지 체크
                if (uploadFileList.length == 0) {
                    // 파일등록 경고창
                    alert("파일이 없습니다.");
                    return;
                }    
                // 용량을 500MB를 넘을 경우 업로드 불가
                if (totalFileSize > maxUploadSize) {
                    // 파일 사이즈 초과 경고창
                    alert("총 용량 초과\n총 업로드 가능 용량 : " + maxUploadSize + " MB");
                    return;
                }   
                if (confirm("등록 하시겠습니까?")) {
                    // 등록할 파일 리스트를 formData로 데이터 입력
                    var form = $('#uploadForm')[0];
                    var formData = new FormData(form);
                    for (var i = 0; i < uploadFileList.length; i++) {
                    	console.log(uploadFileList[i]);
                    	console.log(fileList[uploadFileList[i]].name);
                    }
                    console.log("전");
                    $.ajax({
                        url : "${pageContext.request.contextPath}/upload.file",
                        data : formData,
                        type : 'POST',
                        enctype : 'multipart/form-data',
                        processData : false,
                        contentType : false,
                        dataType : 'json',
                        cache : false,
                        success : function(result) {
                        	//result = JSON.parse(result)                      
                        	console.log(result);
                        	console.log("후");
                            if (result.fileName.length != 0) {
                                alert("성공");
                                //location.reload();
                            	location.href = "${pageContext.request.contextPath}/list.file"
                            } else {
                                alert("실패");
                                location.reload();
                            }
                        },
                        error : function(request,status,error){
                        	console.log(request.status+"////error:"+error)
                        	console.log("fail");
                        	}
                        
                    });
                }
            }
        </script>
</html>
 