#! usr/bin/perl
use strict;
my @dir=`ls /extraspace/zzhang9/YubinZhou/JianshengXie/TMEM/`;
my $index ="/extraspace/zzhang9/genome/human/ht2-hg38/hg38/genome";
chomp @dir;
open STRINGTIE,">STRINGTIE";
foreach my $dirs (@dir){
	chomp $dirs;
	#print ($dirs);
	my $label=$dirs;
	my $out= "$label.sam";
	my $out1= "$label.unsort_bam";
	my $fq1="/extraspace/zzhang9/YubinZhou/JianshengXie/TMEM/$dirs/$dirs\_1.fq.gz";
	my $fq2="/extraspace/zzhang9/YubinZhou/JianshengXie/TMEM/$dirs/$dirs\_2.fq.gz";
	print "hisat2 -p 20 -x $index -1 $fq1 -2 $fq2 -S $out\n";
	# die;
	my $bam=$label.".bam";
	print "samtools index $bam\n";
	#/extraspace/zzhang9/genome/human/hsat-hg38/
	my $in=$label.".bam";
	my $table=$label.".GTF";
	print STRINGTIE "$label /extraspace/zzhang9/YubinZhou/JianshengXie/Analysis-ZZ/$table\n";
	print "stringtie -G /extraspace/zzhang9/genome/human/hg38y_gtf $in -e -o $table -b ./$label/\n\n\n";
	`hisat2 -p 20 -x $index -1 $fq1 -2 $fq2 -S $out`;
	`samtools view -bS $out >$out1`;
	`samtools sort -@ 20 $out1 $label`;
	`samtools index $bam`;
	`stringtie -G "/extraspace/zzhang9/genome/human/hg38y_gtf" $in -e -o $table -b ./$table/`;
}

`python2 prepDE.py -i ./STRINGTIE`;

#stringtie -G "/extraspace/zzhang9/genome/human/hg38y_gtf" ../bam/L042617-NO-IL15_S18.bam -e -o L042617-NO-IL15_S18.out -b ./L042617-NO-IL15_S18/ &