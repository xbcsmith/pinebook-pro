# GoLand Install

Install delve

```bash
go get -u github.com/go-delve/delve/cmd/dlv
```

Get the IDE

```bash
wget -O goland-2020.2.2.tar.gz  https://download.jetbrains.com/go/goland-2020.2.2.tar.gz

tar -C ~/ -zxvf goland-2020.2.2.tar.gz

mv ~/GoLand-2020.2.2 ~/GoLand-2020.2EAP
```

Install a proper jre

```bash
rm -rf GoLand-2020.2EAP/jbr/

wget -O jbr.tar.gz https://bintray.com/jetbrains/intellij-jbr/download_file?file_path=jbr-11_0_6-linux-aarch64-b722.2.tar.gz

tar -C ~/GoLand-2020.2EAP/ -zxvf jbr.tar.gz
```

Compile a proper fileWatcher

```bash
sudo apt install libc6-dev gcc

cat > fetch_file_watcher.sh << EOF
#!/usr/bin/env bash

mkdir ~/jbFileWatcher
cd ~/jbFileWatcher
wget https://raw.githubusercontent.com/JetBrains/intellij-community/master/native/fsNotifier/linux/fsnotifier.h
wget https://raw.githubusercontent.com/JetBrains/intellij-community/master/native/fsNotifier/linux/inotify.c
wget https://raw.githubusercontent.com/JetBrains/intellij-community/master/native/fsNotifier/linux/main.c
wget https://raw.githubusercontent.com/JetBrains/intellij-community/master/native/fsNotifier/linux/make.sh
wget https://raw.githubusercontent.com/JetBrains/intellij-community/master/native/fsNotifier/linux/util.c

chmod +x make.sh

./make.sh

cp fsnotifier-aarch64 ~/GoLand-2020.2EAP/bin/
EOF


chmod +x fetch_file_watcher.sh
./fetch_file_watcher.sh
```

Start IDE

```bash
JAVA_HOME=~/GoLand-2020.2EAP/jbr ~/GoLand-2020.2EAP/bin/goland.sh &
```

Since this is the first time we are starting the IDE, we need to do a bit of configuration before creating a project.

Click on the Configure button, then select the Edit Custom Properties action, add the following line, then restart the IDE:

```text
idea.filewatcher.executable.path=fsnotifier-aarch64
dlv.path=/home/ubuntu/go/bin/dlv
```
