# 替换为实际的 OpenClaw 官方镜像名
FROM ghcr.io/openclaw/openclaw:latest

# 切换到 root 用户来安装软件
USER root

# 1. 安装基础系统依赖 (jq, ripgrep, gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y \
    jq \
    ripgrep \
    gh \
    && rm -rf /var/lib/apt/lists/*

# 5. 安装 mcporter 和 summarize (它们是 Node.js 写的 CLI 工具)
# OpenClaw 官方镜像已内置 Node.js 和 npm，直接全局安装即可
RUN npm install -g mcporter summarize clawhub

# 6. (可选) 如果官方镜像原本运行在非 root 用户下（例如 node 或 openclaw），请在此切换回去
USER node
