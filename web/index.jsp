<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<%@ page
        import="src.bean.*, src.db.CategoryDB, src.db.MemoDB, src.db.TagDB, java.util.*, java.text.SimpleDateFormat" %>
<%
    // 검색 파라미터 가져오기
    String keyword = request.getParameter("keyword");

    // 태그 필터링 파라미터 가져오기
    String tagFilter = request.getParameter("tag");

    // 카테고리 ID 가져오기
    String categoryIdParam = request.getParameter("categoryId");
    int selectedCategoryId = 0;

    if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
        try {
            selectedCategoryId = Integer.parseInt(categoryIdParam);
        } catch (NumberFormatException e) {
            // 숫자 형식이 아닌 경우 무시
        }
    }

    // 카테고리 정보 가져오기
    CategoryDB categoryDB = null;
    List<Category> categories = null;
    try {
        categoryDB = new CategoryDB();
        categories = categoryDB.getCategoriesByUserId(userId);
        categoryDB.close();
    } catch (Exception e) {
        out.print(e);
    }

    // 활성 카테고리 결정
    Category activeCategory = null;

    // 선택된 카테고리 ID가 있으면 해당 카테고리를 활성화
    if (selectedCategoryId > 0 && categories != null) {
        for (Category category : categories) {
            if (category.getCategoryId() == selectedCategoryId) {
                activeCategory = category;
                break;
            }
        }
    }

    // 선택된 카테고리가 없고, 카테고리가 존재하면 첫 번째 카테고리를 활성화
    if (activeCategory == null && categories != null && !categories.isEmpty()) {
        activeCategory = categories.get(0);
        selectedCategoryId = activeCategory.getCategoryId();
    }

    // 메모 목록 가져오기
    List<Memo> memos = null;
    MemoDB memoDB = null;
    TagDB tagDB = null;
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    // 메모 ID와 태그 목록을 매핑하는 맵
    HashMap<Integer, List<Tag>> memoTagsMap = new HashMap<>();

    try {
        memoDB = new MemoDB();
        tagDB = new TagDB();

        // 태그 필터가 있으면 태그로 메모 검색
        if (tagFilter != null && !tagFilter.trim().isEmpty()) {
            // 태그로 메모 ID 목록 가져오기
            List<Integer> memoIds = tagDB.getMemoIdsByTagName(tagFilter);
            if (memoIds != null && !memoIds.isEmpty()) {
                memos = memoDB.getMemosByIds(memoIds, Integer.valueOf(userId));
            } else {
                memos = new ArrayList<>(); // 빈 목록 반환
            }
        }
        // 검색어가 있으면 검색 결과를, 없으면 선택된 카테고리의 메모 목록을 가져옴
        else if (keyword != null && !keyword.trim().isEmpty()) {
            memos = memoDB.searchMemos(userId, keyword);
        } else if (selectedCategoryId > 0) {
            memos = memoDB.getMemosByCategory(selectedCategoryId, userId);
        }

        // 각 메모의 태그 목록 가져오기
        if (memos != null && !memos.isEmpty()) {
            for (Memo memo : memos) {
                List<Tag> tags = tagDB.getTagsByMemoId(memo.getMemoId());
                memoTagsMap.put(memo.getMemoId(), tags);
            }
        }

        if (tagDB != null) {
            tagDB.close();
        }
        memoDB.close();
    } catch (Exception e) {
        out.print(e);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>메모 관리 시스템</title>
    <link rel="stylesheet" href="css/common/styles.css"/>
    <link rel="stylesheet" href="css/common/tag.css"/>
    <link rel="stylesheet" href="css/pages/index.css"/>
</head>
<body>
<div class="container">
    <aside class="sidebar">
        <div class="new-category-container">
            <a href="category-add.jsp" style="text-decoration: none">
                <button class="btn primary">+ 새 카테고리</button>
            </a>
        </div>

        <nav class="category-nav">
            <ul class="category-list">
                <% if (categories != null && !categories.isEmpty()) { %>
                <% for (Category category : categories) { %>
                <li class="category-item <%= (activeCategory != null && category.getCategoryId() == activeCategory.getCategoryId()) ? "active" : "" %>">
                    <div class="category-info">
                        <a href="index.jsp?categoryId=<%= category.getCategoryId() %>"
                           style="text-decoration: none; color: inherit;">
                            <span class="category-name"><%= category.getCategoryName() %></span>
                            <span class="category-count">(<%= category.getMemoCount() %>)</span>
                        </a>
                    </div>
                    <div class="category-actions">
                        <a href="category-edit.jsp?categoryId=<%= category.getCategoryId() %>"
                           class="icon-btn edit-btn">수정</a>
                        <a href="category-do.jsp?action=delete&categoryId=<%= category.getCategoryId() %>"
                           onclick="return confirm('정말 이 카테고리를 삭제하시겠습니까?')"
                           class="icon-btn delete-btn">삭제</a>
                    </div>
                </li>
                <% } %>
                <% } else { %>
                <li class="category-item">
                    <div class="category-info">
                        <span class="category-name">카테고리가 없습니다</span>
                    </div>
                </li>
                <% } %>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <div class="header-container">
                <h1 class="page-title">
                    <% if (tagFilter != null && !tagFilter.trim().isEmpty()) { %>
                    태그: #<%= tagFilter %>
                    <a href="index.jsp<%= activeCategory != null ? "?categoryId=" + activeCategory.getCategoryId() : "" %>"
                       class="clear-tag-btn">×</a>
                    <% } else if (keyword != null && !keyword.trim().isEmpty()) { %>
                    "<%= keyword %>" 검색 결과
                    <% } else if (activeCategory != null) { %>
                    <%= activeCategory.getCategoryName() %>
                    <% } else { %>
                    메모
                    <% } %>
                </h1>
                <div class="header-actions">
                    <form action="index.jsp" method="get" class="search-container">
                        <input type="text" class="search-input" name="keyword"
                               placeholder="메모 검색"
                               value="<%= keyword != null ? keyword : "" %>"/>
                        <button type="submit" class="btn secondary">검색</button>
                    </form>


                    <a href="memo-add.jsp<%= activeCategory != null ? "?categoryId=" + activeCategory.getCategoryId() : "" %>"
                       style="text-decoration: none">
                        <button class="btn primary">새 메모</button>
                    </a>
                    <a href="logout.jsp" class="btn secondary"
                       style="text-decoration: none">로그아웃</a>
                </div>
            </div>
        </header>

        <div class="memo-content">
            <div class="memo-grid">
                <% if (memos != null && !memos.isEmpty()) { %>
                <% for (Memo memo : memos) { %>
                <div class="memo-card"
                     style="background-color: <%= memo.getBackgroundColor() %>; cursor: pointer;"
                     onclick="location.href='memo-view.jsp?memoId=<%= memo.getMemoId() %>'">
                    <div class="memo-header">
                        <h3 class="memo-title"><%= memo.getTitle() %>
                        </h3>
                        <span class="<%= memo.isImportant() ? "starred" : "" %>">
                            <%= memo.isImportant() ? "★" : "☆" %>
                        </span>
                    </div>
                    <p class="memo-text"><%= memo.getContent() %>
                    </p>

                    <%
                        List<Tag> tags = memoTagsMap.get(memo.getMemoId());
                        if (tags != null && !tags.isEmpty()) {
                    %>
                    <div class="tag-container" onclick="event.stopPropagation();">
                        <% for (Tag tag : tags) { %>
                        <a href="index.jsp?tag=<%= tag.getTagName() %>"
                           class="tag">#<%= tag.getTagName() %>
                        </a>
                        <% } %>
                    </div>
                    <% } %>

                    <div class="memo-footer">
                        <span class="memo-date"><%= dateFormat.format(memo.getCreatedAt()) %></span>
                        <div class="memo-actions" onclick="event.stopPropagation();">
                            <a href="memo-edit.jsp?memoId=<%= memo.getMemoId() %>"
                               class="icon-btn edit-btn">수정</a>
                            <a href="memo-do.jsp?action=delete&memoId=<%= memo.getMemoId() %>"
                               onclick="return confirm('정말 이 메모를 삭제하시겠습니까?')"
                               class="icon-btn delete-btn">삭제</a>
                        </div>
                    </div>
                </div>
                <% }
                } else { %>
                <div class="no-memo-message">
                    <p>등록된 메모가 없습니다.</p>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>
</body>
</html>
