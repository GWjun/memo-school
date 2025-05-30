<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String memoId = request.getParameter("memo-id");
    String memoTitle = request.getParameter("memo-title");
    String memoImportant = request.getParameter("memo-important");
    String memoContent = request.getParameter("memo-content");
    String memoColor = request.getParameter("memo-color");
    String memoDate = request.getParameter("memo-date");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>메모 관리 시스템 - 메모 확인</title>
    <link rel="stylesheet" href="styles.css"/>
    <style>
      .form-content {
        flex: 1;
        overflow: auto;
        padding: 24px;
      }

      .form-container {
        max-width: 800px;
        margin: 0 auto;
        background-color: <%= memoColor %>;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        padding: 24px;
      }

      .form {
        display: flex;
        flex-direction: column;
        gap: 16px;
      }

      .form-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
      }

      .form-label {
        font-size: 14px;
        font-weight: 500;
        color: #555;
      }

      .form-input,
      .form-textarea {
        width: 100%;
        padding: 8px 12px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
      }

      .form-textarea {
        resize: vertical;
        min-height: 120px;
      }

      .checkbox-container {
        display: flex;
        align-items: center;
      }

      .form-checkbox {
        margin-right: 8px;
      }

      .checkbox-label {
        font-size: 14px;
        color: #555;
      }

      .file-input {
        display: none;
      }

      .file-input-label {
        display: inline-flex;
        align-items: center;
        padding: 8px 16px;
        background-color: #f0f0f0;
        border: 1px solid #ccc;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
      }

      .form-color {
        width: 100%;
        height: 40px;
        border: 1px solid #ccc;
        border-radius: 4px;
      }
    </style>
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
                <h1 class="page-title">메모 확인</h1>
            </div>
        </header>

        <div class="form-content">
            <div class="form-container">
                <div class="form">
                    <div class="form-group">
                        <label for="memo-id" class="form-label">메모 번호</label>
                        <input
                                type="text"
                                id="memo-id"
                                class="form-input"
                                value="<%= memoId %>"
                                disabled
                        />
                    </div>

                    <div class="form-group">
                        <label for="memo-title" class="form-label">제목</label>
                        <input
                                type="text"
                                id="memo-title"
                                name="memo-title"
                                class="form-input"
                                value="<%= memoTitle %>"
                                disabled
                        />
                    </div>

                    <div class="form-group">
                        <label for="memo-important" class="form-label">중요 여부</label>
                        <div class="checkbox-container">
                            <input
                                    type="checkbox"
                                    id="memo-important"
                                    name="memo-important"
                                    class="form-checkbox"
                                    <%= memoImportant != null ? "checked" : "" %>
                                    disabled
                            />
                            <label for="memo-important" class="checkbox-label">
                                중요
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="memo-content" class="form-label">내용</label>
                        <textarea
                                id="memo-content"
                                name="memo-content"
                                class="form-textarea"
                                disabled
                        ><%= memoContent %>
                        </textarea>
                    </div>

                    <div class="form-group">
                        <label for="memo-color" class="form-label">메모 배경색</label>
                        <input
                                type="color"
                                id="memo-color"
                                name="memo-color"
                                class="form-color"
                                value="<%= memoColor %>"
                                disabled
                        />
                    </div>

                    <div class="form-group">
                        <label class="form-label">첨부 그림</label>
                        <div>
                            <input
                                    type="file"
                                    id="memo-image"
                                    class="file-input"
                                    accept="image/*"
                                    disabled
                            />
                            <label for="memo-image" class="file-input-label">
                                이미지 첨부
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="memo-date" class="form-label">작성일</label>
                        <input
                                type="text"
                                id="memo-date"
                                class="form-input"
                                value="<%= memoDate %>"
                                disabled
                        />
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
