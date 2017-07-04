#!/bin/bash
# Generate the list based on https://discourse.pi-hole.net/t/how-do-i-block-ads-on-youtube/253/11?u=jacob.salmela

## vars
REPONAME=rootsubgen
REPODIR=/etc/"$REPONAME"/
REPOOWNER=deathbybandaid
GITREPOSITORYURL="github.com/"$REPOOWNER"/"$REPONAME".git"
DOCTOSPITOUT="$REPODIR"domainlist.txt
DOCTOSPITOUTB="$REPODIR"domainlistb.txt

# Brace expanded array of Google Video fingerprints from sn-aaaaaaaa to sn-99999999
fingerprints=($(echo sn-{{a..z},{0..9}}{{a..z},{0..9}}{{a..z},{0..9}}{{a..z},{0..9}}{{a..z},{0..9}}{{a..z},{0..9}}{{a..z},{0..9}}{{a..z},{0..9}}))

# For each fingerpint, 
for ((i = 0; i < "${#fingerprints[@]}"; i++)); do

DOMAINONE=`echo r{1..20}---${fingerprints[$i]}.googlevideo.com`
DOMAINTWO=`echo r{1..20}.${fingerprints[$i]}.googlevideo.com`

SOURCEIPFETCHONE=`ping -c 1 $DOMAINONE | gawk -F'[()]' '/PING/{print $2}'`
SOURCEIPONE=`echo $SOURCEIPFETCHONE`
SOURCEIPFETCHTWO=`ping -c 1 $DOMAINTWO | gawk -F'[()]' '/PING/{print $2}'`
SOURCEIPTWO=`echo $SOURCEIPFETCHTWO`

if
[[ -n $SOURCEIPONE ]]
then
echo "$DOMAINONE is located at $SOURCEIPONE"
echo "$DOMAINONE" | tee --append $DOCTOSPITOUT &>/dev/null
fi

if
[[ -n $SOURCEIPTWO ]]
then
echo "$DOMAINTWO is located at $SOURCEIPTWO"
echo "$DOMAINTWO" | tee --append $DOCTOSPITOUT &>/dev/null
fi

unset SOURCEIPONE
unset SOURCEIPTWO

done
