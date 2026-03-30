# Ubuntu Server

## Config static IP

- sudo -i : use root
- nano /etc/netplan/ then tab to select .yaml
- If you are using bridge network, in yaml:

```
  network:
    ethernets:
      ens33:
        **dhcp4**: false
        addresses: [192.168.1.110/24] //sample
        gateway4: 192.162.1.1 //your pc ip gateway
      version: 2
```

- Use Wifi

```
  network:
    renderer: networkd
      wifis:
        wlp2s0: // check ip a
          dhcp4: no
          addresses: [192.168.1.110/24] //sample
          routes:
            - to: dedault
              via: 192.162.1.1 //your pc ip gateway
          nameservers:
            addresses: [8.8.8.8, [1.1.1.1]]
          access-points:
            "Your Wifi":
              password: "Your password"
      version: 2
```

- Crtl X + Enter to save
- netplan apply
- ip a

## Working with laptop: Run server when leaving the laptop

- sudo nano /etc/systemd/logind.conf
- HandleLidSwitch=ignore, HandleLidSwitchExternalPower=ignore, HandleLidSwitchDocked=ignore
- sudo systemctl restart systemd-logind
- sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

## Create snapshot

For the backup

## SSH to server

- Open Command Line
- Install: apt install openssh-server -y
- systemctl status ssh
- systemctl enable --now ssh
- ssh <username\>@<addresses\>
- ssh-keygen -R <address\>

# Ubuntu Common Commands

## pwd

## whoami

## Linux System file

https://www.linuxfoundation.org/blog/blog/classic-sysadmin-the-linux-filesystem-explained

## cd <folder\>

## clear

## ls <folder\>

- ls -l <folder\>
- ls -a <folder\>
- ls -t <folder\>
- ls -lta <folder\>

## mkdir <folder>

- mkdir -p <folders\> : mkdir -p data/data1/data11

## touch <file\>

## rm <file\>

## rm -r <folder\>

## rm -rf <folder\>

## cp -r <oldFolder\> <newFolder\>

## cp <oldFile\> <newFile\>

## mv <file/folder\> <newFile/newFolder\>

. : the current location

## echo ""

- echo "" > <file\>
- echo "" >>
- cat <file\>
- tail -n <lineToSee\> <file\>
- tail -n <lines\> <file1\> > <file2\>
- tail -f <file\> : real time

## sudo

- sudo cp data1.txt /var/
- sudo -i

## free -m

## df -h /

## top

## hostnamectl set-hostname <newNameServer>

## reboot

## netstat -tlpun

- Install: apt install net-tools
- -t : info tcp connection
- -l : port listen
- -p : pid and name process
- -u : udp info
- n : ip , port number

## ps -ef

- Running process

## ping

## telnet <ip\> <port\>

## traceroute -T -p <port\> <ip\>

## apt install <tool\>

- apt remove <tool\>

# Vim

- tool to format file

## apt install vim -y

vim <file\>

- Enter y: Insert mode
- Esacpe: out to Command mode (~~)
- Delete one line : double D
- Undo: U
- Copy: YY , Paste: P
- Search: /character
- Save: :x Not Save: :q!

# Access Control

## User

### useradd <newUser\>

### adduser <newUser\>

- Use this

### su <user\> >< exit

### vi /etc/passwd

### deluser <user>

## Group

### groupadd <group\>

### delgroup <group\>

### usermod -aG <group\> <user\>

### groups <user\>

-When creating user, system auto create group with same name and add user to this group

### deluser <user\> <group\>

## Permission

### When using ls -l, the order print is: <user\> <group>

### chown <oldGroup>:<newGroup> <folder\>/

- chown -R <oldGroup\>:<newGroup\> <folder\>/
- Know file or foler: use ls -l and check the first character: having "-" is file, d is folder

### 3 permissions: r,w,x

- first 3 character: user permission, next 3 character: group permission, last 3 characters: default
- Example: rwxr-xr-x

### chmod <u/g/o\>=<rwx\> <folder\>/|<file\>

- chmod u=<>,g=<>,o=<rwx-\> <folder\>/|<file\>

### At least you need to have x permission

### Permission numbers

