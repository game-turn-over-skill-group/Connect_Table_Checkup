#!/bin/bash

# 检查参数
if [ $# -ne 1 ]; then
    echo "用法: $0 <日志文件路径>"
    exit 1
fi

log_file="$1"
threshold=90  # 相当于0.9（放大100倍）
declare -A flow_map

# 读取日志文件
while IFS= read -r line; do
    # 跳过不包含流量数据的行（避免处理非连接表行）
    if [[ ! "$line" =~ bytes= ]]; then
        continue
    fi
    
    # 使用Bash字符串操作提取每个字段的原始数据
    src_ip___="${line#*src=}"
    src_ip="${src_ip___%% *}"  # 提取源IP
    
    dst_ip___="${line#*dst=}"
    dst_ip="${dst_ip___%% *}"  # 提取目标IP
    
    src_port___="${line#*sport=}"
    src_port="${src_port___%% *}"  # 提取源端口
    
    dst_port___="${line#*dport=}"
    dst_port="${dst_port___%% *}"  # 提取目标端口
    
    # 提取第一个bytes=的值(源字节数)
    src_bytes___="${line#*bytes=}"
    src_bytes="${src_bytes___%% *}"
    
    # 提取第二个bytes=的值(目标字节数)
    dst_bytes___="${src_bytes___#*bytes=}"
    dst_bytes="${dst_bytes___%% *}"
    
    # 计算节流比：(目标字节/源字节) * 100
    if [[ -n "$src_bytes" && -n "$dst_bytes" && "$src_bytes" -gt 0 ]]; then
        # 整数运算：(dst_bytes * 100) / src_bytes
        ratio=$(( (dst_bytes * 100) / src_bytes ))
        
        # 如果比率大于等于阈值，记录源IP和源端口
        if [ "$ratio" -ge "$threshold" ]; then
            echo "${src_ip}:${src_port}"
        fi
    fi
done < "$log_file" | sort -u    
