#!/bin/bash
INPUT="doh_server_urls.list"
sed -e 's/.*:\/\///g' -e 's/\/.*$//g' $INPUT > doh_server_domains.list
sort -u doh_server_domains.list > doh_server_domains.list.sorted && mv doh_server_domains.list.sorted doh_server_domains.list