- r=4, w=2, x= 1 => 4+2+1=7
- example: chmod 750 datas/

# Mindset for project implementation

- Implement various types of project: frontend, backend

## Mindset to implement project:

- Tools: suitable tools + suitable versions.
- 3 Types file: feature files, config files (focus), other files (readme...)
- Steps: Build + Run
- Note: each project has its own folder + users

# Implement Frontend project

- scp <file.zip\> <user\>@<address\>:/home/<folder\>
- apt install unzip + unzip <file.zip\>
- mkdir /projects then mv <folder\> to projects
- adduser <user\>
- chown -R <user\>:<user\> projects/<folder\>/
- c hmod -R 750 projects/<folder\>/
- install nodejs:

```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
apt install nodejs -y
```

- Run frontend: web server, service, pm2

### nginx

- etc/nginx: all configuration
- sites-available/default: default-config
- Create file in: conf.d/<project\>.conf
- More configuration: www.digitalocean.com/community/tools/nginx
- nginx -t: test
- systemctl restart nginx: apply

### service

- vi /lib/systemd/system/<project\>.service
- In service file:

```
Type=simple
User=<project>
Restart=on-failure
WorkingDirectory=<address>
ExecStart=npm run start -- --port=3000 //example
```

- systemctl daemon-reload
- systemctl start <project\>
- systemctl status <project\>

## Implement Backend project

- Like frontend
- Implement database + backend

### Run backend in background

- nohup java -jar ... 2>&1 &
- ps -ef| grep | <searchKey\>
- kill -9 <pid\>

```
ping.eu

```

# CI/CD

- commit -> build -> test -> deploy
- CI: continuous intergartion
- CD: Continuous deployment/delivery
- Tools: Gitlab CI/CD, Jenkins

# Docker

- See docker architecture
- See load balancer

## Install Docker on Ubuntu

- mkdir /tools + mkdir docker
- cd docker and vi instal-docker.sh

```
#!/bin/bash

# Cập nhật và cài đặt các gói phụ trợ
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Thêm Docker GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Thêm Docker Repository (Đã sửa lỗi echo và dấu cách)
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Cài đặt Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Kích hoạt Docker
sudo systemctl start docker
sudo systemctl enable docker

# Cài đặt Docker Compose bản mới nhất
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Kiểm tra phiên bản
docker --version
docker-compose --version
```

- chmod +x install-docker.sh
- bash install-docker.sh

## Docker Common Commands

- docs.docker.com/get-started/docker_cheatsheet.pdf

## Dockerfile

- Dockerfile: make source code to container + install required tools to run project

### Dockerfile Commands

- FROM
- WORKDIR: WORKDIR /app
- COPY ..: first dot present the source code, the 2nd dot present the workdir.
- RUN
- ENV
- EXPOSE: define port in container
- CMD and ENTRYPOINT

### Mindset for Dockerfile

- non root user
- base image suitable
- Multiple stage

## Dockerfile for backend

- Choose image: choose right version, from official, verified, sponsored sources, chose alpine base image

```
## build stage ##
FROM maven:3.5.3-jdk-8-alpine as build

WORKDIR /app
COPY . .
RUN mvn install -DskipTests=true

## run stage ##
FROM amazoncorretto:8u402-alpine-jre
RUN adduser -D <user>
WORKDIR /run
COPY --from=build /app/target/...jar /run/...jar

RUN chown -R <group>:<user> /run

USER <user>

EXPOSE 8080

ENTRYPOINT java -jar /run/...jar
```

- docker build -t <image_name\>:<version\> -f <dockerfile> .
- docker run --name <container_name\> - dp <out_port\>:<in_port\> <image\>
- docker logs -f <container\>
- docker exec -it <container\> sh
- In container: ps -ef | grep <search\>

## Dockerfile for Frontend

```
## build stage ##
FROM node:18.18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

## run stage ##
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

## Optional: Copy file config Router
# COPY nginx.conf /etc/nginx/conf.d.default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

```

## Docker volume

- In project: mkdir -p /db/mariadb-1
- docker run -v /db/mariadb-1/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -p 3307:3306 --name mariadb-1 -d mariadb:10.6

## Docker Compose

