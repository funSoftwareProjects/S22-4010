
all: build

build:
	( cd bsvr/main ; go build )
	( cd sig-test ; go build )
	( cd wallet-client ; go build )

PP=`pwd`
FN=Assignment-04-Signatures
FN1=
FN2=development-steps
DIR=.././../
IMG=
PY=

all: setup all2

setup:
	../mk_all_nu.sh

all2: ${FN}.html ${PY} ${FN2}.html


.PRECIOUS: %.md 
%.md: %.raw.md $(PY) $(IMG)
	m4 -P $< >$@

%.html: %.md
	blackfriday-tool ./$< $@
	echo cat ./${DIR}/css/md.css $@ >/tmp/$@
	cat ./${DIR}/css/pre ./${DIR}/css/markdown.css ./${DIR}/css/post ./${DIR}/css/md.css ./${DIR}/css/hpre $@ ./${DIR}/css/hpost >/tmp/$@
	mv /tmp/$@ ./$@
	echo "file://${PP}/$@" >>open.1

