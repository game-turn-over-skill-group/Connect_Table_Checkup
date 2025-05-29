




项目地址：https://github.com/game-turn-over-skill-group/Connect_Table_Checkup


快速审查 路由器连接表流量 找出接近等比流量 的刷流量IP


使用方法（注意先使用lc命令 或者 自行过滤一次 方便排查）：
把路由器的连接表nf_conntrack.log内容输入到router_log.txt


linux系统：
bash llsc.sh router_log.txt
或
llsc.sh /proc/net/nf_conntrack


win10系统
执行llsc.cmd
手动输入内容到router_log.txt并保存 之后会自动输出到控制台










