#!/bin/bash

#SBATCH --job-name="glutamate_sim4_v3"
#SBATCH --time=3:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=compute-p2
#SBATCH --mem-per-cpu=1GB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim4/v3/postproc_sim4/Analysis_glutamate_v3.out
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim4/v3/postproc_sim4/Analysis_glutamate_v3.err
#SBATCH --mail-type=ALL

set -euo pipefail
module load 2025 openmpi gromacs

SELECT_1="atomnr 5777 plus com of atomnr {9080 9081}"
SELECT_2="atomnr 5777 plus com of atomnr {4826 4827}"


#compute distance glu584
gmx_mpi distance -s sim4_md.tpr -f trajout_whole_nojump.xtc -n index_group.ndx -select "${SELECT_1}" -oall data/glutamate584_sim4_v3.xvg 

#compute distance glu312
gmx_mpi distance -s sim4_md.tpr -f trajout_whole_nojump.xtc -n index_group.ndx -select "${SELECT_2}" -oall data/glutamate312_sim4_v3.xvg



