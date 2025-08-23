# SteamGuard_installer

## 食用步骤

1. 安装并登录 Steam 3.x ，不要通过 Steam 内的方式迁移令牌
2. 结束运行 Steam
3. 编辑模块中的 `action.sh` 文件. 将 [SteamGuardDump][] 导出的内容使用 base64 编码为单行字符串, 填入 `DumpDATA=''` 的单引号中.
4. 把编辑好的模块保存在安全的地方, **注意任何得到这个模块的人都能获取你的 SteamGuard**.
5. 使用 Magisk / KernelSU / APatch 安装模块.
6. 重启设备并在 Root 管理器的模块页面的 **SteamGuard_installer** 上点击 `执行` 按钮.
7. 打开 Steam 3.x，你将会看到从 2.x 版本升级到 3.x 版本会出现的“新功能介绍”，这一般就说明你成功了，可以验证一下动态密码等功能是否正常了。
8. 现在可以安全地卸载模块了.

## 注意事项

- 如果检测到更新, 请在下载到的新模块中重新执行前面的步骤3. 而不是直接安装白板模块.

## 参考来源

[在Steam3.x上还原令牌](https://github.com/YifePlayte/SteamGuardDump/issues/2)

[SteamGuardDump]: https://github.com/YifePlayte/SteamGuardDump
