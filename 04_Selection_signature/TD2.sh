#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

vcftools --gzvcf file_path/your_file.vcf.gz --chr 8 --from-bp 27420001 --to-bp 27780000 --TajimaD 20000 --out no.2K.BNC2-27420001-27780000.TajimaD