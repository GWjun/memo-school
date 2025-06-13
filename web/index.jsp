<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>메모 관리 시스템</title>
    <link rel="stylesheet" href="css/common/styles.css"/>
    <link rel="stylesheet" href="css/pages/index.css"/>
</head>
<body>
<div class="container">
    <aside class="sidebar">
        <div class="new-category-container">
            <button class="btn primary">+ 새 카테고리</button>
        </div>

        <nav class="category-nav">
            <ul class="category-list">
                <li class="category-item active">
                    <div class="category-info">
                        <span class="category-name">업무</span>
                        <span class="category-count">(12)</span>
                    </div>
                    <div class="category-actions">
                        <button class="icon-btn edit-btn">수정</button>
                        <button class="icon-btn delete-btn">삭제</button>
                    </div>
                </li>

                <li class="category-item">
                    <div class="category-info">
                        <span class="category-name">개인</span>
                        <span class="category-count">(8)</span>
                    </div>
                    <div class="category-actions">
                        <button class="icon-btn edit-btn">수정</button>
                        <button class="icon-btn delete-btn">삭제</button>
                    </div>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <div class="header-container">
                <h1 class="page-title">업무</h1>
                <div class="header-actions">
                    <input type="text" class="search-input" placeholder="메모 검색"/>

                    <a href="memo-add.html" style="text-decoration: none">
                        <button class="btn primary">+ 새 메모</button>
                    </a>
                </div>
            </div>
        </header>

        <div class="memo-content">
            <div class="memo-grid">
                <div class="memo-card yellow">
                    <div class="memo-header">
                        <h3 class="memo-title">회의 일정 정리</h3>
                        <span class="starred">★</span>
                    </div>
                    <p class="memo-text">다음 주 월요일</p>
                    <div class="memo-footer">
                        <span class="memo-date">2024.02.15</span>
                        <div class="memo-actions">
                            <button class="icon-btn edit-btn">수정</button>
                            <button class="icon-btn delete-btn">삭제</button>
                        </div>
                    </div>
                </div>

                <div class="memo-card yellow">
                    <div class="memo-header">
                        <h3 class="memo-title">프로젝트 체크리스트</h3>
                        <span>☆</span>
                    </div>
                    <p class="memo-text">- 기획안 검토 완료</p>
                    <div class="memo-footer">
                        <span class="memo-date">2024.02.14</span>
                        <div class="memo-actions">
                            <button class="icon-btn edit-btn">수정</button>
                            <button class="icon-btn delete-btn">삭제</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
