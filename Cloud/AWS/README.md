## EC2 AWS Cloud Lab

### Overview

In this lab, I deployed a fully functional web server on Amazon Web Services using an EC2 instance. The goal was to understand the fundamentals of cloud infrastructure, instance management, and public web hosting.

<img src="step1.png"/>

<img src="step2.png"/>

### Environment Setup

I launched a Linux-based EC2 instance (Amazon Linux).

<img src="step3.png"/>

<img src="step4.png"/>

Configured networking using a public subnet, an internet gateway, and appropriate security group rules.

<img src="step5.png"/>

Allowed inbound HTTP traffic on port 80 to make the web server accessible externally.

<img src="step6.png"/>

<img src="step7.png"/>

### Server Configuration

Installed the httpd (Apache) web server package.

<img src="step8.png"/>

Enabled and started the service to ensure it runs on boot.

<img src="step9.png"/>

Deployed a simple website by placing custom HTML content in /var/www/html/.

### Public Deployment

Retrieved the instance’s public IP / DNS.

<img src="step10.png"/>

Verified that the website was reachable from the public internet.

<img src="step11.png"/>

Confirmed that the EC2 instance successfully served web content externally.

<img src="step12.png"/>

### Outcome

This lab demonstrated the complete workflow of:

provisioning cloud compute resources,

configuring a Linux server,

installing and managing web services,

and exposing a website to the internet.

It provided hands-on experience with AWS infrastructure, networking, and basic web hosting in a cloud environment.
