<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<%@ page import="src.bean.Memo, src.db.MemoDB, java.text.SimpleDateFormat" %>
<%@ page import="src.bean.Tag, src.db.TagDB, java.util.List" %>
<%
    // 메모 ID 파라미터 가져오기
    String memoIdStr = request.getParameter("memoId");
    int memoId = 0;
    Memo memo = null;
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    List<Tag> memoTags = null;

    try {
        memoId = Integer.parseInt(memoIdStr);

        // 메모 정보 가져오기
        MemoDB memoDB = null;
        TagDB tagDB = null;

        memoDB = new MemoDB();
        memo = memoDB.getMemoById(memoId, userId);

        // 권한 확인
        if (memo == null || memo.getUserId() != userId) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 메모의 태그 목록 가져오기
        tagDB = new TagDB();
        memoTags = tagDB.getTagsByMemoId(memoId);

        memoDB.close();
        tagDB.close();
    } catch (Exception e) {
        out.print(e);
        response.sendRedirect("index.jsp");
        return;
    }

    // 색상 코드 처리
    String backgroundColor = memo.getBackgroundColor();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= memo.getTitle() %> - 메모 보기</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/memo-form.css">
    <link rel="stylesheet" href="css/common/tag.css">
    <link rel="stylesheet" href="css/pages/memo-view.css">
</head>
<body>

<div class="memo-view-container custom-bg" style="background-color: <%= backgroundColor %>;">
    <div class="memo-header">
        <h1 class="memo-title"><%= memo.getTitle() %>
        </h1>
        <% if (memo.isImportant()) { %>
        <div class="memo-important">★</div>
        <% } %>
    </div>

    <div class="memo-content">
        <%= memo.getContent().replace("\n", "<br>") %>
    </div>

    <% if (memo.getImageUrl() != null && !memo.getImageUrl().isEmpty()) { %>
    <div>
        <img src="<%= memo.getImageUrl() %>" alt="메모 이미지" class="memo-image">
    </div>
    <% } %>

    <% if (memoTags != null && !memoTags.isEmpty()) { %>
    <div class="tag-container">
        <% for (Tag tag : memoTags) { %>
        <a href="index.jsp?tag=<%= tag.getTagName() %>" class="tag">#<%= tag.getTagName() %>
        </a>
        <% } %>
    </div>
    <% } %>

    <div class="memo-meta">
        <div class="category-info">
            카테고리: <%= memo.getCategoryName() %>
        </div>
        <div class="date-info">
            <div>작성일: <%= dateFormat.format(memo.getCreatedAt()) %>
            </div>
            <% if (memo.getUpdatedAt() != null && !memo.getUpdatedAt()
                    .equals(memo.getCreatedAt())) { %>
            <div>수정일: <%= dateFormat.format(memo.getUpdatedAt()) %>
            </div>
            <% } %>
        </div>
    </div>

    <div class="action-buttons">
        <a href="index.jsp?categoryId=<%= memo.getCategoryId() %>"
           class="btn secondary">목록으로</a>
        <div class="btn-group">
            <a href="memo-edit.jsp?memoId=<%= memo.getMemoId() %>" class="btn primary">수정</a>
            <a href="memo-do.jsp?action=delete&memoId=<%= memo.getMemoId() %>"
               onclick="return confirm('정말 이 메모를 삭제하시겠습니까?')"
               class="btn danger">삭제</a>
        </div>
    </div>
</div>
</body>
</html>
