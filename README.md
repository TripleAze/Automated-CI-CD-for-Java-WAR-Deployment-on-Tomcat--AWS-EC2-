# 🚀 Automated CI/CD for Java WAR Deployment on AWS EC2

This repository contains a fully automated pipeline for building and deploying a Java Maven web application to Apache Tomcat using Infrastructure as Code (Terraform) and Configuration Management (Ansible).

## 🏗️ Architecture
- **Infrastructure**: AWS EC2 Instances (provisioned via Terraform).
- **CI Server**: Jenkins (running Java 21).
- **Application Server**: Apache Tomcat 10.1.50 (running Java 21).
- **Orchestration**: Ansible (packages, services, and security configuration).
- **Pipeline**: Jenkins Pipeline (Declarative `Jenkinsfile`).

---

## 🛠️ Project Evolution & Debugging Log

Building this pipeline involved several complex challenges. Below is a log of the key issues encountered and how they were resolved.

### 1. Configuration Management Strategy
- **Issue**: Initial Terraform code used `user_data` for service installation. This made configuration hard to version and debug.
- **Solution**: Removed all configuration logic from Terraform. Refactored the project to use **Ansible roles** for a clean separation between "Provisioning" (Terraform) and "Configuration" (Ansible).

### 2. Jenkins Plugin Authentication Failure
- **Issue**: The Ansible `jenkins_plugin` module failed due to Jenkins' CSRF protection and default security settings not being initialized.
- **Solution**: Switched to the **Jenkins CLI** using `-auth admin:{{ password }}`. This bypassed the UI-level security hurdles during the automated bootstrap.

### 3. Tomcat Service Startup Error (JAVA_HOME)
- **Issue**: Tomcat failed to start with "control process exited with error code".
- **Diagnosis**: Checked `journalctl -xeu tomcat` and found `JAVA_HOME` was pointing to `/usr/lib/jvm/jre` (a RedHat/CentOS path).
- **Solution**: Updated the `tomcat.service.j2` template to the correct Ubuntu path: `/usr/lib/jvm/java-21-openjdk-amd64`.

### 4. Jenkins Pipeline Compilation Errors
- **Issue**: Pipeline failed with `unexpected token: Java 21` at the `tools` block.
- **Solution**: The user had accidentally used `JDK_21` as a keyword instead of the standard `jdk` directive. Corrected the `Jenkinsfile` to use `jdk 'Java 21'`.

### 5. Deployment Directory Race Condition
- **Issue**: The `Deploy` stage failed with `scp: dest open "/home/ubuntu/tmp/": Failure`.
- **Solution**: The directory did not exist on the target server. Manually created the directory and updated the `Jenkinsfile` to ensure it targets `/home/ubuntu/tmp/` specifically.

### 6. Health Check Failure (Race Condition)
- **Issue**: The `Health Check` stage failed immediately after the `Deploy` stage because `curl` was executed while Tomcat was still initializing.
- **Solution**: Implemented a **15-second sleep** and a **retry(5)** loop in the `Jenkinsfile` to give Tomcat enough time to deploy the WAR file fully before checking for a 200 OK response.

---

---

## 📂 Project Structure
```text
.
├── ansible/            # Configuration Management (Java, Tomcat, Jenkins)
├── app/               # Java Maven Web Application
├── docs/               # Architecture and Documentation
├── scripts/            # Automation (Cleanup, etc.)
├── terraform/          # Infrastructure as Code (AWS VPC, EC2, SG, IAM)
├── Jenkinsfile         # CI/CD Orchestration
└── README.md           # Project Overview & Debugging Log
```

---

## 🚀 Getting Started

### 1. Provision Infrastructure
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 2. Configure Servers
Update `ansible/inventories/host.ini` with the new IPs and run:
```bash
cd ansible
ansible-playbook -i inventories/host.ini site.yml
```

### 3. Configure Jenkins UI
- Create a **New Pipeline Job**.
- Set the GitHub repo to: `https://github.com/TripleAze/Automated-CI-CD-for-Java-WAR-Deployment-on-Tomcat--AWS-EC2-`
- Set Branch to `*/main`.
- Point Script Path to `Jenkinsfile`.

---

## 🧹 Cleanup
To avoid AWS costs, use the included cleanup script:
```bash
./scripts/cleanup.sh
```

---
*Created by Antigravity AI for the user Abubakar.*