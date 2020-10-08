# RNA-seq
Preparation
1)	Genome, xx.fa;
2)	Annotation, xx.gtf;
3)	Reads, xx.fastq.gz;
4)  Add the hisat2 and stringtie folders to your environmental PATH respectively.

Four steps
1)	Build index
  $ hisat2-build <ref.fa> [index]
2)	Alignment to genome
  $ hisat2 -x [index] -1 <read1.fq> -2 <read2.fa> -S |samtools view -bS > out.bam
  $ samtools sort -@ 8 out.bam sort
3)	Expression level
  $ stringtie -G <ref.gtf> sort.bam -o OUTFILE -e -B
  OR 
  $ stringtie -G <GTF> <$sort> -e -o <$table> -b <./$files/>
4)	get expression table
python2 prepDE.py -i ./STRINGTIE`
  5)  Using Rscript deseq.R to detect DE gene
  
