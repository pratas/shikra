#!/bin/bash
GET_GOOSE=1;
GET_FALCON=1;
GET_GULL=1;
DOWNLOAD=1;
GET_DB=1;
PARSE_ERR567364=1;
PARSE_ERR567365=1;
PARSE_ERR732642=0;
COMPRESS_ERR567364=1;
COMPRESS_ERR567365=1;
COMPRESS_ERR732642=0;
INTRASIM_ERR567364=1;
INTRASIM_ERR567365=1;
INTRASIM_ERR732642=0;
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
if [[ "$GET_FALCON" -eq "1" ]]; then
  git clone https://github.com/pratas/falcon.git
  cd falcon/src/
  cmake .
  make
  cp FALCON ../../
  cp FALCON-FILTER ../../
  cp FALCON-EYE ../../
  cd ../../
  cp falcon/scripts/*.pl .
fi
#==============================================================================
# GET GULL
if [[ "$GET_GULL" -eq "1" ]]; then
  rm -fr GULL/ GULL-map GULL-visual
  git clone https://github.com/pratas/GULL.git
  cd GULL/src/
  cmake .
  make
  cp GULL-map ../../
  cp GULL-visual ../../
  cd ../../
fi
#==============================================================================
# DOWNLOAD
if [[ "$DOWNLOAD" -eq "1" ]]; then
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567364/ERR567364.fastq.gz
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567365/ERR567365.fastq.gz
  # wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567366/ERR567366.fastq.gz
  # wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR567/ERR567367/ERR567367.fastq.gz
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR732/ERR732642/ERR732642.fastq.gz
fi
#==============================================================================
# GET DB
if [[ "$GET_DB" -eq "1" ]]; then
  perl DownloadArchaea.pl
  perl DownloadBacteria.pl
  perl DownloadFungi.pl
  perl DownloadViruses.pl
  cat bacteria.fa | grep -v -e "ERROR" -e "eFetchResult" -e "DOCTYPE" -e "xml version" -e "Unable to obtain" | grep -v -x ">" > bacteria.fna
  mv bacteria.fna bacteria.fa
  cat viruses.fa bacteria.fa archaea.fa fungi.fa | tr ' ' '_' | ./goose-extractreadbypattern complete_genome | ./goose-getunique > DB.fa
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
# PARSE
if [[ "$PARSE_ERR732642" -eq "1" ]]; then
  zcat ERR732642.fastq.gz \
| ./goose-FastqMinimumLocalQualityScoreForward -k 5 -w 15 -m 33 \
| ./goose-FastqMinimumReadSize 35 \
| ./goose-FastqExcludeN 5 \
| ./goose-FastqMinimumQualityScore 15 \
> reads_ERR732642.fq
fi
#==============================================================================
# COMPRESS
if [[ "$COMPRESS_ERR567364" -eq "1" ]]; then
  (time ./FALCON -v -n 8 -t 200 -F -Z -m 13:10:0:0/0 -m 14:50:0:3/1 -m 20:100:1:5/10 -c 200 -y complexity-ERR567364.txt reads_ERR567364.fq DB.fa ) &> REPORT-FALCON-ERR567364 ;
  (time ./FALCON-FILTER -v -F -sl 0.001 -du 20000000 -t 0.5 -o positions-ERR567364.txt complexity-ERR567364.txt ) &> REPORT-FALCON-FILTER ;
  (time ./FALCON-EYE -v -F  -e 500 -s 4 -sl 4.15 -o FALCON-ERR567364.svg positions-ERR567364.txt ) &> REPORT-FALCON-EYE ;
  mv top.csv top_ERR567364.csv
fi
#==============================================================================
# COMPRESS
if [[ "$COMPRESS_ERR567365" -eq "1" ]]; then
  (time ./FALCON -v -n 8 -t 200 -F -Z -m 13:10:0:0/0 -m 14:50:0:3/1 -m 20:100:1:5/10 -c 200 -y complexity-ERR567365.txt reads_ERR567365.fq DB.fa ) &> REPORT-FALCON-ERR567365 ;
  (time ./FALCON-FILTER -v -F -sl 0.001 -du 20000000 -t 0.5 -o positions-ERR567365.txt complexity-ERR567365.txt ) &> REPORT-FALCON-FILTER ;
  (time ./FALCON-EYE -v -F  -e 500 -s 4 -sl 4.15 -o FALCON-ERR567365.svg positions-ERR567365.txt ) &> REPORT-FALCON-EYE ;
  mv top.csv top_ERR567365.csv
fi
#==============================================================================
# COMPRESS
if [[ "$COMPRESS_ERR732642" -eq "1" ]]; then
  (time ./FALCON -v -n 8 -t 200 -F -Z -m 13:10:0:0/0 -m 14:50:0:3/1 -m 20:100:1:5/10 -c 200 -y complexity-ERR732642.txt reads_ERR732642.fq DB.fa ) &> REPORT-FALCON-ERR732642 ;
  (time ./FALCON-FILTER -v -F -sl 0.001 -du 20000000 -t 0.5 -o positions-ERR732642.txt complexity-ERR732642.txt ) &> REPORT-FALCON-FILTER ;
  (time ./FALCON-EYE -v -F  -e 500 -s 4 -sl 2 -o FALCON-ERR732642.svg positions-ERR732642.txt ) &> REPORT-FALCON-EYE ;
  mv top.csv top_ERR732642.csv
fi
#==============================================================================
if [[ "$INTRASIM_ERR567364" -eq "1" ]]; then
  cat top_ERR567364.csv | awk '{ if($3 > 5.45) print $1"\t"$2"\t"$3"\t"$4; }' \
  | awk '{ print $4;}' | tr '|' '\t' | awk '{ print $2;}' > GIS;
  idx=0;
  cat GIS | while read line
    do
    namex=`echo $line | tr ' ' '_'`;
    if [[ "$idx" -eq "0" ]]; then
      printf "%s" "$namex" > FNAMES.fil;
      else
      printf ":%s" "$namex" >> FNAMES.fil;
    fi
    ./goose-extractreadbypattern $line < DB.fa > $namex;
    ((idx++));
    done
  ./GULL-map -v -m 4:1:0:0/0 -m 11:10:1:0/0 -m 14:50:0:3/1 -m 20:500:1:5/10 -c 30 -n 8 -x MATRIX-ERR567364.csv `cat FNAMES.fil`
  ./GULL-visual -v -w 32 -a 4 -x HEATMAP-ERR567364.svg MATRIX-ERR567364.csv
fi
#==============================================================================
if [[ "$INTRASIM_ERR567365" -eq "1" ]]; then
  cat top_ERR567365.csv | awk '{ if($3 > 6.2) print $1"\t"$2"\t"$3"\t"$4; }' \
  | awk '{ print $4;}' | tr '|' '\t' | awk '{ print $2;}' > GIS;
  idx=0;
  cat GIS | while read line
    do
    namex=`echo $line | tr ' ' '_'`;
    if [[ "$idx" -eq "0" ]]; then
      printf "%s" "$namex" > FNAMES.fil;
      else
      printf ":%s" "$namex" >> FNAMES.fil;
    fi
    ./goose-extractreadbypattern $line < DB.fa > $namex;
    ((idx++));
    done
  ./GULL-map -v -m 4:1:0:0/0 -m 11:10:1:0/0 -m 14:50:0:3/1 -m 20:500:1:5/10 -c 30 -n 8 -x MATRIX-ERR567365.csv `cat FNAMES.fil`
  ./GULL-visual -v -w 32 -a 4 -x HEATMAP-ERR567365.svg MATRIX-ERR567365.csv
fi
#==============================================================================
if [[ "$INTRASIM_ERR732642" -eq "1" ]]; then
  cat top_ERR732642.csv | awk '{ if($3 > 6.2) print $1"\t"$2"\t"$3"\t"$4; }' \
  | awk '{ print $4;}' | tr '|' '\t' | awk '{ print $2;}' > GIS;
  idx=0;
  cat GIS | while read line
    do
    namex=`echo $line | tr ' ' '_'`;
    if [[ "$idx" -eq "0" ]]; then
      printf "%s" "$namex" > FNAMES.fil;
      else
      printf ":%s" "$namex" >> FNAMES.fil;
    fi
    ./goose-extractreadbypattern $line < DB.fa > $namex;
    ((idx++));
    done
  ./GULL-map -v -m 4:1:0:0/0 -m 11:10:1:0/0 -m 14:50:0:3/1 -m 20:500:1:5/10 -c 30 -n 8 -x MATRIX-ERR732642.csv `cat FNAMES.fil`
  ./GULL-visual -v -w 32 -a 4 -x HEATMAP-ERR732642.svg MATRIX-ERR732642.csv
fi
#==============================================================================
