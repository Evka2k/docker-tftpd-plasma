#!/bin/sh

opath=$(pwd -P)
ppath=$(cd "$(dirname $0)"; pwd -P)

cd $ppath
for d in ./*/download.sh; do
	$d
done

cd $opath
