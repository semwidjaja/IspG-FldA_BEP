#!/bin/bash

#SBATCH --job-name="analysis_sim8_v1"
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=compute-p2
#SBATCH --mem-per-cpu=1GB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v1/analysis_sim8_v1/Analysis_no_SQ_v1.out
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v1/analysis_sim8_v1/Analysis_no_SQ_v1.err
#SBATCH --mail-type=ALL

module load 2025 openmpi gromacs

#RMSD 
printf '4\n4\n' | gmx_mpi rms -f trajout_whole_nojump.xtc -s sim8_npt.tpr -n index.ndx -o RMSD_v1.xvg 

# RMSF
printf '4/n' | gmx_mpi rmsf -f trajout_whole_nojump.xtc -s sim8_npt.tpr -n index.ndx -res -o RMSF_v1.xvg 

# Gyration
printf '1/n' | gmx_mpi gyrate -f trajout_whole_nojump.xtc -s sim8_npt.tpr -n index.ndx -o gyrate_v1.xvg 

#Cofactor distance (COM); N5-C4A
printf '' | gmx_mpi distance -f trajout_whole_nojump.xtc -s sim8_md.tpr -n index.ndx -select "atomnr 11558 plus com of atomnr {14283 14285}" -oall cofactor_dis_v1.xvg

#Cofactor distance (COM); N5-C5A
printf '' | gmx_mpi distance -f trajout_whole_nojump.xtc -s sim8_md.tpr -n index.ndx -select "atomnr 11558 plus com of atomnr {14285 14286}" -oall cofactor_dis_v2.xvg

#Angle 
printf '' | gmx_mpi gangle -s sim8_md.tpr -f trajout_whole_nojump.xtc -n index.ndx -g1 plane -group1 "atomnr {14283 14285 14286}" -g2 vector -group2 "atomnr {14283 14285 14286} atomnr 11588" -oav data/FMN_SF4_angle_sim8_v2.xvg

