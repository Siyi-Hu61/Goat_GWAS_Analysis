setwd("file_path")
library(qvalue)
library(tidyverse)
#library(ggplot2)
library(CMplot)
library(conflicted)
conflict_prefer("filter", "dplyr")
gemmaphe <- read.table("phe.assoc.txt", header = TRUE, sep = "\t", quote = "", stringsAsFactors = FALSE)
pvalue<-cbind(gemmaphe[,c("rs", "chr", "ps", "p_wald")])
#计算膨胀系数
dp<- as.matrix(pvalue[,4])
dp2<-as.matrix(dp[which(!is.na(dp)),])
dp_value=dp2
dz = qnorm(1-dp_value / 2,mean = 0,sd = 1)
dz2 <- dz^2
domlambda = median(dz2)/qchisq(0.5, df = 1)
domlambda=signif(domlambda, digits = 3)
print(domlambda)
#FDR
fdr<-qvalue(p=pvalue$'p_wald')
fdr1<-data.frame(gemmaphe,fdr$qvalues)
fdr2 <- fdr1%>%select(chr,rs,ps,n_miss,allele1,allele0,af,beta,se,p_wald,fdr.qvalues)%>% filter(fdr.qvalues<0.05)
fdrvalue <- max(fdr2$'p_wald', na.rm = TRUE)
print(fdrvalue)
hint <- fdr1%>%select(chr,rs,ps,n_miss,allele1,allele0,af,beta,se,p_wald,fdr.qvalues)%>% filter(p_wald < 1e-05)
write.table(hint,'gemmaphe_5e5.csv',row.names = F,col.names = T,sep = ",")
#QQ图
sorted_p <- sort(pvalue$'p_wald', decreasing = FALSE)
qq_data <- data.frame(observed = -log10(sort(pvalue$'p_wald', decreasing = FALSE)),expected = -log10((1:length(sorted_p)) / (length(sorted_p) + 1)))
n <- nrow(qq_data)
qq_data$index <- 1:n
qq_data$lower_bound <- -log10(qbeta(0.025, qq_data$index, n - qq_data$index + 1))
qq_data$upper_bound <- -log10(qbeta(0.975, qq_data$index, n - qq_data$index + 1))

# 绘图代码
q <- ggplot(qq_data, aes(expected, observed)) +
  geom_ribbon(aes(ymin = lower_bound, ymax = upper_bound),  # 添加置信带
              fill = "grey", alpha = 0.4) +                 # 灰色半透明区域
  geom_point(color = "blue", size = 0.6, alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1,
              color = "black", linetype = "dashed") +
  labs(x = expression(Expected~~-log[10](p)),
       y = expression(Observed~~-log[10](p))) +
  theme_bw(base_size = 14) +
  theme(panel.grid = element_blank(),
        plot.title = element_text(hjust = 0.5))
# 保存图像
ggsave("gemmaphe.png", dpi = 600, width = 6, height = 6)
#曼哈顿图
chrom_colors <- rep(c("#4292c6", "#08306b"), length.out = length(unique(pvalue$chr)))
chrom_order <- unique(pvalue$chr)
chrom_order <- chrom_order[order(chrom_order)]
threshold_vals <- c(5e-8, 1e-5)
threshold_cols <- c("#CA2026", "#38459B")

# 绘制曼哈顿图
CMplot(pvalue, plot.type = "m", col = chrom_colors, chr.labels = chrom_order, 
       threshold = threshold_vals, threshold.lty = 2, threshold.lwd = 1.5, 
       threshold.col = threshold_cols, 
       amplify = TRUE, signal.cex = 0.8, signal.pch = 19, cex = 0.6, 
       chr.den.col = NULL, file = "png", width = 8, height = 3,
       file.output = TRUE, verbose = TRUE, file.name = "gemmaphe_m")