## Comprehensive Workflow and Deployment Documentation: Testing, Building, Deploying,


# Prerequisites
-   GitHub account and familiarity with GitHub Actions.
-   Basic understanding of Docker, Docker File .
-   Basic knowledge of Secrets  and variables
-   Access to a cloud service  and a text editor or IDE.
-   A web browser for accessing project repositories and references.

## Workflow Overview

This document explains how we test our code and after that make sure our code does not have any errors and after that  package it as a container, send it to the cloud,  and run it there.

## Workflow Steps

### Step 1: Testing

For testing we will take 
**offical nodejs workflow by github actions**

  

      name: Node.js CI
    
    on: [push]
    
    jobs:
      build:
    
        runs-on: ubuntu-latest
    
        steps:
          - uses: actions/checkout@v4
          - name: Use Node.js
            uses: actions/setup-node@v3
            with:
              node-version: '20.x'
          - run: npm ci
          - run: npm test




### Step 2: Building a Docker Image & Pushing the Docker Image

After test successful next step is to build a docker image and and dockerhub credentials are defined in secrets and docker file should be present in your repository.

  

      
    
    on:
      push:
        branches:
          - test
    
    jobs:
      build-push-docker-image:
        runs-on: ubuntu-latest
    
        steps:
        - name: Checkout code
          uses: actions/checkout@v2
    
        - name: Build Docker image
          run: docker build -t iamdivye/express-js:latest .
    
        - name: Login to Docker Hub
          run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
    
        - name: Push Docker image to Docker Hub
          run: docker push iamdivye/express-js:latest
    `

### Step 4: SSH into EC2

After passing necessary secret variables u can ssh into ec2 also have an bash file ater loging a bash will check if there is any container runnig with same name or not if yes it will delete the container so we can make one with the latest changes . 


### Step 5: Deployment Script

    - name: Deploy to EC2
      env:
        PRIVATE_KEY: ${{ secrets.SSH_KEY }}
        HOSTNAME: ${{ secrets.HOST_IP }}
        USER_NAME: ${{ secrets.HOST_USER }}
      run: |
         echo "$PRIVATE_KEY" > key.pem && chmod 600 key.pem
        ssh -o StrictHostKeyChecking=no -i key.pem ${USER_NAME}@${HOSTNAME} '       
          cd ~
          chmod +x del.sh
          ./del.sh
            docker pull your-docker-image:latest
            docker run -d -p 4000:4000 --name your-container-name your-docker-image:latest
    '



## Secrets Configuration

   -   `$DOCKER_USERNAME` is a placeholder for your Docker Hub username.
-   `$DOCKER_PASSWORD` is a placeholder for your Docker Hub password.
-   `$SSH_KEY` is a placeholder for your SSH key.
-   `$HOST_IP` is a placeholder for your EC2 instance's IP address or hostname.
-   `$HOST_USER` is a placeholder for your SSH username.

## You should store these actual values as GitHub secrets and reference them in your workflow and deployment script as needed, without exposing the real values in your code.



## Final work flow file 

    name: Test, Build, and Push Docker Image
    
    on:
      push:
        branches:
          - test
    
    jobs:
      test-build-push:
        runs-on: ubuntu-latest
    
        strategy:
          matrix:
            node-version: [16.x]
    
        steps:
        - name: Checkout code
          uses: actions/checkout@v2
    
        - name: Use Node.js ${{ matrix.node-version }}
          uses: actions/setup-node@v2
          with:
            node-version: ${{ matrix.node-version }}
            cache: 'npm'
    
        - name: Install dependencies
          run: npm ci
    
        - name: Run tests
          run: npm test
    
        - name: Build Docker image
          run: |
            docker build -t your-docker-image-name:latest .
            
        - name: Login to Docker Hub
          run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
    
        - name: Push Docker image to Docker Hub
          run: docker push your-docker-image-name:latest
    
        - name: Deploy to EC2
          env:
            PRIVATE_KEY: ${{ secrets.SSH_KEY }}
            HOSTNAME: ${{ secrets.HOST_IP }}
            USER_NAME: ${{ secrets.HOST_USER }}
          run: |
            # Continue with the rest of the deployment steps
            echo "$PRIVATE_KEY" > key.pem && chmod 600 key.pem
            ssh -o StrictHostKeyChecking=no -i key.pem ${USER_NAME}@${HOSTNAME} '       
              cd ~
              chmod +x del.sh
              ./del.sh
              docker pull your-docker-image-name:latest
              docker run -d -p 4000:4000 --name your-container-name your-docker-image-name:latest
            '


