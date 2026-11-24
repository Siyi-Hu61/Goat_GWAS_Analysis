# 设置工作目录
setwd("file_path")

# 加载必要的包
library(ggplot2)
library(dplyr)
library(gridExtra)  # 用于图形排列

# 读取FST计算结果文件
filename_FST <- "file_path/yes_no.snp_Fst.windowed.weir.fst"
FST <- read.table(filename_FST, header = TRUE)

# 提取第22条染色体的51560001-51880000片段的信息
FST_filtered <- FST %>%
  filter(CHROM == 17 & BIN_START >= 14020001 & BIN_START <= 14460000)

# 读取Pi计算结果文件
filename_Pi_yes <- "file_path/yes_maf0.5_geno0.1.pi.windowed.pi"
filename_Pi_no <- "file_path/no_maf0.5_geno0.1.pi.windowed.pi"
Pi_yes <- read.table(filename_Pi_yes, header = TRUE)
Pi_no <- read.table(filename_Pi_no, header = TRUE)

# 提取第22条染色体的51560001-51880000片段的信息
Pi_yes_filtered <- Pi_yes %>%
  filter(CHROM == 17 & BIN_START >= 14020001 & BIN_START <= 14460000)
Pi_no_filtered <- Pi_no %>%
  filter(CHROM == 17 & BIN_START >= 14020001 & BIN_START <= 14460000)

# 读取Tajima's D计算结果文件
filename_yes <- "file_path/yes.2K.TAOK3-14020001-14460000.TajimaD.Tajima.D"
filename_no <- "file_path/no.2K.TAOK3-14020001-14460000.TajimaD.Tajima.D"
TD_yes <- read.table(filename_yes, header = TRUE)
TD_no <- read.table(filename_no, header = TRUE)
# 将 TD_NF 中的 BIN_START 从 178000 改为 178001
TD_yes$BIN_START <- TD_yes$BIN_START + 1
TD_no$BIN_START <- TD_no$BIN_START + 1

# 初始化合并后的数据框
TAOK3_fst_pi_td <- FST_filtered

# 使用 left_join 进行合并
TAOK3_fst_pi_td <- TAOK3_fst_pi_td %>%
  left_join(Pi_yes_filtered, by = c("CHROM", "BIN_START")) %>%
  left_join(Pi_no_filtered, by = c("CHROM", "BIN_START")) %>%
  left_join(TD_yes, by = c("CHROM", "BIN_START")) %>%
  left_join(TD_no, by = c("CHROM", "BIN_START"))

# 提取特定列并重命名
TAOK3_fst_pi_td_new <- TAOK3_fst_pi_td %>%
  select(CHROM, BIN_START, BIN_END.x, WEIGHTED_FST, PI.x, PI.y, TajimaD.x, TajimaD.y) %>%
  rename(
    BIN_END = BIN_END.x,
    PI_yes = PI.x,
    PI_no = PI.y,
    TajimaD_yes = TajimaD.x,
    TajimaD_no = TajimaD.y
  )

# 将结果保存到新文件
write.table(TAOK3_fst_pi_td_new, "TAOK3_fst_pi_td_new", sep = "\t", row.names = FALSE, quote = FALSE)

# 转换BIN_START为Kb单位
TAOK3_fst_pi_td_new$BIN_START <- TAOK3_fst_pi_td_new$BIN_START/1000000

# Define the region for the shaded area
shade_start <- 14.14
shade_end <- 14.31

# fst threshold 
threshold_3_percent_fst <- quantile(FST$WEIGHTED_FST, probs = 0.99, na.rm = TRUE)

# 确保 x_min 和 x_max 是已知的 x 轴范围
x_min <- min(c(
  min(TAOK3_fst_pi_td_new$BIN_START, na.rm = TRUE)
  ))

x_max <- max(c(
  max(TAOK3_fst_pi_td_new$BIN_START, na.rm = TRUE)
))

