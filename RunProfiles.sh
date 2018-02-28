#!/bin/bash
GET_GOOSE=1;
GET_GECO=1;
DOWNLOAD=1;
GET_VIRUS=1;
PARSE_ERR567364=1;
PARSE_ERR567365=1;
COMPRESS_ERR567364=1;
COMPRESS_ERR567365=1;
#==============================================================================
# GET GOOSE
if [[ "$GET_GOOSE" -eq "1" ]]; then
  rm -fr goose/ goose-*
  git clone https://github.com/pratas/goose.git
  cd goose/src/
  make
  cd ../../
  cp goose/src/goose-* .
  cp goose/scripts/*.sh .
fi
#==============================================================================
# GET FALCON
if [[ "$GET_GECO" -eq "1" ]]; then
  git clone https://github.com/pratas/geco.git
  cd geco/src/
  cmake .
  make
  cp GeCo ../../
  cd ../../
fi
#==============================================================================
# DOWNLOAD
if [[ "$DOWNLOAD" -eq "1" ]]; then
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567364/ERR567364.fastq.gz
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567365/ERR567365.fastq.gz
  # wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567366/ERR567366.fastq.gz
  # wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567367/ERR567367.fastq.gz
  # wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR732/ERR732642/ERR732642.fastq.gz
fi
#==============================================================================
# GET DB
if [[ "$GET_VIRUS" -eq "1" ]]; then
  printf "TAGTATTACCTGACCCCCTGAGTTGAGTGAGCAACTCTATCCTACTATCCACATAACACACCGTAGTCATTTCTGAAAATGCGTGGTCGTAAACGTGACCATCGAGGCCGTTTTATTAGAGCCACTGTCGTTGGTGCCGGACGTGCCATTAGATATGCTGCCGGAGTTGGCTCTGGCTTTGCTGGGCTTGCTTCTAGTTTTGCCCGAACTCGTCGTAATCGAATGACCTCTGGTCAAGGAGTTACCTTTGAAAATGATCGGACACGTATCTATCGTCGTAAAAGAGCACCTGCGCGAAAACGTCGTCGCTGGCGAAAAATCCTACGAGTCAACAACGCTGTTGACCAAACCAAACTGGGAACCAGAACTATTTTGTTTAATAAGAGCCAAACTTATGGAAACTCTACTGCTGGACAACATGGTTTAGCATGGGCTGCCCTTTATGGAGCAAACTCTGCCAATTCTGTCTTAAATGATCTTCGAGCTATCTGGTCGAACGAAGCCCTCAATCAGAACCCTACCGCAGGTGGAGGACCAACGTCTTATAACAGCACGAAAATGTTCTTTAAGTCTGCTGTACTGGACATGACAATCCGAAACGTCTCATCTGTCGGAGATGATATAACATCACCTGCTGATGTACCCCTTGAACTTGATATTTATGAAATGTCTTCAAAATGCCGAATGGTAGAAAATGATGCTGGAACTGCTCTTAAACAGTGGAACAACATCCCTGAAACCTTTGACGAAGCCCTTGACAATACCTTTGCTATTGACGGAGCTGGAACGAAGTGTGACCTAAACCTAAGAGGTGTAACCCCTTGGGAAAATACTTTTGCTCTATCTCGATACAAATACAAGATTCATAAAAAAACTAAATACCGGATCGGTCGTGGTAATTCTATCACTTATCAATTCCGAGACCCAAAGAATCGGACTACATCCCATAATGCCCTTGGAGACCTAGCAGGATTCAACAAACCTGGCTGGACTCATAACTTATTGATCGTCTATAAATCTGTACCCGGCTATTCAGTCGGAACAGCACCTACTGATATTCAGGAACGAATTGAAATCGGATATACTCGCAAGTATACATACAAAGTCGAAGGACATTCTGATGCACGAAGTTTATATATTAACTCGTAACATCTTTAAACTCCTTAAATCTCGTAAACCTTGAATGAAATCCCAAACTTGGTAAATAATGCCACTTATCTACTCTTCTTTCAAATGCAGGAAAATAACAACTGTCGCTGTTATACCACTGATCAGGACACTTATTAGTAGTAAAAATAATGGTTTTTGCAACAAACTGGAGCTGGCCTCCCTTACTTTCAACAAGCAACGGGTACCTGTCGCACAATCGTAACAACAAGTCGAATGGCAACCACCCGTAGTATTCGTCGATAATGACGGTCTCATGCCCGACGTATCCATCCCACCATTTACTTCTTTGCTTCCAATATGCTCCCGGATATTCGTCCATTGCCCACTTGGACTTCCCGGTTCCGGTAGGTCCATAGAGAACGTGTACTTCACACTCCCAATTCCTCGGTTCTGCTTTCATAGTCATATATTTCTCAAATGCCCTATAATGACGTACCCACAGATCAAAATGTTCATCTGCAATCTCTTCAATCGAACTTGATCGCTCGGACAACTTCTCTTTGATTTCCAATAGCCTCGAGTTCGTCCCACAATTCCCATTCTCGCTCGTCGCTAATGTTATCCCCCGCGAGTTCAAGCATGATGTTAAGCTGTCTGGATCCAAGTCTTCCCAAGATAGATCTCTTGAGGTCCACAGTCTCGGACGGACTAATCTGGAGTCCTCCTTGCAACAATACAGTATCGCCTGACTTCTTGTCCCCTTTCGGCGTTCCCAATGTGCCCTTCCGTTCAAGCCTTTCAGCCAACCAATCGCCCGCGGAGAGTCGATTTCCAGATAACCCTGCAAGTGTAATGTTTCCTCTTCCCCCATTTCCACTTGATACAATATCGTCTTCAGATGCGTTACAGGCCATTGTTCAGGATAATCAGTCAATTCAGGATTATTAATAGTAAAACACCAATTCCTACCAGACATTAAATTCAAAAGTGAGCGGTACTAACCGTTTACATAAAACCGTTTCTAATTCAAAATGAATGGCTACGCCGCGCAGATTAAATGCGCCAATCACCGTCAACCCCTAACCCCAGGGGCGCGGAGCGCGGGTAAGGGTAAGCGTAATGTCTTTCCTCGCAGGGGGTCAGCC" > viruses.fa
  cp viruses.fa virus-ERR567364.fa
  cp viruses.fa virus-ERR567365.fa
fi
#==============================================================================
# PARSE
if [[ "$PARSE_ERR567364" -eq "1" ]]; then
  zcat ERR567364.fastq.gz \
| ./goose-FastqMinimumLocalQualityScoreForward -k 5 -w 15 -m 33 \
| ./goose-FastqMinimumReadSize 35 \
| ./goose-FastqExcludeN 5 \
| ./goose-FastqMinimumQualityScore 15 \
> reads_ERR567364.fq
fi
#==============================================================================
# PARSE
if [[ "$PARSE_ERR567365" -eq "1" ]]; then
  zcat ERR567365.fastq.gz \
| ./goose-FastqMinimumLocalQualityScoreForward -k 5 -w 15 -m 33 \
| ./goose-FastqMinimumReadSize 35 \
| ./goose-FastqExcludeN 5 \
| ./goose-FastqMinimumQualityScore 15 \
> reads_ERR567365.fq
fi
#==============================================================================
# COMPRESS
if [[ "$COMPRESS_ERR567364" -eq "1" ]]; then
  (time ./GeCo -v -e -rm 13:10:0:0/0 -rm 14:50:0:3/1 -rm 20:100:1:5/10 -c 200 -r reads_ERR567364.fq virus-ERR567364.fa ) &> REPORT-V-ERR567364 ;
fi
#==============================================================================
# COMPRESS
if [[ "$COMPRESS_ERR567365" -eq "1" ]]; then
  (time ./GeCo -v -e -rm 13:10:0:0/0 -rm 14:50:0:3/1 -rm 20:100:1:5/10 -c 200 -r reads_ERR567365.fq virus-ERR567365.fa ) &> REPORT-V-ERR567365 ;
fi
#==============================================================================

