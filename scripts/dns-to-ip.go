package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"os"
	"time"
)

type DNSList map[string][]DNSEntry

type DNSEntry struct {
	IP       net.IP    `json:"ip"`
	LastSeen time.Time `json:"last_seen"`
}

var defaultIP4 = net.ParseIP("0.0.0.0")
var defaultIP6 = net.ParseIP("::")

func main() {
	dnsList, err := readDNSList("dns_list_to_ip.json")
	if err != nil {
		log.Fatal(err)
	}

	domains, err := os.Open("doh_server_domains.list")
	if err != nil {
		log.Fatal(err)
	}
	defer domains.Close()

	scanner := bufio.NewScanner(domains)
	for scanner.Scan() {
		domain := scanner.Text()
		ips, _ := net.LookupIP(scanner.Text())

		for _, ip := range ips {
			if ip.Equal(defaultIP4) || ip.Equal(defaultIP6) {
				continue
			}
			if _, ok := dnsList[domain]; !ok {
				dnsList[domain] = []DNSEntry{}
			}
			found := false
			for i, entry := range dnsList[domain] {
				if entry.IP.Equal(ip) {
					dnsList[domain][i].LastSeen = time.Now()
					found = true
				}
			}
			if !found {
				dnsList[domain] = append(dnsList[domain], DNSEntry{IP: ip, LastSeen: time.Now()})
			}
		}
	}

	pruneDnsList(&dnsList)

	if err := writeDNSList("dns_list_to_ip.json", dnsList); err != nil {
		log.Fatal(err)
	}

	writeV4List(dnsList, "ipv4.list")
	writeV6List(dnsList, "ipv6.list")

}

func readDNSList(filename string) (DNSList, error) {
	b, err := os.ReadFile(filename)

	var dnsList DNSList
	if err != nil {
		return nil, err
	}
	err = json.Unmarshal(b, &dnsList)
	return dnsList, err
}

func writeDNSList(filename string, dnsList DNSList) error {
	b, err := json.MarshalIndent(dnsList, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(filename, b, 0644)
}

func pruneDnsList(dnsList *DNSList) {
	for domain, entries := range *dnsList {
		for i, entry := range entries {
			// remove entry from list if it's older than 30 days
			if time.Since(entry.LastSeen) > 30*24*time.Hour {
				if len((*dnsList)[domain]) == 1 {
					delete(*dnsList, domain)
					break
				}
				if len((*dnsList)[domain]) > i+1 {
					(*dnsList)[domain] = append((*dnsList)[domain][:i], (*dnsList)[domain][i+1:]...)
				} else {
					(*dnsList)[domain] = (*dnsList)[domain][:i]
				}
			}
		}
		if len((*dnsList)[domain]) == 0 {
			delete(*dnsList, domain)
		}
	}
}

func writeV4List(dnsList DNSList, filename string) {
	f, err := os.Create(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	for _, entries := range dnsList {
		for _, entry := range entries {
			if entry.IP.To4() != nil {
				fmt.Fprintf(f, "%s\n", entry.IP)
			}
		}
	}
}

func writeV6List(dnsList DNSList, filename string) {
	f, err := os.Create(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	for _, entries := range dnsList {
		for _, entry := range entries {
			if entry.IP.To4() == nil {
				fmt.Fprintf(f, "%s\n", entry.IP)
			}
		}
	}
}
