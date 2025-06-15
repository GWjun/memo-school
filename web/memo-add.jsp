<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %>
<%@ page
        import="src.bean.Category, src.db.CategoryDB, java.util.List" %>
<%
    // 카테고리 기본값 설정
    String categoryIdParam = request.getParameter("categoryId");
    int selectedCategoryId = Integer.parseInt(categoryIdParam);

    // 카테고리 목록 가져오기
    List<Category> categories = null;

    try {
        CategoryDB categoryDB = new CategoryDB();
        categories = categoryDB.getCategoriesByUserId(userId);
        categoryDB.close();
    } catch (Exception e) {
        out.print(e);
    }

    // 카테고리가 없으면 카테고리 등록 페이지로 리다이렉트
    if (categories == null || categories.isEmpty()) {
        response.sendRedirect("category-add.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 메모 등록</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/memo-form.css">
    <link rel="stylesheet" href="css/common/tag.css">
    <link rel="stylesheet" href="css/pages/memo-form.css">
</head>
<body>
<div class="memo-form-container">
    <h2 class="form-title">새 메모 등록</h2>
    <form action="memo-do.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">

        <div class="form-group">
            <label for="categoryId">카테고리</label>
            <select id="categoryId" name="categoryId" required>
                <% if (categories != null) { %>
                <% for (Category category : categories) { %>
                <option value="<%= category.getCategoryId() %>"
                        <%= category.getCategoryId() == selectedCategoryId ? "selected" : "" %>>
                    <%= category.getCategoryName() %>
                </option>
                <% } %>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" required>
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" required></textarea>
        </div>

        <div class="form-group">
            <label>중요 여부</label>
            <div>
                <label class="color-option">
                    <input type="checkbox" name="important" value="true" class="important-toggle">
                    <span>중요 메모로 표시</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label for="backgroundColor">배경색</label>
            <input type="color" id="backgroundColor" name="backgroundColor" value="#fff9c4"
                   class="color-picker">
            <p class="color-help">원하는 색상을 선택하세요.</p>
        </div>

        <div class="form-group">
            <label for="imageFile">이미지 첨부 (선택사항)</label>
            <input type="file" id="imageFile" name="imageFile" accept="image/*">
        </div>

        <div class="form-group">
            <label for="tags">태그 (쉼표로 구분)</label>
            <input type="text" id="tags" name="tags" placeholder="예: 중요, 회의, 아이디어">
            <p class="tag-help">여러 개의 태그는 쉼표(,)로 구분하여 입력하세요.</p>
        </div>

        <div class="button-group">
            <a href="index.jsp<%= selectedCategoryId > 0 ? "?categoryId=" + selectedCategoryId : "" %>"
               class="btn secondary">취소</a>
            <button type="submit" class="btn primary">등록</button>
        </div>
    </form>
</div>
</body>
</html>
