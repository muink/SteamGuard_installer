# SteamGuard_installer

## 食用步骤

1. 安装并登录 [Steam 3.10.0][] ，不要通过 Steam 内的方式迁移令牌
2. 结束运行 Steam
3. 保留`所有者` `群组` `权限`备份 `/data_mirror/data_ce/null/0/com.valvesoftware.android.steam.community/shared_prefs/steam.uuid.xml` 和 `/data_mirror/data_ce/null/0/com.valvesoftware.android.steam.community/databases/RKStorage`
4. 编辑模块中的 `action.sh` 文件. 将 [SteamGuardDump][] 导出的内容使用 base64 编码为单行字符串, 填入 `DumpDATA=''` 的单引号中.
5. 把编辑好的模块保存在安全的地方, **注意任何得到这个模块的人都能获取你的 SteamGuard**.
6. 使用 Magisk / KernelSU / APatch 安装模块.
7. 重启设备并在 Root 管理器的模块页面的 **SteamGuard_installer** 上点击 `执行` 按钮.
8. 打开 Steam Steam 3.10.0，你将会看到从 2.x 版本升级到 3.x 版本会出现的“新功能介绍”，这一般就说明你成功了。
9. 结束运行 Steam
10. 把前面备份的两个文件按原始 `所有者` `群组` `权限` 放回原位, 重新打开 Steam
11. 现在可以安全地卸载模块或更新 Steam 了

## 奇怪问题

[Prompted for PIN to "exit Family View" on fresh install of Steam mobile app](https://steamcommunity.com/groups/steamfamilies/discussions/0/595148876446446418/)

## 参考来源

[在Steam3.x上还原令牌](https://github.com/YifePlayte/SteamGuardDump/issues/2)

[Steam 3.10.0]: https://github.com/muink/SteamGuard_installer/raw/refs/heads/releases/com.valvesoftware.android.steam.community_3.10.0-9653292_minAPI24(arm64-v8a,armeabi-v7a,x86,x86_64)(nodpi)_apkmirror.com.apk
[SteamGuardDump]: https://github.com/YifePlayte/SteamGuardDump
