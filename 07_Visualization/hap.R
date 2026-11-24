setwd("file_path")
library(pheatmap)
library(ggplot2)
a=read.table("TAOK3_17_14140001_14310000_HaplotypeMatrix.change", header=T,sep="\t")
data<-t(data.matrix(a[which(a$chr==17),][,3:122]))
annotation_row = data.frame(GroupClass=as.vector(unlist(a[1,][,3:122])))
rownames(annotation_row) = rownames(data)
ann_colors = list(GroupClass = c(HB="#00C558",DB="#FA7850"))
map <- pheatmap(data,annotation_row = annotation_row,annotation_colors = ann_colors,cluster_row = FALSE,cluster_col = FALSE,legend =FALSE,labels_col = rep("",ncol(data)),labels_row=rep("",nrow(data)),color=c("#F7F8D5","#BF3826"),cellwidth = 0.4,cellheight = 0.5,angle_col = "0")
print(map)
ggsave("file_path/TAOK3_Haplotype.heatmap.pdf", 
       plot = map,
       width = 12,
       height = 20,
       units = "in") 