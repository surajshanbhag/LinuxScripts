# List all IP to be checked to Forward the USB IP
BBBIP=("192.168.8.2" "192.168.7.2")
for ip in ${BBBIP[@]}; do
    interfaceName=`arp -a | grep $ip`
    if [ "$interfaceName" = "" ]
    then
        echo -n "not found:" $ip
    else
        echo -n "    found": $ip
        set -- $interfaceName
        echo -n "    interface:$7"
        sudo iptables --append FORWARD --in-interface $7 -j ACCEPT
        sudo iptables --table nat --append POSTROUTING --out-interface wlp5s0 -j MASQUERADE
        sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
    fi
    echo ""
done
