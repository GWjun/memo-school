<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<%@ page import="src.bean.Category, src.db.CategoryDB" %>
<%
    // 카테고리 ID 파라미터 가져오기
    String categoryIdStr = request.getParameter("categoryId");
    int categoryId = 0;
    Category category = null;

    if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
        try {
            categoryId = Integer.parseInt(categoryIdStr);

            // 카테고리 정보 가져오기
            CategoryDB categoryDB = null;

            categoryDB = new CategoryDB();
            category = categoryDB.getCategoryById(categoryId);
            categoryDB.close();

            // 권한 확인 (다른 사용자의 카테고리를 수정할 수 없음)
            if (category == null || category.getUserId() != userId) {
                response.sendRedirect("index.jsp");
                return;
            }

        } catch (Exception e) {
            out.print(e);
            response.sendRedirect("index.jsp");
            return;
        }
    } else {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카테고리 수정</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/category-form.css">
    <link rel="stylesheet" href="css/pages/category-form.css">
</head>
<body>
<div class="category-form-container">
    <h2 class="form-title">카테고리 수정</h2>
    <form action="category-do.jsp" method="post">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="categoryId" value="<%= category.getCategoryId() %>">
        <div class="form-group">
            <label for="categoryName">카테고리 이름</label>
            <input type="text" id="categoryName" name="categoryName"
                   value="<%= category.getCategoryName() %>" required>
        </div>
        <div class="button-group">
            <a href="index.jsp" class="btn secondary">취소</a>
            <button type="submit" class="btn primary">수정</button>
        </div>
    </form>
</div>
</body>
</html>

