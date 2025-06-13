<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 세션 초기화
    session.invalidate();

    // 로그인 페이지로 리다이렉트
    response.sendRedirect("login.jsp");
%>
