setwd("/extraspace/zzhang9/YubinZhou/JianshengXie/Analysis-ZZ")
library(DESeq2)
dat=read.csv("./gene_count_matrix.csv")

countData <- data.frame(dat[,2:7])
condition <- factor(c("ctr","ctr","ctr","si","si","si"))
colData <- data.frame(row.names=colnames(countData), condition) 
dds <- DESeq2::DESeqDataSetFromMatrix(countData, DataFrame(condition), design= ~ condition )
head(dds)
dds2 <- DESeq(dds)
resultsNames (dds2)
res <- results(dds2) 
head (res, n=5) 
res1=data.frame(dat,data.frame(res))

write.table(res1,"./DEseq2.out",row.names = T,sep = "\t",quote = F)

res1$padj=ifelse(res1$padj<1e-10,1e-10,res1$padj)
res1$gene_id=stringr::str_replace_all(res1$gene_id,".*\\|","")
res1$log2FoldChange=ifelse(res1$log2FoldChange<c(-5),-5,res1$log2FoldChange)
res1$log2FoldChange=ifelse(res1$log2FoldChange>5,5,res1$log2FoldChange)
res1.sig=res1[which(res1$padj<0.05 & abs(res1$log2FoldChange)>1),]
res1.sig1=res1.sig[order(res1.sig$log2FoldChange),]
res1.sig1=rbind(res1.sig1[1:10,],tail(res1.sig1,n=10))
dim(res1.sig)
ggplot(res1,aes(log2FoldChange,-log10(padj)))+geom_point(col="grey")+
  geom_point(dat=res1.sig,aes(log2FoldChange,-log10(padj),col=sign(log2FoldChange)))+
  scale_color_gradient(high = 2,low = 4)+
  ggrepel::geom_text_repel(data=res1.sig1,aes(log2FoldChange,-log10(padj),label=gene_id))+
  xlim(-5,5)+
  theme(axis.text = element_text(color = "black",size=10),
        plot.title = element_text(size=14),
        plot.subtitle = element_text(size = 12),
        axis.title = element_text(size = 12),
        panel.background = element_blank(),
        panel.border = element_rect(fill = NA,colour = 1),
        legend.position = "NULL"
  )

gl=read.delim("/extraspace/zzhang9/eRNAhg38/a-new-version-rpm-cutoff/actionable/actionable.genes.txt",stringsAsFactors = F)[,1]
gl1=read.csv("/extraspace/zzhang9/eRNAhg38/a-new-version-rpm-cutoff/immu/immu-check.csv",stringsAsFactors = F)[,1]
share=intersect(gl,res1.sig$gene_id)
share1=intersect(gl1,res1.sig$gene_id)
res1.sig[match(share,res1.sig$gene_id),]
