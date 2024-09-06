#!/bin/bash

##SBATCH -J hahahah-Sm-1step-3-part
##SBATCH -A p0020158
##SBATCH -n 96
##SBATCH --time=3:00:00
##SBATCH --export=ALL
##SBATCH --mem-per-cpu=4096

module purge
module load intel python/2.7.15 fftw

root_dir="/home/xj54kovo/work/CFP/project1/Sm-2element"
find "$root_dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
        find "$subdir" -mindepth 1 -maxdepth 1 -type d | while read -r subsubdir; do
        (
                cd "$subsubdir" || exit
                python save_case.py
        )
        done
done

