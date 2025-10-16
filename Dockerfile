FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production --no-optional

# Copy source code
COPY . .

# Expose ports
EXPOSE 3000 8080

# Start the application
CMD ["node", "server.js"]
