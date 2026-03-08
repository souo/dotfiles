# 编译器设置
CC = clang

# 编译选项：开启最高优化级别 (-O3)，显示所有警告 (-Wall)
CFLAGS = -O3 -Wall

# 链接框架：包含 CoreFoundation 和 私有框架 MediaRemote
LDFLAGS = -framework CoreFoundation -F /System/Library/PrivateFrameworks -framework MediaRemote

# 输出目录和目标文件
BIN_DIR = bin
TARGET = $(BIN_DIR)/media_helper

# 源文件列表
SRCS = media_helper.c 

# 默认目标
all: $(TARGET)

# 确保在编译前 bin 目录已存在
# 管道符 `|` 表示 order-only 依赖，即只有在目录不存在时才创建，目录时间戳更新不会导致重新编译
$(TARGET): $(SRCS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SRCS) $(LDFLAGS) -o $(TARGET)

# 创建 bin 目录的规则
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# 清理规则：直接删除整个 bin 目录
clean:
	rm -rf $(BIN_DIR)

# 伪目标声明
.PHONY: all clean