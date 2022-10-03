import os, subprocess

analysis_path = ''
raw_seq_path = ''
hisat2_index_path = '/home/ubuntu/download/human_genome/hg38/grch38/genome'
ref_anno_path = '/home/ubuntu/download/human_genome/hg38/Homo_sapiens.GRCh38.104.gtf'

os.chdir(analysis_path)
for x in os.listdir(raw_seq_path):
	if os.path.isdir(os.path.join(raw_seq_path,x)):
		print(os.path.join(raw_seq_path,x,x+'_1.fq.gz'))

		result = subprocess.run(["hisat2", '-p 20','-x',hisat2_index_path,
											'-1',os.path.join(raw_seq_path,x,x+'_1.fq.gz'),
											'-2',os.path.join(raw_seq_path,x,x+'_2.fq.gz'),
											'-S',os.path.join(analysis_path,x+'.sam')],
								 stdout=subprocess.PIPE,
								  stderr=subprocess.PIPE, text=True)
		with open(os.path.join(analysis_path,x+'_hisat_stdout.txt'), 'w') as f:
			f.write(result.stdout)
		with open(os.path.join(analysis_path,x+'_hisat_stderr.txt'), 'w') as f:
			f.write(result.stderr)


		result = subprocess.run(["samtools", 'view','-bS',
								os.path.join(analysis_path,x+'.sam'),
								'-o',os.path.join(analysis_path,x+'.bam')],
								stdout=subprocess.PIPE,
								stderr=subprocess.PIPE, text=True)
		with open(os.path.join(analysis_path,x+'_samview_stdout.txt'), 'w') as f:
			f.write(result.stdout)
		with open(os.path.join(analysis_path,x+'_samview_stderr.txt'), 'w') as f:
			f.write(result.stderr)

		result = subprocess.run(["samtools", 'sort','-@ 20',
								os.path.join(analysis_path,x+'.bam'),
								'-o',os.path.join(analysis_path,x+'_sort.bam')],
								stdout=subprocess.PIPE,
								stderr=subprocess.PIPE, text=True)
		with open(os.path.join(analysis_path,x+'_samsort_stdout.txt'), 'w') as f:
			f.write(result.stdout)
		with open(os.path.join(analysis_path,x+'_samsort_stderr.txt'), 'w') as f:
			f.write(result.stderr)


		result = subprocess.run(["samtools", 'index',
								os.path.join(analysis_path,x+'_sort.bam')],
								stdout=subprocess.PIPE,
								stderr=subprocess.PIPE, text=True)
		with open(os.path.join(analysis_path,x+'_samindex_stdout.txt'), 'w') as f:
			f.write(result.stdout)
		with open(os.path.join(analysis_path,x+'_samindex_stderr.txt'), 'w') as f:
			f.write(result.stderr)

		result = subprocess.run(["stringtie", '-p 20','-G',ref_anno_path,
								'-A',os.path.join(analysis_path,'stringtie',x,x+'.tab.txt'),
								'-e', '-b',os.path.join(analysis_path,'stringtie',x),
								'-o',os.path.join(analysis_path,'stringtie',x,x+'.gtf'),
								os.path.join(analysis_path,x+'_sort.bam')],
								stdout=subprocess.PIPE,
								stderr=subprocess.PIPE, text=True)
		with open(os.path.join(analysis_path,x+'_stringtie_stdout.txt'), 'w') as f:
			f.write(result.stdout)
		with open(os.path.join(analysis_path,x+'_stringtie_stderr.txt'), 'w') as f:
			f.write(result.stderr)