// Configuration file for Security Dashboard
const config = {
    development: {
        port: process.env.PORT || 3000,
        wsPort: process.env.WS_PORT || 8080,
        logLevel: 'debug',
        enableWebSocket: true,
        dataRefreshInterval: 10000, // 10 seconds
        maxIncidents: 100,
        features: {
            realTimeUpdates: true,
            dataExport: true,
            reportGeneration: true
        }
    },
    production: {
        port: process.env.PORT || 3000,
        wsPort: process.env.WS_PORT || 8080,
        logLevel: 'info',
        enableWebSocket: true,
        dataRefreshInterval: 30000, // 30 seconds
        maxIncidents: 1000,
        features: {
            realTimeUpdates: true,
            dataExport: false, // Disable in production for security
            reportGeneration: true
        }
    }
};

module.exports = config[process.env.NODE_ENV || 'development'];
