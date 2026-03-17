
# FastAPI Mangum Integration

This repository contains a FastAPI application integrated with Mangum, allowing you to deploy FastAPI applications using AWS Lambda via AWS API Gateway or other serverless platforms that accept synchronous web frameworks.

## Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.x
- [FastAPI](https://fastapi.tiangolo.com/)
- [Mangum](https://github.com/erm/mangum)

## Getting Started

1. **Clone the repository to your local machine:**

    ```shell
    git clone <repository-url>
    cd <repository-folder>
    ```

2. **Install the required dependencies using pip:**

    ```shell
    pip install fastapi mangum
    ```

3. **Run the FastAPI application using Mangum:**

    ```shell
    uvicorn main:app --host 0.0.0.0 --port 8000
    ```

   This will start the FastAPI application locally on `http://localhost:8000`.

## Code Explanation

- **main.py:** Contains the FastAPI application definition and route handling logic.
- **requirements.txt:** Lists the required Python packages for the application.

The `main.py` file sets up a FastAPI application with a single route at `/v1`. When accessed, this route logs the requested path and responds with a JSON message: `{"message": "Hello World"}`.

## Mangum Integration

Mangum acts as an adapter, enabling the asynchronous FastAPI application to work seamlessly within the synchronous environment of AWS Lambda. It facilitates the integration between FastAPI and AWS API Gateway, ensuring requests are properly handled and responses are formatted correctly.

## Key Features of Mangum

- **Asynchronous FastAPI Support:** Mangum enables FastAPI, which is asynchronous, to work effectively within the synchronous execution model of AWS Lambda.
- **Integration with AWS API Gateway:** Requests sent to API Gateway are passed on to the FastAPI application running on Lambda via Mangum, and responses are returned back through API Gateway.
- **Exception Handling:** Mangum handles exception translation between FastAPI and AWS Lambda, ensuring consistent error handling within the serverless architecture.
- **Optimized for Cold Starts:** Mangum is optimized to mitigate the effects of cold starts, reducing latency for the first request.

## Deploying to AWS Lambda

Check the `pulumi` directory