# fst plot (p2)
p2 <- ggplot(TAOK3_fst_pi_td_new, aes(x = BIN_START)) +
  annotate("rect", xmin = shade_start, xmax = shade_end, ymin = -Inf, ymax = Inf,
           fill = "#FAE6BE", alpha = 0.5) +
  geom_line(aes(y = WEIGHTED_FST, color = "yes_no_Fst")) +
  geom_hline(yintercept = threshold_3_percent_fst, linetype = "dotted", color = "black") +
  scale_color_manual(values = c("#005AC8")) +
  theme_bw() +
  xlab("") + ylab(expression(paste(bold(F[st])))) +
  theme(
    legend.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 9, face = "bold", color = "black")
  ) +
  theme(
    plot.title = element_text(size = 9, face = "bold", color = "black", hjust = 1),
    axis.title.y = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
    axis.title.x = element_text(size = 12, color = "black", face = "bold"),
    axis.text.y = element_text(size = 9, face = "bold", color = "black", hjust = 0.5, vjust = 0.5),
    axis.text.x = element_blank()
  ) +
  coord_cartesian(xlim = c(x_min, x_max))

# Pi plot for NF and CA (p3)
p3 <- ggplot(TAOK3_fst_pi_td_new, aes(x = BIN_START)) +
  annotate("rect", xmin = shade_start, xmax = shade_end, ymin = -Inf, ymax = Inf,
           fill = "#FAE6BE", alpha = 0.5) +
  geom_line(aes(y = PI_yes, color = "yes_Pi")) +
  geom_line(aes(y = PI_no, color = "no_Pi")) +
  theme_bw() +
  xlab("") +
  ylab(expression(theta * pi)) +
  scale_color_manual(values = c("#FA7850", "#005AC8")) +
  theme(
    legend.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 9, face = "bold", color = "black"),
    plot.title = element_text(size = 9, face = "bold", color = "black", hjust = 0.5),
    axis.title.y = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
    axis.title.x = element_text(size = 12, color = "black", face = "bold"),
    axis.text.y = element_text(size = 9, face = "bold", color = "black", hjust = 0.5, vjust = 0.5),
    axis.text.x = element_blank()
  ) +
  coord_cartesian(xlim = c(x_min, x_max))

# Tajima's D plot for NF and CA (p6)
p4 <- ggplot(TAOK3_fst_pi_td_new, aes(x = BIN_START)) +
  annotate("rect", xmin = shade_start, xmax = shade_end, ymin = -Inf, ymax = Inf,
           fill = "#FAE6BE", alpha = 0.5) +
  geom_line(aes(y = TajimaD_yes, color = "yes_Tajima's D")) +
  geom_line(aes(y = TajimaD_no, color = "no_Tajima's D")) +
  theme_bw() +
  xlab("Chromosome 17 (Mb)") + ylab(expression(paste(bold("Tajima's D")))) +
  scale_color_manual(values = c("#FA7850", "#005AC8")) +
  theme(
    legend.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 9, face = "bold", color = "black"),
    plot.title = element_text(size = 9, face = "bold", color = "black", hjust = 1),
    axis.title.y = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
    axis.title.x = element_text(size = 12, color = "black", face = "bold"),
    axis.text.y = element_text(size = 9, face = "bold", color = "black", hjust = 0.5, vjust = 0.5),
    axis.text.x = element_text(size = 9, face = "bold", color = "black", hjust = 0.5, vjust = 0.1)
  ) +
  coord_cartesian(xlim = c(x_min, x_max))

# 保存为 PDF
pdf("TAOK3_combined_plots.pdf", width = 8, height = 14)

# 使用 grid.arrange 将图形上下排列，设置统一的高度比例
grid.arrange(
  p2, p3, p4,
  ncol = 1,  # 单列排列
  heights = c(1.5, 1.5, 1.5, 1.5, 2)  # 调整高度比例，确保 x 轴对齐
)

# 关闭 PDF 设备
dev.off()