package servlet;

import dao.DepartmentDAO;
import dao.FeeDAO;
import dao.StudentDAO;
import model.Department;
import model.FeeStructure;
import model.Payment;
import model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/fees")
public class FeesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeeDAO feeDAO;
    private DepartmentDAO departmentDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        feeDAO = new FeeDAO();
        departmentDAO = new DepartmentDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "pending";

        switch (action) {
            case "structure":
                showStructure(request, response);
                break;
            case "pay":
                showPayForm(request, response);
                break;
            case "receipt":
                showReceipt(request, response);
                break;
            case "pending":
            default:
                showPendingReport(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("saveStructure".equals(action)) {
            saveFeeStructure(request, response);
        } else if ("recordPayment".equals(action) || "processPayment".equals(action)) {
            recordFeePayment(request, response);
        }
    }

    private void showStructure(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<FeeStructure> feeList = feeDAO.getAllFeeStructures();
        List<Department> deptList = departmentDAO.getAllDepartments();
        request.setAttribute("feeList", feeList);
        request.setAttribute("deptList", deptList);
        request.getRequestDispatcher("fee-structure.jsp").forward(request, response);
    }

    private void showPayForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Student> studentList = studentDAO.getAllStudents();
        request.setAttribute("studentList", studentList);

        String sIdParam = request.getParameter("studentId");
        if (sIdParam != null && !sIdParam.isEmpty()) {
            int studentId = Integer.parseInt(sIdParam);
            Student student = studentDAO.getStudentById(studentId);
            request.setAttribute("selectedStudent", student);
        }
        request.getRequestDispatcher("pay-fee.jsp").forward(request, response);
    }

    private void showPendingReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Map<String, Object>> pendingList = feeDAO.getPendingFeeReport();
        request.setAttribute("pendingList", pendingList);
        request.getRequestDispatcher("pending-fees.jsp").forward(request, response);
    }

    private void showReceipt(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String receiptNo = request.getParameter("receiptNo");
        if (receiptNo != null) {
            Payment payment = feeDAO.getPaymentByReceipt(receiptNo);
            request.setAttribute("payment", payment);
        }
        request.getRequestDispatcher("fee-receipt.jsp").forward(request, response);
    }

    private void saveFeeStructure(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        int semester = Integer.parseInt(request.getParameter("semester"));
        double tuitionFee = Double.parseDouble(request.getParameter("tuitionFee"));
        double otherFee = Double.parseDouble(request.getParameter("otherFee"));

        FeeStructure fs = new FeeStructure(0, deptId, semester, tuitionFee, 0, otherFee, 0);
        feeDAO.saveFeeStructure(fs);
        response.sendRedirect("fees?action=structure&msg=Fee+Structure+Saved+Successfully");
    }

    private void recordFeePayment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        double amountPaid = Double.parseDouble(request.getParameter("amountPaid"));
        String paymentMode = request.getParameter("paymentMode");
        String transactionId = request.getParameter("transactionId");
        String remarks = request.getParameter("remarks");
        Date payDate = Date.valueOf(LocalDate.now());

        Payment p = new Payment(0, "", studentId, amountPaid, payDate, paymentMode, transactionId, remarks);
        String receiptNo = feeDAO.recordPayment(p);

        if (receiptNo != null) {
            response.sendRedirect("fees?action=receipt&receiptNo=" + receiptNo + "&msg=Payment+Processed+Successfully");
        } else {
            response.sendRedirect("fees?action=pay&error=Payment+Failed");
        }
    }
}
