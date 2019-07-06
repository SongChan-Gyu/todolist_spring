<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>게시물 리스트</title>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
    <table class="board_list">
        <colgroup>
            <col width="5%">
            <col width="50%">
            <col width="5%">
            <col width="15%">
            <col width="15%">
        </colgroup>
        <caption>게시판</caption>
        <thead>
            <tr>
                <th>No.</th>
                <th>제목</th>
                <th>Hit</th>
                <th>작성자</th>
                <th>작성시간</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${fn:length(list)>0}">
                    <c:forEach items="${list }" var="con" >
                        <tr>
                            <td>${con.IDX }</td>
                            <td><input type="hidden" id="IDX" value="${con.IDX }"><a href="#this" name="TITLE">${con.TITLE }</a></td>
                            <td>${con.HIT_CNT }</td>
                            <td>${con.CREA_ID }</td>
                            <td>${con.CREA_DTM }</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td>게시물이 존재하지 않습니다.</td>
                    </tr>
                </c:otherwise>            
            </c:choose>
        </tbody>
    </table>
 
    <c:if test="${not empty paginationInfo}">
         <ui:pagination paginationInfo = "${paginationInfo}" type="text" jsFunction="fn_search"/>
    </c:if>
    <input type="hidden" id="currentPageNo" name="currentPageNo"/>
     
 
 
 
    <a href="#this" class="btn" id="write">글쓰기</a>
     <a href="#" class="btn" id="member">회원가입</a>
    <%@ include file="/WEB-INF/include/include-body.jspf" %>
     
    <script type="text/javascript">
        $(document).ready(function(){
            $("#write").on("click",function(e){
                e.preventDefault();
                fn_openBoardWrite();
            })
            $("a[name='TITLE']").on("click",function(e){
                e.preventDefault();
                fn_openBoardDetail($(this));
            })
            $("#member").on("click",function(e){
            	e.preventDefault();
            	fn_openBoardMember();
            })
        })
        function fn_openBoardMember(){
        	var comSubmit = new ComSubmit();
        	comSubmit.setUrl("<c:url value='/user/openSignUp.do'/>");
        	comSubmit.submit();
        }
        
          
        function fn_openBoardWrite(){
            var comSubmit = new ComSubmit();
            comSubmit.setUrl("<c:url value='/sample/openBoardWrite.do'/>");
            comSubmit.submit();
        }
        function fn_openBoardDetail(val){
            var comSubmit = new ComSubmit();
            comSubmit.addParam("IDX",val.parent().find("#IDX").val());
            comSubmit.setUrl("<c:url value='/sample/viewBoard.do'/>");
            comSubmit.submit();
        }
        function fn_search(pageNo){
            var comSubmit = new ComSubmit();
            comSubmit.setUrl("<c:url value='/sample/openBoardList.do' />");
            comSubmit.addParam("currentPageNo", pageNo);
            comSubmit.submit();
        }
 
    </script>
</body>
</html>