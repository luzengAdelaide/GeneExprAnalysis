# Amniote Gene Expression

Code used to explore the association of transposable elements (TEs) with gene expression during the Amniote evolution

#### Recommended programs
- CARP (https://github.com/carp-te/carp-documentation)
- SRA-Toolkit (https://www.ncbi.nlm.nih.gov/sra/docs/toolkitsoft/)
- RSEM (https://deweylab.github.io/RSEM/)
- BEDTools (http://bedtools.readthedocs.io/en/latest/)

#### Optional
- fastqc (https://www.bioinformatics.babraham.ac.uk/projects/download.html)
- Trim_galore (https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/)
- Bowtie2 (https://sourceforge.net/projects/bowtie-bio/files/bowtie2/)

#### Data used
- Genome (Downloaded from NCBI)
- RNA-seq (Downloaded from NCBI, Gene Expression Omnibus accession numbers GSE30352 and GSE97367, BioProject number PRJEB5206)
- Ortholog (https://asia.ensembl.org/info/website/archives/index.html)

#### Prerequisites
- Some level of familiarity with queuing systems (SLURM)

## Workflow


### 1) Use CARP to annotate TEs in the anmiote genomes
### 1a) Download or acquire genomes of interest
6 genomes were downloaded from public databases (NCBI); All genomes were downloaded using ```wget```, as recommended by NCBI (https://www.ncbi.nlm.nih.gov/genome/doc/ftpfaq/). See Supplementary Table 1 for the source and assembly version of each genome used.

### 1b) Extract speicifc TE types that are recent insertions.
Details can be found in TESeparation