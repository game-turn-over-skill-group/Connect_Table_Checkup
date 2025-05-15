
@echo off

cd /d "E:\Github\Connect_Table_Checkup"

:: 设置UTF-8编码（静默执行）
chcp 65001 >nul 2>&1

:: 清空文件
type nul > "router_log.txt"

:: 打开文件供编辑
start "" "router_log.txt"

echo 请将日志内容输入到 router_log.txt 并保存。

:check_loop
rem 检查文件大小是否大于0字节（非空）
for %%a in ("router_log.txt") do (
    if %%~za gtr 0 (
        goto run_script
    )
)

rem 等待2秒（使用ping命令兼容所有Windows版本）
ping -n 2 127.0.0.1 >nul 2>&1
goto check_loop

:run_script

echo.
bash llsc.sh router_log.txt
echo.
