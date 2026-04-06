--- === SSDBackup
---
--- 自动备份源码到移动硬盘的 Spoon
---
--- 当检测到指定的 SSD 插入时，自动使用 rsync 增量同步源码目录到备份目标。
--- 支持防重复启动、前置条件检查、手动热键触发等功能。
---
--- Parameters:
---  * ssName - SSD 卷标名称（默认 "Assets"）
---  * projectSrc - 源码目录路径（默认 "~/code/"）
---  * notifyLevel - 通知级别：0=无，1=仅错误，2=全部（默认 2）
---
--- Returns:
---  * 一个 SSDBackup 对象
---
--- Notes:
---  * 加载后需调用 start() 方法启动监听
---  * 调用 stop() 方法停止监听
---
--- Usage:
---   hs.loadSpoon("SSDBackup")
---   spoon.SSDBackup.ssName = "MySSD"
---   spoon.SSDBackup:start()
---
--- License: MIT

local obj = {}
obj.__index = obj

-- 模块元数据
obj.name = "SSDBackup"
obj.version = "1.0.2"
obj.author = "2z"
obj.license = "MIT"
obj.homepage = "https://github.com/2z/dotfiles"

-- 默认配置
obj.ssName = "Assets"
obj.projectSrc = "~/code/"
obj.backupDest = nil
obj.rsyncPath = nil      -- rsync 路径（默认自动检测）
obj.notifyLevel = 2
obj.useChecksum = false  -- 使用 checksum 校验（更准确但更慢）
obj.logMaxAge = 30       -- 日志保留天数（默认 30 天）

-- 默认排除列表
obj.defaultExcludes = {
    "target/",
    ".godot/",
    ".DS_Store",
    "*.tmp",
    "node_modules/.cache/",
    ".git/",
    "*.pyc",
    "__pycache__/"
}

-- 日志目录
obj.logDir = nil
obj.logFile = nil

-- 内部状态
local isBackingUp = false
local volumeWatcher = nil
local hotkeyTrigger = nil
local currentBackupTask = nil

--- SSDBackup:init()
--- Method
--- 初始化 Spoon，解析路径，设置默认值
---
--- Parameters:
---  * None
---
--- Returns:
---  * obj
function obj:init()
    -- 确保路径末尾有斜杠，rsync 行为：src/ 表示同步目录下的内容
    if not self.projectSrc:match("/$") then
        self.projectSrc = self.projectSrc .. "/"
    end

    if not self.backupDest then
        self.backupDest = "/Volumes/" .. self.ssName .. "/Code_Backup/"
    end

    -- 确保 fs 模块已加载
    if not hs.fs then
        require("hs.fs")
    end

    -- 自动检测 rsync 路径（优先使用 Homebrew/MacPorts 的新版 rsync）
    if not self.rsyncPath then
        if hs.fs.attributes("/opt/homebrew/bin/rsync") then
            self.rsyncPath = "/opt/homebrew/bin/rsync"
        elseif hs.fs.attributes("/usr/local/bin/rsync") then
            self.rsyncPath = "/usr/local/bin/rsync"
        else
            self.rsyncPath = "rsync"
        end
    end

    -- 设置日志目录
    local homeDir = os.getenv("HOME")
    self.logDir = homeDir .. "/.hammerspoon/logs"

    -- 创建日志目录（如果不存在）
    local attr = hs.fs.attributes(self.logDir)
    if not attr then
        local ok, err = hs.fs.mkdir(self.logDir)
        if ok then
            print("[SSDBackup] 创建日志目录：" .. self.logDir)
        else
            print("[SSDBackup] 错误：无法创建日志目录：" .. tostring(err))
        end
    end

    print("[SSDBackup] 初始化完成，SSD: " .. self.ssName)
    return self
end

--- SSDBackup:expandPath(path)
--- Method
--- 展开路径中的 ~ 为完整 home 目录
---
--- Parameters:
---  * path - 路径字符串
---
--- Returns:
---  * string - 展开后的完整路径
function obj:expandPath(path)
    return path:gsub("^~", os.getenv("HOME"))
end

