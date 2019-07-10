#!/bin/bash
sed -i 's/#Banner none/Banner \/etc\/issue.net/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh
