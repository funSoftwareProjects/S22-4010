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
	for i in $( find . -name "*.sql") ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*.go >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.go") ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*.sol >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.sol") ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi
if ls */*/*.sol >/dev/null 2>&1 ; then
	XXX=$(pwd)
	for i in $( find . -name "*.sol") ; do
		DN=$(dirname $i)
		BN=$(basename $i)
		cd $DN
		mk_nu $BN
		cd $XXX
	done
fi




