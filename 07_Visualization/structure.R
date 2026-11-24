# 设置工作目录
setwd("file_path")
library(ggplot2)
library(gggenes)

#######单个基因例子###############
data <- read.table("BNC2.txt",header=T)
colnames(data)[1] <- "Gene"

ggplot(data, aes(xmin = Start/1e6, xmax = End/1e6, y = Gene,label = Gene)) +
  # 1. 基因主体（箭头表示方向）
  geom_gene_arrow(aes(forward = (Strand == "+")),
                  fill = "white",      # 基因主体填充为白色
                  color = "black",     # 边框颜色
                  alpha = 1 ,#不透明度设为1（完全显示）
  ) +
  # 2. 外显子（浅灰色)和CDS区域（玫红色）二选一
  #geom_subgene_arrow(
    #aes(xsubmin = Exon_Starts/1e6, xsubmax = Exon_Ends/1e6,fill = "Exon"),
    #alpha = 0.7,
    #color="gray70",
    #show.legend = TRUE  # 确保图例显示
  #) +
  
  # 3. CDS区域（玫红色）
  geom_subgene_arrow(
    aes(xsubmin = CDS_Start/1e6, xsubmax = CDS_End/1e6,fill = "CDS"),
    alpha = 0.7,
    color = "#AA3377",
    show.legend = TRUE  # 确保图例显示
  ) +
  
  # 4. 3' UTR（绿色）
  #geom_subgene_arrow(
    #aes(xsubmin = UTR3_Start/1e6, xsubmax = UTR3_End/1e6, fill = "3’UTR"),
    #color = "green4", alpha = 0.7,show.legend = TRUE  # 确保图例显示
  #) +
  # 4. 5' UTR（粉色）
  #geom_subgene_arrow(
    #aes(xsubmin = UTR5_Start/1e6, xsubmax = UTR5_End/1e6, fill = "5’UTR"),
    #color = "pink", alpha = 0.7,show.legend = TRUE  # 确保图例显示
  #) +
  
  # 5. 起始密码子（红色高亮）
  geom_subgene_arrow(
    aes(xsubmin = StartCodon_Start/1e6, xsubmax = StartCodon_End/1e6,fill = "Start Codon"),
    color = "red",  alpha = 0.7,show.legend = TRUE  # 确保图例显示
  ) +
  
  # 6. 终止密码子（蓝色高亮）
  geom_subgene_arrow(
    aes(xsubmin = StopCodon_Start/1e6, xsubmax = StopCodon_End/1e6,fill = "Stop Codon"),
    color = "blue", alpha = 0.7,show.legend = TRUE  # 确保图例显示
  ) +
  # 8. 分染色体展示
  facet_grid(Chromosome ~ ., scales = "free_y", space = "free_y") +
  # 9. 自定义图例（顶部水平排列）
  scale_fill_manual(
    name = "Gene Features",
    values = c("CDS" = "#AA3377",
               #"3’UTR" = "green4",
               #"5’UTR" = "pink",
               "Start Codon" = "red",
               "Stop Codon" = "blue"),
    guide = guide_legend(
      direction = "horizontal",  # 水平排列
      title.position = "top",    # 标题在上
      nrow = 1,                  # 单行显示
      override.aes = list(linewidth = 2, alpha = 1)
    )
  ) +
  # 10. 主题调整
  theme_genes() +
  labs(x = "Genomic Position (Mb)", y = "") +
  theme(
    legend.position = "top",  # 图例在顶部
    legend.box = "horizontal", # 水平排列
    legend.title = element_text(face = "bold", size = 10),
    legend.text = element_text(size = 8),
    legend.margin = margin(t = 0, r = 0, b = 5, l = 0),  # 调整边距
    legend.spacing.x = unit(0.2, "cm")  # 图例项间距
  )
#theme(legend.position = "none")  # 隐藏图例（按需调整）

