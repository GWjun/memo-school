<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<%@ page import="src.bean.Category, src.db.CategoryDB" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String action = request.getParameter("action");
    String resultMessage = "";
    boolean showResult = true; // 결과 페이지 표시 여부

    try {
        CategoryDB categoryDB = new CategoryDB();

        // 카테고리 추가
        if ("add".equals(action)) {
            String categoryName = request.getParameter("categoryName");

            if (categoryName == null || categoryName.trim().isEmpty()) {
                resultMessage = "카테고리 이름을 입력해주세요.";
            } else {
                Category category = new Category();
                category.setUserId(userId);
                category.setCategoryName(categoryName);

                int newCategoryId = categoryDB.insertCategory(category);

                if (newCategoryId > 0) {
                    response.sendRedirect("index.jsp");
                    showResult = false;
                } else {
                    resultMessage = "카테고리 등록에 실패했습니다.";
                }
            }
        }
        // 카테고리 수정
        else if ("edit".equals(action)) {
            String categoryIdStr = request.getParameter("categoryId");
            String categoryName = request.getParameter("categoryName");

            if (categoryIdStr == null || categoryName == null || categoryName.trim().isEmpty()) {
                resultMessage = "카테고리 정보가 올바르지 않습니다.";
            } else {
                int categoryId = Integer.parseInt(categoryIdStr);
                Category existingCategory = categoryDB.getCategoryById(categoryId);

                if (existingCategory == null || existingCategory.getUserId() != userId) {
                    resultMessage = "카테고리를 찾을 수 없거나 권한이 없습니다.";
                } else {
                    existingCategory.setCategoryName(categoryName);

                    if (categoryDB.updateCategory(existingCategory)) {
                        response.sendRedirect("index.jsp");
                        showResult = false;
                    } else {
                        resultMessage = "카테고리 수정에 실패했습니다.";
                    }
                }
            }
        }
        // 카테고리 삭제
        else if ("delete".equals(action)) {
            String categoryIdStr = request.getParameter("categoryId");

            if (categoryIdStr == null) {
                resultMessage = "카테고리 정보가 올바르지 않습니다.";
            } else {
                int categoryId = Integer.parseInt(categoryIdStr);
                Category existingCategory = categoryDB.getCategoryById(categoryId);

                if (existingCategory == null || existingCategory.getUserId() != userId) {
                    resultMessage = "카테고리를 찾을 수 없거나 권한이 없습니다.";
                } else {
                    if (categoryDB.deleteCategory(categoryId, userId)) {
                        response.sendRedirect("index.jsp");
                        showResult = false;
                    } else {
                        resultMessage = "카테고리 삭제에 실패했습니다.";
                    }
                }
            }
        } else {
            resultMessage = "유효하지 않은 작업입니다.";
        }

        categoryDB.close();
    } catch (Exception e) {
        out.print(e);
        resultMessage = "오류가 발생했습니다: " + e.getMessage();
    }

    // 작업 실패 시에만 결과 페이지 표시
    if (!showResult) {
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카테고리 작업 결과</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/category-form.css">
</head>
<body>
<div class="result-container">
    <h2>카테고리 작업 결과</h2>
    <div class="result-message error">
        <%= resultMessage %>
    </div>
    <div class="button-group">
        <a href="index.jsp" class="btn primary">메인으로 돌아가기</a>
    </div>
</div>
</body>
</html>
