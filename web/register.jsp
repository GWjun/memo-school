<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="css/common/styles.css">
    <link rel="stylesheet" href="css/common/memo-form.css">
    <link rel="stylesheet" href="css/pages/register.css">
</head>
<body>
<div class="register-container">
    <h1>회원가입</h1>

    <% if (request.getParameter("error") != null) {
        String errorType = request.getParameter("error");
        String errorMessage = "";

        if (errorType.equals("duplicate")) {
            errorMessage = "이미 사용 중인 아이디입니다.";
        } else if (errorType.equals("password")) {
            errorMessage = "비밀번호가 일치하지 않습니다.";
        } else if (errorType.equals("empty")) {
            errorMessage = "모든 필드를 입력해주세요.";
        } else {
            errorMessage = "회원가입 중 오류가 발생했습니다.";
        }
    %>
    <div class="error-message">
        <%= errorMessage %>
    </div>
    <% } %>

    <form action="register-do.jsp" method="post" class="form">
        <div class="form-group">
            <label class="form-label" for="loginId">아이디</label>
            <input class="form-input" type="text" id="loginId" name="loginId" required>
        </div>

        <div class="form-group">
            <label class="form-label" for="password">비밀번호</label>
            <input class="form-input" type="password" id="password" name="password" required>
        </div>

        <div class="form-group">
            <label class="form-label" for="confirmPassword">비밀번호 확인</label>
            <input class="form-input" type="password" id="confirmPassword" name="confirmPassword"
                   required>
        </div>

        <div class="form-group">
            <label class="form-label" for="nickname">닉네임</label>
            <input class="form-input" type="text" id="nickname" name="nickname" required>
        </div>

        <button type="submit" class="btn primary">회원가입</button>
    </form>

    <div class="login-link">
        <a href="login.jsp" style="text-decoration: none; color: gray">로그인</a>
    </div>
</div>
</body>
</html>
