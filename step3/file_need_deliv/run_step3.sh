#!/bin/bash  -l
#SBATCH -J run3-Sm-3step-final-part
#SBATCH -A p0020158
#SBATCH -n 96
#SBATCH --time=6:00:00
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=4096


module purge
module load intel intelmpi python/2.7.15 fftw

#module load python
python step3_final.py
exit

