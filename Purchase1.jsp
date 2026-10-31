<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<body>
<h2>Music Concert Ticket Booking</h2>

<c:choose>
    <c:when test="${soldOut}">
        <h2>Sold Out!</h2>
    </c:when>

    <c:otherwise>
        <form action="TicketServlet" method="post">
            Number of Tickets:
            <input type="number" name="qty" min="1" required>
            <input type="submit" value="Book Tickets">
        </form>
    </c:otherwise>
</c:choose>

</body>
</html>
