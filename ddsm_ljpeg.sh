#!/usr/bin/env bash

# read the input parameter
while getopts "d:" arg
do
	case $arg in
		d)
		echo "LJPEG files's path: $OPTARG"
		path=$OPTARG
		;;
		?)
		echo "unkonw argument"
		exit 1
		;;
	esac
done

# get the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "DDSM-LJPEG tool's root path: $DIR"

ljpeg2raw=$DIR/lib/decompress_ljpeg.py
raw2pnm=$DIR/ddsm/ddsm-software/ddsmraw2pnm
change_name=$DIR/lib/change_name.py
echo -e "\n"

cd $path

# convert LJPEG to png
for sub_path in $(ls)
do
	cd $sub_path
	cur_path=$(pwd)
	echo "Current path is $cur_path"

	# run python script to convert .LJPEG to raw image
	raw2pnm_command_split=$(python $ljpeg2raw --dir $cur_path --raw2pnm $raw2pnm)
	# echo $raw2pnm_command_split

	# convert raw image to .pnm format
	i=0
	for item in $raw2pnm_command_split
	do
		let "i=$i+1"

		# check whether the new command begins
		let "v=$i%5"
		first_flag=$[$v==1]
		# echo $i
		# echo $item

		# check whether a full command ends
		let "u=$i%5"
		round_flag=$[$u==0]
		if [ $first_flag == '1' ];then
			raw2pnm_command=$item
		else
			raw2pnm_command=$raw2pnm_command" "$item
		fi

		if [ $round_flag == '1' ];then
			echo $raw2pnm_command
			$raw2pnm_command
		fi
	done

	# use ImageMagick to convert .pnm to .png
	pnm_list=$(ls *.pnm)
	for file in $pnm_list
	do
		echo $file
	done

	printf "\n"

	cd ..
done

