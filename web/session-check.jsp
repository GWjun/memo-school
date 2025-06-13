<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 사용자 정보 확인
    Object userObj = session.getAttribute("user");
    Integer userId = (Integer) session.getAttribute("userId");

    // 로그인 상태 확인
    boolean isLoggedIn = (userObj != null) && (userId != null) && (userId > 0);

    // 로그인이 안 되어 있는 경우 리다이렉트
    if (!isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
