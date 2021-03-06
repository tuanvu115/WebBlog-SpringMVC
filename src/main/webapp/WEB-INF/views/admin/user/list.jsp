<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="UserAPI" value="/api/user"/>
<c:url var ="UserURL" value="/quan-tri/nguoi-dung/danh-sach"/>
<c:url var="CreateUserURL" value="/quan-tri/nguoi-dung/chinh-sua"/>

<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Danh sách người dùng</title>
</head>

<body>
	<div class="main-content">
	<form action="${UserURL}" id="formSubmit" method="get">
			<div class="main-content-inner">
				<div class="breadcrumbs ace-save-state" id="breadcrumbs">
					<ul class="breadcrumb">
						<li>
							<i class="ace-icon fa fa-home home-icon"></i>
							<a href="<c:url value='/trang-chu'/>">Trang chủ</a>
						</li>
					</ul>
					<!-- /.breadcrumb -->
				</div>


				<div class="page-content">



					<div class="row">
						<div class="col-xs-12">
							<c:if test="${not empty message}">
								<div class="alert alert-<c:out value='${alert}'/>">
									<c:out value='${message}'/>
								</div>
							</c:if>
							<div class="widget-box table-filter">
								<div class="table-btn-controls">
									<div class="pull-right tableTools-container">
										<div class="dt-buttons btn-overlap btn-group">
											<a flag="info"
												class="dt-button buttons-colvis btn btn-white btn-primary btn-bold" data-toggle="tooltip"
												title='Thêm user' href='${CreateUserURL}'>
														<span>
															<i class="fa fa-plus-circle bigger-110 purple"></i>
														</span>
											</a>
											<button id="btnDelete" type="button" onclick="warningBeforeDelete()"
													class="dt-button buttons-html5 btn btn-white btn-primary btn-bold" data-toggle="tooltip" title='Xóa user'>
															<span>
																<i class="fa fa-trash-o bigger-110 pink"></i>
															</span>
											</button>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-12">
									<div class="table-responsive">
										<table class="table table-bordered">
											<thead>
												<tr>
													<th><input type="checkbox" id="checkAll"></th>
													<th>Username</th>
													<th>Fullname</th>
													<th>Status</th>
													<th>Thao tác</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${model.listResult}">
													<tr>
														<td><input type="checkbox" id="checkbox_${item.id}" value="${item.id}"></td>
														<td><c:out value="${item.userName}"/></td>
														<td><c:out value="${item.fullName}"/></td>
														<c:if test="${item.status == 1}">
															<td>Hoạt động</td>
														</c:if>
														<c:if test="${item.status == 0}">
															<td>Vô hiệu hóa</td>
														</c:if>

														<td>
															<c:url var="updateUserURL" value="/quan-tri/nguoi-dung/chinh-sua">
																<c:param name="id" value="${item.id}"/>
															</c:url>
															<a class="btn btn-sm btn-primary btn-edit" data-toggle="tooltip"
																title="Cập nhật " href='${updateUserURL}'><i class="fa fa-pencil-square-o" aria-hidden="true"></i>
															</a>
														</td>
														
													</tr>
												</c:forEach>
											</tbody>
										</table>
										<ul class="pagination" id="pagination"></ul>
										<input type="hidden" value="1" id="page" name="page"/>
	                                    <input type="hidden" value="5" id="limit" name="limit"/>
	                                    <input type="hidden" value="id" id="sortName" name="sortName"/>
	                                    <input type="hidden" value="desc" id="sortBy" name="sortBy"/>
									</div>
								</div>
							</div>
						</div>

					</div>

					<div class="row">
                    <div class="col-lg-3">
                    	<div class="form-group">
						  <label for="sel1">Tìm kiếm theo:</label>
						  <select class="form-control" id="searchKey" name="searchKey">
						    <option value="userName">Username</option>
						    <option value="fullName">Fullname</option>						 				 	
						  </select>
						</div>
						
                        <div class="input-group">
                          <input type="text" class="form-control" placeholder="Nhập vào để tìm kiếm" id="searchName" name="searchName" />
                          <span class="input-group-btn">
                            <button class="btn btn-default" type="submit">Search</button>
                          </span>
                        </div>
                    </div>

                </div>

				</div>
			</div>
	</form>
	</div>
	<!-- /.main-content -->
	<script>

		$('#checkAll').click(function(){
		if($('#checkAll').prop('checked')){
			$('input:checkbox').prop('checked',true);
		}else{
			$('input:checkbox').prop('checked',false);
		}
		});

		var totalPages = ${model.totalPage};
		var currentPage = ${model.page};
		var limit = 5;
		$(function () {
			window.pagObj = $('#pagination').twbsPagination({
				totalPages: totalPages,
				visiblePages: 10,
				startPage: currentPage,
				onPageClick: function (event, page) {
					if (currentPage != page) {
						$('#limit').val(limit);
						$('#page').val(page);
						$('#sortName').val('id');
						$('#sortBy').val('desc');
						$('#searchKey').val('${model.searchKey}');
                    	$('#searchName').val('${model.searchName}');
						$('#formSubmit').submit();
					}
				}
			});
		});

		
		function deleteUser(data) {
			$.ajax({
				url: '${UserAPI}',
				type: 'DELETE',
				contentType: 'application/json',
				data: JSON.stringify(data),
				success: function (result) {
					window.location.href = "${UserURL}?page=1&limit=5&sortName=id&sortBy=desc&message=delete_success";
				},
				error: function (error) {
					window.location.href = "${UserURL}?page=1&limit=5&sortName=id&sortBy=desc&message=error_system";
				}
			});
		}

		function warningBeforeDelete(){
			const swalWithBootstrapButtons = Swal.mixin({
				customClass: {
					confirmButton: 'btn btn-success',
					cancelButton: 'btn btn-danger'
				},
				buttonsStyling: false
			})

			swalWithBootstrapButtons.fire({
				title: 'Xác nhận xóa?',
				text: "Bạn có chắc muốn xóa!",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonText: 'Xác nhận',
				cancelButtonText: 'Hủy bỏ',
				reverseButtons: true
			}).then((result) => {
				if (result.isConfirmed) {
					var ids = $('tbody input[type=checkbox]:checked').map(function () {
						return $(this).val();
					}).get();
					deleteUser(ids);
				} else if ( result.dismiss === Swal.DismissReason.cancel ) {
					swalWithBootstrapButtons.fire(
							'Hủy bỏ thành công'
					)
				}
			})
		}

	</script>
</body>

</html>