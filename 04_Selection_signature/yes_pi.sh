#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

vcftools --gzvcf file_path/your_file.vcf.gz --window-pi 50000 --window-pi-step 20000 --out file_path/yes_maf0.5_geno0.1.pi