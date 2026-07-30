# Statistical Analysis Code

This repository contains the Stata (.do) and R Markdown (.Rmd) scripts used for the statistical analyses and figure generation for the manuscript:

**Lead exposure, anemia, and school readiness among low-income urban children in Bihar, India: A longitudinal study**

## Repository contents

The repository includes:

- Stata do-files for data management, variable derivation, descriptive analyses, and longitudinal statistical analyses.
- A Stata script for cleaning the International Development of the International Development and Early Learning Assessment (IDELA) questionnaire and scoring using an Item Response Theory (IRT) approach.
- An R Markdown script used for restricted cubic spline analyses and publication-quality figure generation.

File Description: 
01_merge_prepare_data.do | Data cleaning and preparation for analysis |
02_pb_idela_analysis.do | Primary longitudinal analyses, interactions, Table 2 |
03_pb_eyt_analysis.do | Primary longitudinal analyses, interactions, Table 2 |
04_pb_rcpm_crosssectional.do | Cross-sectional analysis between baseline blood lead and follow-up RCPM score |
05_Table1.do | Preparation and analysis for Table 1 |
06_idela_cleaning.do | Cleaning of domain and total scores in IDELA
07_IDELA_IRT.do | Deriving total and domain scores using an Item Response Theory (IRT) approach |
08_Figure-2-and-non-linearity-check.Rmd | Restricted cubic spline analyses and figure 2 generation |

## IDELA scoring

The same scoring algorithm was used for both the baseline (T1) and follow-up (T2) IDELA assessments. The IDELA scoring script included in this repository demonstrates the complete scoring procedure. The identical code was subsequently applied to the follow-up (T2) dataset by replacing the input dataset with the corresponding follow-up assessment data.

## Data availability

The analytical dataset used in this study is not publicly available because it contains confidential participant information. De-identified and curated data may be made available to bona fide researchers for scientific purposes upon reasonable request to the corresponding author (aditi@ccdcindia.org), subject to the necessary institutional data-sharing agreements and ethics approvals.

## Software
- Stata 16.1
- R (version 4.3.3)

## Reproducing the analyses

The scripts should be run in the order indicated by their filenames. Users will need access to the analytical dataset and may need to modify local file paths before executing the scripts.

## Contact

For questions regarding the code or requests for data access, please contact:

**Dr. Aditi Roy**  
Centre for Chronic Disease Control (CCDC), New Delhi  
Email: aditi@ccdcindia.org
