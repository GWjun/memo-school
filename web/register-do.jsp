<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="src.db.UserDB" %>
<%@ page import="src.bean.User" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 폼에서 전송된 데이터 가져오기
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String nickname = request.getParameter("nickname");

    // 값이 비어있는지 확인
    if (loginId == null || password == null || confirmPassword == null || nickname == null ||
            loginId.trim().equals("") || password.trim().equals("") ||
            confirmPassword.trim().equals("") || nickname.trim().equals("")) {
        response.sendRedirect("register.jsp?error=empty");
        return;
    }

    // 비밀번호 확인
    if (!password.equals(confirmPassword)) {
        response.sendRedirect("register.jsp?error=password");
        return;
    }

    try {
        // UserDB 인스턴스 생성
        UserDB userDB = new UserDB();

        try {
            // User 객체 생성
            User user = new User();
            user.setLoginId(loginId);
            user.setPassword(password);
            user.setNickname(nickname);

            // 사용자 등록
            int userId = userDB.insertUser(user);

            if (userId > 0) { // 회원가입 성공
                // 세션에 사용자 정보 저장
                user.setUserId(userId);
                session.setAttribute("user", user);
                session.setAttribute("userId", userId);
                session.setAttribute("nickname", nickname);

                // 세션 유효 시간 설정 (30분)
                session.setMaxInactiveInterval(1800);

                // 메인 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/");
            } else { // 회원가입 실패
                response.sendRedirect("register.jsp?error=failed");
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // 중복된 아이디 예외 처리
            response.sendRedirect("register.jsp?error=duplicate");
        } finally {
            userDB.close();
        }
    } catch (SQLException | NamingException e) {
        response.sendRedirect("register.jsp?error=else");
    }
%>
