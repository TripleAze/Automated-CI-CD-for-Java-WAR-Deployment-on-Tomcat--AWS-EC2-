<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Simple Java Web App</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background-color: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
        h1 { color: #2c3e50; }
        p { color: #7f8c8d; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello from Jenkins CI/CD!</h1>
        <p>Current server time: <%= new Date() %></p>
        <p>This application was deployed automatically to Tomcat on EC2.</p>
        <p style="color: #27ae60; font-weight: bold;">✅ Pipeline Test: Verification Successful!</p>
    </div>
</body>
</html>
