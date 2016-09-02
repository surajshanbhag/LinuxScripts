interfaceName=`ifconfig | grep "80:30:dc:90:f2:eb"`
set -- $interfaceName
sudo iptables --append FORWARD --in-interface $1 -j ACCEPT
sudo iptables --table nat --append POSTROUTING --out-interface wlp5s0 -j MASQUERADE
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
