<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Trends Analysis · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/trends.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
    <%@ include file="../fragments/navbar.jsp" %>

    <div id="loading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <div class="container">
        <div class="header">
            <h1>Booking Trends Analysis</h1>
            <p>Data-driven insights for strategic manager planning</p>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <h3><i class="ph ph-chart-line"></i> Booking Volume</h3>
                <canvas id="bookingChart"></canvas>
            </div>
            <div class="card">
                <h3><i class="ph ph-percent"></i> Occupancy Trend</h3>
                <canvas id="occupancyChart"></canvas>
            </div>
        </div>

        <div class="card">
            <h3><i class="ph ph-money"></i> Recent Payments</h3>
            <div class="table-container">
                <table id="paymentsTable">
                    <thead>
                        <tr>
                            <th>Guest</th>
                            <th>Amount</th>
                            <th>Method</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data will be populated by JS -->
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card">
            <h3><i class="ph ph-table"></i> Detailed Monthly Data</h3>
            <div class="table-container">
                <table id="trendTable">
                    <thead>
                        <tr>
                            <th>Year</th>
                            <th>Month</th>
                            <th>Total Bookings</th>
                            <th>Revenue</th>
                            <th>Occupancy %</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data will be populated by JS -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            fetchTrends();
            fetchRecentPayments();
        });

        function fetchTrends() {
            fetch('${pageContext.request.contextPath}/api/manager/dashboard/trends')
                .then(response => {
                    if (!response.ok) throw new Error('Access Denied');
                    return response.json();
                })
                .then(data => {
                    if (data.length > 0) {
                        document.getElementById('loading').style.display = 'none';
                    }
                    renderCharts(data);
                    renderTable(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading trend data: ' + error.message);
                    document.getElementById('loading').style.display = 'none';
                });
        }

        function fetchRecentPayments() {
            fetch('${pageContext.request.contextPath}/api/manager/dashboard/recent-payments')
                .then(response => {
                    if (!response.ok) throw new Error('Access Denied');
                    return response.json();
                })
                .then(data => {
                    renderPaymentsTable(data);
                })
                .catch(error => console.error('Error fetching payments:', error));
        }

        function renderPaymentsTable(data) {
            const tbody = document.querySelector('#paymentsTable tbody');
            tbody.innerHTML = '';
            data.forEach(p => {
                const date = new Date(p.date).toLocaleString();
                const statusClass = (p.status || '').toLowerCase();
                const row = document.createElement('tr');
                row.innerHTML = 
                    '<td>' + (p.guestName || '') + '</td>' +
                    '<td>$' + (p.amount !== undefined ? p.amount.toFixed(2) : '') + '</td>' +
                    '<td>' + (p.method || '') + '</td>' +
                    '<td><span class="status-badge ' + statusClass + '">' + (p.status || '') + '</span></td>' +
                    '<td>' + date + '</td>';
                tbody.appendChild(row);
            });
        }

        function renderCharts(data) {
            // Reverse data to show chronological order
            const chronologicalData = [...data].reverse();
            
            const labels = chronologicalData.map(d => {
                const monthName = new Date(0, d.month - 1).toLocaleString('default', { month: 'short' });
                return monthName + ' ' + d.year;
            });

            // Booking Volume Chart
            new Chart(document.getElementById('bookingChart'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Number of Bookings',
                        data: chronologicalData.map(d => d.bookingCount),
                        backgroundColor: '#c4a96299',
                        borderColor: '#2bb3e6',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
                }
            });

            // Occupancy Trend Chart
            new Chart(document.getElementById('occupancyChart'), {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Occupancy Rate %',
                        data: chronologicalData.map(d => d.occupancyPercentage),
                        borderColor: '#0e4d6e',
                        backgroundColor: '#1e2b3a22',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    scales: { 
                        y: { 
                            beginAtZero: true, 
                            max: 100,
                            ticks: { callback: value => value + '%' }
                        } 
                    }
                }
            });
        }

        function renderTable(data) {
            const tbody = document.querySelector('#trendTable tbody');
            data.forEach(d => {
                const monthName = new Date(0, d.month - 1).toLocaleString('default', { month: 'long' });
                const row = document.createElement('tr');
                row.innerHTML = 
                    '<td>' + (d.year || '') + '</td>' +
                    '<td>' + monthName + '</td>' +
                    '<td><strong>' + (d.bookingCount || 0) + '</strong></td>' +
                    '<td class="trend-up">$' + (d.totalRevenue !== undefined ? d.totalRevenue.toLocaleString() : '0') + '</td>' +
                    '<td>' + (d.occupancyPercentage !== undefined ? d.occupancyPercentage.toFixed(1) : '0') + '%</td>';
                tbody.appendChild(row);
            });
        }
    </script>
</body>
</html>
