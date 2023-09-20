# FastQC
conda create -n fastqc
conda activate fastqc
conda install -c bioconda fastqc
conda deactivate

# Trimmomatic
conda create -n trimmomatic
conda activate trimmomatic
conda install -c bioconda trimmomatic
conda deactivate

# Mapping
conda create -n star
conda activate star
conda install -c bioconda star
conda deactivate