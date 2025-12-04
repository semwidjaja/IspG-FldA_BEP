#!/bin/bash
#SBATCH --job-name="post_proc_NSQ_v3"
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=compute-p1,compute-p2
#SBATCH --mem-per-cpu=3800MB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v3/postproc_sim8/postproc_NSQ_v3.out
#SBATCH --error=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v3/postproc_sim8/postproc_NSQ_v3.err
#SBATCH --mail-type=ALL

module load 2025 openmpi gromacs


printf '0\n'| gmx_mpi trjconv -s sim8_md.tpr -f sim8_md.xtc -o postproc_sim8/trajout_whole.xtc -pbc whole
printf '0\n'| gmx_mpi trjconv -s sim8_md.tpr -f trajout_whole.xtc -o postproc_sim8/trajout_whole_nojump.xtc -pbc nojump
rm trajout_whole.xtc # remove this intermediate file to save space
printf '0\n'| gmx_mpi trjconv -s sim8_md.tpr -f trajout_whole_nojump.xtc -o postproc_sim8/trajout_whole_nojump_10.xtc -n index_group.ndx -skip 10
printf '0\n'| gmx_mpi trjconv -s sim8_md.tpr -f trajout_whole_nojump_10.xtc -o postproc_sim8/trajout_whole_nojump_100.xtc -n index_group.ndx -skip 10
