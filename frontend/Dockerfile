# Use the official Node.js image as the base image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install production dependencies
RUN npm install --only=production

# Copy the built application files into the container
COPY build/ .

# Expose the port your app runs on
EXPOSE 3000

# Define the command to run your app
CMD ["node", "index.js"]