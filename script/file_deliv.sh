#!/bin/bash

ml purge
ml load intel python/2.7.15 fftw

root_dir="/home/xj54kovo/work/CFP/project1/Sm-2element"
find "$root_dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
        find "$subdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubdir; do
		find "$subsubdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubsubdir; do
       		(
                	cd "$subsubsubdir" || exit
                	cp /home/xj54kovo/work/CFP/project1/script1_1to3/step3/file_need_deliv/make_fermi.py ./
			cp /home/xj54kovo/work/CFP/project1/script1_1to3/step3/file_need_deliv/make_inwf.py ./
			cp /home/xj54kovo/work/CFP/project1/script1_1to3/step3/file_need_deliv/make_inwf2.py ./
			cp /home/xj54kovo/work/CFP/project1/script1_1to3/step3/file_need_deliv/step3_final.py ./
			cp /home/xj54kovo/work/CFP/project1/script1_1to3/step3/file_need_deliv/run_step3.sh ./
        	)
		done
        done
done
