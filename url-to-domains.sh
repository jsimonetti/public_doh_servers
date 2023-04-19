#!/bin/bash
INPUT="doh_server_urls.list"
sed -e 's/.*:\/\///g' -e 's/\/.*$//g' $INPUT > doh_server_domains.list
