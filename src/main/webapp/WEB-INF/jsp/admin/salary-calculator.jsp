<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salary Calculator · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/salary-calculator.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
    <jsp:include page="../fragments/navbar.jsp" />
    <div class="container">
        <div class="header">
            <div class="header-text">
                <h1>Salary Calculator</h1>
                <p style="color: var(--au-muted);">Calculate monthly payroll for hotel staff</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">
                <i class="ph ph-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="calculator-card">
            <div class="form-grid">
                <div class="input-group full-width">
                    <label>Employee Name</label>
                    <select class="input-field" id="staffSelect">
                        <option value="">-- Select Staff Member --</option>
                        <c:forEach var="s" items="${allStaff}">
                            <option value="${s.id}">${s.displayName} (${s.jobRole})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="input-group">
                    <label>Basic Salary ($)</label>
                    <input type="number" id="basic" class="input-field" value="0">
                </div>
                <div class="input-group">
                    <label>Allowances ($)</label>
                    <input type="number" id="allowance" class="input-field" value="0">
                </div>
                <div class="input-group">
                    <label>OT Hours</label>
                    <input type="number" id="otHours" class="input-field" value="0">
                </div>
                <div class="input-group">
                    <label>OT Rate ($/hr)</label>
                    <input type="number" id="otRate" class="input-field" value="0">
                </div>
                <div class="input-group">
                    <label>Deductions ($)</label>
                    <input type="number" id="deductions" class="input-field" value="0">
                </div>
                <div class="input-group">
                    <label>Bonus ($)</label>
                    <input type="number" id="bonus" class="input-field" value="0">
                </div>

                <button class="calc-btn" onclick="calculate()">
                    <i class="ph ph-equals"></i> Calculate Net Pay
                </button>
            </div>

            <div id="result" class="result-section">
                <p style="color: var(--au-muted); font-weight: 600;">Net Salary for <span id="resName" style="color: #2bb3e6;">Employee</span></p>
                <div class="result-value" id="resVal">$0.00</div>
                <p style="font-size: 13px; color: var(--au-muted);">Basic + (OT*Rate) + Allowance + Bonus - Deductions</p>
            </div>
        </div>
    </div>

    <script>
        function calculate() {
            const select = document.getElementById('staffSelect');
            if (!select.value) { alert('Please select an employee'); return; }
            
            const b = parseFloat(document.getElementById('basic').value) || 0;
            const a = parseFloat(document.getElementById('allowance').value) || 0;
            const oh = parseFloat(document.getElementById('otHours').value) || 0;
            const or = parseFloat(document.getElementById('otRate').value) || 0;
            const d = parseFloat(document.getElementById('deductions').value) || 0;
            const bo = parseFloat(document.getElementById('bonus').value) || 0;
            
            const total = b + (oh * or) + a + bo - d;
            
            document.getElementById('resName').innerText = select.options[select.selectedIndex].text.split(' (')[0];
            document.getElementById('resVal').innerText = '$' + total.toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2});
            document.getElementById('result').style.display = 'block';
        }
    </script>
</body>
</html>
