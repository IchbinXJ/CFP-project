#!/bin/bash  -l
#SBATCH -J run33-Sm-1step-3-part
#SBATCH -A p0020158
#SBATCH -n 96
#SBATCH --time=6:00:00
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=4096


module purge
module load intel python/2.7.15 fftw
#module load python
echo -e "1000\n0\n" | x kgen -fbz
x lapw1 -orb
exit

