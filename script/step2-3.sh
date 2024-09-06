#!/bin/bash

#SBATCH -J Sm-1step-2-part3
#SBATCH -A p0020158
#SBATCH -n 96
#SBATCH --time=00:59:00
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=4096


module purge
module load intel python

root_dir="/home/xj54kovo/work/CFP/project1/Sm-2element"
find "$root_dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
        find "$subdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubdir; do
		find "$subsubdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubsubdir; do
       		(	
                	cd "$subsubsubdir" || exit
                	python /home/xj54kovo/work/CFP/project1/script1_1to3/step2/step2_vorb.py
       		)
		done
        done
done

