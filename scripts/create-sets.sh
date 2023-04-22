#!/bin/bash
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
