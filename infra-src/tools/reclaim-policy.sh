#!/bin/bash

PV_LIST=$1

# Fonction to patch all pv from a list, list is a file as $1
function patch_pv() {
	echo "Patching all PV..."
	while read pv; do
		kubectl patch pv $pv -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
	done < $1
	echo "...Done"
}

# Check if 1st argument is provided, we need at least one
if [ -z ${PV_LIST} ]; then
	echo "First argument must be --all OR --file"
	exit -1
# Or we use --all for all the PV of the cluster
elif [[ ${PV_LIST} == "--all" ]]; then
	kubectl get pv |awk {'print $1'} |tail -n +2 > /tmp/pv
	patch_pv /tmp/pv
	rm /tmp/pv
# Or we use --file <FILE> to patch a pv list
elif [[ ${PV_LIST} == "--file" ]]; then
	# If we use --file, then we need to provide a file afterwards
	if [ -z $2 ]; then
		echo "When you use --file you must provide as second argument the file with the pv list"
		exit -2
	fi
	# And we need this file to exist ...
	if [ ! -f $2 ]; then
		echo "File $2 not found, please verify the path"
		exit -3
	fi
	patch_pv $2
fi
