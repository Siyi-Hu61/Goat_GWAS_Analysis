Goat Whole-Genome Sequencing and Genome-Wide Association Analysis

Overview

This repository contains the analysis scripts used in the whole-genome sequencing (WGS), population genetics, selection signature, and genome-wide association study (GWAS) of goats.

The scripts cover genotype quality control, population structure analysis, GWAS using GEMMA and Fast3VmrMLM, selection signature analysis, downstream result processing, and data visualization.

This repository aims to provide a reproducible analytical workflow and facilitate the reuse of the methods and scripts described in the associated research article.

Repository Organization

The repository is organized into seven main directories according to the analytical workflow.

01_PLINK_QC

Scripts for genotype quality control and filtering using PLINK: v1.90.

This directory contains scripts related to genotype data preparation and quality control.

02_Population_Structure

Scripts for population structure analysis.

This directory contains the scripts used to investigate genetic relationships and population structure among goat individuals.

03_GWAS_GEMMA

Scripts for genome-wide association analysis using GEMMA: v0.98.5.

This directory contains the scripts and relevant parameter settings used for GWAS analysis based on the GEMMA software.

04_Selection_signature

Scripts for selection signature analysis.

This directory contains the scripts used to identify genomic regions potentially affected by selection.

05_GWAS_Fast3VmrMLM

Scripts for genome-wide association analysis using Fast3VmrMLMv3.0.

This directory contains the scripts and parameter settings used to perform GWAS with the Fast3VmrMLM method.

06_Result_Processing

Annotation files and supporting resources for downstream analysis and interpretation of GWAS and genomic analysis results.

This directory contains annotation files used to annotate candidate genomic regions, SNPs, and genes, facilitating the identification and functional interpretation of candidate genes associated with the studied traits.

07_Visualization

Scripts for data visualization.

This directory contains scripts used to generate figures and graphical representations of the analysis results.

Analysis Workflow

The overall analytical workflow is organized as follows:

Genotype Quality Control: Quality control and filtering of genotype data using PLINK.

Population Structure Analysis: Investigation of population genetic structure.

GWAS Using GEMMA: Genome-wide association analysis using GEMMA.

Selection Signature Analysis: Identification of candidate genomic regions under selection.

GWAS Using Fast3VmrMLM: Genome-wide association analysis using Fast3VmrMLM.

Result Processing: Downstream processing and organization of analytical results.

Data Visualization: Generation of figures for the presentation and interpretation of results.

Software Requirements

The analyses were performed using the following software and tools:

PLINKv1.90

GEMMAv0.98.5

Fast3VmrMLM:v3.0

R: v4.3.2

Relevant R packages and other command-line tools required by individual scripts

The specific software versions and package dependencies should be provided in the corresponding analysis scripts or supplementary documentation.

Data Availability

The raw sequencing data generated in this study have been deposited in the Genome Sequence Archive (GSA) at the National Genomics Data Center (NGDC), China, under accession number CRA039898.

The GWAS summary statistics have been deposited in the OMIX repository under accession number OMIX019587.

Please refer to the associated publication for further information regarding data access and availability.

Reproducibility

The scripts in this repository are provided to facilitate the reproducibility of the analyses described in the associated publication.

Before running the scripts, users should:

Install the required software and R packages.

Download the relevant datasets from the corresponding public repositories, where available.

Adjust input and output file paths according to their local computing environments.

Check the parameters and execution instructions in each script.

Please note that the scripts may require modifications to accommodate different datasets and computing environments.

Citation

If you use the scripts or analytical workflow provided in this repository, please cite the associated research article:

[Insert the full citation of the published article here.]

Contact

For questions regarding the analytical scripts or research, please contact the corresponding author of the associated publication.
