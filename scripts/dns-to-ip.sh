#!/bin/bash
sort -u ipv4.list | grep -v "0.0.0.0" | sort -h >> ipv4.list.sorted && mv ipv4.list.sorted ipv4.list
sort -u ipv6.list | grep -v "::" | sort -h >> ipv6.list.sorted && mv ipv6.list.sorted ipv6.list
