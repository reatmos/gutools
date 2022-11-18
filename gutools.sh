#!/bin/bash
echo Wait..
if [ -f "ver.txt" ]; then
	rm "ver.txt"
fi
SORT_PATH=$(unalias sort &> /dev/null; command -v sort) || display_error "SORT ERROR" || return 1
versions=$(git ls-remote -t https://github.com/golang/go | awk -F/ '{ print $NF }' | $SORT_PATH)
for version in $versions; do
	if [[ "${version:0:3}" == "go1" ]]; then
		echo "$version"
	fi
done | sort -V > ver.txt
arch=$(uname -m)
gol=$(tail -1 ver.txt)
god=$(which go)
gopd="$(dirname "$god")"
goppd="$(dirname "$gopd")"
gor="$(dirname "$goppd")"
echo "####################"
printf "Last : "
echo "$gol"
rm "ver.txt"
gov=$(go version)
printf "Installed : "
echo "${gov:11:8}"
printf "ARCH : "
echo "$arch"
printf "GOROOT : "
echo "$gopd"
if [[ "$gol" == "${gov:11:8}" ]]; then
	echo "Go is Latest"
else
	echo "Go is Updatable"
	read -p "Do you want to update? 1. Yes 2. No : " gou
	if [[ "$gou" == "1" ]]; then
		if [[ "$arch" == "aarch64" ]]; then
			arch="arm64"
		elif [[ "$arch" == "x86_64" ]]; then
			arch="amd64"
		fi
		gog=("$gol".linux-"$arch".tar.gz)
		wget https://go.dev/dl/"$gog"
		mkdir "golatemp"
		tar -zxvf "$gog" -C "golatemp"
		rm "$gog"
		rm -rf "$goppd"
		mv "golatemp/go" "$gor"
		rmdir "golatemp"
		echo "Update Finish"
	fi
fi
echo "####################"
