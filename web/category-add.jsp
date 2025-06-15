<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 카테고리 등록</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/category-form.css">
    <link rel="stylesheet" href="css/pages/category-form.css">
</head>
<body>
<div class="category-form-container">
    <h2 class="form-title">새 카테고리 등록</h2>
    <form action="category-do.jsp" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label for="categoryName">카테고리 이름</label>
            <input type="text" id="categoryName" name="categoryName" required>
        </div>
        <div class="button-group">
            <a href="index.jsp" class="btn secondary">취소</a>
            <button type="submit" class="btn primary">등록</button>
        </div>
    </form>
</div>
</body>
</html>

