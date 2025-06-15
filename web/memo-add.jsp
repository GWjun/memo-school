<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %>
<%@ page import="src.bean.Category, src.db.CategoryDB, java.util.List" %>
<%
    // 카테고리 기본값 설정
    String categoryIdParam = request.getParameter("categoryId");
    int selectedCategoryId = 0;

    if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
        try {
            selectedCategoryId = Integer.parseInt(categoryIdParam);
        } catch (NumberFormatException e) {
            // 숫자 형식이 아닌 경우 무시
        }
    }

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
    <style>
      .memo-form-container {
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .form-title {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
      }

      .form-group {
        margin-bottom: 15px;
      }

      .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }

      .form-group input[type="text"],
      .form-group textarea,
      .form-group select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 16px;
      }

      .form-group textarea {
        height: 150px;
        resize: vertical;
      }

      .color-options {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
      }

      .color-option {
        display: flex;
        align-items: center;
        margin-right: 10px;
      }

      .color-preview {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        margin-right: 5px;
        border: 1px solid #ddd;
      }

      .color-preview.yellow {
        background-color: #fff9c4;
      }

      .color-preview.green {
        background-color: #e8f5e9;
      }

      .color-preview.blue {
        background-color: #e3f2fd;
      }

      .color-preview.pink {
        background-color: #fce4ec;
      }

      .color-preview.purple {
        background-color: #f3e5f5;
      }

      .color-preview.orange {
        background-color: #fff3e0;
      }

      .button-group {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
      }

      .important-toggle {
        margin-right: 10px;
      }
    </style>
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
            <label>배경색</label>
            <div class="color-options">
                <label class="color-option">
                    <input type="radio" name="backgroundColor" value="yellow" checked>
                    <span class="color-preview yellow"></span>
                    <span>노랑</span>
                </label>
                <label class="color-option">
                    <input type="radio" name="backgroundColor" value="green">
                    <span class="color-preview green"></span>
                    <span>초록</span>
                </label>
                <label class="color-option">
                    <input type="radio" name="backgroundColor" value="blue">
                    <span class="color-preview blue"></span>
                    <span>파랑</span>
                </label>
                <label class="color-option">
                    <input type="radio" name="backgroundColor" value="pink">
                    <span class="color-preview pink"></span>
                    <span>분홍</span>
                </label>
                <label class="color-option">
                    <input type="radio" name="backgroundColor" value="purple">
                    <span class="color-preview purple"></span>
                    <span>보라</span>
                </label>
                <label class="color-option">
                    <input type="radio" name="backgroundColor" value="orange">
                    <span class="color-preview orange"></span>
                    <span>주황</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label for="imageFile">이미지 첨부 (선택사항)</label>
            <input type="file" id="imageFile" name="imageFile" accept="image/*">
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

