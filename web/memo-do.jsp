<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="session-check.jsp" %> <%-- 인증 로직 --%>
<%@ page import="src.bean.Memo, src.db.MemoDB, java.io.File" %>
<%@ page import="src.multipart.MultiPart, src.bean.MyPart" %>
<%@ page import="src.db.TagDB, src.bean.Tag" %>

<%!
    // 태그 처리를 위한 메서드
    private void processTags(String tagsStr, int memoId, TagDB tagDB) throws Exception {
        String[] tagArray = tagsStr.split(",");
        for (String tagName : tagArray) {
            tagName = tagName.trim();
            if (!tagName.isEmpty()) {
                Tag tag = new Tag();
                tag.setTagName(tagName);
                int tagId = tagDB.insertTag(tag);
                if (tagId > 0) {
                    tagDB.addTagToMemo(memoId, tagId);
                }
            }
        }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String resultMessage = "";
    String uploadedFilePath = null;
    MemoDB memoDB = null;
    TagDB tagDB = null;

    try {
        memoDB = new MemoDB();
        tagDB = new TagDB();

        // 요청 타입 확인
        boolean isMultipart = request.getContentType() != null &&
                request.getContentType().startsWith("multipart/form-data");

        // 멀티파트 요청 (메모 추가/수정)
        if (isMultipart && ("add".equals(action) || "edit".equals(action))) {
            // 파일 저장 경로 설정
            String uploadPath = application.getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // 파일 업로드 처리
            MultiPart multiPart = new MultiPart(request.getParts(), uploadPath);

            // 폼 데이터 가져오기
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String categoryIdStr = request.getParameter("categoryId");
            String backgroundColorValue = request.getParameter("backgroundColor");
            String importantValue = request.getParameter("important");
            String memoIdStr = request.getParameter("memoId");
            String removeImageValue = request.getParameter("removeImage");
            String tagsStr = request.getParameter("tags");
            int categoryId = Integer.parseInt(categoryIdStr);

            // 업로드된 이미지 처리
            MyPart imagePart = multiPart.getMyPart("imageFile");
            if (imagePart != null) {
                uploadedFilePath = "uploads/" + imagePart.getSavedFileName();
            }

            // 메모 추가 처리
            if ("add".equals(action)) {
                Memo memo = new Memo();
                memo.setUserId(userId);
                memo.setCategoryId(categoryId);
                memo.setTitle(title);
                memo.setContent(content);
                memo.setImportant(importantValue != null);
                memo.setBackgroundColor(backgroundColorValue);
                if (uploadedFilePath != null) {
                    memo.setImageUrl(uploadedFilePath);
                }

                int newMemoId = memoDB.insertMemo(memo);
                if (newMemoId > 0) {
                    // 태그 처리
                    if (tagsStr != null && !tagsStr.trim().isEmpty()) {
                        processTags(tagsStr, newMemoId, tagDB);
                    }

                    response.sendRedirect("memo-view.jsp?memoId=" + newMemoId);
                    return;
                } else {
                    resultMessage = "메모 등록에 실패했습니다.";
                }
            }
            // 메모 수정 처리
            else if ("edit".equals(action)) {
                int memoId = Integer.parseInt(memoIdStr);
                Memo memo = memoDB.getMemoById(memoId, userId);

                if (memo != null) {
                    memo.setCategoryId(categoryId);
                    memo.setTitle(title);
                    memo.setContent(content);
                    memo.setImportant(importantValue != null);
                    memo.setBackgroundColor(backgroundColorValue);

                    // 이미지 처리
                    if ("true".equals(removeImageValue)) {
                        memo.setImageUrl(null);
                    } else if (uploadedFilePath != null) {
                        memo.setImageUrl(uploadedFilePath);
                    }

                    if (memoDB.updateMemo(memo)) {
                        // 태그 처리 - 기존 태그를 모두 삭제하고 새로운 태그 추가
                        tagDB.removeAllTagsFromMemo(memoId);
                        if (tagsStr != null && !tagsStr.trim().isEmpty()) {
                            processTags(tagsStr, memoId, tagDB);
                        }

                        response.sendRedirect("memo-view.jsp?memoId=" + memoId);
                        return;
                    } else {
                        resultMessage = "메모 수정에 실패했습니다.";
                    }
                } else {
                    resultMessage = "메모를 찾을 수 없거나 권한이 없습니다.";
                }
            }
        }
        // 메모 삭제 처리 (일반 요청)
        else if ("delete".equals(action)) {
            String memoIdStr = request.getParameter("memoId");

            if (memoIdStr != null && !memoIdStr.isEmpty()) {
                int memoId = Integer.parseInt(memoIdStr);
                Memo memo = memoDB.getMemoById(memoId, userId);

                if (memo != null && memo.getUserId() == userId) {
                    // 이미지 파일 삭제
                    if (memo.getImageUrl() != null && !memo.getImageUrl().isEmpty()) {
                        String imagePath = application.getRealPath("/") + memo.getImageUrl();
                        File imageFile = new File(imagePath);
                        if (imageFile.exists()) {
                            imageFile.delete();
                        }
                    }

                    // 메모와 관련된 모든 태그 연결 삭제
                    tagDB.removeAllTagsFromMemo(memoId);

                    // 메모 삭제 및 리다이렉트
                    if (memoDB.deleteMemo(memoId, userId)) {
                        response.sendRedirect("index.jsp?categoryId=" + memo.getCategoryId());
                        return;
                    } else {
                        resultMessage = "메모 삭제에 실패했습니다.";
                    }
                } else {
                    resultMessage = "메모를 찾을 수 없거나 권한이 없습니다.";
                }
            } else {
                resultMessage = "메모 ID가 유효하지 않습니다.";
            }
        } else {
            resultMessage = "지원하지 않는 요청입니다.";
        }

        tagDB.close();
        memoDB.close();
    } catch (Exception e) {
        resultMessage = "오류가 발생했습니다: " + e.getMessage();
        out.print(e);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메모 작업 결과</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/memo-form.css">
</head>
<body>
<div class="result-container">
    <h2>메모 작업 결과</h2>

    <div class="result-message">
        <%= resultMessage %>
    </div>

    <div class="button-group">
        <a href="index.jsp" class="btn primary">메인으로 돌아가기</a>
    </div>
</div>
</body>
</html>
