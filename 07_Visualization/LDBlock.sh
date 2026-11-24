#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

# 设置 Perl 模块路径
export PERL5LIB=/work/share/ac0ro0mhro/software/miniconda3/envs/ldblock/lib/perl5/site_perl:$PERL5LIB

# 运行 LDBlockShow
LDBlockShow -InVCF file_path/your_file.vcf -OutPut gwas_tmem100 -Region 11:80938513:80944315 -OutPng -SeleVar 1