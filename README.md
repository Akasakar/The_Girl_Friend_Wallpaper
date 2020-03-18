# The Girl Friend Wallpaper
## 环境构建

**ssh key**

``` shell
mkdir .ssh && cd .ssh
echo "id_pub" > authorized_keys
chmod 600 authorized_keys
chmod 700 .

sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/'  /etc/ssh/sshd_config
cat >> /etc/ssh/sshd_config << 'EOF'

RSAAuthentication yes
PubkeyAuthentication yes

EOF
systemctl reload sshd
```

**script**

``` shell
mkdir script
cd script
```

**BBR**

``` shell
wget -P ~/script/ https://raw.githubusercontent.com/Akasakar/The_Girl_Friend_Wallpaper/master/bbr_install.sh
curl -C - -o ~/script/bbr_install.sh https://raw.githubusercontent.com/Akasakar/The_Girl_Friend_Wallpaper/master/bbr_install.sh

# update kernel for CenOS8 commit
bash ~/script/bbr_install.sh &
```

**yum**

``` shell
yum -y update
yum -y install epel-release
yum -y install vim git zsh unzip make zlib zlib-devel gcc-c++ \
    libtool  openssl openssl-devel socat net-tools 
```

**vim**

``` shell	
yum -y install vim
cat >> ~/.vimrc << 'EOF'
filetype plugin indent on
set nu et acd
set ls=2 ts=4 sts=4 sw=4

EOF
```

---

**[~oh-my-zsh](https://ohmyz.sh/)**

* *install*

``` shell
yum -y install zsh curl wget git

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

* *configure*

``` shell	
sed -i 's/robbyrussell/agnoster/' ~/.zshrc
cat >> ~/.zshrc<<EOF

prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

EOF
cat >> ~/.zshrc<<EOF
alias ll='ls -alF'

EOF
source ~/.zshrc
```

> 下面荡的[Project V](https://www.v2ray.com/)
>
> 新 V2Ray 白话文指南：[安装v2ray](https://guide.v2fly.org/prep/install.html)
>
> [安装v2ray](https://toutyrater.github.io/prep/install.html)

**v2ray**

``` shell
wget -P ~/script/  https://install.direct/go.sh
bash ~/script/go.sh
systemctl start v2ray

# check config
sudo /usr/bin/v2ray/v2ray -test -config /etc/v2ray/config.json
```

**[Trojan-gfw](https://github.com/trojan-gfw/trojan)**

```shel
wget -P ~/script/ https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh
bash ~/script/trojan-quickstart.sh

ln -s /usr/local/etc/trojan /etc/trojan
```

> 新 V2Ray 白话文指南：[TLS](https://guide.v2fly.org/advanced/tls.html)
>
> [TLS](https://toutyrater.github.io/advanced/tls.html)

**SSL证书**

``` shell
curl  https://get.acme.sh | sh
#证书生成
#执行以下命令生成证书：
#以下的命令会临时监听 80 端口，请确保执行该命令前 80 端口没有使用
sudo ~/.acme.sh/acme.sh --issue --standalone -k ec-256 -d mydomain.me
#证书更新
sudo ~/.acme.sh/acme.sh --renew -d mydomain.com --force --ecc
#安装证书和密钥
sudo ~/.acme.sh/acme.sh --installcert -d mydomain.me --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc

wget -P ~/script/ https://raw.githubusercontent.com/Akasakar/The_Girl_Friend_Wallpaper/master/domain_acme.sh
```

**Apache**

```shell
yum -y install httpd mod_ssl openssl
# config file path
/etc/httpd/conf.d/
```

**Haproxy**

```shell
/etc/haproxy/haproxy.cfg
```



**fail2ban**

```
cat >> /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime  = 86400
findtime = 600
maxretry = 3

[sshd]
enabled = true
EOF
```

**firewall-cmd**

``` shell
firewall-cmd --add-services=http
```



---



## Shadowsocks-libev

#### Build from source with centos

* *prequirement*

If you are using CentOS 7, you need to install these prequirement to build from source code:

```shell
yum -y install epel-release
yum -y install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel
```

* *build shadowsocks-libev*

``` shel
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init
./autogen.sh && ./configure && make
make install
```

sample obfs

* *prequirement*

``` shell
# Debian / Ubuntu
sudo apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake
# CentOS / Fedora / RHEL
sudo yum install gcc autoconf libtool automake make zlib-devel openssl-devel asciidoc xmlto libev-devel
```

* *build sample-obfs*

``` shell
git clone https://github.com/shadowsocks/simple-obfs.git
cd simple-obfs
git submodule update --init --recursive
./autogen.sh
./configure && make
sudo make install
```

* creat directory

``` shell
mkdir -p /etc/shadowsocks-libev/
```

* /etc/shadowsocks-libev/config.json

``` json
{
	"server": "0.0.0.0",
	"server_port": 443,
	"local_port": 1080,
	"password": "psw",
	"timeout": 60,
	"method": "aes-256-gcm",
	"plugin": "obfs-server",
	"plugin_opts": "obfs=http"
}
```

* /etc/systemd/system/shadowsocks.service

``` shell
[Unit]
Description=Shadowsocks Server
After=network.target

[Service]
ExecStart=/usr/local/bin/ss-server -c /etc/shadowsocks-libev/config.json -u
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

``` shell
systemctl enable shadowsocks
systemctl start shadowsocks
systemctl status shadowsocks 
```



[`shadowsocks for Android`](https://github.com/shadowsocks/shadowsocks-android/releases)



---