```
services:
  db1:
    image: mariadb:10.6
    volumes:
      - /db/mariadb-1:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "3307:3306"
    container_name: mariadb-1
    restart: always
  app-backend:
    image: <image>
    ports:
      - "8081:8080"
    container_name: <name>
    restart: always
```

- docker-compose ps
- docker-compose up -d

# Registry Server

## dockerhub

- docker login
- docker image = domain/project/repo:tag
- Example: docker tag todolist:v1 el
  roydevops/todolist:v1
- doker push <image>
- docker logout

## private registry

- In tools: mkdir registry
- In registry: apt install openssl

## harbor

# Jenkins

## Definitinon

Jenkin :open source automation server, provide hundreds of plugins to support building, deploying and automating any project.

## CI/CD with Jenkins

- GitHub/GitLab: git push code. GitHub Webhooks to Jenkins
- Jenkins Server: build & test, docker build, push to Docker Hub
- Ubuntu Server: docker pull, stop and run

## Install Jenkin Server

- Check jenkins-install.sh
- chmod +x jenkins-install.sh
- sh jenkins-install.sh
- 192.168.1.111:8080
- Reverse proxy: create in /etc/nginx: vi conf.d/jenkins.tech.conf

```
server {
    listen 80;

    server_name jenkins.elroydevops.tech;

    location / {
        proxy_pass http://jenkins.elroydevops.tech:8080;
        proxy_http_version 1.1;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

- systemctl restart nginx

## Notes

- /var/lib/jenkins: jenkins config files
- /etc/passwd: check the jenkin user
- Plugins
- Nodes: Add jenkins agents to jenkins server (important)
- security
- credentials (important)
- user
- System log
- Jenkins CLI (important):

# Jenkins CI/CD (Continuos Deployment)

## Connect Jenkins Agent to Jenkins Server

- When using Jenkins, use Jenkins Agent instead of SSH.
- Require: Server must have the same Java version with Jenkin server
- Multiple java versions: update-alternatives --config java
- add user jenkins
- Security: Agents: TCP port inbound -> Fixed: 8999
- On web Jenkins, Manage Jenkins/Nodes: New Nodes
- New Nodes: Custom WorkDir Path: /var/lib/jenkins: mkdir /var/lib/jenkins in ubuntu server
- chown jenkin. /var/lib/jenkins/
- cd /var/lib/jenkins and su jenkins
- On Ubuntu server, Run commands in "On run from agent command line, with the...Unix but the last command is: java -jar agent.jar -url http://192.168.1.111:8080/ -secret @secret-file -name "test_server" -webSocket -workDir "/var/lib/jenkins/" > nohup.out 2>&1
- New Item: Folder, Name: action-in-lab -> Save

## Connect Jenkins Server to GitHub/GitLab

### Install Plugins

Install Plugin: GitLab/Github + Blue Ocean -> Restart tick

- System -> GitLab/Github + config github domain in /etc/hosts
- Credentials: Access Token. In Github: create new admin user + get access token.

### Configure Pipeline

- In folder, New Item: Create pipeline -> name of project
- Discard old builds: Max 10, Build trigger: when a change (push event, accepted merge request), pipeline script from SCM -> Git

### Configure Webhook

- Settings -> Network -> Outbound requests -> allow...from web hooks
- On Jenkins web, admin -> configure -> api token
- In Gitlab/Github, projec -> setting -> Webhooks
- url: http://<user on jenkins\>:<token user in jenkin\>@<jenkin ip\>/project/<pipeline address on jenkins\>
- Tick tag event, merge request, remove enable ssl
- In pipeline: add branch develop
- Jenkinsfile: www.jenkins.io/doc/book/pipeline/syntax

```
pipeline {
  agent {
    label '<label in jenkins agent>'
  }
  environment {
    appUser = ""
    appName = ""
    appVersion = ""
    appType = ""
    processName = "${appName}-${appVersion}.${appType}"
    folderDeploy = "/datas/${appUser}"
    buildScript = "mvn clean install -DskipTests-true"
    copyScript = "sudo cp target/${processName} ${folderDeploy}"
    permsScript = "sudo chown -R ${appUser}. ${folderDeploy}
    killScript = "sudo kill -9 \$(ps -ef| grep ${processName}| grep -v grep| awk '{print \$2}')"
    runScript = 'sudo su ${appUser} -c "cd ${folderDeploy}; java -jar ${processName} > nohub.out 2>&1 &"'
  }
  stages {
    stage('build') {
      steps {
        sh(script: """ ${buildScript} """, label: "build with maven")
      }
    }
    stage('deploy') {
      steps {
        sh(script: """ ${buildScript} """, label: "build with maven")
        sh(script: """ ${permsScript} """, label: "set permission folder")
        sh(script: """ ${killScript} """, label: "terminate the running process")
        sh(script: """ ${runScript} """, label: "run the project)
      }
    }
  }
}
```

- in Ubuntu server: visudo

```
root ALL=(ALL:ALL) ALL
# User privilege specification
jenkins ALL=(ALL) NOPASSWD: /bin/cp*
jenkins ALL=(ALL) NOPASSWD: /bin/kill*
jenkins ALL=(ALL) NOPASSWD: /bin/chown*
jenkins ALL=(ALL) NOPASSWD: /bin/su <project>*
```

### Configure React Jenkinsfile

- In Ubuntu server: nano /etc/nginx/conf.d/<project\>.conf

```
server {
    listen <port>;
    # Nếu bạn dùng cổng khác (ví dụ 8081), hãy sửa ở đây
    server_name 192.168.1.111;

    root /var/www/html/wheel-of-names;
    index index.html;

    location / {
        # Quan trọng cho React/Vite: chuyển mọi request về index.html để tránh lỗi 404 khi F5
        try_files $uri $uri/ /index.html;
    }
}
```

-See Jenkinsfile_react

## Config Jenkins Agents Service

- Use to turn on after turning off jenkin agent.
- vi /etc/systemd/system/jenkins-agent.service

```
[Unit]
Description=Jenkins Agent Service
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
User=jenkins
Group=jenkins
WorkingDirectory=/var/lib/jenkins
ExecStart=/user/bin/bash -c 'java -jar agent.jar -jnlpUrl http://192.168.1.111:8080/computer/test-server/jenkins-agent.jnlp -secret @secret-file -workDir "/var/lib/jenkins/"'
Restart=always
[Install]
WantedBy=multi-user.target
```

- systemctl daemon-reload
- systemctl start jenkins-agent
- systemctl status jenkins-agent

# Jenkins CI/CD (Continuos Delivery)

- You have a large project, must have one person to check

```
stages{
  ...
  stage('deploy') {
    steps {
      script {
        try {
          timeout(time: 5, unit: 'MINUTES') {
            env.useChoice = input message: "Can it be deployed?",
              parameters: [choice(name: deploy, choices: 'no\nyes', description: 'Choose "yes" if you want to deploy')]
          }
          if (env.useChoice == 'yes') {
            sh(...)
          } else {
            echo "Don not confirm the deployment!"
          }
        } catch (Exception err) {

        }
      }

    }
  }
}
```

# Monitoring

## Install Zabbix

# Optimize Server

## Check

- free -h
- docker stats
- sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches

## Swap

- Get Disk to virtual RAM

```
# Tạo file swap 4GB
sudo fallocate -l 4G /swapfile
# Phân quyền bảo mật
sudo chmod 600 /swapfile
# Thiết lập hệ thống swap
sudo mkswap /swapfile
sudo swapon /swapfile
# Lưu cấu hình để khi gập máy/reboot không bị mất
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## Ubuntu Server

- Snapd: turn off

```
sudo systemctl stop snapd
sudo systemctl disable snapd
```

- Multipathd

```
sudo systemctl stop multipathd
sudo systemctl disable multipathd
```

## Docker

- Clean Docker: docker system prune -a --volumes -f

## Oracle DB

- SGA/PGA optimize

```

ALTER SYSTEM SET sga_target = 600M SCOPE=SPFILE;
ALTER SYSTEM SET pga_aggregate_target = 200M SCOPE=SPFILE;
EXIT;

```

## Jenkins

- Optimze Heapsize

```

services:
jenkins:
...
environment: - JAVA_OPTS=-Xmx512m -Xms256m -XX:MaxMetaspaceSize=256m

```

```

```
