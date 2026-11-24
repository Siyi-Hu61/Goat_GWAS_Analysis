# 设置工作目录
setwd("file_path")

## 选择信号组合图
library(ggplot2)
library(ggthemes)
library(RColorBrewer)
library(showtext)

# 启用showtext
showtext_auto()

# 读取选择信号结果文件
data1 <- read.table("yes_no_rresorted.fst", sep='\t', header = TRUE)
data3 <- read.table("no_yes_pic_ratio_log2.txt", sep='\t', header = TRUE)

# 添加SNP列，格式为CHROM_BIN_START
data3$SNP <- paste0(data3$CHROM, "_", data3$BIN_START)

# 修改列名
colnames(data1)[colnames(data1) == "CHROM"] <- "CHR"
colnames(data1)[colnames(data1) == "BIN_START"] <- "BP"
colnames(data1)[colnames(data1) == "BIN_END"] <- "value"

colnames(data3)[colnames(data3) == "CHROM"] <- "CHR"
colnames(data3)[colnames(data3) == "BIN_START"] <- "BP"
colnames(data3)[colnames(data3) == "BIN_END"] <- "value"

# 合并数据
merged_data <- merge(data1, data3, by = c("CHR", "BP"))
input_data <- merged_data[, c(9, 1, 2, 5, 8)]
names(input_data) <- c("SNP", "CHR", "BP", "fst", "pi")

# 设置阈值
fst_threshold <- 0.0754412
pi_threshold <- 0.824148322500475

# 根据阈值创建颜色分组
# 同时超过两个阈值的点为红色，其他为蓝色
input_data$color_group <- ifelse(input_data$fst >= fst_threshold & input_data$pi >= pi_threshold, 
                                 "阈值内(红色)", "阈值外(蓝色)")

# 查看数据统计
cat("总点数:", nrow(input_data), "\n")
cat("阈值内的点数量:", sum(input_data$color_group == "阈值内(红色)"), "\n")
cat("阈值外的点数量:", sum(input_data$color_group == "阈值外(蓝色)"), "\n")

# 绘制组合图 - 展示所有点
p <- ggplot(data = input_data, aes(x = fst, y = pi)) + 
  # 先画蓝色点（阈值外）
  geom_point(data = subset(input_data, color_group == "阈值外(蓝色)"), 
             color = "#5199D3", alpha = 0.6, size = 3) +
  # 再画红色点（阈值内）
  geom_point(data = subset(input_data, color_group == "阈值内(红色)"), 
             color = "#E74B83", alpha = 0.8, size = 3) +
  labs(x = expression(paste(italic('F'), st)), 
       y = "log2(θπ_no / θπ_yes)") +
  geom_hline(yintercept = pi_threshold, linetype = "dashed", color = "black", linewidth = 0.8) +
  geom_vline(xintercept = fst_threshold, linetype = "dashed", color = "black", linewidth = 0.8) +
  theme(axis.text = element_text(face = "bold", size = 12),
        axis.title = element_text(face = "bold", size = 14),
        legend.position = "none") +  # 隐藏图例
  theme_few()

# 显示图形
print(p)

# 保存图形
ggsave("no_yes_plot.pdf", plot = p, width = 6, height = 6, dpi = 300)

# 输出阈值内点的详细信息
threshold_points <- input_data[input_data$color_group == "阈值内(红色)", ]
if(nrow(threshold_points) > 0) {
  cat("\n阈值内点的详细信息:\n")
  print(threshold_points)
  write.csv(threshold_points, "阈值内点详细信息.csv", row.names = FALSE)
}
