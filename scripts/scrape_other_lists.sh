#!/bin/bash
SOURCES="https://raw.githubusercontent.com/crypt0rr/public-doh-servers/main/dns.list"
for source in ${SOURCES}; do
  curl -q $source >> doh_server_domains.list
done
sort -u doh_server_domains.list > doh_server_domains.list.sorted && mv doh_server_domains.list.sorted doh_server_domains.list
