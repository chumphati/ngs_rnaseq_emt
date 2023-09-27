#!/bin/bash

MAPPING="results/MAPPING"
MAPPING_REF="results/MAPPING/DATA_REF"
COUNT="results/COUNT"

#créer le répertoire si nécessaire
if [ ! -d "$COUNT" ]; then
  mkdir -p "$COUNT"
fi

echo "Index bam files ............................. 0%"
sample_list=("Day_0_1_chr18.sampled" "Day_0_2_chr18.sampled" "Day_0_3_chr18.sampled" "Day_7_1_chr18.sampled" "Day_7_2_chr18.sampled" "Day_7_3_chr18.sampled")
x=0
for i in ${sample_list[*]}; do
  ((x=x+15))
  echo -e "\033[1AIndex bam files ............................. ${x}%"
  samtools index "$MAPPING/${i}Aligned.sortedByCoord.out.bam" > /dev/null 2>&1
done
echo -e "\033[1AIndex bam files ............................. 100%"

echo "Feature counts ............................. 0%"
featureCounts -p -t exon -g gene_id -a "$MAPPING_REF/gencode.v24lift37.basic.annotation.gtf" -o "$COUNT/featureCounts.txt" $MAPPING/*.bam > /dev/null 2>&1
echo -e "\033[1AFeature counts ............................. 25%"
perl -ne 'print "$1 $2\n" if /gene_id \"(.*?)\".*gene_name \"(.*?)\"/' "$MAPPING_REF/gencode.v24lift37.basic.annotation.gtf" | sort | uniq > "$COUNT/encode-to-hugo.tab" > /dev/null 2>&1
echo -e "\033[1AFeature counts ............................. 50%"
sort -k1,1 "$COUNT/featureCounts.txt" > "$COUNT/temp1" > /dev/null 2>&1
echo -e "\033[1AFeature counts ............................. 60%"
sort -k1,1 "$COUNT/encode-to-hugo.tab" > "$COUNT/temp2" > /dev/null 2>&1
echo -e "\033[1AFeature counts ............................. 80%"
join -1 1 -2 1 "$COUNT/temp1" "$COUNT/temp2" | grep "chr18" | awk '{print $5 " " $1}' > "$COUNT/final_counts.txt" > /dev/null 2>&1
echo -e "\033[1AFeature counts ............................. 100%"
