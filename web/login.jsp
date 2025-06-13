<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/memo-form.css">
    <link rel="stylesheet" href="css/pages/login.css">
</head>
<body>
<div class="login-container">
    <h1>로그인</h1>

    <% if (request.getParameter("error") != null) {
        String errorType = request.getParameter("error");
        String errorMessage = "";

        if (errorType.equals("invalid")) {
            errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";
        } else if (errorType.equals("empty")) {
            errorMessage = "모든 필드를 입력해주세요.";
        } else {
            errorMessage = "로그인 중 오류가 발생했습니다.";
        }
    %>
    <div class="error-message">
        <%= errorMessage %>
    </div>
    <% } %>

    <form action="login-do.jsp" method="post" class="form">
        <div class="form-group">
            <label class="form-label" for="loginId">아이디</label>
            <input class="form-input" type="text" id="loginId" name="loginId" required>
        </div>

        <div class="form-group">
            <label class="form-label" for="password">비밀번호</label>
            <input class="form-input" type="password" id="password" name="password" required>
        </div>

        <button type="submit" class="btn-login">로그인</button>
    </form>

    <div class="register-link">
        <p>계정이 없으신가요? <a href="register.jsp" style="text-decoration: none">회원가입</a></p>
    </div>
</div>
</body>
</html>

