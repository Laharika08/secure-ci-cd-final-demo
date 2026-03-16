# Use the official Go image matching the specified version
FROM golang:1.22.2

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download and install dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o main .

# Set the command to run when the container starts
CMD ["./main"]
