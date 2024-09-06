#!/bin/bash

ml purge
ml load intel python/2.7.15 fftw

root_dir="/home/xj54kovo/work/CFP/project1/Sm-2element"
find "$root_dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
        find "$subdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubdir; do
		find "$subsubdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubsubdir; do
       		(
                	cd "$subsubsubdir" || exit
                	##cp -r /home/xj54kovo/work/CFP/project1/script1_1to3/step4/file_deliv/programs ./
			cp /home/xj54kovo/work/CFP/project1/script1_1to3/step4/file_deliv/make_inbkq.py ./
        	)
		done
        done
done
