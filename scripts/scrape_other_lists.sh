#!/bin/bash
SOURCES="https://raw.githubusercontent.com/crypt0rr/public-doh-servers/main/dns.list https://raw.githubusercontent.com/dibdot/DoH-IP-blocklists/refs/heads/master/doh-domains.txt"
for source in ${SOURCES}; do
  curl -q $source >> doh_server_domains.list
done
sort -u doh_server_domains.list > doh_server_domains.list.sorted && mv doh_server_domains.list.sorted doh_server_domains.list
