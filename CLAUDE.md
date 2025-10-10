# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Next.js 14、Supabase 和 Creem.io 构建的现代化 SaaS 启动套件，专注于 AI 中文名字生成服务。该项目支持全球用户登录和支付，特别对中国大陆开发者友好。

### 核心技术栈

- **前端框架**: Next.js 14 (App Router)
- **UI 组件**: Radix UI + Shadcn/ui + Tailwind CSS
- **认证系统**: Supabase Auth
- **数据库**: Supabase (PostgreSQL)
- **支付系统**: Creem.io (支持全球信用卡收款)
- **AI 服务**: OpenAI/OpenRouter API (使用 Gemini 2.5 Flash 模型)
- **语音合成**: 豆包 TTS (可选)
- **类型安全**: TypeScript
- **状态管理**: React Hooks + Server Actions

## 开发环境设置

### 前置条件
- Node.js 18+
- npm/yarn
- Supabase 账户和项目
- Creem.io 账户 (用于支付)

### 常用命令

```bash
# 安装依赖
npm i

# 开发服务器 (默认端口 3000)
npm run dev

# 构建生产版本
npm run build

# 启动生产服务器
npm start
```

### 环境变量配置

复制 `.env.example` 到 `.env.local` 并配置以下关键变量：

```bash
# Supabase 配置 (必需)
NEXT_PUBLIC_SUPABASE_URL=你的Supabase项目URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=你的匿名密钥
SUPABASE_SERVICE_ROLE_KEY=你的服务角色密钥

# Creem.io 支付配置 (必需)
CREEM_API_KEY=你的API密钥
CREEM_WEBHOOK_SECRET=你的Webhook密钥
CREEM_API_URL=https://test-api.creem.io/v1  # 测试环境

# AI 服务配置 (至少一个)
OPENROUTER_API_KEY=你的OpenRouter密钥
OPENAI_API_KEY=你的OpenAI密钥
OPENAI_BASE_URL=https://openrouter.ai/api/v1

# 站点配置
NEXT_PUBLIC_SITE_URL=http://localhost:3000
CREEM_SUCCESS_URL=http://localhost:3000/dashboard
```

## 项目架构

### 目录结构

```
├── app/                     # Next.js App Router
│   ├── (auth-pages)/       # 认证页面组 (sign-in, sign-up, forgot-password)
│   ├── dashboard/          # 用户仪表板 (需要认证)
│   ├── api/               # API 路由
│   │   ├── chinese-names/ # 中文名字生成相关 API
│   │   ├── creem/         # 支付相关 API
│   │   ├── webhooks/      # 第三方 Webhook
│   │   └── credits/       # 积分系统 API
│   ├── auth/              # Supabase 认证回调
│   ├── actions.ts         # Server Actions (认证、支付等)
│   ├── layout.tsx         # 根布局
│   ├── page.tsx           # 首页
│   └── globals.css        # 全局样式
├── components/            # React 组件
│   ├── ui/               # Shadcn/ui 基础组件
│   ├── dashboard/        # 仪表板相关组件
│   ├── product/          # 产品展示组件
│   └── layout/           # 布局组件 (header, footer, nav)
├── lib/                  # 工具库
│   └── utils.ts          # 通用工具函数 (cn 函数等)
├── utils/                # 功能工具
│   └── supabase/         # Supabase 客户端和中间件
├── hooks/                # 自定义 React Hooks
├── types/                # TypeScript 类型定义
├── supabase/             # 数据库相关
│   ├── migrations/       # 数据库迁移文件
│   └── scripts/          # 数据库脚本
└── middleware.ts         # Next.js 中间件 (路由保护)
```

### 核心功能模块

#### 1. 认证系统 (`app/auth/`, `utils/supabase/`)
- 基于 Supabase Auth 的完整认证流程
- 支持邮箱/密码登录和 OAuth (Google 等)
- 中间件自动保护 `/dashboard` 路由
- Session 管理由 Supabase SSR 处理

#### 2. AI 中文名字生成 (`app/api/chinese-names/`)
- 使用 OpenAI/OpenRouter API 调用 Gemini 2.5 Flash 模型
- 支持标准和高级两种生成模式
- 基于用户个性化信息生成名字
- 自动去重和降级处理机制
- IP 级别的免费用户限流 (每天3次)

#### 3. 支付系统 (`app/api/creem/`, `app/actions.ts`)
- 集成 Creem.io 支付网关
- 支持订阅和积分两种模式
- Webhook 自动处理支付状态更新
- 测试和生产环境切换

#### 4. 积分系统 (`app/api/credits/`)
- 用户积分余额管理
- 积分消费记录和历史查询
- 支持多种积分获取方式

### 数据库架构

关键表结构：
- `customers`: 统一客户信息表 (包含积分余额)
- `generation_batches`: 生成批次记录
- `generated_names`: 生成的名字详情
- `credits_history`: 积分变动历史
- `name_generation_logs`: 生成日志和分析
- `ip_rate_limits`: IP 级别限流

### API 设计模式

1. **认证检查**: 所有付费功能需要用户认证
2. **积分验证**: 生成前检查用户积分余额
3. **限流保护**: 免费用户基于 IP 的限流
4. **错误处理**: 统一的错误响应格式
5. **日志记录**: 关键操作的完整日志

### 开发模式

#### 组件开发
- 使用 Shadcn/ui 作为基础组件库
- 遵循 Radix UI 的可访问性标准
- Tailwind CSS 用于样式设计
- TypeScript 严格类型检查

#### API 开发
- Next.js App Router API Routes
- Server Actions 用于表单处理
- Supabase 客户端用于数据库操作
- 统一的错误处理和响应格式

#### 认证流程
- Supabase 中间件自动处理 session
- Server Actions 处理表单提交
- 重定向和错误消息统一处理

## 部署说明

### 开发环境
1. 配置 `.env.local` 环境变量
2. 运行 `npm run dev`
3. 访问 `http://localhost:3000`

### 生产部署 (Vercel)
1. 推送代码到 GitHub
2. 导入 Vercel 项目
3. 配置所有环境变量
4. 更新 Creem.io Webhook URL 为生产地址
5. 切换 Creem.io API 到生产环境

### 数据库设置
1. 在 Supabase 中创建项目
2. 执行 `supabase/migrations/` 中的 SQL 文件
3. 配置认证提供商 (邮箱、Google 等)
4. 设置 URL 重定向

## 重要提醒

- **端口配置**: 开发环境使用 3000 端口
- **环境变量**: 所有敏感信息存储在 `.env.local`
- **路由保护**: `/dashboard` 及其子路由自动需要认证
- **限流策略**: 免费用户每天3次生成，认证用户无限制
- **AI 配置**: 优先使用 OpenRouter，备选 OpenAI
- **支付配置**: 测试环境使用 `https://test-api.creem.io/v1`
- **数据库**: 使用 Supabase 的自动迁移功能