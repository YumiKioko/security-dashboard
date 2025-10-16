const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const WebSocket = require('ws');
const http = require('http');
const SecurityLogger = require('./logger');
const config = require('./config');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });
const logger = new SecurityLogger(config.logLevel);

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(__dirname));

// Request logging middleware
app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url}`, {
        ip: req.ip,
        userAgent: req.get('User-Agent')
    });
    next();
});

// Data storage functions
function loadData(file) {
    try {
        const data = fs.readFileSync(path.join(__dirname, 'data', file), 'utf8');
        return JSON.parse(data);
    } catch (error) {
        logger.error(`Failed to load data from ${file}`, { error: error.message });
        return null;
    }
}

function saveData(file, data) {
    try {
        fs.writeFileSync(path.join(__dirname, 'data', file), JSON.stringify(data, null, 2));
        return true;
    } catch (error) {
        logger.error(`Failed to save data to ${file}`, { error: error.message });
        return false;
    }
}

// Enhanced data generation
function generateSecurityData() {
    const incidents = loadData('incidents.json') || [];
    const compliance = loadData('compliance.json') || { frameworks: {} };
    
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
                confidence: 95,
                ioc: ['C2 communication', 'suspicious process']
            },
            {
                id: 'AV-' + Date.now(),
                name: 'Suspicious IP Activity',
                severity: 'medium',
                source: 'AlienVault OTX',
                target: 'Firewall',
                status: 'Monitored',
                detection: new Date().toISOString(),
                confidence: 82,
                ioc: ['port scanning', 'brute force attempts']
            }
        ],
        incidents: incidents,
        compliance: compliance.frameworks,
        infrastructure: {
            servers: [
                { id: 1, name: 'Web Server 01', status: 'online', cpu: 42, memory: 68, storage: 54, location: 'DC-A', services: ['nginx', 'nodejs'] },
                { id: 2, name: 'DB Server 02', status: 'online', cpu: 28, memory: 45, storage: 72, location: 'DC-B', services: ['postgresql', 'redis'] },
                { id: 3, name: 'App Server 03', status: 'warning', cpu: 78, memory: 82, storage: 35, location: 'DC-A', services: ['java', 'tomcat'] }
            ],
            network: {
                latency: 24,
                packetLoss: 0.2,
                bandwidthUsage: 68,
                status: 'healthy',
                threatsBlocked: 1247
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
                    detection: '10 minutes ago',
                    action: 'quarantined'
                }
            ]
        },
        reports: {
            generated: 15,
            scheduled: 3,
            recent: [
                { id: 'RPT-001', name: 'Weekly Security Overview', date: '2024-01-15', status: 'completed', type: 'security', size: '2.4 MB' },
                { id: 'RPT-002', name: 'Compliance Audit Report', date: '2024-01-14', status: 'completed', type: 'compliance', size: '1.8 MB' }
            ]
        },
        metrics: {
            mttd: '45m',  // Mean Time to Detect
            mttr: '2.5h', // Mean Time to Respond
            sla: '99.9%',
            uptime: '99.99%'
        }
    };
}

// API Endpoints

// Health check with detailed status
app.get('/api/health', (req, res) => {
    const health = {
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        environment: process.env.NODE_ENV || 'development',
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        endpoints: [
            '/api/security-data',
            '/api/incidents',
            '/api/compliance',
            '/api/infrastructure',
            '/api/security-ops',
            '/api/reports'
        ]
    };
    res.json(health);
});

// Complete security data
app.get('/api/security-data', (req, res) => {
    logger.info('Security data requested');
    res.json(generateSecurityData());
});

// Individual endpoints
app.get('/api/incidents', (req, res) => {
    const data = generateSecurityData();
    res.json(data.incidents);
});

app.get('/api/compliance', (req, res) => {
    const data = generateSecurityData();
    res.json(data.compliance);
});

app.get('/api/infrastructure', (req, res) => {
    const data = generateSecurityData();
    res.json(data.infrastructure);
});

app.get('/api/security-ops', (req, res) => {
    const data = generateSecurityData();
    res.json(data.securityOps);
});

app.get('/api/reports', (req, res) => {
    const data = generateSecurityData();
    res.json(data.reports);
});

// Incident management endpoints
app.post('/api/incidents', (req, res) => {
    const newIncident = {
        id: 'INC-' + Date.now(),
        timestamp: new Date().toISOString(),
        status: 'open',
        ...req.body
    };
    
    logger.securityEvent('INCIDENT_CREATED', newIncident);
    res.json(newIncident);
});

// WebSocket for real-time updates
wss.on('connection', (ws) => {
    logger.info('WebSocket connection established');
    
    ws.send(JSON.stringify({
        type: 'CONNECTION_ESTABLISHED',
        message: 'Connected to security data feed',
        timestamp: new Date().toISOString()
    }));

    // Send periodic updates
    const interval = setInterval(() => {
        const update = {
            type: 'DATA_UPDATE',
            timestamp: new Date().toISOString(),
            data: generateSecurityData()
        };
        ws.send(JSON.stringify(update));
    }, config.dataRefreshInterval);

    ws.on('close', () => {
        logger.info('WebSocket connection closed');
        clearInterval(interval);
    });

    ws.on('error', (error) => {
        logger.error('WebSocket error', { error: error.message });
    });
});

// Serve dashboard
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Error handling
app.use((err, req, res, next) => {
    logger.error('Server error', { error: err.message, stack: err.stack });
    res.status(500).json({ error: 'Internal server error' });
});

// 404 handler
app.use((req, res) => {
    logger.warn('404 Not Found', { url: req.url });
    res.status(404).json({ error: 'Endpoint not found' });
});

// Start server
server.listen(config.port, '0.0.0.0', () => {
    logger.info(`🚀 ENHANCED SECURITY DASHBOARD STARTED`, {
        port: config.port,
        environment: process.env.NODE_ENV || 'development',
        features: config.features
    });
    
    console.log('\n📊 SECURITY DASHBOARD STATUS:');
    console.log(`   Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`   Dashboard: http://localhost:${config.port}`);
    console.log(`   API Health: http://localhost:${config.port}/api/health`);
    console.log(`   WebSocket: ws://localhost:${config.wsPort}`);
    console.log(`   Log Level: ${config.logLevel}`);
    console.log('\n🔧 Available Endpoints:');
    console.log('   GET  /api/health          - System health check');
    console.log('   GET  /api/security-data   - Complete security data');
    console.log('   GET  /api/incidents       - Incident data');
    console.log('   GET  /api/compliance      - Compliance data');
    console.log('   POST /api/incidents       - Create new incident');
    console.log('   GET  /api/infrastructure  - Infrastructure data');
    console.log('   GET  /api/security-ops    - Security operations');
    console.log('   GET  /api/reports         - Reports data');
});
