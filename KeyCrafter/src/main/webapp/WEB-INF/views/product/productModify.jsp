<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../include/header.jsp" %>

<section class="cat_product_area mt-xl mb-60">
	<div class="container-fluid">
		<div class="row flex-row-reverse">
			<div class="col-lg-9">
				<h3 class="mb-30 title_color">상품 수정</h3>
				<form action="/product/update" method="post" role="form">
					<div class="form-group row">
						<label for="pname" class="col-sm-2 col-form-label single-label"><h5>상품명</h5></label>
						<div class="col-sm-10">
							<input type="text" value="${ product.pname }" class="form-control" name="pname" id="pname" maxlength="50" required>
						</div>
					</div>
					<div class="form-group row justify-content-start">
						<label for="price" class="col-sm-2 single-label"><h5>가격</h5></label>
						<div class="col-sm-4">
							<input type="text" value="${ product.price }" class="form-control" name="price" id="price" maxlength="10" required>
						</div>
						<label for="quantity" class="col-sm-2 single-label"><h5>수량</h5></label>
						<div class="col-sm-4">
							<input type="text" value="${ product.quantity }" class="form-control" name="quantity" id="quantity" maxlength="10" required>
						</div>
					</div>
					<div class="form-group row justify-content-start">
						<label for="company" class="col-sm-2 single-label"><h5>제조사</h5></label>
						<div class="col-sm-4">
							<input type="text" value="${ product.company }" class="form-control" name="company" id="company" maxlength="50">
						</div>
						<label for="madeIn" class="col-sm-2 single-label"><h5>제조국</h5></label>
						<div class="col-sm-4">
							<input type="text" value="${ product.madeIn }" class="form-control" name="madeIn" id="madeIn" maxlength="20">
						</div>
					</div>
					<div class="form-group row justify-content-start">
						<label id="addCategory" class="col-sm-2 single-label">
							<h5>카테고리</h5>
						</label>
						<div class="col-sm-10">
							<div id="categoryList" class="row justify-content-start">
							</div>
						</div>
					</div>				
					<div class="form-group row">
						<label for="productDesc" class="single-label"><h5>상품 설명</h5></label>
						<textarea class="form-control" name="productDesc" id="productDesc" rows="5">${ product.productDesc }</textarea>
					</div>
					<div class="form-group form-button">
						<div class="row">
							<input type="submit" value="수정" class="btn btn-primary">&nbsp;&nbsp;
							<!-- <input type="reset" value="삭제" class="btn btn-warning">&nbsp;&nbsp; -->
							<input type="button" value="뒤로" class="btn btn-secondary" onclick="history.back()">
						</div>
						
					</div>
					<input type="hidden" name="pid" value="${ product.pid }">
					
					<input type="hidden" name="page" value="${ cri.page }">
					<input type="hidden" name="show" value="${ cri.show }">
					<input type="hidden" name="cat" value="${ cri.cat }">
					
					<c:forEach items="${ cri.keyword }" varStatus="status">
						<input type="hidden" name="type" value="${ cri.type[status.index] }">
						<input type="hidden" name="keyword" value="${ cri.keyword[status.index] }">
					</c:forEach>
					
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</form>
				
				<div class="form-group row mt-25 justify-content-start">
					<div class="col-sm-2 single-label">
					<!-- <h3 class="title_color">이미지 파일</h3> -->
						<h5>이미지 파일</h5>
					</div>
					<!-- <div class="uploadDiv row"> -->
					<div class="uploadDiv col-sm-10">
						<input type="file" class="form-control-file" name="productAttach" id="productAttach" style="padding: 5px 0px 0px 0px;" multiple required>
					</div>
					<div class="uploadResult row justify-content-around mt-25">
					</div>
				</div>
			</div>
			<div class="col-lg-3">
				<%@ include file="../category/categoryList.jsp" %>
			</div>
		</div>
	</div>
</section>
<!--================End Category Product Area =================-->

