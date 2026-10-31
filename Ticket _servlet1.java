import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/TicketServlet")
public class TicketServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {
        int qty = Integer.parseInt(req.getParameter("qty"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ticketdb",
                "root", "your_password");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM events");
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int total = rs.getInt("total_tickets");
                int sold = rs.getInt("sold_tickets");

                if (sold + qty <= total && qty > 0) {
                    PreparedStatement up = con.prepareStatement(
                        "UPDATE events SET sold_tickets=?");
                    up.setInt(1, sold + qty);
                    up.executeUpdate();

                    req.setAttribute("message",
                        "Booking Successful! Total Price: Rs. " + qty * 500);
                } else {
                    req.setAttribute("message", "Tickets Not Available");
                }
            }

            con.close();
        } catch (Exception e) {
            req.setAttribute("message", "Error: " + e.getMessage());
        }

        req.getRequestDispatcher("result.jsp").forward(req, res);
    }
}
