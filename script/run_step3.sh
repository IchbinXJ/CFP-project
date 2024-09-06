#!/bin/bash

#SBATCH -J Sm-3step-1-part1
#SBATCH -A p0020158
#SBATCH -n 1  # Each job will use 1 CPU
#SBATCH --time=00:59:00
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=4096

module purge
module load intel/2020.4 intelmpi/2020.4 python/2.7.15 fftw/3.3.10

root_dir="/home/xj54kovo/work/CFP/project1/Sm-2element"

# Find all third-level subdirectories in root_dir and store them in an array
subsubsubdirs=($(find "$root_dir" -mindepth 3 -maxdepth 3 -type d))

# Calculate the total number of jobs
total_jobs=${#subsubsubdirs[@]}

# Submit each subsubsubdir as a separate job in the SLURM job array
for ((i=0; i<${total_jobs}; i++)); do
    subsubsubdir=${subsubsubdirs[$i]}
    case=$(basename "$subsubsubdir")

    # Submit job for each subsubsubdir
    sbatch <<EOF
#!/bin/bash
#SBATCH -J Sm-3step-1-part1-${i}
#SBATCH -A p0020158
#SBATCH -n 1
#SBATCH --time=03:00:00
#SBATCH --mem-per-cpu=4096
#SBATCH --export=ALL

module purge
module load intel/2020.4 intelmpi/2020.4 python/2.7.15 fftw/3.3.10

cd "$subsubsubdir" || { echo "Failed to change directory to $subsubsubdir"; exit 1; }

write_win num_iter 1000
mpiexec.hydra -n 1 wannier90.x -pp "$case"
x w2w
mpiexec.hydra -n 1 wannier90.x "$case"
EOF
done

