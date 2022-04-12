#!/bin/bash

function mk_nu(){
	cat -n $1 | sed -e 's/\t/    /g' -e 's/^   //' -e 's/    /: /' >$1.nu
}

if ls *.sql >/dev/null 2>&1 ; then
	for i in *.sql ; do
		mk_nu $i
	done
fi
if ls *.go >/dev/null 2>&1 ; then
	for i in *.go ; do
		mk_nu $i
	done
fi
if ls *.sol >/dev/null 2>&1 ; then
	for i in *.sol ; do
		mk_nu $i
	done
fi

if ls */*.sql >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.sql" | sed -e '/node_modules/d' ) ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*.go >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.go" | sed -e '/node_modules/d' ) ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*.sol >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.sol" | sed -e '/node_modules/d' ) ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*/*.sol >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.sol" | sed -e '/node_modules/d' ) ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*/*/*.sol >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.sol" | sed -e '/node_modules/d' ) ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*/*.js >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.js" | sed -e '/node_modules/d' ) ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi




