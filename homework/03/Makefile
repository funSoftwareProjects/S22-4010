
all: build

build:
	( cd bsvr/main ; go build )

PP=`pwd`
FN=Assignment-03-Transactions
FN1=handout-p1
FN2=handout-p2
DIR=.././../
IMG=
PY=

all: setup all2

setup:
	../mk_all_nu.sh

all2: ${FN}.html ${PY} ${FN1}.html ${FN2}.html


.PRECIOUS: %.md 
%.md: %.raw.md $(PY) $(IMG)
	m4 -P $< >$@

%.html: %.md
	blackfriday-tool ./$< $@
	echo cat ./${DIR}/css/md.css $@ >/tmp/$@
	cat ./${DIR}/css/pre ./${DIR}/css/markdown.css ./${DIR}/css/post ./${DIR}/css/md.css ./${DIR}/css/hpre $@ ./${DIR}/css/hpost >/tmp/$@
	mv /tmp/$@ ./$@
	echo "file://${PP}/$@" >>open.1

