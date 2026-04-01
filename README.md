# 🚀 Java Project – End-to-End DevOps Pipeline (Jenkins + Docker + Kubernetes + Linode)

---

## 📌 Project Overview

This project demonstrates a complete **DevOps pipeline**:

```
Code → Webhook triggerred Build (Maven) → Docker Image → Push to DockerHub → Deploy to Kubernetes (LKE)
```
---
Interesting feature of this pipeline: Every docker image has unique tag and latest tag for the latest revision.. 
---

## 🏗️ Tech Stack

* Java 
* Maven
* Docker
* Jenkins
* Kubernetes (Linode LKE)

---

## 📂 Project Structure

```
javaproject/
├── src/
├── target/
├── Dockerfile
├── pom.xml
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── Jenkinsfile
└── README.md
```

---

# ⚙️ Prerequisites

## 🔹 Install Required Tools

```bash
sudo apt update
sudo apt install docker.io -y
sudo apt install maven -y
sudo apt install kubectl -y
```

---

## 🔹 Install Jenkins

```bash
sudo apt install openjdk-17-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
```

Start Jenkins:

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Access Jenkins:

```
http://<your-server-ip>:8080
```

---

# 🔌 Jenkins Plugins Required

Install from **Manage Jenkins → Plugins**:

### ✅ Mandatory Plugins

* Git
* Pipeline
* Docker Pipeline
* Kubernetes CLI
* Credentials Binding
* Maven Integration

---

# 🔐 Jenkins Credentials Setup

Go to: **Manage Jenkins → Credentials**

Add:

### 🔹 DockerHub Credentials

* ID: `dockerhub-credentials`
* Username: your DockerHub username
* Password: your DockerHub password

---

### 🔹 Kubernetes Config

* Type: Secret file OR text
* ID: `kubeconfig`
* Value: contents of your kubeconfig

---

# 🐳 Docker Setup

## 🔹 Build Image

```bash
docker build -t <dockerhub-username>/javaproject:latest .
```

---

## 🔹 Push to DockerHub

```bash
docker login
docker push <dockerhub-username>/javaproject:latest
```

---

# ☸️ Kubernetes Setup (LKE)

## 🔹 Get kubeconfig

```bash
linode-cli lke kubeconfig-view <cluster-id> --text > kubeconfig.yaml
export KUBECONFIG=kubeconfig.yaml
```

---

## 🔹 Verify Cluster

```bash
kubectl get nodes
```

---

# 🚀 Deploy to Kubernetes

```bash
kubectl apply -f k8s/
kubectl get pods
kubectl get svc
```

---

# 🌐 Access Application

```bash
kubectl get svc
```

Open:

```
http://<EXTERNAL-IP>
```

---

# ⚠️ Known Issue (Linode Limit)

If you see:

```
EXTERNAL-IP: <pending>
```

👉 Reason: LoadBalancer quota exceeded

### ✅ Fix:

* Delete unused NodeBalancers OR
* Use NodePort OR
* Setup Ingress

---

# 🔄 Deployment Update Strategy

```bash
kubectl set image deployment/javaproject \
javaproject=<image>:<tag>
```

---

# 📈 Scaling

```bash
kubectl scale deployment javaproject --replicas=5
```

---

# 🧹 Cleanup

```bash
kubectl delete -f k8s/
```

---

# 🚀 Future Improvements

* Add Helm Chart
* Setup Ingress + Domain + HTTPS
* Add HPA (Auto Scaling)
* Add Monitoring (Prometheus + Grafana)


---

# 🎯 Summary

This project demonstrates:

✅ Docker image creation
✅ Webhook triggers
✅ Jenkins CI/CD pipeline
✅ Kubernetes deployment (LKE)
✅ Service exposure (LoadBalancer)
✅ Real-world DevOps workflow

---

## 💡 Author

Murthy – DevOps Engineer & Enthusiast 🚀

---
