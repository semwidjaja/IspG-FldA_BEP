#!/bin/bash

#SBATCH --job-name="MMGBSA_sim8_v3"
#SBATCH --time=15:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --partition=compute-p2
#SBATCH --mem-per-cpu=3900MB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v3/postproc_sim8/MMGBSA_sim8_v3.out
#SBATCH --error=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v3/postproc_sim8/MMGBSA_sim8_v3.err
#SBATCH --mail-type=ALL

module load miniconda3 openmpi
module load 2025 openmpi gromacs

#set conda env
unset CONDA_SHLVL
source "$(conda info --base)/etc/profile.d/conda.sh"

conda activate gmxMMPBSA

# 4) Make sure the env's bin is at the front of PATH
export PATH="$CONDA_PREFIX/bin:$PATH"

# 5) Sanity checks
echo "CONDA_PREFIX = $CONDA_PREFIX"
echo "PATH = $PATH"
which gmx_MMPBSA || { echo 'gmx_MMPBSA not found in PATH'; exit 1; }

mpirun -np 10 gmx_MMPBSA \
    -O -i mmpbsa.in \
    -cs sim8_npt.tpr \
    -ct trajout_whole_nojump_100.xtc \
    -ci index_group.ndx \
    -cg 22 23 \
    -cp no_substrate_SQ_non_gro.top \
    -o mmgbsa/sim8_v3_MMPBSA.dat \
    -do mmgbsa/sim8_v3_MMPBSA_decomp.dat \
    -eo mmgbsa/sim8_v3_MMPBSA.csv

conda deactivate

