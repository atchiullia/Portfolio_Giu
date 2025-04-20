# Static Website Deployment with Terraform, AWS, and GitHub Actions

This project demonstrates the automated deployment of a static website using **Terraform**, **AWS**, and **GitHub Actions**, featuring a custom domain ([giullialazaro.com](https://giullialazaro.com)). It focuses on automation, infrastructure as code (IaC), security, and continuous delivery.

---

## Project Goals

- Implement **Infrastructure as Code (IaC)** with **Terraform**
- Automate **CI/CD** deployment pipelines using **GitHub Actions**
- Secure secrets and validate container security with **Trivy**
- Deploy a globally distributed and secure static site with **SSL**, **CDN**, and **custom domain**
- Monitor the infrastructure with **AWS CloudWatch**

---

## Tech Stack & Services

| Category           | Tools & Services                                                                 |
|--------------------|-----------------------------------------------------------------------------------|
| Infrastructure     | Terraform, AWS S3, CloudFront, Route 53, ACM, CloudWatch                         |
| CI/CD              | GitHub Actions, GitHub Secrets                                                   |
| Security           | Trivy for vulnerability scanning, GitHub Secrets for credential management       |
| Domain Management  | Route 53 + Squarespace                                                           |
| Monitoring         | AWS CloudWatch Alerts                                                            |

---

## Infrastructure as Code

All infrastructure is provisioned using **Terraform**, including:

- **S3**: For static website hosting
- **CloudFront**: For global CDN delivery and HTTPS support
- **Route 53 + Squarespace**: For custom domain and DNS management
- **ACM**: For SSL certificate provisioning and renewal
- **CloudWatch**: For real-time monitoring and alerting

---

## CI/CD Pipeline

A GitHub Actions workflow automates:

- **Build and deploy** on every push to `main`
- **Trivy scans** for security vulnerabilities
- Secure handling of credentials via **GitHub Secrets**
- Infrastructure updates with Terraform commands (`plan` and `apply`)

---

## Security

- **Trivy** scans containers and dependencies for vulnerabilities before deployment
- **GitHub Secrets** securely stores and injects sensitive credentials into the workflow

---

## Custom Domain

- Site hosted at: [`giullialazaro.com`](https://giullialazaro.com)
- DNS handled via **Route 53** and **Squarespace**
- SSL certificate managed with **AWS Certificate Manager (ACM)**
- **CNAME validation** ensures secure domain verification

---

## Monitoring & Observability

- **AWS CloudWatch** tracks availability and performance
- Alert rules notify on errors and critical events

---

## Final Result

> A **fully automated, secure, and scalable static site deployment** with:
> - Global CDN
> - Custom domain with SSL
> - IaC-managed infrastructure
> - Continuous Delivery with built-in security checks

---

## Key Learnings

- Hands-on integration of **DevOps best practices** with **IaC**
- Deploying static web applications securely and efficiently
- Using **GitHub Actions** as a CI/CD tool for real-world infrastructure
- Applying **security-first** principles in the DevOps lifecycle

---

Built with ❤️ by [Giullia Lazaro](https://github.com/atchiullia)

