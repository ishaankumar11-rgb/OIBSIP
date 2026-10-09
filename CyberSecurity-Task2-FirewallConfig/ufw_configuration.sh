#!/bin/bash
# UFW Firewall Configuration Script
# Task 2 - Oasis Infobyte Security Analyst Internship
# This script applies a basic set of firewall rules using UFW.

echo "Enabling UFW..."
sudo ufw enable

echo "Allowing SSH (port 22)..."
sudo ufw allow ssh

echo "Denying HTTP (port 80)..."
sudo ufw deny http

echo "Allowing HTTPS (port 443)..."
sudo ufw allow https

echo "Denying Telnet (port 23) - insecure protocol..."
sudo ufw deny 23

echo "Configuration complete. Current status:"
sudo ufw status verbose