<script type="text/javascript">
$(document).ready(function() {
	var formObj = $("form[role = 'form']");
	var cloneObj = $(".uploadDiv").clone();
	
	var csrfHeaderName = "${ _csrf.headerName }";
	var csrfTokenValue = "${ _csrf.token }";
	
	getCategory();
	showImage();
	
	// 상품에 저장된 카테고리 정보를 얻어서 html로 작성
	function getCategory() {
		var categoryList;
		
		$.ajax({
			url: "/category/product/" + "${ product.pid }",
			method: "GET",
			async: false
		})
		.done(function(data) {
			for (var i = 1; i < data.length; i++) {
				var selectedCatNum = data[i].catNum;
				
				$.ajax({
					url: "/category/list?cat=" + data[i - 1].catNum + "&all=0",
					method: "GET",
					async: false
				})
				.done(function(subList) {
					var str = "<div class='col-sm-3'><select class='form-control'>";
					str += "<option value='0'>[선택]</option>";
					
					for (var j = 1; j < subList.length; j++) {
						if (subList[j].catNum == selectedCatNum) {
							str += "<option value='" + subList[j].catNum + "' selected>" + subList[j].catName + "</option>";
						}
						else {
							str += "<option value='" + subList[j].catNum + "'>" + subList[j].catName + "</option>";
						}
					}
					
					if (subList[0].lft > 1) {
						str += "<option value='-1'>[삭제]</option></select></div>";
					}
					
					$("#categoryList").append(str);
				});
			}
		});
	}
	
	// 카테고리 서브리스트 호출, html 추가
	function addCategory(root, all) {
		$.getJSON("/category/list?cat=" + root + "&all=" + all, function(data) {
			if (data.length > 1) {
				var str = "<div class='col-sm-3'><select class='form-control'>";
				str += "<option value='0'>[선택]</option>";
				
				for (var i = 1; i < data.length; i++) {
					str += "<option value='" + data[i].catNum + "'>" + data[i].catName + "</option>";
				}
				
				if(data[0].lft > 1) {
					str += "<option value='-1'>[삭제]</option>";
				}
				
				str += "</select></div>";
				$("#categoryList").append(str);
			}
		});
	}
	
	// 카테고리 목록 추가 및 삭제
	$("#categoryList").on("change", "div select", function() {
		var action = $(this).val();
		
		if (action > 0) {
			$(this).closest("div").nextAll("div").remove();
			addCategory(action, 0);
		}
		
		else if (action == -1) {
			$(this).closest("div").remove();
		}
	});
	
	// 상품에 이미 등록된 사진 파일 로드
	function showImage() {
		$.getJSON("/getImage/" + "${ product.pid }", function(result) {
			if (!result || result.length == 0) {
				return;
			}
			
			var uploadResult = $(".uploadResult");
			var str = "";
			
			$(result).each(function(i, obj) {
				if (obj.uploadPath != "default") {
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					var filePath = encodeURIComponent(obj.uploadPath);
					var fileName = encodeURIComponent("s_" + obj.uuid + "_" + obj.fileName);
					
					str += "<div class='col-1' data-uuid='" + obj.uuid + "' data-uploadpath='" + obj.uploadPath +
					"' data-filename='" + obj.fileName + "'><img src='https://upload-kc.s3.ap-northeast-2.amazonaws.com/upload/" + fileCallPath +
					"'><span data-filepath='" + filePath + "' data-filename='" + fileName + "'>" +
					"<i class='fa fa-remove'></i></span></div>";
					
					/* LOCAL VER.
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					
					str += "<div class='col-1' data-uuid='" + obj.uuid + "' data-uploadpath='" + obj.uploadPath +
							"' data-filename='" + obj.fileName + "'><img src='/show?fileName=" + fileCallPath +
							"'><span data-file='" + fileCallPath + "'><i class='fa fa-remove'></i></span></div>";
					*/
				}
			});
			
			uploadResult.append(str);
		});
	}
	
	// 첨부파일 확장자 확인, 이미지 파일만 가능
	function checkExtension(fileName, fileSize) {
		var regExp = new RegExp("(.*?)\.(jpg|jpeg|png|gif|bmp)$");
		var maxSize = 20971520; // 20MB
		
		if (maxSize < fileSize) {
			alert("파일 용량 초과");
			$(".uploadDiv").html(cloneObj.html());
			return false;
		}
		
		if (!regExp.test(fileName)) {
			alert("이미지 파일만 업로드할 수 있습니다");
			$(".uploadDiv").html(cloneObj.html());
			return false;
		}
		
		return true;
	}
	
	// file 필드에 파일이 선택되면 임시로 파일 업로드
	$("input[type = 'file']").on("change", function(e) {
		var formData = new FormData();
		var inputFile = $("input[name = 'productAttach']");
		var files = inputFile[0].files;
		
		for (var i = 0; i < files.length; i++) {
			if (!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			
			formData.append("uploadFile", files[i]);
			// console.log(formData);
		}
		
		tempUpload(formData, function(result) {
			showUploadResult(result);
			$(".uploadDiv").html(cloneObj.html());
			// $(".uploadDiv").replaceWith(cloneObj);
		});
	});
	
	function tempUpload(formData, callback) {
		$.ajax({
			url: '/uploadAjaxAction',
			type: 'post',
			processData: false,
			contentType: false,
			data: formData,
			dataType: 'json',
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			success: function(result) {
				if (callback) {
					callback(result);
				}
			}
		});
	}
	
	// 임시로 파일 업로드 후 확인과 삭제를 위한 div 생성
	function showUploadResult(result) {
		if (!result || result.length == 0) {
			return;
		}
		
		var uploadResult = $(".uploadResult");
		var str = "";
		
		$(result).each(function(i, obj) {
			var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
			var filePath = encodeURIComponent(obj.uploadPath);
			var fileName = encodeURIComponent("s_" + obj.uuid + "_" + obj.fileName);
			
			str += "<div class='col-1' data-uuid='" + obj.uuid + "' data-uploadpath='" + obj.uploadPath +
			"' data-filename='" + obj.fileName + "'><img src='https://upload-kc.s3.ap-northeast-2.amazonaws.com/upload/" + fileCallPath +
			"'><span data-filepath='" + filePath + "' data-filename='" + fileName + "'>" +
			"<i class='fa fa-remove'></i></span></div>";
			
			/* LOCAL VER.
			var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
			
			str += "<div class='col-1' data-uuid='" + obj.uuid + "' data-uploadpath='" + obj.uploadPath +
					"' data-filename='" + obj.fileName + "'><img src='/show?fileName=" + fileCallPath +
					"'><span data-file='" + fileCallPath + "'><i class='fa fa-remove'></i></span></div>";
			*/
		});
		
		uploadResult.append(str);
	}
	
	// 임시 업로드 파일 삭제
	$(".uploadResult").on("click", "span", function() {
		/*
		var fileName = $(this).data("file");
		console.log("Temporarily delete file: " + fileName);
		*/
		
		if (confirm("삭제하시겠습니까?")) {
			var targetLi = $(this).closest("div");
			targetLi.attr("class", "d-none");
		}
	});
	
	/* LOCAL VER.
	$(".uploadResult").on("click", "span", function() {
		var fileName = $(this).data("file");
		
		// console.log("Temporarily delete file: " + fileName);
		
		if (confirm("삭제하시겠습니까?")) {
			var targetLi = $(this).closest("div");
			targetLi.attr("class", "d-none");
		}
	});
	*/
	
	// 등록 form에 첨부파일과 카테고리 추가 후 submit
	$("input[type = 'submit']").on("click", function(e) {
		e.preventDefault();
		
		var str="";
		var flag = 0;
		var i = 0;
		$(".uploadResult div").each(function(j, obj) {
			var jobj = $(obj);
			
			// uploadResult div에서 삭제 처리한 파일을 실제로 삭제
			if (jobj.attr("class") == "d-none") {
				var filePath = jobj.children("span").data("filepath");
				var fileName = jobj.children("span").data("filename");
				
				$.ajax({
					url: "/deleteFile",
					type: "POST",
					data: {"filePath": filePath, "fileName": fileName},
					dataType: "text",
					beforeSend: function(xhr) {
						xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					}/*,
					success: function(result) {
						result = decodeURIComponent(result);
						console.log(result);
					}
					*/
				});
				
				/* LOCAL VER.
				var fileName = jobj.children("span").data("file");
				
				$.ajax({
					url: "/deleteFile",
					type: "POST",
					data: {"fileName": fileName},
					dataType: "text",
					beforeSend: function(xhr) {
						xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					},
					success: function(result) {
						result = decodeURIComponent(result);
						// console.log(result);
					}
				});
				*/
			}
			else {
				str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("uploadpath") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
				if (!flag) {
					str += "<input type='hidden' name='attachList[" + i + "].mainImage' value='T'>";
					flag = 1;
				}
				else {
					str += "<input type='hidden' name='attachList[" + i + "].mainImage' value='F'>";
				}
				i++;
			}
		});
		
		var catNum = 1;
		
		$("#categoryList div select").each(function(i, obj) {
			var catObj = $(obj);
			
			if (catObj.val() > 0) {
				catNum = catObj.val();
			}
		});
		
		str += "<input type='hidden' name='catNum' value='" + catNum + "'>";
		
		formObj.append(str).submit();
	});
});
</script>

<%@ include file="../include/footer.jsp" %>