<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="myBean.db.UserDB" %>
<%@ page import="myBean.bean.User" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.naming.NamingException" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 폼에서 전송된 데이터 가져오기
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");

    // 값이 비어있는지 확인
    if (loginId == null || password == null || loginId.trim().equals("") || password.trim()
            .equals("")) {
        response.sendRedirect("login.jsp?error=empty");
        return;
    }

    try {
        // UserDB 인스턴스 생성
        UserDB userDB = new UserDB();

        try {
            // 로그인 시도
            User user = userDB.login(loginId, password);

            if (user != null) { // 로그인 성공 시
                // 세션에 사용자 정보 저장
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("nickname", user.getNickname());

                // 세션 유효 시간 설정 (30분)
                session.setMaxInactiveInterval(1800);

                // 요청된 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/");
            } else { // 로그인 실패
                response.sendRedirect("login.jsp?error=invalid");
            }
        } finally {
            userDB.close();
        }
    } catch (SQLException | NamingException e) {
        response.sendRedirect("login.jsp?error=else");
    }
%>
