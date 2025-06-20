<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<%@ page
        import="src.bean.Category, src.bean.Memo, src.bean.Tag, src.db.CategoryDB, src.db.MemoDB, src.db.TagDB, java.util.List" %>
<%
    // 메모 ID 파라미터 가져오기
    String memoIdStr = request.getParameter("memoId");
    int memoId = 0;
    Memo memo = null;
    List<Tag> memoTags = null;

    // 메모 정보 가져오기
    try {
        MemoDB memoDB = null;
        memoDB = new MemoDB();
        memoId = Integer.parseInt(memoIdStr);
        memo = memoDB.getMemoById(memoId, userId);

        // 권한 확인
        if (memo == null || memo.getUserId() != userId) {
            response.sendRedirect("index.jsp");
            return;
        }

        memoDB.close();

        // 메모의 태그 목록 가져오기
        TagDB tagDB = new TagDB();
        memoTags = tagDB.getTagsByMemoId(memoId);
        tagDB.close();
    } catch (Exception e) {
        out.print(e);
        response.sendRedirect("index.jsp");
        return;
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

    // 태그들을 쉼표로 구분된 문자열로 변환
    StringBuilder tagString = new StringBuilder();
    if (memoTags != null && !memoTags.isEmpty()) {
        for (int i = 0; i < memoTags.size(); i++) {
            tagString.append(memoTags.get(i).getTagName());
            if (i < memoTags.size() - 1) {
                tagString.append(", ");
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메모 수정</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/memo-form.css">
    <link rel="stylesheet" href="css/pages/memo-form.css">
</head>
<body>
<div class="memo-form-container">
    <h2 class="form-title">메모 수정</h2>
    <form action="memo-do.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="memoId" value="<%= memo.getMemoId() %>">

        <div class="form-group">
            <label for="categoryId">카테고리</label>
            <select id="categoryId" name="categoryId" required>
                <% if (categories != null) { %>
                <% for (Category category : categories) { %>
                <option value="<%= category.getCategoryId() %>"
                        <%= category.getCategoryId() == memo.getCategoryId() ? "selected" : "" %>>
                    <%= category.getCategoryName() %>
                </option>
                <% } %>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" value="<%= memo.getTitle() %>" required>
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" required><%= memo.getContent() %></textarea>
        </div>

        <div class="form-group">
            <label>중요 여부</label>
            <div>
                <label class="color-option">
                    <input type="checkbox" name="important" value="true"
                           class="important-toggle" <%= memo.isImportant() ? "checked" : "" %>>
                    <span>중요 메모로 표시</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label for="backgroundColor">배경색</label>
            <input type="color" id="backgroundColor" name="backgroundColor"
                   value="<%= memo.getBackgroundColor() %>" class="color-picker">
            <p class="color-help">원하는 색상을 선택하세요.</p>
        </div>

        <div class="form-group">
            <label for="imageFile">이미지 첨부 (선택사항)</label>

            <% if (memo.getImageUrl() != null && !memo.getImageUrl().isEmpty()) { %>
            <div>
                <p>현재 이미지:</p>
                <img src="<%= memo.getImageUrl() %>" alt="현재 이미지" class="current-image">
                <label>
                    <input type="checkbox" name="removeImage" value="true">
                    현재 이미지 삭제
                </label>
            </div>
            <% } %>

            <input type="file" id="imageFile" name="imageFile" accept="image/*">
            <p>새 이미지를 선택하면 기존 이미지가 교체됩니다.</p>
        </div>

        <div class="form-group">
            <label for="tags">태그 (쉼표로 구분)</label>
            <input type="text" id="tags" name="tags" placeholder="예: 중요, 회의, 아이디어"
                   value="<%= tagString.toString() %>">
            <p class="tag-help">여러 개의 태그는 쉼표(,)로 구분하여 입력하세요.</p>
        </div>

        <div class="button-group">
            <a href="memo-view.jsp?memoId=<%= memo.getMemoId() %>" class="btn secondary">취소</a>
            <button type="submit" class="btn primary">저장</button>
        </div>
    </form>
</div>
</body>
</html>
