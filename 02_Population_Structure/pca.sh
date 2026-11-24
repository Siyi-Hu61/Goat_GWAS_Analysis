#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

plink --bfile file_path/your_file --pca 20 --out file_path/snp_pca --chr-set 29