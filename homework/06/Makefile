
all: build

build:

PP=`pwd`
FN=Assignment-06
DIR=.././../
IMG=
PY= \
Vest90Days/contracts/Vest90Days.sol

all: setup all2

setup:
	../mk_all_nu.sh

all2: ${FN}.html ${PY} 


.PRECIOUS: %.md 
%.md: %.raw.md $(PY) $(IMG)
	m4 -P $< >$@

%.html: %.md
	blackfriday-tool ./$< $@
	echo cat ./${DIR}/css/md.css $@ >/tmp/$@
	cat ./${DIR}/css/pre ./${DIR}/css/markdown.css ./${DIR}/css/post ./${DIR}/css/md.css ./${DIR}/css/hpre $@ ./${DIR}/css/hpost >/tmp/$@
	mv /tmp/$@ ./$@
	echo "file://${PP}/$@" >>open.1

