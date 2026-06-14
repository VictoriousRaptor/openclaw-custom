# 替换为实际的 OpenClaw 官方镜像名
FROM ghcr.io/openclaw/openclaw:latest

# 切换到 root 用户来安装软件
USER root

# 1. 安装系统依赖
#    jq ripgrep gh — 原有的
#    build-essential  — gcc/g++/make 编译器（pycairo C 扩展需要）
#    python3-venv     — ensurepip + venv 支持
#    python3-dev      — Python.h 头文件（C 扩展编译需要）
#    libcairo2-dev    — Cairo 2D 图形库头文件（pycairo 链接需要）
#    pkg-config       — meson 构建工具查找 .pc 描述文件
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y \
    jq \
    ripgrep \
    gh \
    build-essential \
    python3-venv \
    python3-dev \
    libcairo2-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 2. 安装 Node.js CLI 工具
RUN npm install -g mcporter summarize clawhub

# 3. 切回 node 用户运行
USER node
