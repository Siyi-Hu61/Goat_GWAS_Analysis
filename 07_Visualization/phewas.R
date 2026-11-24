library(ggplot2)
setwd("file_path")

# 读取数据
data <- read.table("phewas.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
colnames(data) <- c("Trait", "P_value")

# 计算 -log10(P-value)
data$neg_log10_p <- -log10(data$P_value)

# 获取所有唯一的Trait
unique_traits <- unique(data$Trait)
n_traits <- length(unique_traits)

# 夏日多巴胺配色（高饱和度、明亮欢快的颜色）
dopamine_colors <- c(
  "#E60707",  # 红色
  "#62A3FF",  # 天空蓝
  "#FFA300",  # 活力橙
  "#FF006E",  # 玫红
  "#FD8CD0",  # 樱花粉
  "#8E44AD",  # 紫色
  "#1e90ff",  # 海蓝色
  "#30325e",  # 深蓝
  "#6BFF6B",  # 荧光绿
  "#FF6B6B",  # 珊瑚橙
  "#4ECDC4",  # 薄荷绿
  "#FF9F4A",  # 杏色
  "#C77DFF",  # 淡紫色
  "#FFE162",  # 柠檬黄
  "#4CC9F0",  # 浅青
  "#663e35",  # 棕色
  "#EAF151",  # 黄绿
  "#074b04",  # 深绿
  "#E67E22",  # 胡萝卜橙
  "#E74C3C",  # 番茄红
  "#1ABC9C",  # 绿松石
  "#3498DB",  # 天蓝
  "#F1C40F",  # 橙黄
  "#debb9e",  # 米色
  "#2ECC71",   # 翡翠绿
  "#936c00"   # 翡翠绿
)

# 如果颜色不够，重复使用或插值
if(n_traits > length(dopamine_colors)) {
  colors <- colorRampPalette(dopamine_colors)(n_traits)
} else {
  colors <- dopamine_colors[1:n_traits]
}

# 绘制散点图
p <- ggplot(data, aes(x = Trait, y = neg_log10_p, color = Trait)) +
  geom_point(size = 2.5, alpha = 0.85, stroke = 0.2) +
  scale_color_manual(values = colors, name = "Trait") +
  labs(
    x = "Trait Category",
    y = expression(-log[10](P-value))
  ) +
  theme_minimal() +
  theme(
    # 背景透明
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA),
    # 移除所有网格线
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # 坐标轴：黑色0.75粗实线
    axis.line = element_line(color = "black", linewidth = 0.75),
    axis.ticks = element_line(color = "black", linewidth = 0.75),
    axis.ticks.length = unit(0.2, "cm"),
    # 字体设置
    axis.text = element_text(color = "black", size = 10),
    axis.title = element_text(color = "black", size = 12, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    # 图例设置
    legend.title = element_text(size = 10, face = "bold"),
    legend.text = element_text(size = 9),
    legend.position = "right",
    legend.key = element_blank()
  )

# 显示图形
print(p)

# 修改保存图形的宽度来缩小横坐标刻度之间的距离
# 减小宽度会让点之间的水平距离变小
ggsave("phewas_BNC2.pdf", p, width = 10, height = 5, bg = "transparent")  # 将宽度从14改为10
