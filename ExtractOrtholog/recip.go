package main

// get ortholog data from two files

import (
	"bufio"
	"bytes"
	"fmt"
	"log"
	"os"
	"strconv"
)

type hit struct {
	name   string
	eValue float64
}

const (
	nameField   = 0
	matchField  = 1
	eValueField = 10
)

func main() {

	// pairs is a key like hash in perl
	pairs := make(map[string]hit)
	sc := bufio.NewScanner(os.Stdin)

	// this is the loop we will using to get our results
	for sc.Scan() {
		f := bytes.Fields(sc.Bytes())
		fname := string(f[nameField])
		eValue, err := strconv.ParseFloat(string(f[eValueField]), 64)
		if err != nil {
			log.Fatalf("failed to parse float: %v", err)
		}
		prev, ok := pairs[fname]
		// only keep if not already seen, or eValue is lower
		if !ok || eValue < prev.eValue {
			pairs[fname] = hit{name: string(f[matchField]), eValue: eValue}
		}
	}
	if err := sc.Err(); err != nil {
		log.Fatalf("error during read:%v", err)
	}

	printed := make(map[string]bool)
	// iterate over results
	for c, m := range pairs {
		// used for check if already printed - don't do it again
		if printed[c] {
			continue
		}
		// check if paired match also matches original
		if h := pairs[m.name]; h.name == c {
			fmt.Println(c, m.name, m.eValue, h.eValue)
			printed[m.name] = true
		}
	}
}
