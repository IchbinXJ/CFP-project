#!/bin/bash

#SBATCH -J Sm-3step-1-part1
#SBATCH -A p0020158
#SBATCH -n 1  # Each job will use 1 CPU
#SBATCH --time=00:59:00
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=4096

module purge
module load intel python

root_dir="/home/xj54kovo/work/CFP/project1/Sm-2element"

# Find all third-level subdirectories in root_dir and store them in an array
subsubsubdirs=($(find "$root_dir" -mindepth 3 -maxdepth 3 -type d))
subsubsubsubdirs=($(find "$root_dir" -mindepth 4 -maxdepth 4 -type d))

# Calculate the total number of jobs
total_jobs=${#subsubsubdirs[@]}

# Submit each subsubsubdir as a separate job in the SLURM job array
for ((i=0; i<${total_jobs}; i++)); do
    subsubsubdir=${subsubsubdirs[$i]}
    subsubsubsubdir=${subsubsubsubdirs[$i]}
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
module load intel python

cd "$subsubsubdir" || { echo "Failed to change directory to $subsubsubdir"; exit 1; }
cp "${case}.inbkq" ./programs
cd "$subsubsubsubdir" || { echo "Failed to change directory to $subsubsubsubdir"; exit 1; }
bkq<"${case}.inbkq">"${case}.outbkq"


EOF
done

