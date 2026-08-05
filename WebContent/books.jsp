<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Book, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String userRole = loggedUser.getRole();
    List<Book> bookList = (List<Book>) request.getAttribute("bookList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management - University of Lucknow ERP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css?v=6.0">
    <style>
        .book-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 20px; margin-top: 20px; }
        .book-card { background: var(--bg-card); border: 1px solid var(--border-glass); border-radius: 16px; padding: 20px; transition: var(--transition); }
        .book-card:hover { transform: translateY(-4px); border-color: var(--border-gold); box-shadow: var(--shadow-soft); }
        .book-icon { width: 48px; height: 48px; border-radius: 12px; background: var(--gold-gradient); display:flex; align-items:center; justify-content:center; margin-bottom:12px; color:#000; font-size:1.2rem; box-shadow: var(--gold-glow); }
        .book-title { font-size: 1rem; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
        .book-author { font-size: 0.85rem; color: var(--text-muted); margin-bottom: 12px; }
        .avail-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }
        .avail-yes { background: rgba(16,185,129,0.18); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }
        .avail-no  { background: rgba(239,68,68,0.18); color: #fca5a5; border: 1px solid rgba(239,68,68,0.3); }
        .modal-backdrop { position:fixed; inset:0; background:rgba(0,0,0,0.75); backdrop-filter:blur(6px); display:none; place-items:center; z-index:999; }
        .modal-backdrop.show { display:grid; }
        .modal-box { background: var(--bg-card); border: 1px solid var(--border-gold); border-radius: 20px; padding: 28px; width: 90%; max-width: 480px; }
    </style>
</head>
<body>
    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>
    <div class="app-container glass-container">
        
        <%@ include file="sidebar.jsp" %>

        <main class="main-content">
            <header class="top-navbar">
                <button type="button" class="mobile-toggle-btn" id="mobileMenuToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="welcome-title">
                    <h2><i class="fa-solid fa-book" style="color:var(--gold-light);margin-right:10px;"></i>Library Management</h2>
                    <p>Manage books inventory and lending circulation.</p>
                </div>
                <div style="display:flex;gap:12px;">
                    <a href="library?action=issued" class="btn-demo" style="padding:10px 18px;text-decoration:none;"><i class="fa-solid fa-bookmark"></i> Issued Books</a>
                    <a href="library?action=issue" class="btn-demo" style="padding:10px 18px;text-decoration:none;"><i class="fa-solid fa-hand-holding-heart"></i> Issue Book</a>
                    <% if("ADMIN".equals(userRole)) { %>
                    <button onclick="document.getElementById('addModal').classList.add('show')" class="btn-primary" style="width:auto;padding:10px 18px;">
                        <i class="fa-solid fa-plus"></i> Add Book
                    </button>
                    <% } %>
                </div>
            </header>

            <% if(msg != null) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%=msg%></span></div>
            <% } %>

            <!-- Summary -->
            <div class="glass-card" style="padding:16px 20px;margin-bottom:20px;display:inline-flex;align-items:center;gap:12px;">
                <i class="fa-solid fa-books" style="color:var(--gold-light);font-size:1.3rem;"></i>
                <span style="color:var(--text-secondary);">Total Catalog Books: <strong style="color:var(--gold-light);font-size:1.1rem;"><%=bookList != null ? bookList.size() : 0%></strong></span>
            </div>

            <!-- Book Grid -->
            <div class="book-grid">
                <% if(bookList != null && !bookList.isEmpty()) {
                    for(Book b : bookList) { %>
                <div class="book-card">
                    <div class="book-icon"><i class="fa-solid fa-book"></i></div>
                    <div class="book-title"><%=b.getTitle()%></div>
                    <div class="book-author"><i class="fa-solid fa-feather-pointed" style="margin-right:6px;color:var(--gold);"></i><%=b.getAuthor()%></div>
                    <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px;">
                        <span class="badge-violet"><%=b.getCategory()%></span>
                        <span style="background:rgba(255,255,255,0.07);padding:4px 10px;border-radius:20px;font-size:0.73rem;color:var(--text-muted);">ISBN: <%=b.getIsbn()%></span>
                    </div>
                    <div style="display:flex;justify-content:space-between;align-items:center;">
                        <span style="font-size:0.8rem;color:var(--text-muted);">Total: <%=b.getTotalCopies()%></span>
                        <% if(b.getAvailableCopies() > 0) { %>
                            <span class="avail-badge avail-yes"><i class="fa-solid fa-circle-check"></i> <%=b.getAvailableCopies()%> Available</span>
                        <% } else { %>
                            <span class="avail-badge avail-no"><i class="fa-solid fa-circle-xmark"></i> Out of Stock</span>
                        <% } %>
                    </div>
                </div>
                <% } } else { %>
                <div style="grid-column:1/-1;text-align:center;padding:50px;color:var(--text-muted);">
                    <i class="fa-solid fa-book-open" style="font-size:3rem;display:block;margin-bottom:12px;opacity:0.3;"></i>
                    No books in library catalog yet.
                </div>
                <% } %>
            </div>
        </main>
    </div>

    <!-- Add Book Modal -->
    <div class="modal-backdrop" id="addModal" onclick="if(event.target===this)this.classList.remove('show')">
        <div class="modal-box">
            <h3 style="font-size:1.1rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;">
                <i class="fa-solid fa-plus-circle" style="color:var(--gold);margin-right:8px;"></i>Add New Book
            </h3>
            <form action="library" method="post">
                <input type="hidden" name="action" value="addBook">
                <div class="form-group">
                    <label class="form-label">ISBN</label>
                    <input type="text" name="isbn" class="form-control" placeholder="978-XXXXXXXXXX" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Book Title</label>
                    <input type="text" name="title" class="form-control" placeholder="Enter book title" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Author</label>
                    <input type="text" name="author" class="form-control" placeholder="Author name" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-control" style="padding-left:14px;">
                        <option>Computer Science</option><option>Mathematics</option>
                        <option>Physics</option><option>Chemistry</option>
                        <option>Literature</option><option>Reference</option><option>Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Total Copies</label>
                    <input type="number" name="totalCopies" class="form-control" value="1" min="1" required>
                </div>
                <div style="display:flex;gap:12px;margin-top:20px;">
                    <button type="button" onclick="document.getElementById('addModal').classList.remove('show')" class="btn-demo" style="flex:1;padding:12px;">Cancel</button>
                    <button type="submit" class="btn-primary" style="flex:1;width:auto;"><i class="fa-solid fa-save"></i> Add Book</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
