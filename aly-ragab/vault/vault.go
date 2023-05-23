package vault

import (
	"io/ioutil"
	"os"
)

var FilePath = os.Getenv("AUDIT_FILE_PATH")

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type AuditData struct {
	AuditContent string
}

func (ad *AuditData) AuditFileCheck() {
	_, err := os.Stat(FilePath)
	check(err)
	read, err := ioutil.ReadFile(FilePath)
	check(err)
	ad.AuditContent = string(read)
}

func TruncateAuditFile(file string) {
	if err := os.Truncate(FilePath, 0); err != nil {
		check(err)
	}
}
