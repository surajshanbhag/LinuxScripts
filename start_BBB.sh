BBBIP="192.168.7.2"
interfaceName=`arp -a | grep $BBBIP`
set -- $interfaceName
echo "Using interface :$7"
sudo iptables --append FORWARD --in-interface $7 -j ACCEPT
sudo iptables --table nat --append POSTROUTING --out-interface wlp5s0 -j MASQUERADE
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
