#!/bin/bash
cd ~/security-dashboard

# Create a new index.html with all pages
cat > index-full.html << 'FULL_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Security Operations Platform</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg-primary: #0a0e27; --bg-secondary: #151b3d; --bg-tertiary: #1e2749;
            --text-primary: #e8eaf6; --text-secondary: #9fa8da; --accent-blue: #2196f3;
            --accent-cyan: #00bcd4; --success: #4caf50; --warning: #ff9800; --danger: #f44336;
            --border: rgba(255, 255, 255, 0.08); --shadow: rgba(0, 0, 0, 0.3);
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, var(--bg-primary) 0%, #0d1128 100%);
            color: var(--text-primary); line-height: 1.6;
        }
        .app-container { display: grid; grid-template-columns: 260px 1fr; min-height: 100vh; }
        .sidebar { background: var(--bg-secondary); border-right: 1px solid var(--border); padding: 20px; }
        .brand { display: flex; align-items: center; gap: 12px; margin-bottom: 30px; }
        .brand-icon { width: 40px; height: 40px; background: linear-gradient(135deg, var(--accent-blue), var(--accent-cyan)); border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .brand-name { font-size: 18px; font-weight: 700; }
        .nav-section { margin-bottom: 24px; }
        .nav-section-title { font-size: 11px; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; margin-bottom: 4px; border-radius: 8px; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .nav-item:hover { background: var(--bg-tertiary); color: var(--text-primary); }
        .nav-item.active { background: var(--bg-tertiary); color: var(--accent-blue); }
        .main-content { padding: 32px; overflow-y: auto; }
        .page-header { margin-bottom: 32px; }
        .page-title { font-size: 32px; font-weight: 700; margin-bottom: 8px; background: linear-gradient(135deg, var(--text-primary), var(--accent-cyan)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .page-subtitle { color: var(--text-secondary); font-size: 14px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 12px; padding: 24px; position: relative; transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-card::before { content: ""; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--accent-blue), var(--accent-cyan)); }
        .stat-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px; }
        .stat-icon { width: 48px; height: 48px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; background: linear-gradient(135deg, rgba(33, 150, 243, 0.2), rgba(0, 188, 212, 0.2)); color: var(--accent-cyan); }
        .stat-value { font-size: 36px; font-weight: 700; margin-bottom: 4px; }
        .stat-label { color: var(--text-secondary); font-size: 14px; }
        .content-section { background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 12px; padding: 24px; margin-bottom: 24px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border); }
        .section-title { font-size: 20px; font-weight: 600; }
        .server-grid, .threat-grid, .reports-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .server-card, .threat-card, .report-card { background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 10px; padding: 20px; }
        .server-status { padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .status-online { background: rgba(76, 175, 80, 0.2); color: var(--success); }
        .status-warning { background: rgba(255, 152, 0, 0.2); color: var(--warning); }
        .status-offline { background: rgba(244, 67, 54, 0.2); color: var(--danger); }
        .threat-severity { padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .severity-high { background: rgba(244, 67, 54, 0.2); color: var(--danger); }
        .severity-medium { background: rgba(255, 152, 0, 0.2); color: var(--warning); }
        .severity-low { background: rgba(33, 150, 243, 0.2); color: var(--accent-blue); }
        .page-view { display: none; }
        .page-view.active { display: block; animation: fadeIn 0.3s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .btn { padding: 12px 24px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
        .btn-primary { background: linear-gradient(135deg, var(--accent-blue), var(--accent-cyan)); color: white; }
        .btn-secondary { background: var(--bg-tertiary); color: var(--text-primary); border: 1px solid var(--border); }
    </style>
</head>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="brand">
                <div class="brand-icon"><i class="fas fa-shield-alt"></i></div>
                <div class="brand-name">SecureOps</div>
            </div>
            <nav class="nav">
                <div class="nav-section">
                    <div class="nav-section-title">Overview</div>
                    <div class="nav-item active" data-page="dashboard"><i class="fas fa-chart-line"></i><span>Dashboard</span></div>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Management</div>
                    <div class="nav-item" data-page="compliance"><i class="fas fa-balance-scale"></i><span>Compliance</span></div>
                    <div class="nav-item" data-page="incidents"><i class="fas fa-exclamation-triangle"></i><span>Incidents</span></div>
                    <div class="nav-item" data-page="reports"><i class="fas fa-file-alt"></i><span>Reports</span></div>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Operations</div>
                    <div class="nav-item" data-page="infrastructure"><i class="fas fa-server"></i><span>Infrastructure</span></div>
                    <div class="nav-item" data-page="security"><i class="fas fa-lock"></i><span>Security Ops</span></div>
                </div>
            </nav>
        </aside>

        <main class="main-content">
            <!-- Dashboard Page -->
            <div class="page-view active" id="dashboard">
                <div class="page-header">
                    <h1 class="page-title">Security Dashboard</h1>
                    <p class="page-subtitle">Real-time overview of your security posture</p>
                </div>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="dash-threats">0</div><div class="stat-label">Active Threats</div></div>
                            <div class="stat-icon"><i class="fas fa-shield-virus"></i></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="dash-incidents">0</div><div class="stat-label">Open Incidents</div></div>
                            <div class="stat-icon"><i class="fas fa-exclamation-triangle"></i></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="dash-compliance">0%</div><div class="stat-label">Compliance Score</div></div>
                            <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="dash-servers">0</div><div class="stat-label">Servers Online</div></div>
                            <div class="stat-icon"><i class="fas fa-server"></i></div>
                        </div>
                    </div>
                </div>
                <div class="content-section">
                    <div class="section-header"><h2 class="section-title">Recent Activity</h2></div>
                    <div id="recent-activity">Loading...</div>
                </div>
            </div>

            <!-- Infrastructure Page -->
            <div class="page-view" id="infrastructure">
                <div class="page-header">
                    <h1 class="page-title">Infrastructure Monitoring</h1>
                    <p class="page-subtitle">Monitor system and network health</p>
                </div>
                <div class="content-section">
                    <div class="section-header"><h2 class="section-title">Server Status</h2></div>
                    <div class="server-grid" id="server-grid">Loading servers...</div>
                </div>
                <div class="content-section">
                    <div class="section-header"><h2 class="section-title">Network Health</h2></div>
                    <div id="network-health">Loading network data...</div>
                </div>
            </div>

            <!-- Security Ops Page -->
            <div class="page-view" id="security">
                <div class="page-header">
                    <h1 class="page-title">Security Operations</h1>
                    <p class="page-subtitle">Monitor threats and security events</p>
                </div>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="ops-threats">0</div><div class="stat-label">Active Threats</div></div>
                            <div class="stat-icon"><i class="fas fa-shield-virus"></i></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="ops-events">0</div><div class="stat-label">Events Today</div></div>
                            <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div><div class="stat-value" id="ops-detection">0%</div><div class="stat-label">Detection Rate</div></div>
                            <div class="stat-icon"><i class="fas fa-radar"></i></div>
                        </div>
                    </div>
                </div>
                <div class="content-section">
                    <div class="section-header"><h2 class="section-title">Active Threats</h2></div>
                    <div class="threat-grid" id="threat-grid">Loading threats...</div>
                </div>
            </div>

            <!-- Reports Page -->
            <div class="page-view" id="reports">
                <div class="page-header">
                    <h1 class="page-title">Security Reports</h1>
                    <p class="page-subtitle">Generate and download security reports</p>
                </div>
                <div class="content-section">
                    <div class="section-header"><h2 class="section-title">Recent Reports</h2></div>
                    <div class="reports-grid" id="reports-grid">Loading reports...</div>
                </div>
                <div class="content-section">
                    <div class="section-header"><h2 class="section-title">Generate New Report</h2></div>
                    <button class="btn btn-primary"><i class="fas fa-file-pdf"></i> Generate Security Report</button>
                </div>
            </div>
        </main>
    </div>

    <script>
        const SecurityDashboard = {
            currentPage: 'dashboard',
            
            init() {
                this.setupNavigation();
                this.loadData();
                console.log("🚀 Full Security Dashboard initialized");
            },

            setupNavigation() {
                document.querySelectorAll(".nav-item").forEach(item => {
                    item.addEventListener("click", (e) => {
                        const page = item.dataset.page;
                        this.navigateTo(page);
                    });
                });
            },

            navigateTo(page) {
                document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
                document.querySelectorAll(".page-view").forEach(p => p.classList.remove("active"));
                
                document.querySelector(`[data-page="${page}"]`).classList.add("active");
                document.getElementById(page).classList.add("active");
                this.currentPage = page;
                
                // Load specific data for each page
                if (page === 'infrastructure') this.loadInfrastructure();
                if (page === 'security') this.loadSecurityOps();
                if (page === 'reports') this.loadReports();
            },

            async loadData() {
                try {
                    const response = await fetch("/api/security-data");
                    const data = await response.json();
                    this.updateDashboard(data);
                } catch (error) {
                    console.error("Failed to load data:", error);
                }
            },

            async loadInfrastructure() {
                try {
                    const response = await fetch("/api/infrastructure");
                    const data = await response.json();
                    this.renderInfrastructure(data);
                } catch (error) {
                    console.error("Failed to load infrastructure data:", error);
                }
            },

            async loadSecurityOps() {
                try {
                    const response = await fetch("/api/security-ops");
                    const data = await response.json();
                    this.renderSecurityOps(data);
                } catch (error) {
                    console.error("Failed to load security ops data:", error);
                }
            },

            async loadReports() {
                try {
                    const response = await fetch("/api/reports");
                    const data = await response.json();
                    this.renderReports(data);
                } catch (error) {
                    console.error("Failed to load reports data:", error);
                }
            },

            updateDashboard(data) {
                // Update main stats
                document.getElementById("dash-threats").textContent = data.threats?.length || 0;
                document.getElementById("dash-incidents").textContent = data.incidents?.length || 0;
                document.getElementById("dash-servers").textContent = data.infrastructure?.servers?.filter(s => s.status === 'online').length || 0;
                
                // Update compliance score
                if (data.compliance) {
                    const scores = Object.values(data.compliance).map(c => c.score);
                    const avgScore = Math.round(scores.reduce((a, b) => a + b, 0) / scores.length);
                    document.getElementById("dash-compliance").textContent = avgScore + '%';
                }

                // Update recent activity
                if (data.incidents && data.incidents.length > 0) {
                    const recentHtml = data.incidents.slice(0, 3).map(incident => `
                        <div style="background: var(--bg-tertiary); padding: 15px; margin: 10px 0; border-radius: 8px; border-left: 4px solid ${incident.priority === 'high' ? '#f44336' : incident.priority === 'medium' ? '#ff9800' : '#2196f3'}">
                            <strong>${incident.title}</strong>
                            <div style="color: var(--text-secondary); font-size: 14px;">${incident.description}</div>
                        </div>
                    `).join("");
                    document.getElementById("recent-activity").innerHTML = recentHtml;
                }
            },

            renderInfrastructure(data) {
                // Render servers
                if (data.servers) {
                    const serversHtml = data.servers.map(server => `
                        <div class="server-card">
                            <div style="display: flex; justify-content: between; align-items: center; margin-bottom: 15px;">
                                <strong>${server.name}</strong>
                                <span class="server-status status-${server.status}">${server.status.toUpperCase()}</span>
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                                <div><small>CPU: ${server.cpu}%</small></div>
                                <div><small>Memory: ${server.memory}%</small></div>
                                <div><small>Storage: ${server.storage}%</small></div>
                                <div><small>Location: ${server.location}</small></div>
                            </div>
                        </div>
                    `).join("");
                    document.getElementById("server-grid").innerHTML = serversHtml;
                }

                // Render network health
                if (data.network) {
                    const networkHtml = `
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                            <div style="text-align: center;">
                                <div style="font-size: 2em; font-weight: bold;">${data.network.latency}ms</div>
                                <div style="color: var(--text-secondary);">Latency</div>
                            </div>
                            <div style="text-align: center;">
                                <div style="font-size: 2em; font-weight: bold;">${data.network.packetLoss}%</div>
                                <div style="color: var(--text-secondary);">Packet Loss</div>
                            </div>
                            <div style="text-align: center;">
                                <div style="font-size: 2em; font-weight: bold;">${data.network.bandwidthUsage}%</div>
                                <div style="color: var(--text-secondary);">Bandwidth</div>
                            </div>
                        </div>
                    `;
                    document.getElementById("network-health").innerHTML = networkHtml;
                }
            },

            renderSecurityOps(data) {
                // Update stats
                document.getElementById("ops-threats").textContent = data.activeThreats || 0;
                document.getElementById("ops-events").textContent = data.eventsToday || 0;
                document.getElementById("ops-detection").textContent = (data.detectionRate || 0) + '%';

                // Render threats
                if (data.threats) {
                    const threatsHtml = data.threats.map(threat => `
                        <div class="threat-card">
                            <div style="display: flex; justify-content: between; align-items: center; margin-bottom: 15px;">
                                <strong>${threat.name}</strong>
                                <span class="threat-severity severity-${threat.severity}">${threat.severity.toUpperCase()}</span>
                            </div>
                            <div style="color: var(--text-secondary); font-size: 14px;">
                                <div>Source: ${threat.source}</div>
                                <div>Target: ${threat.target}</div>
                                <div>Status: ${threat.status}</div>
                                <div>Detected: ${threat.detection}</div>
                            </div>
                        </div>
                    `).join("");
                    document.getElementById("threat-grid").innerHTML = threatsHtml;
                }
            },

            renderReports(data) {
                if (data.recent) {
                    const reportsHtml = data.recent.map(report => `
                        <div class="report-card">
                            <div style="margin-bottom: 15px;">
                                <strong>${report.name}</strong>
                                <div style="color: var(--text-secondary); font-size: 12px;">ID: ${report.id}</div>
                            </div>
                            <div style="display: flex; justify-content: between; align-items: center;">
                                <span style="color: var(--text-secondary);">${report.date}</span>
                                <span style="background: ${report.status === 'completed' ? 'rgba(76, 175, 80, 0.2)' : 'rgba(255, 152, 0, 0.2)'}; color: ${report.status === 'completed' ? '#4caf50' : '#ff9800'}; padding: 4px 8px; border-radius: 8px; font-size: 12px;">
                                    ${report.status.toUpperCase()}
                                </span>
                            </div>
                        </div>
                    `).join("");
                    document.getElementById("reports-grid").innerHTML = reportsHtml;
                }
            }
        };

        document.addEventListener("DOMContentLoaded", () => SecurityDashboard.init());
    </script>
</body>
</html>
FULL_EOF

# Replace the old index.html
mv index-full.html index.html
echo "✅ Full dashboard with all pages created!"