--- SSDBackup:isSSDMounted()
--- Method
--- 检查 SSD 是否已挂载
---
--- Parameters:
---  * None
---
--- Returns:
---  * boolean - 已挂载返回 true
function obj:isSSDMounted()
    local mountPoint = "/Volumes/" .. self.ssName
    local attr = hs.fs.attributes(mountPoint)
    return attr and attr.mode == "directory"
end

--- SSDBackup:isSourceDirValid()
--- Method
--- 检查源目录是否存在且有效
---
--- Parameters:
---  * None
---
--- Returns:
---  * boolean - 有效返回 true
function obj:isSourceDirValid()
    local expandedPath = self:expandPath(self.projectSrc)
    local attr = hs.fs.attributes(expandedPath)
    return attr and attr.mode == "directory"
end

--- SSDBackup:sendNotify(title, info)
--- Method
--- 发送系统通知（内部方法）
---
--- Parameters:
---  * title - 通知标题
---  * info - 通知内容
function obj:sendNotify(title, info)
    if self.notifyLevel == 0 then return end
    hs.notify.new({title = title, informativeText = info}):send()
end

--- SSDBackup:startBackup(manual)
--- Method
--- 启动 rsync 备份任务
---
--- Parameters:
---  * manual - boolean, 是否为手动触发（默认 false）
---
--- Returns:
---  * obj
function obj:startBackup(manual)
    if isBackingUp then
        self:sendNotify("SSDBackup", "备份正在进行中，跳过本次请求")
        return self
    end

    if not self:isSSDMounted() then
        self:sendNotify("SSDBackup", "SSD 未挂载，无法启动备份")
        print("[SSDBackup] 错误：SSD 未挂载: " .. self.ssName)
        return self
    end

    local srcPath = self:expandPath(self.projectSrc)
    if not self:isSourceDirValid() then
        self:sendNotify("SSDBackup", "源目录无效：" .. self.projectSrc)
        print("[SSDBackup] 错误：源目录无效：" .. srcPath)
        return self
    end

    isBackingUp = true

    local notifyTitle = manual and "手动备份" or "自动备份"
    self:sendNotify(notifyTitle, "开始同步：" .. srcPath)

    -- 清理旧日志
    self:cleanOldLogs()

    -- 生成日志文件名
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local logFileName = string.format("backup_%s_%s.log", manual and "manual" or "auto", timestamp)
    self.logFile = self.logDir .. "/" .. logFileName

    print("[SSDBackup] ========================================")
    print("[SSDBackup] 开始备份 @ " .. os.date("%Y-%m-%d %H:%M:%S"))
    print("[SSDBackup] 源目录：" .. srcPath)
    print("[SSDBackup] 目标目录：" .. self.backupDest)

    -- 构建 rsync 参数列表（直接传数组，完全避免 shell 转义问题）
    -- -a:               归档模式（递归 + 符号链接 + 时间戳）
    -- -z:               压缩传输
    -- --no-perms/owner/group: exFAT 不支持 Unix 权限，禁用可避免 rsync 每次都把所有
    --                   文件标记为 group 属性"不匹配"，从而消除 4 万行噪音日志
    -- --out-format:     只对真正有内容/元数据变化的文件输出 itemize 行
    -- --stats:          输出 sent/received/speedup 摘要
    -- --modify-window=1: 处理 exFAT 的 2 秒时间戳精度

    local args = {
        "--archive",
        "--compress",
        "--no-perms", "--no-owner", "--no-group",
        "--modify-window=1",
        "--delete",
        "--timeout=60",
        "--stats",
        "--out-format=%i %n%L",
    }

    if self.useChecksum then
        table.insert(args, "--checksum")
    end

    for _, v in ipairs(self.defaultExcludes) do
        table.insert(args, "--exclude=" .. v)
    end

    table.insert(args, srcPath)
    table.insert(args, self.backupDest)

    print("[SSDBackup] 执行命令: rsync " .. self.rsyncPath)

    local outputBuffer = ""
    local errorBuffer = ""

    -- 流式回调：持续接收 rsync 的实时输出
    local function streamCallback(task, stdOut, stdErr)
        if stdOut and #stdOut > 0 then
            outputBuffer = outputBuffer .. stdOut
        end
        if stdErr and #stdErr > 0 then
            errorBuffer = errorBuffer .. stdErr
        end
        return true  -- 返回 true 表示继续接收流
    end

    -- 完成回调：任务结束时处理汇总
    local function completionCallback(exitCode, stdOut, stdErr)
        -- 最后一批输出
        if stdOut and #stdOut > 0 then outputBuffer = outputBuffer .. stdOut end
        if stdErr and #stdErr > 0 then errorBuffer = errorBuffer .. stdErr end

        isBackingUp = false
        currentBackupTask = nil

        -- rsync 返回码含义：
        -- 0  = 全部成功
        -- 23 = 部分传输（无权限文件）
        -- 24 = 部分传输（源文件在传输中消失）
        local isSuccess = (exitCode == 0 or exitCode == 23 or exitCode == 24)

        print("[SSDBackup] 任务结束，退出码：" .. exitCode)
        print("[SSDBackup] 任务完成，输出：" .. #outputBuffer .. " 字节")

        -- 分析变更数量
        -- rsync --out-format='%i %n%L' 对真正有变化的文件输出结构化 itemize 前缀：
        --   [1] 操作类型：> 上传、< 下载、c 本地变更、* 消息、h 硬链接
        --   [2] 文件类型：f 普通文件、d 目录、L 软链接 等
        --   [3-11] 各属性变更位（+ 新建 / . 未变 / 字母 表该属性有变化）
        --   例：>f+++++++++ 新文件，>f.st...... 时间戳变更
        local changeCount = 0
        if #outputBuffer > 0 then
            for line in outputBuffer:gmatch("[^\n]+") do
                -- 精确匹配 itemize 格式：11 位前缀 + 空格 + 路径
                if line:match("^[><ch%*][bcdlpDS][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.][+cstTUpog%.] ") then
                    changeCount = changeCount + 1
                    if changeCount < 20 then
                        print("[SSDBackup]   " .. line)
                    elseif changeCount == 20 then
                        print("[SSDBackup]   ... (更多变更见日志)")
                    end
                end
                -- 打印摘要行（不计入变更数）
                if line:match("^sent ") or line:match("^received ") or line:match("^total size")
                    or line:match("^Number of") or line:match("^Total") then
                    print("[SSDBackup]   " .. line)
                end
            end
        end

        -- 写入日志文件
        local logFileHandle = io.open(self.logFile, "w")
        if logFileHandle then
            logFileHandle:write("备份报告\n" .. string.rep("=", 20) .. "\n")
            logFileHandle:write("时间: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
            logFileHandle:write("退出码: " .. exitCode .. "\n")
            logFileHandle:write("变更项: " .. changeCount .. "\n")
            logFileHandle:write("\n--- 输出明细 ---\n")
            logFileHandle:write(outputBuffer)
            if #errorBuffer > 0 then
                logFileHandle:write("\n--- 错误明细 ---\n")
                logFileHandle:write(errorBuffer)
            end
            logFileHandle:close()
            print("[SSDBackup] 日志已保存：" .. self.logFile)
        else
            print("[SSDBackup] 错误：无法保存日志文件 " .. self.logFile)
        end

        -- 通知用户
        if isSuccess then
            local msg = (changeCount > 0) and ("已同步 " .. changeCount .. " 个项目") or "无文件变更"
            self:sendNotify("✓ 备份完成", msg)
        else
            self:sendNotify("✗ 备份失败", "退出码: " .. exitCode .. "，请查看日志")
        end
        print("[SSDBackup] ========================================")
    end

    -- 直接传参数数组，无需经过 shell 转义
    currentBackupTask = hs.task.new(self.rsyncPath, completionCallback, streamCallback, args)
    currentBackupTask:start()
    return self
end

--- SSDBackup:bindHotkeys(mapping)
--- Method
--- 绑定热键到指定操作
---
--- Parameters:
---  * mapping - 热键映射表，格式：{backup={{"ctrl","alt","cmd"}, "B"}}
---
--- Returns:
---  * obj
function obj:bindHotkeys(mapping)
    if hotkeyTrigger then
        hotkeyTrigger:delete()
        hotkeyTrigger = nil
    end

    local finalMapping = mapping or {backup = {{"ctrl", "alt", "cmd"}, "B"}}

    for action, keySpec in pairs(finalMapping) do
        if action == "backup" then
            hotkeyTrigger = hs.hotkey.bind(
                keySpec[1],
                keySpec[2],
                function()
                    print("[SSDBackup] 手动启动备份...")
                    self:startBackup(true)
                end
            )
        end
    end

    return self
end

--- SSDBackup:start()
--- Method
--- 启动 Spoon，开始监听 USB 设备事件
---
--- Parameters:
---  * None
---
--- Returns:
---  * obj
function obj:start()
    self:init()
    self:bindHotkeys()

    -- 停止旧的监听器（如果存在）
    if volumeWatcher then
        volumeWatcher:stop()
        volumeWatcher = nil
    end

    -- 使用 hs.fs.volume 监听设备挂载（比 usb.watcher 更稳健）
    volumeWatcher = hs.fs.volume.new(function(eventType, eventInfo)
        if not eventInfo then return end

        local isMainTarget = false
        if eventInfo.path then
            isMainTarget = (eventInfo.path == "/Volumes/" .. self.ssName)
        elseif eventInfo.NSURLVolumeNameKey then
            isMainTarget = (eventInfo.NSURLVolumeNameKey == self.ssName)
        end

        if not isMainTarget then return end

        if eventType == hs.fs.volume.didMount then
            print("[SSDBackup] 检测到设备挂载：" .. self.ssName)
            self:sendNotify("SSDBackup", "备份盘已挂载，准备开始备份...")
            -- 延迟执行，确保文件系统完全就绪
            hs.timer.doAfter(3, function()
                self:startBackup(false)
            end)
        elseif eventType == hs.fs.volume.didUnmount then
            print("[SSDBackup] 检测到设备移除：" .. self.ssName)
            -- 如果正在备份，强制停止任务
            if isBackingUp and currentBackupTask then
                currentBackupTask:terminate()
                isBackingUp = false
                currentBackupTask = nil
                self:sendNotify("SSDBackup", "备份中断：设备已移除")
            end
        end
    end)


    if volumeWatcher then
        volumeWatcher:start()
        print("[SSDBackup] 已启动，监听设备：" .. self.ssName)
    else
        print("[SSDBackup] 警告：无法创建 USB 监听器")
    end

    return self
end

--- SSDBackup:stop()
--- Method
--- 停止 Spoon，移除卷监听和热键
---
--- Parameters:
---  * None
---
--- Returns:
---  * obj
function obj:stop()
    -- 停止卷监听器
    if volumeWatcher then
        volumeWatcher:stop()
        volumeWatcher = nil
    end

    -- 停止热键
    if hotkeyTrigger then
        hotkeyTrigger:delete()
        hotkeyTrigger = nil
    end

    -- 终止正在进行的备份任务
    if currentBackupTask then
        currentBackupTask:terminate()
        currentBackupTask = nil
    end

    isBackingUp = false
    print("[SSDBackup] 已停止")
    return self
end

--- SSDBackup:cleanOldLogs(maxAge)
--- Method
--- 清理指定天数之前的旧日志文件
---
--- Parameters:
---  * maxAge - 保留天数（默认使用 logMaxAge 配置）
---
--- Returns:
---  * number - 删除的文件数量
function obj:cleanOldLogs(maxAge)
    local days = maxAge or self.logMaxAge
    if not self.logDir or not hs.fs.attributes(self.logDir) then return 0 end

    local deletedCount = 0
    local now = os.time()
    local maxAgeSeconds = days * 24 * 60 * 60

    for file in hs.fs.dir(self.logDir) do
        if file:match("^backup_.*%.log$") then
            local path = self.logDir .. "/" .. file
            local attr = hs.fs.attributes(path)
            if attr and (now - attr.modification) > maxAgeSeconds then
                os.remove(path)
                deletedCount = deletedCount + 1
            end
        end
    end

    if deletedCount > 0 then
        print("[SSDBackup] 清理了 " .. deletedCount .. " 个旧日志文件")
    end
    return deletedCount
end

return obj
