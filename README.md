# 一个mpv播放器的脚本
## 功能
长按键盘right键视频倍速  
点按快进视频

## 使用方法
将pressing_faster.lua存放在 mpv安装位置/portable_config/scripts 下

## 修改配置
#### 修改快进秒数
修改脚本或配置文件中seek_distance项
#### 修改加速过程
修改脚本或配置文件中speed_interval, speed_increase, speed_decrease项  
长按时每 speed_interval 秒速度 增加speed_increase 或减少 speed_decrease 直至最大或原速度
#### 修改最大倍速
修改脚本或配置文件中speed_max项