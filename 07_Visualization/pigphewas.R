# 加载必要的包
library(ggplot2)
library(readr)
setwd("file_path")

# 读取数据
data <- read.table("pigphewas.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
colnames(data) <- c("categoryMain", "pvalue")

# 确保pvalue是数值型
data$pvalue <- as.numeric(as.character(data$pvalue))

# 删除pvalue为NA的行（非数值行）
data <- data[!is.na(data$pvalue), ]

# 计算 -log10(P-value)
data$neg_log10_p <- -log10(data$pvalue)

# 获取所有唯一的Category
unique_categoryMain <- unique(data$categoryMain)
n_traits <- length(unique_categoryMain)

# 定义多巴胺配色方案
dopamine_colors <- c(
  "#E60707",  # 红色
  "#62A3FF",  # 天空蓝
  "#FFA300",  # 活力橙
  "#6BFF6B",  # 玫红
  "#FD8CD0",  # 樱花粉
  "#8E44AD"  # 紫色
)

# 确保颜色数量足够
if(length(unique_categoryMain) > length(dopamine_colors)) {
  colors_to_use <- rep(dopamine_colors, length.out = length(unique_categoryMain))
  names(colors_to_use) <- unique_categoryMain
} else {
  colors_to_use <- dopamine_colors[1:length(unique_categoryMain)]
  names(colors_to_use) <- unique_categoryMain
}

# 创建散点图（横坐标为-log10(pvalue)）
p <- ggplot(data, aes(x = neg_log10_p, y = categoryMain, color = categoryMain)) +
  geom_point(size = 3, alpha = 0.7) +  # 添加散点，设置大小和透明度
  geom_vline(xintercept = -log10(1e-5), color = "blue", size = 0.8, linetype = "dashed") +  # 添加蓝色阈值线（虚线）
  scale_color_manual(values = colors_to_use) +  # 应用多巴胺配色
  scale_x_continuous(  # 使用连续坐标轴
    breaks = c(0, 2, 4, 6, 8, 10),
    labels = c("0", "2", "4", "6", "8", "10")
  ) +
  labs(
    title = "Scatter Plot of -log10(P-values) by Category",
    x = expression(-log[10](P-value)),
    y = "Category",
    color = "Category"
  ) +
  theme_minimal() +  # 使用简洁主题作为基础
  theme(
    # 背景透明
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA),
    # 移除网格线
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # 坐标轴设置：黑色0.75粗实线
    axis.line = element_line(color = "black", size = 0.75),
    axis.ticks = element_line(color = "black", size = 0.75),
    axis.ticks.length = unit(0.2, "cm"),
    # 轴标签文字设置
    axis.text = element_text(color = "black", size = 10),
    axis.title = element_text(color = "black", size = 12, face = "bold"),
    # 图例设置
    legend.position = "right",
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9),
    # 标题设置
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)
  )

# 显示图形
print(p)

# 保存为PDF
ggsave("TAOK3-pigphewas.pdf", plot = p, width = 12, height = 8, bg = "transparent")
