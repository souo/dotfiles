module.exports = {
    extends: ["@commitlint/config-conventional"],
    rules: {
        "type-enum": [
            2,
            "always",
            [
                "feat",
                "fix",
                "docs",
                "style",
                "refactor",
                "perf",
                "test",
                "chore",
                "revert",
            ],
        ], // 允许的提交类型
        "scope-empty": [2, "never", true],
        "subject-max-length": [2, "always", 72],
    },

    prompt: {
        settings: {},
        messages: {
            skip: ":回车跳过",
            max: "%d个字符以内",
            min: "%d个字符以上",
            emptyWarning: "必选",
            upperLimitWarning: "超过字数限制",
            lowerLimitWarning: "低于字数要求",
        },
        questions: {
            type: {
                description: "选择提交类型",
                enum: {
                    feat: {
                        description: "新增功能",
                        title: "新功能",
                        emoji: "✨",
                    },
                    fix: {
                        description: "修复缺陷",
                        title: "修复 bug",
                        emoji: "🐛",
                    },
                    docs: {
                        description: "文档更新",
                        title: "文档",
                        emoji: "📚",
                    },
                    style: {
                        description: "代码风格调整(不影响代码逻辑)",
                        title: "格式",
                        emoji: "💎",
                    },
                    refactor: {
                        description: "代码重构（不改变功能）",
                        title: "重构",
                        emoji: "📦",
                    },
                    perf: {
                        description: "性能优化",
                        title: "优化",
                        emoji: "🚀",
                    },
                    test: {
                        description: "添加/修改测试用例",
                        title: "测试",
                        emoji: "🚨",
                    },
                    chore: {
                        description: "构建/依赖/配置变更",
                        title: "工具",
                        emoji: "♻️",
                    },
                    revert: {
                        description: "回滚到之前版本",
                        title: "回滚",
                        emoji: "🗑",
                    },
                },
            },
            scope: {
                description: "请输入影响范围（如模块名）",
            },
            subject: {
                description: "请输入简短描述（遵循「动词+对象」结构）",
            },
            body: {
                description: "详细说明动机和方案（'|' 换行）",
            },
            isBreaking: {
                description: "是否有破坏性变更（如 API 变更，可选）?",
            },
            breakingBody: {
                description: "破坏性变更的详细说明",
            },
            breaking: {
                description: "破坏性变更主题",
            },
            isIssueAffected: {
                description: "是否与某个未关闭的问题（Issue）直接相关?",
            },
            issuesBody: {
                description: "如果 ISSUE 被关闭，需要详细的说明",
            },
            issues: {
                description: '关联 Issue (如 "fix|close|ref #123". 可选)',
            },
        },
    },
};
