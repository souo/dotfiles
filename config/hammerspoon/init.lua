-- Hammerspoon 配置入口
-- 所有功能通过 Spoons 加载，便于管理和扩展

-- 加载 SSDBackup Spoon
hs.loadSpoon("SSDBackup")

-- 配置 SSDBackup
local ssdBackup = spoon.SSDBackup
ssdBackup.ssName = "Assets"           -- SSD 卷标名
ssdBackup.projectSrc = "~/code/"      -- 源码目录
ssdBackup.notifyLevel = 2             -- 通知级别：0=无，1=仅错误，2=全部
ssdBackup.useChecksum = false         -- 使用 checksum 校验（更准确但更慢）
ssdBackup.logMaxAge = 30              -- 日志保留天数（默认 30 天）

-- 自定义热键（可选）
ssdBackup:bindHotkeys({
    backup = {{"ctrl", "alt", "cmd"}, "B"}
})

-- 启动 Spoon
ssdBackup:start()

-- 日志：配置已加载
print("[Init] Hammerspoon 配置已加载")
