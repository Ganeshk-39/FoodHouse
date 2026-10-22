<%-- 
    ========================================================================
    FILE: Register.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Forwards seamlessly to unified 1-page Auth Portal with 
                 the Register tab automatically selected.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.sendRedirect("Login.jsp?tab=register");
%>
