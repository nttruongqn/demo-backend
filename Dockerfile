# Base image
FROM node:14-alpine AS builder

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

# Build the application
RUN npm run build

# Create a new image for the runtime environment
FROM node:14-alpine

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install only the production dependencies
RUN npm install --only=production

# Copy the built application from the builder stage to the container
COPY --from=builder /app/dist ./dist

# Expose port 3000 for the application
EXPOSE 1328

# Start the application
CMD ["npm", "run", "start:prod"]