#!/bin/bash
# Check Privilege
# Make sure only root can run our script
echo "正在检查权限 Checking Privilege ..."
if [ "$(id -u)" != "0" ]; then
	echo "失败: 请用Root身份运行此脚本. 是不是忘了sudo?" 1>&2
	echo "Fail: This script must be run as root. perhaps forget sudo?" 1>&2
	exit 1
fi
echo "成功 Success"
echo ""

echo "正在将自启动脚本复制到/etc/systemd/system/ss-bash.service"
echo "Creating systemd service /etc/systemd/system/ss-bash.service"
cat << EOF > /etc/systemd/system/ss-bash.service
[Unit]
Description=ss-bash
Documentation=https://github.com/hellofwy/ss-bash/wiki
After=network.target

[Service]
User=root
Type=forking
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/ssadmin.sh start
ExecStop=$(pwd)/ssadmin.sh stop

[Install]
WantedBy=multi-user.target
EOF

if [ $? -eq 0 ]; then
	echo "成功 Success"
	echo ""
	echo "请用以下命令运行Shadowssocks"
	echo "Use the following commands to start Shadowsocks"
	echo "sudo systemctl daemon-reload"
	echo "sudo systemctl start ss-bash.service"
	echo ""
	echo "请用以下命令启动Shadowssocks自启动服务"
	echo "Use the following command to run Shadowsocks as service"
	echo "sudo systemctl enable ss-bash.service"
fi
