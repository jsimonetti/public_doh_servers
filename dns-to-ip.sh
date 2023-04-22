#!/bin/bash
INPUT="doh_server_domains.list"
while IFS= read -r line
do
       dig @$1 +short -t "A" "$line" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >> ipv4.list|| true
       dig @$1 +short -t "AAAA" "$line" | grep -oE "\b(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\b" >> ipv6.list || true
done < "$INPUT"
sort -u ipv4.list | grep -v "0.0.0.0" | sort -h >> ipv4.list.sorted && mv ipv4.list.sorted ipv4.list
sort -u ipv6.list | grep -v "::" | sort -h >> ipv6.list.sorted && mv ipv6.list.sorted ipv6.list

echo "set doh_servers_ipv4 { " > nftables-ipv4-aggr.set
echo "  flags interval" >> nftables-ipv4-aggr.set
echo "  type ipv4_addr" >> nftables-ipv4-aggr.set
echo "  elements = {" >> nftables-ipv4-aggr.set
cat ipv4.list | aggregate6 | sed -e 's/$/,/g' -e 's/^/  /g' >> nftables-ipv4-aggr.set
echo "  }" >> nftables-ipv4-aggr.set
echo "}" >> nftables-ipv4-aggr.set

echo "set doh_servers_ipv4 { " > nftables-ipv4.set
echo "  type ipv4_addr" >> nftables-ipv4.set
echo "  elements = {" >> nftables-ipv4.set
cat ipv4.list | sed -e 's/$/,/g' -e 's/^/  /g' >> nftables-ipv4.set
echo "  }" >> nftables-ipv4.set
echo "}" >> nftables-ipv4.set

echo "set doh_servers_ipv6 { " > nftables-ipv6-aggr.set
echo "  flags interval" >> nftables-ipv6-aggr.set
echo "  type ipv6_addr" >> nftables-ipv6-aggr.set
echo "  elements = {" >> nftables-ipv6-aggr.set
cat ipv6.list | aggregate6 | sed -e 's/$/,/g' -e 's/^/  /g' >> nftables-ipv6-aggr.set
echo "  }" >> nftables-ipv6-aggr.set
echo "}" >> nftables-ipv6-aggr.set

echo "set doh_servers_ipv6 { " > nftables-ipv6.set
echo "  type ipv6_addr" >> nftables-ipv6.set
echo "  elements = {" >> nftables-ipv6.set
cat ipv6.list | sed -e 's/$/,/g' -e 's/^/  /g' >> nftables-ipv6.set
echo "  }" >> nftables-ipv6.set
echo "}" >> nftables-ipv6.set
