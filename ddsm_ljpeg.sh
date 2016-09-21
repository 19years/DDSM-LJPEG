#!/usr/bin/env bash

# read the input parameter
while getopts "d:i:" arg
do
	case $arg in
		d)
		printf "LJPEG files's path: %s\n" $OPTARG
		path_ljpeg=$OPTARG
		;;
		i)
		printf "imdb_IRMA's path: %s\n" $OPTARG
		imdb_path=$OPTARG
		;;
		?)
		echo "unkonw argument"
		exit 1
		;;
	esac
done


# get the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

printf "DDSM-LJPEG tool's root path: %s\n\n" $DIR

gen_img_list=$DIR/lib/gen_img_list.py
ljpeg2raw=$DIR/lib/decompress_ljpeg.py
raw2pnm=$DIR/ddsm/ddsm-software/ddsmraw2pnm
change_name=$DIR/lib/change_name.py


# generate image index list of imdb_IRMA
$(python $gen_img_list --imdb $imdb_path)


# convert LJPEG to png
cd $path_ljpeg

for sub_path in $(ls)
do
	cd $sub_path
	cur_path=$(pwd)
	printf "Current path is %s\n" $cur_path

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
			printf "%s %s %s %s %s\n" $raw2pnm_command
			$raw2pnm_command
		fi
	done

	# use ImageMagick to convert .pnm to .png
	pnm_list=$(ls *.pnm)
	for file in $pnm_list
	do
		convert $file $file.png
		printf "%s\n" $file.png
	done

	# use python script to change .png image name
	# if not match with imdb_IRMA
	

	printf "\n"

	cd ..
done

