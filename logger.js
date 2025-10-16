// Enhanced logging system for Security Dashboard
const logLevels = {
    error: 0,
    warn: 1,
    info: 2,
    debug: 3
};

class SecurityLogger {
    constructor(level = 'info') {
        this.level = level;
        this.levels = logLevels;
    }

    shouldLog(level) {
        return this.levels[level] <= this.levels[this.level];
    }

    formatMessage(level, message, meta = {}) {
        const timestamp = new Date().toISOString();
        return `[${timestamp}] [${level.toUpperCase()}] ${message} ${Object.keys(meta).length ? JSON.stringify(meta) : ''}`;
    }

    error(message, meta = {}) {
        if (this.shouldLog('error')) {
            console.error(this.formatMessage('error', message, meta));
        }
    }

    warn(message, meta = {}) {
        if (this.shouldLog('warn')) {
            console.warn(this.formatMessage('warn', message, meta));
        }
    }

    info(message, meta = {}) {
        if (this.shouldLog('info')) {
            console.log(this.formatMessage('info', message, meta));
        }
    }

    debug(message, meta = {}) {
        if (this.shouldLog('debug')) {
            console.debug(this.formatMessage('debug', message, meta));
        }
    }

    securityEvent(type, details) {
        this.info(`SECURITY_EVENT: ${type}`, details);
        // In a real system, this would send to SIEM
    }
}

module.exports = SecurityLogger;
