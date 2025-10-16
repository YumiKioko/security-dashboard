const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();

// Enable CORS and JSON parsing
app.use(cors());
app.use(express.json());

// Serve static files from current directory
app.use(express.static(__dirname));

// Log all requests for debugging
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();
});

// API endpoints
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        timestamp: new Date().toISOString(),
        message: 'Security Dashboard API is running'
    });
});

app.get('/api/security-data', (req, res) => {
    const data = {
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
                timestamp: new Date().toISOString()
            },
            {
                id: 'INC-' + (Date.now() + 1),
                title: 'Phishing Email Detected',
                description: 'Employee reported suspicious email with attachment',
                priority: 'medium', 
                status: 'investigating',
                timestamp: new Date().toISOString()
            }
        ],
        compliance: {
            iso27001: { score: 82, status: 'Active' },
            nist: { score: 78, status: 'In Progress' },
            gdpr: { score: 91, status: 'Compliant' }
        },
        systemHealth: {
            servers: 156,
            uptime: '99.9%',
            status: 'healthy'
        }
    };
    res.json(data);
});

// Explicitly serve index.html for root route
app.get('/', (req, res) => {
    console.log('Serving index.html...');
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start server
const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log('🚀 SECURITY DASHBOARD SERVER STARTED');
    console.log('📊 Dashboard: http://localhost:' + PORT);
    console.log('🔧 API Health: http://localhost:' + PORT + '/api/health');
    console.log('📡 API Data: http://localhost:' + PORT + '/api/security-data');
    console.log('');
    console.log('📁 Current directory:', __dirname);
    console.log('📄 Files in directory:');
    fs.readdirSync(__dirname).forEach(file => {
        if (file.endsWith('.html') || file.endsWith('.js')) {
            console.log('   - ' + file);
        }
    });
});
