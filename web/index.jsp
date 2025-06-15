<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %>
<%@ page
        import="src.bean.Category, src.bean.Memo, src.db.CategoryDB, src.db.MemoDB, java.util.List, java.text.SimpleDateFormat" %>
<%
    // 검색 파라미터 가져오기
    String keyword = request.getParameter("keyword");
    String searchType = request.getParameter("searchType");

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
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    try {
        memoDB = new MemoDB();

        // 검색어가 있으면 검색 결과를, 없으면 선택된 카테고리의 메모 목록을 가져옴
        if (keyword != null && !keyword.trim().isEmpty()) {
            if (searchType == null) {
                searchType = "both"; // 기본 검색 타입
            }
            memos = memoDB.searchMemos(userId, keyword, searchType);
        } else if (selectedCategoryId > 0) {
            memos = memoDB.getMemosByCategory(selectedCategoryId, userId);
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
    <link rel="stylesheet" href="css/pages/index.css"/>
    <style>
      .memo-card {
        position: relative;
        padding: 16px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        margin-bottom: 16px;
        transition: transform 0.2s ease;
      }

      .memo-card:hover {
        transform: translateY(-3px);
      }

      .memo-card.yellow {
        background-color: #fff9c4;
      }

      .memo-card.green {
        background-color: #e8f5e9;
      }

      .memo-card.blue {
        background-color: #e3f2fd;
      }

      .memo-card.pink {
        background-color: #fce4ec;
      }

      .memo-card.purple {
        background-color: #f3e5f5;
      }

      .memo-card.orange {
        background-color: #fff3e0;
      }

      .memo-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
      }

      .memo-title {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
      }

      .memo-text {
        margin: 0 0 16px 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .memo-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #666;
        font-size: 14px;
      }

      .memo-actions {
        display: flex;
        gap: 5px;
      }

      .starred {
        color: #FFD700;
      }

      .search-container {
        display: flex;
        gap: 10px;
        margin-bottom: 16px;
      }

      .search-container select {
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }

      .no-memo {
        text-align: center;
        padding: 40px 0;
        color: #666;
      }
    </style>
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
                           onclick="return confirm('정말 이 카테고리를 삭제하시겠습니까? 관련된 모든 메모도 함께 삭제됩니다.')"
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
                    <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                    "<%= keyword %>" 검색 결과
                    <% } else if (activeCategory != null) { %>
                    <%= activeCategory.getCategoryName() %>
                    <% } else { %>
                    메모
                    <% } %>
                </h1>
                <div class="header-actions">
                    <div class="header-right">
                        <form action="index.jsp" method="get" class="search-container">
                            <select name="searchType">
                                <option value="both" <%= "both".equals(searchType) ? "selected"
                                        : "" %>>제목+내용
                                </option>
                                <option value="title" <%= "title".equals(searchType) ? "selected"
                                        : "" %>>제목
                                </option>
                                <option value="content" <%= "content".equals(searchType)
                                        ? "selected" : "" %>>내용
                                </option>
                            </select>
                            <input type="text" class="search-input" name="keyword"
                                   placeholder="메모 검색"
                                   value="<%= keyword != null ? keyword : "" %>"/>
                            <button type="submit" class="btn secondary">검색</button>
                        </form>
                    </div>

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
                <div class="memo-card <%= memo.getBackgroundColor() %>">
                    <div class="memo-header">
                        <a href="memo-view.jsp?memoId=<%= memo.getMemoId() %>"
                           style="text-decoration: none; color: inherit;">
                            <h3 class="memo-title"><%= memo.getTitle() %>
                            </h3>
                        </a>
                        <span class="<%= memo.isImportant() ? "starred" : "" %>">
                                    <%= memo.isImportant() ? "★" : "☆" %>
                                </span>
                    </div>
                    <p class="memo-text"><%= memo.getContent() %>
                    </p>
                    <div class="memo-footer">
                        <span class="memo-date"><%= dateFormat.format(memo.getCreatedAt()) %></span>
                        <div class="memo-actions">
                            <a href="memo-edit.jsp?memoId=<%= memo.getMemoId() %>"
                               class="icon-btn edit-btn">수정</a>
                            <a href="memo-do.jsp?action=delete&memoId=<%= memo.getMemoId() %>"
                               onclick="return confirm('정말 이 메모를 삭제하시겠습니까?')"
                               class="icon-btn delete-btn">삭제</a>
                        </div>
                    </div>
                </div>
                <% } %>
                <% } else { %>
                <div class="no-memo">
                    <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                    검색 결과가 없습니다.
                    <% } else if (activeCategory != null) { %>
                    <p>이 카테고리에 메모가 없습니다.</p>
                    <p>
                        <a href="memo-add.jsp?categoryId=<%= activeCategory.getCategoryId() %>"
                           class="btn primary">
                            새 메모 추가하기
                        </a>
                    </p>
                    <% } else { %>
                    <p>카테고리를 선택하거나 생성해주세요.</p>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>
</body>
</html>
