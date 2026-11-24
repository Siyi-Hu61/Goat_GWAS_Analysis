library(ggplot2)
library(tidyverse)
setwd("file_path")
blgwas <- read.table("file_path/phe.assoc.txt", header = TRUE, sep = "\t", quote = "", stringsAsFactors = FALSE)
ld <- read.table("snp_tmem100.ld",header = T)
blleadld<-ld%>%select(CHR_A,BP_A,SNP_A,CHR_B,BP_B,SNP_B,R2)%>%filter(BP_A=="80944153")
#读取gwas总文件时
A<-blleadld[1,5]
B<-blleadld[length(blleadld$CHR_A),5]
SNP_P<-blgwas %>%select(chr,rs,ps,allele1,allele0,af,beta,se,p_wald)%>% filter(chr==11&ps>A&ps<B)#筛选snp上下1MB（列名根据文件实际修改）
bllead <- merge(SNP_P,blleadld, by.x = 'ps', by.y = 'BP_B',all.x=TRUE)
pvalue = data.frame(cbind(bllead$chr,bllead$ps,bllead$p_wald,bllead$R2))
colnames(pvalue)<-c("chr","BP","logp","r2")
pvalue<-pvalue[complete.cases(pvalue),]
pvalue$logp<- -log10(pvalue$logp)
pvalue <- pvalue[!duplicated(pvalue$BP), ]
sig = pvalue[pvalue$BP == 80944153, ]
cols <- c("#14128A", "#28D7CA", "#075F1A", "#EB7806", "#FC1304")
pvalue$r2_group <- cut(pvalue$r2,
            breaks = seq(0, 1, by = 0.2),
            labels = c("0.0-0.2", "0.2-0.4", "0.4-0.6", "0.6-0.8", "0.8-1.0"),
            include.lowest = TRUE)
pdf(paste0("tmem100.pdf"),width=5,height=3)
ggplot(pvalue, aes(BP/1000000, logp, fill = r2_group)) +
     geom_point(shape = 21, size = 2, color = "black") +  # 使用fill映射r2分组
     geom_point(data = sig, aes(BP/1000000, logp), 
                shape = 23, size = 4, fill = "purple") +
     labs(
         fill = expression(R^2),  # 图例标题为R²
         x = "Genomic position of chr11 (Mb)",
         y = expression(GWAS - log(italic(P)))
     ) +
     scale_fill_manual(values = cols) +  # 应用自定义颜色
     theme_classic() +
     theme(
         axis.title.y = element_text(size = 12, color = "black", face = "bold"),
         axis.title.x = element_text(size = 12, color = "black", face = "bold"),
         axis.text.y = element_text(size = 12, face = "bold", color = "black", 
                                    hjust = 0.5, vjust = 0.5),
         axis.text.x = element_text(size = 12, face = "bold", color = "black", 
                                    hjust = 0.5, vjust = 0.1),
         legend.title = element_text(face = "bold", colour = "black", 
                                     size = 12, vjust = 0.5),
         legend.text = element_text(colour = "black", size = 8, 
                                    hjust = 0, vjust = 0.5, face = "bold"),
         legend.key.size = unit(0.4, "cm"),
         legend.background = element_rect(size = 0.5),
         plot.margin = unit(c(0.2, 1.4, 0.4, 0.4), "cm")  # top, right, bottom, left
     )
dev.off()