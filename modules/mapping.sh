#!/bin/bash

FILTERED_FASTQ="results/FASTQ/FILTERED"
MAPPING="results/MAPPING"
MAPPING_REF="results/MAPPING/DATA_REF"

echo "Download reference and annotation file ............................. 0%"

#créer le répertoire si nécessaire
if [ ! -d results/MAPPING ];then
  mkdir -p results/MAPPING/DATA_REF
fi

wget -P $MAPPING_REF http://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/chr18.fa.gz > /dev/null 2>&1
echo -e "\033[1ADownload reference and annotation file ............................. 30%"
wget -P $MAPPING_REF ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_24/GRCh37_mapping/gencode.v24lift37.basic.annotation.gtf.gz > /dev/null 2>&1
echo -e "\033[1ADownload reference and annotation file ............................. 60%"
gunzip $MAPPING_REF/gencode.v24lift37.basic.annotation.gtf.gz > /dev/null 2>&1
echo -e "\033[1ADownload reference and annotation file ............................. 80%"
gunzip $MAPPING_REF/chr18.fa.gz > /dev/null 2>&1

echo -e "\033[1ADownload reference and annotation file ............................. 100%"

echo "Index reference ............................. 0%"
STAR --runMode genomeGenerate --runThreadN 4 --genomeDir index --genomeFastaFiles chr18.fa --sjdbGTFfile gencode.v24lift37.basic.annotation.gtf > /dev/null 2>&1
echo -e "\033[1AIndex reference ............................. 100%"

echo "Mapping ............................. 0%"
sample_list=("Day_0_1_chr18.sampled" "Day_0_2_chr18.sampled" "Day_0_3_chr18.sampled" "Day_7_1_chr18.sampled" "Day_7_2_chr18.sampled" "Day_7_3_chr18.sampled")
x=0
for i in ${sample_list[*]};do
  ((x=x+15))
  echo -e "\033[1AMapping ............................. ${x}%"
  STAR --runThreadN 8 --outFilterMultimapNmax 1 --genomeDir index --outSAMattributes All --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $MAPPING/${i} --readFilesIn $FILTERED_FASTQ/${i}_1P.fastq $FILTERED_FASTQ/${i}_2P.fastq > /dev/null 2>&1
done
echo -e "\033[1AMapping ............................. 100%"
