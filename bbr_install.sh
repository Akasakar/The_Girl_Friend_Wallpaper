# install bbr for CentOS 8 shell

Update_kernel()
{
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    yum install \
        https://www.elrepo.org/elrepo-release-8.1-1.el8.elrepo.noarch.rpm
    yum --enablerepo=elrepo-kernel -y install kernel-ml
    rpm -qa | grep kernel
    grub2-set-default 0
    reboot
}

Enable_BBR()
{
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl -n net.ipv4.tcp_congestion_control
    lsmod | grep "tcp_bbr"
}

[[ $EUID != 0 ]] && echo "error: No root${EUID} permission." && exit -1;
#Update_kernel
Enable_BBR

