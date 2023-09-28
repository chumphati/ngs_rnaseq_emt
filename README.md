# Pipeline du TP NGS RNA-seq

__Fiona Hak<sup>1</sup>__
<br>
<sub>1. Université Paris-Saclay

Ce dépôt contient un pipeline bash d'analyse de données NGS allant de l'importation des données du TP (ou autres à condition de fournir un chemin vers les fichiers fastq) à l'identification de gènes.
Les consignes du TP sont dans le dossier "data".

## Installation
Ce dépôt doit être cloné :

    git clone git@github.com:chumphati/ngs_ue_ami2b.git

## Usage
Le pipeline peut être lancé via ses executables directement dans le dossier d'installation :

    cd ngs_ue_ami2b
    conda activate analyzer
    bash analyzer.sh <options> [--download_data | --import_data]

Pour plus d'information sur les options disponible :

    bash analyzer.sh --help

Il faut obligatoirement spécifier en argument si on souhaite télécharger de novo les données ou fournir un dossier des fichiers fastq.

## Dépendances
Ce pipeline est basé sur plusieurs dépendances, contenus dans des environnements conda  :

- fastqc v.0.12.1
- trimmomatic v.0.39
- star v.2.7.11a
- samtools v1.17.24
- subread v2.0.3

Ces dépendances peuvent être installées via :

    conda create -n analyzer
    conda activate analyzer
    conda install -c bioconda fastqc
    conda install -c bioconda trimmomatic
    conda install -c bioconda star
    conda install -c bioconda samtools
    conda deactivate
    sudo apt-get install subread


