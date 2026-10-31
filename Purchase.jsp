<%@ page import="java.sql.*" %>
<%@ taglib prefix="c"
    uri="jakarta.tags.core" %>

<%
    String url = "jdbc:mysql://localhost:3306/ticketdb";
    String user = "root";
    String password = "your_password";

    int totalTickets = 0;
    int soldTickets = 0;
    String eventName = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con =
                DriverManager.getConnection(url, user, password);
             PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM events WHERE event_id = 1");
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                eventName = rs.getString("event_name");
                totalTickets = rs.getInt("total_tickets");
                soldTickets = rs.getInt("sold_tickets");
            }
        }
    } catch (Exception e) {
        throw new ServletException(e);
    }

    request.setAttribute("eventName", eventName);
    request.setAttribute("totalTickets", totalTickets);
    request.setAttribute("soldTickets", soldTickets);
    request.setAttribute("availableTickets",
        totalTickets - soldTickets);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Music Concert Tickets</title>
</head>
<body>

<h2>${eventName}</h2>

<c:choose>
    <c:when test="${availableTickets <= 0}">
        <h2>Sold Out!</h2>
        <p>Sorry, all tickets have been sold.</p>
    </c:when>

    <c:otherwise>
        <p>Available Tickets: ${availableTickets}</p>
        <p>Price per ticket: ₹500</p>

        <form action="TicketServlet" method="post">
            <label>Select ticket quantity:</label>

            <select name="quantity" required>
                <c:forEach var="i" begin="1"
                           end="${availableTickets > 10 ? 10 : availableTickets}">
                    <option value="${i}">${i}</option>
                </c:forEach>
            </select>

            <button type="submit">Purchase Tickets</button>
        </form>
    </c:otherwise>
</c:choose>

</body>
</html>
