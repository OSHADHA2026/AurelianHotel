<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Bill #${booking.id} · Billing · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/bill-detail.css">
                <%@ include file="../fragments/head-assets.jsp" %>
</head>

                <body>
                    <%@ include file="../fragments/navbar.jsp" %>

                        <div class="page">
                            <div class="header">
                                <div>
                                    <h1><i class="ph ph-file-text" style="color:#2bb3e6;"></i> Bill #${booking.id}
                                    </h1>
                                    <p style="color:var(--au-muted); font-size:14px; margin-top:4px;">${booking.guestName} ·
                                        Room ${booking.room.roomNumber}</p>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/admin/billing/${booking.id}/invoice"
                                        class="btn btn-primary" target="_blank" style="margin-right: 8px;">
                                        <i class="ph ph-printer"></i> Preview & Print Bill
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/billing"
                                        class="btn btn-secondary">
                                        <i class="ph ph-arrow-left"></i> Back to Billing
                                    </a>
                                </div>
                            </div>

                            <c:if test="${not empty success}">
                                <div class="alert alert-success"><i class="ph ph-check-circle"></i> ${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-error"><i class="ph ph-warning-circle"></i> ${error}</div>
                            </c:if>
                            <div class="tab-container">
                                <button class="tab-btn active" onclick="switchTab('summary')">Summary & Details</button>
                                <button class="tab-btn" onclick="switchTab('payment')">Process Payment</button>
                                <button class="tab-btn" onclick="switchTab('history')">Payment History</button>
                            </div>

                            <div id="summary" class="tab-pane active">
                                <!-- Details wrapper: User & Room Info -->
                                <div
                                    style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
                                    <div class="card" style="margin-bottom: 0;">
                                        <h2><i class="ph ph-user-circle" style="color:#2bb3e6;"></i> User Details</h2>
                                        <table class="bill-table" style="max-width: 100%; margin-left: 0;">
                                            <tr>
                                                <td>Guest Name</td>
                                                <td style="text-align: right;">${booking.guestName != null ?
                                                    booking.guestName : '-'}</td>
                                            </tr>
                                            <tr>
                                                <td>Registered By</td>
                                                <td style="text-align: right;">${booking.user.username != null ?
                                                    booking.user.username : '-'}</td>
                                            </tr>
                                            <tr>
                                                <td>Contact Number</td>
                                                <td style="text-align: right;">${booking.contactDetails != null ?
                                                    booking.contactDetails : booking.user.phoneNumber}</td>
                                            </tr>
                                            <tr>
                                                <td>Email Address</td>
                                                <td style="text-align: right;">${booking.user.email != null ?
                                                    booking.user.email : '-'}</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="card" style="margin-bottom: 0;">
                                        <h2><i class="ph ph-bed" style="color:#2bb3e6;"></i> Room Details</h2>
                                        <table class="bill-table" style="max-width: 100%; margin-left: 0;">
                                            <tr>
                                                <td>Room Number</td>
                                                <td style="text-align: right;">${booking.room.roomNumber}</td>
                                            </tr>
                                            <tr>
                                                <td>Room Type</td>
                                                <td style="text-align: right;">${booking.room.roomType}</td>
                                            </tr>
                                            <tr>
                                                <td>Check-In</td>
                                                <td style="text-align: right;">${booking.checkInDate}</td>
                                            </tr>
                                            <tr>
                                                <td>Check-Out</td>
                                                <td style="text-align: right;">${booking.checkOutDate}</td>
                                            </tr>
                                            <tr>
                                                <td>Rate per Night</td>
                                                <td style="text-align: right;">
                                                    <fmt:formatNumber value="${booking.room.pricePerNight}"
                                                        type="currency" currencyCode="USD" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                                <!-- Billing section -->
                                <div class="card">
                                    <h2><i class="ph ph-receipt" style="color:#2bb3e6;"></i> Bill summary</h2>
                                    <table class="bill-table">
                                        <tr>
                                            <td>Booking / Reservation ID</td>
                                            <td>#${booking.id}</td>
                                        </tr>
                                        <tr>
                                            <td>Guest name</td>
                                            <td>${booking.guestName != null ? booking.guestName : '-'}</td>
                                        </tr>
                                        <tr>
                                            <td>Room charges</td>
                                            <td>
                                                <fmt:formatNumber value="${booking.roomCharges}" type="currency"
                                                    currencyCode="USD" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Additional services</td>
                                            <td>
                                                <fmt:formatNumber
                                                    value="${booking.additionalCharges != null ? booking.additionalCharges : 0}"
                                                    type="currency" currencyCode="USD" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Subtotal</td>
                                            <td>
                                                <fmt:formatNumber value="${booking.subtotal}" type="currency"
                                                    currencyCode="USD" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Taxes</td>
                                            <td>
                                                <fmt:formatNumber
                                                    value="${booking.taxAmount != null ? booking.taxAmount : 0}"
                                                    type="currency" currencyCode="USD" />
                                            </td>
                                        </tr>
                                        <c:if test="${booking.packageDiscountAmount > 0}">
                                        <tr>
                                            <td>Package Discount (${booking.roomPackage.name})</td>
                                            <td>-
                                                <fmt:formatNumber value="${booking.packageDiscountAmount}" type="currency" currencyCode="USD" />
                                            </td>
                                        </tr>
                                        </c:if>
                                        <tr>
                                            <td>Manual Discount</td>
                                            <td>-
                                                <fmt:formatNumber value="${booking.discountAmount != null ? booking.discountAmount : 0}" type="currency" currencyCode="USD" />
                                            </td>
                                        </tr>
                                        <tr class="total-row">
                                            <td>Total amount</td>
                                            <td>
                                                <fmt:formatNumber value="${booking.billTotal}" type="currency"
                                                    currencyCode="USD" />
                                            </td>
                                        </tr>
                                    </table>

                                    <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #eef7fc;">
                                        <h3 style="font-size: 14px; margin-bottom: 12px;">Apply adjustments</h3>
                                        <div style="display: flex; gap: 24px; flex-wrap: wrap;">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/billing/${booking.id}/discount"
                                                class="inline-form">
                                                <input type="number" name="discountAmount" step="0.01" min="0"
                                                    placeholder="Discount" class="control" style="width:120px;">
                                                <button type="submit" class="btn btn-sm btn-primary">Apply
                                                    discount</button>
                                            </form>
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/billing/${booking.id}/tax"
                                                class="inline-form">
                                                <input type="number" name="taxAmount" step="0.01" min="0"
                                                    placeholder="Tax" class="control" style="width:120px;">
                                                <button type="submit" class="btn btn-sm btn-primary">Apply tax</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="payment" class="tab-pane">
                                <!-- Payment section -->
                                <div class="card">
                                    <h2><i class="ph ph-credit-card" style="color:#2bb3e6;"></i> Record payment</h2>
                                    <p style="margin-bottom: 16px; font-size: 14px; color: var(--au-muted);">Amount due: <span
                                            class="amount-due">
                                            <fmt:formatNumber value="${amountDue}" type="currency" currencyCode="USD" />
                                        </span> (Total paid:
                                        <fmt:formatNumber value="${totalPaid}" type="currency" currencyCode="USD" />)
                                    </p>
                                    <form method="post"
                                        action="${pageContext.request.contextPath}/admin/billing/${booking.id}/payment">
                                        <div class="form-grid">
                                            <div class="group">
                                                <label class="label">Amount <span
                                                        style="color:#e55353;">*</span></label>
                                                <input type="number" name="amount" step="0.01" min="0.01" required
                                                    class="control" placeholder="0.00" value="${amountDueForForm}">
                                            </div>
                                            <div class="group">
                                                <label class="label">Payment method</label>
                                                <select name="paymentMethod" class="select">
                                                    <option value="CASH">Cash</option>
                                                    <option value="CARD">Card</option>
                                                    <option value="ONLINE_TRANSFER">Online transfer</option>
                                                </select>
                                            </div>
                                            <div class="group">
                                                <label class="label">Status</label>
                                                <select name="status" class="select">
                                                    <option value="COMPLETED">Paid</option>
                                                    <option value="PENDING">Pending</option>
                                                    <option value="FAILED">Failed</option>
                                                </select>
                                            </div>
                                            <div class="group">
                                                <label class="label">Transaction reference</label>
                                                <input type="text" name="transactionReference" class="control"
                                                    placeholder="Optional ref no.">
                                            </div>
                                        </div>
                                        <div class="actions">
                                            <button type="submit" class="btn btn-primary"><i class="ph ph-check"></i>
                                                Record payment</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div id="history" class="tab-pane">
                                <!-- Payment history -->
                                <div class="card">
                                    <h2><i class="ph ph-clock-counter-clockwise" style="color:#2bb3e6;"></i> Payment history</h2>
                                    <c:choose>
                                        <c:when test="${empty payments}">
                                            <p style="color:var(--au-muted);">No payments recorded yet.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <ul class="payment-list">
                                                <c:forEach var="p" items="${payments}">
                                                    <li
                                                        style="border-bottom: 1px solid var(--au-line); padding-bottom: 20px; margin-bottom: 20px;">
                                                        <div style="margin-bottom: 10px;">
                                                            <strong style="font-size: 16px;">
                                                                <fmt:formatNumber value="${p.amount}" type="currency"
                                                                    currencyCode="USD" />
                                                            </strong>
                                                            · ${p.paymentMethod} ·
                                                            <span
                                                                style="font-size: 13px; color: var(--au-muted);">${p.paymentDate}</span>
                                                            <c:if test="${not empty p.transactionId}"> · Ref:
                                                                ${p.transactionId}</c:if>
                                                            <c:if test="${not empty p.receiptPath}">
                                                                <span title="Receipt Uploaded"
                                                                    style="color: #2bb3e6; font-weight: 700; margin-left: 8px; font-size: 13px;">
                                                                    <i class="ph ph-folder-open"></i> Slip Available
                                                                </span>
                                                            </c:if>
                                                            <span class="badge ${fn:toLowerCase(p.status)}"
                                                                style="display: inline-block; padding: 4px 10px; border-radius: 2px; font-size: 10px; font-weight: 700; text-transform: uppercase; margin-left: 10px; border: 1px solid #d6e6f0;">
                                                                ${fn:replace(p.status, '_', ' ')}
                                                            </span>
                                                        </div>
                                                        <div
                                                            style="display: flex; align-items: center; gap: 12px; margin: 8px 0; background: var(--au-soft); padding: 10px; border-radius: 3px; border: 1px solid var(--au-line);">
                                                            <c:if test="${not empty p.receiptPath}">
                                                                <div
                                                                    style="display: flex; flex-direction: column; gap: 8px;">
                                                                    <span
                                                                        style="font-size: 11px; font-weight: 600; color: var(--au-muted);"><i
                                                                            class="ph ph-file-text"
                                                                            style="margin-right: 4px;"></i> Customer
                                                                        Uploaded Slip:</span>
                                                                    <div
                                                                        style="display: flex; align-items: center; gap: 8px;">
                                                                        <button onclick="viewSlip('${p.id}')"
                                                                            class="btn btn-sm btn-secondary"
                                                                            style="font-size: 11px; padding: 6px 12px; border-radius: 2px; background: var(--au-soft); border: 1px solid var(--au-line); color: var(--au-text); font-weight: 600;">
                                                                            <i class="ph ph-arrow-square-out"></i>
                                                                            View Payment Slip
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </c:if>

                                                            <c:if test="${empty p.receiptPath}">
                                                                <form
                                                                    onsubmit="return handleReceiptUpload(event, '${p.id}')"
                                                                    class="inline-form"
                                                                    style="gap: 8px; background: var(--au-surface); padding: 6px 12px; border-radius: 2px; border: 1px dotted var(--au-line); flex: 1;">
                                                                    <label style="font-size: 11px; color: var(--au-muted);"><i
                                                                            class="ph ph-paperclip"></i> Missing Slip?
                                                                        Upload here:</label>
                                                                    <input type="file" id="receiptFile-${p.id}"
                                                                        accept=".jpg,.jpeg,.png,.pdf"
                                                                        style="font-size: 11px; max-width: 140px; border: none; background: transparent;"
                                                                        required>
                                                                    <button type="submit" class="btn btn-sm btn-primary"
                                                                        style="padding: 4px 10px; font-size: 11px;">
                                                                        <i class="ph ph-upload-simple"></i> Upload
                                                                    </button>
                                                                </form>
                                                            </c:if>

                                                            <c:if test="${p.status == 'PENDING_VERIFICATION'}">
                                                                <div
                                                                    style="margin-left: auto; display: flex; gap: 8px; padding-left: 12px; border-left: 2px solid var(--au-line);">
                                                                    <form method="post"
                                                                        action="${pageContext.request.contextPath}/admin/billing/payment/${p.id}/status"
                                                                        style="margin:0;">
                                                                        <input type="hidden" name="bookingId"
                                                                            value="${booking.id}" />
                                                                        <input type="hidden" name="status"
                                                                            value="COMPLETED" />
                                                                        <button type="submit"
                                                                            class="status-btn btn-approve">
                                                                            <i class="ph ph-check-circle"></i> Accept
                                                                            Payment
                                                                        </button>
                                                                    </form>
                                                                    <form method="post"
                                                                        action="${pageContext.request.contextPath}/admin/billing/payment/${p.id}/status"
                                                                        style="margin:0;">
                                                                        <input type="hidden" name="bookingId"
                                                                            value="${booking.id}" />
                                                                        <input type="hidden" name="status"
                                                                            value="FAILED" />
                                                                        <button type="submit"
                                                                            class="status-btn btn-reject">
                                                                            <i class="ph ph-x-circle"></i> Reject
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </c:if>
                                                        </div>

                                                        <c:if test="${p.status != 'PENDING_VERIFICATION'}">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/admin/billing/payment/${p.id}/status"
                                                                class="inline-form" style="margin-top: 8px;">
                                                                <input type="hidden" name="bookingId"
                                                                    value="${booking.id}" />
                                                                <select name="status" class="select"
                                                                    style="width:auto; font-size: 11px; padding: 4px 8px;">
                                                                    <option value="COMPLETED" ${p.status=='COMPLETED'
                                                                        ? 'selected' : '' }>Paid</option>
                                                                    <option value="PENDING" ${p.status=='PENDING'
                                                                        ? 'selected' : '' }>Pending</option>
                                                                    <option value="PENDING_VERIFICATION"
                                                                        ${p.status=='PENDING_VERIFICATION' ? 'selected'
                                                                        : '' }>Pending Verification</option>
                                                                    <option value="FAILED" ${p.status=='FAILED'
                                                                        ? 'selected' : '' }>Failed</option>
                                                                </select>
                                                                <button type="submit" class="btn btn-sm btn-secondary"
                                                                    style="padding: 4px 10px; font-size: 11px;">Update
                                                                    Status</button>
                                                            </form>
                                                        </c:if>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        </div>

                        <%@ include file="../fragments/footer.jsp" %>

                            <div class="preview-modal" id="receiptPreviewModal">
                                <div class="preview-content">
                                    <span class="preview-close" onclick="closePreview()">&times;</span>
                                    <h3
                                        style="margin-bottom: 12px; font-size: 16px; border-bottom: 1px solid #eee; padding-bottom: 8px;">
                                        Payment Slip Preview</h3>
                                    <div id="previewBody"
                                        style="min-width: 400px; min-height: 400px; overflow: auto; display: flex; justify-content: center; align-items: flex-start;">
                                        <p style="color: var(--au-muted); margin-top: 50px;">Loading preview...</p>
                                    </div>
                                </div>
                            </div>

                            <script>
                                function switchTab(tabId) {
                                    // Hide all tab panes
                                    document.querySelectorAll('.tab-pane').forEach(pane => {
                                        pane.classList.remove('active');
                                    });
                                    // Deactivate all tab buttons
                                    document.querySelectorAll('.tab-btn').forEach(btn => {
                                        btn.classList.remove('active');
                                    });

                                    // Show selected tab pane
                                    const targetPane = document.getElementById(tabId);
                                    if (targetPane) {
                                        targetPane.classList.add('active');
                                    }

                                    // Activate corresponding tab button
                                    const targetBtn = document.querySelector('.tab-btn[onclick="switchTab(\'' + tabId + '\')"]');
                                    if (targetBtn) {
                                        targetBtn.classList.add('active');
                                    }
                                }

                                function viewSlip(paymentId) {
                                    const url = '<%= request.getContextPath() %>/api/admin/payments/' + paymentId + '/slip';
                                    window.open(url, '_blank');
                                }

                                function closePreview() {
                                    document.getElementById('receiptPreviewModal').style.display = 'none';
                                    document.getElementById('previewBody').innerHTML = '';
                                }

                                async function handleReceiptUpload(event, paymentId) {
                                    event.preventDefault();
                                    const fileInput = document.getElementById('receiptFile-' + paymentId);
                                    if (!fileInput.files.length) return false;

                                    const formData = new FormData();
                                    formData.append('file', fileInput.files[0]);

                                    const btn = event.target.querySelector('button');
                                    const originalHtml = btn.innerHTML;
                                    btn.disabled = true;
                                    btn.innerHTML = '<i class="ph ph-spinner ph-spin"></i> Uploading...';

                                    try {
                                        const response = await fetch('<%= request.getContextPath() %>/api/admin/payments/' + paymentId + '/upload-receipt', {
                                            method: 'POST',
                                            body: formData
                                        });
                                        const result = await response.json();
                                        if (result.success) {
                                            alert(result.message);
                                            location.reload();
                                        } else {
                                            alert('Error: ' + result.message);
                                            btn.disabled = false;
                                            btn.innerHTML = originalHtml;
                                        }
                                    } catch (error) {
                                        alert('An unexpected error occurred during upload.');
                                        btn.disabled = false;
                                        btn.innerHTML = originalHtml;
                                    }
                                    return false;
                                }
                            </script>
                </body>

                </html>
