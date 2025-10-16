const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const WebSocket = require('ws');
const http = require('http');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(cors());
app.use(express.json());
app.use(express.static(__dirname));

// Enhanced data with all sections
function getSecurityData() {
    return {
        timestamp: new Date().toISOString(),
        threats: [
            {
                id: 'CS-' + Date.now(),
                name: 'Malware Beaconing',
                severity: 'high',
                source: 'CrowdStrike',
                target: 'Multiple endpoints',
                status: 'Active',
                detection: new Date().toISOString(),
                confidence: 95
            },
            {
                id: 'AV-' + Date.now(),
                name: 'Suspicious IP Activity',
                severity: 'medium',
                source: 'AlienVault',
                target: 'Firewall',
                status: 'Monitored',
                detection: new Date().toISOString(),
                confidence: 82
            },
            {
                id: 'VT-' + Date.now(),
                name: 'New Malware Hash',
                severity: 'low',
                source: 'VirusTotal',
                target: 'File Server',
                status: 'Blocked',
                detection: new Date().toISOString(),
                confidence: 88
            }
        ],
        incidents: [
            {
                id: 'INC-' + Date.now(),
                title: 'Unauthorized Access Attempt',
                description: 'Multiple failed login attempts from unknown IP',
                priority: 'high',
                status: 'open',
                timestamp: new Date().toISOString(),
                assigned: 'Security Team'
            },
            {
                id: 'INC-' + (Date.now() + 1),
                title: 'Phishing Email Detected',
                description: 'Employee reported suspicious email with attachment',
                priority: 'medium',
                status: 'investigating',
                timestamp: new Date().toISOString(),
                assigned: 'Sarah Chen'
            },
            {
                id: 'INC-' + (Date.now() + 2),
                title: 'Compliance Documentation Update',
                description: 'Quarterly compliance documentation needs review',
                priority: 'low',
                status: 'open',
                timestamp: new Date().toISOString(),
                assigned: 'Elena Rodriguez'
            }
        ],
        compliance: {
            iso27001: { score: 82, controls: 114, status: 'Active' },
            nist: { score: 78, functions: 23, status: 'In Progress' },
            gdpr: { score: 91, status: 'Compliant' }
        },
        infrastructure: {
            servers: [
                { id: 1, name: 'Web Server 01', status: 'online', cpu: 42, memory: 68, storage: 54, location: 'DC-A' },
                { id: 2, name: 'DB Server 02', status: 'online', cpu: 28, memory: 45, storage: 72, location: 'DC-B' },
                { id: 3, name: 'App Server 03', status: 'warning', cpu: 78, memory: 82, storage: 35, location: 'DC-A' },
                { id: 4, name: 'File Server 04', status: 'offline', cpu: 0, memory: 0, storage: 89, location: 'DC-C' }
            ],
            network: {
                latency: 24,
                packetLoss: 0.2,
                bandwidthUsage: 68,
                status: 'healthy'
            }
        },
        securityOps: {
            activeThreats: 23,
            eventsToday: 1247,
            detectionRate: 98.2,
            threats: [
                {
                    id: 1,
                    name: 'Malware Infection',
                    severity: 'high',
                    source: 'External',
                    target: 'Workstation DEV-045',
                    status: 'Active',
                    detection: '10 minutes ago'
                },
                {
                    id: 2,
                    name: 'Phishing Campaign',
                    severity: 'medium',
                    source: 'Email',
                    target: 'Multiple Users',
                    status: 'Monitored',
                    detection: '2 hours ago'
                }
            ]
        },
        reports: {
            generated: 15,
            scheduled: 3,
            recent: [
                { id: 'RPT-001', name: 'Weekly Security Overview', date: '2024-01-15', status: 'completed' },
                { id: 'RPT-002', name: 'Compliance Audit', date: '2024-01-14', status: 'completed' },
                { id: 'RPT-003', name: 'Incident Summary', date: '2024-01-13', status: 'pending' }
            ]
        }
    };
}

// API endpoints
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        timestamp: new Date().toISOString(),
        message: 'Security Dashboard API is running'
    });
});

app.get('/api/security-data', (req, res) => {
    res.json(getSecurityData());
});

app.get('/api/infrastructure', (req, res) => {
    const data = getSecurityData();
    res.json(data.infrastructure);
});

app.get('/api/security-ops', (req, res) => {
    const data = getSecurityData();
    res.json(data.securityOps);
});

app.get('/api/reports', (req, res) => {
    const data = getSecurityData();
    res.json(data.reports);
});

// WebSocket for real-time updates
wss.on('connection', (ws) => {
    console.log('New WebSocket connection');
    
    ws.send(JSON.stringify({
        type: 'CONNECTION_ESTABLISHED',
        message: 'Connected to security data feed'
    }));

    const interval = setInterval(() => {
        const update = {
            type: 'DATA_UPDATE',
            timestamp: new Date().toISOString(),
            data: getSecurityData()
        };
        ws.send(JSON.stringify(update));
    }, 30000);

    ws.on('close', () => {
        console.log('WebSocket connection closed');
        clearInterval(interval);
    });
});

// Serve index.html for root route
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start server
const PORT = 3000;
server.listen(PORT, '0.0.0.0', () => {
    console.log('🚀 ENHANCED SECURITY DASHBOARD SERVER STARTED');
    console.log('📊 Dashboard: http://localhost:' + PORT);
    console.log('🔧 API Health: http://localhost:' + PORT + '/api/health');
    console.log('📡 WebSocket: ws://localhost:8080');
    console.log('');
    console.log('📋 Available endpoints:');
    console.log('   GET /api/security-data  - Complete security data');
    console.log('   GET /api/infrastructure - Infrastructure data');
    console.log('   GET /api/security-ops   - Security operations data');
    console.log('   GET /api/reports        - Reports data');
});
