# CodeQL Java Demo

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://openjdk.org/projects/jdk/21/)
[![Maven](https://img.shields.io/badge/Maven-3.6+-blue.svg)](https://maven.apache.org/)
[![CodeQL](https://img.shields.io/badge/CodeQL-Supported-green.svg)](https://codeql.github.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 🔍 一个面向初学者的 CodeQL 静态代码分析教学项目，帮助你快速掌握如何使用 CodeQL 对 Java (Maven) 项目进行安全漏洞检测与代码质量分析。

## 📖 项目简介

[CodeQL](https://codeql.github.com/) 是 GitHub 开发的语义代码分析引擎，能够通过编写类 SQL 的查询语句来发现代码中的安全漏洞和质量问题。本项目提供了一个最小化的 Java 示例，演示如何：

- 创建 CodeQL 数据库
- 编写自定义 CodeQL 查询
- 使用内置查询进行安全扫描
- 解析 SARIF 格式的分析结果

## ✨ 特性

- 🎯 **开箱即用** - 包含完整的示例代码和查询脚本
- 📚 **教学导向** - 详细的步骤说明，适合 CodeQL 初学者
- 🔐 **安全示例** - 包含典型的 SQL 注入漏洞演示
- 🛠️ **自定义查询** - 提供可扩展的 `.ql` 查询模板

## 📋 前置条件

在开始之前，请确保你的开发环境满足以下要求：

| 依赖项 | 最低版本 | 说明 |
|--------|----------|------|
| JDK | 21+ | Java 开发工具包 |
| Maven | 3.6+ | 项目构建工具 |
| CodeQL CLI | Latest | [下载地址](https://github.com/github/codeql-action/releases) |

### CodeQL CLI 安装

1. 从 [GitHub Releases](https://github.com/github/codeql-action/releases) 下载适合你操作系统的版本
2. 解压到本地目录
3. 将 `codeql` 可执行文件路径添加到系统 `PATH` 环境变量
4. 验证安装：
   ```bash
   codeql --version
   ```

## 📁 项目结构

```
codeql-java-demo/
├── src/
│   └── main/
│       └── java/
│           └── edu/fdu/se/
│               └── Main.java          # 示例代码（含 SQL 注入漏洞）
├── query_method.ql                    # 自定义 CodeQL 查询
├── qlpack.yml                         # CodeQL 包配置文件
├── pom.xml                            # Maven 配置文件
├── codeql-results.sarif               # 内置查询分析结果
├── methods.sarif                      # 自定义查询分析结果
└── README.md
```

## 🚀 快速开始

### 步骤一：克隆项目

```bash
git clone https://github.com/your-username/codeql-java-demo.git
cd codeql-java-demo
```

### 步骤二：创建 CodeQL 数据库

CodeQL 需要先将源代码编译并构建为数据库，才能进行查询分析。

```bash
codeql database create ../codeql-db --language=java-kotlin
```

**参数说明：**
| 参数 | 说明 |
|------|------|
| `../codeql-db` | 数据库存储路径（目录不存在时自动创建） |
| `--language=java-kotlin` | 指定分析语言为 Java/Kotlin |
| `--overwrite` | 如果数据库已存在则覆盖 |

> ⚠️ **注意**：首次运行时，CodeQL 会自动下载 Java 语言的提取器（extractor），可能需要几分钟时间。

### 步骤三：运行 CodeQL 查询

#### 方式一：运行自定义查询

本项目提供了一个示例查询 `query_method.ql`，用于列出项目中所有方法的详细信息：

```bash
codeql database analyze ../codeql-db query_method.ql --format=sarif-latest --output=methods.sarif --threads=4
```

#### 方式二：运行 CodeQL 内置查询

使用 CodeQL 官方提供的 Java 安全查询套件进行全面扫描：

```bash
codeql database analyze ../codeql-db codeql/java-queries --download --format=sarif-latest --output=codeql-results.sarif
```

**参数说明：**
| 参数 | 说明 |
|------|------|
| `--download` | 自动下载所需的查询包 |
| `--format=sarif-latest` | 输出格式为 SARIF（静态分析结果交换格式） |
| `--output` | 指定输出文件路径 |
| `--threads` | 并行分析线程数 |

## 📝 自定义查询示例
以下是 `query_method.ql` 的完整内容，演示如何编写一个列出所有方法的 CodeQL 查询：

```ql
/**
 * @name List All Methods in Project
 * @description 列出项目中定义的所有方法及其详细信息
 * @kind problem
 * @id java/list-all-methods
 * @problem.severity recommendation
 */

import java

from Method m
where 
  m.fromSource() and           // Only methods defined in source code
  not m.isAbstract()           // Exclude abstract methods
select m,
  "Method: " + m.getName() + 
  " | Class: " + m.getDeclaringType().getQualifiedName() + 
  " | Return: " + m.getReturnType().toString() + 
  " | Params: " + m.getNumberOfParameters().toString() + 
  " | Line: " + m.getLocation().getStartLine().toString()
```

### 更多查询示例

<details>
<summary>🔐 检测 SQL 注入漏洞</summary>

```ql
/**
 * @name SQL Injection Vulnerability
 * @description 检测潜在的 SQL 注入风险
 * @kind path-problem
 * @id java/sql-injection
 * @problem.severity error
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SqlInjectionQuery
import SqlInjectionFlow::PathGraph

from SqlInjectionFlow::PathNode source, SqlInjectionFlow::PathNode sink
where SqlInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potential SQL injection from $@.", source.getNode(), "user input"
```

</details>

<details>
<summary>📊 统计代码复杂度</summary>

```ql
/**
 * @name High Cyclomatic Complexity
 * @description 查找圈复杂度过高的方法
 * @kind problem
 * @id java/high-complexity
 * @problem.severity warning
 */

import java

from Method m, int complexity
where 
  complexity = m.getMetrics().getCyclomaticComplexity() and
  complexity > 10 and
  m.fromSource()
select m, "Method has high cyclomatic complexity: " + complexity.toString()
```

</details>

## 📊 分析结果

分析完成后，结果将以 [SARIF](https://sarifweb.azurewebsites.net/) 格式保存。你可以：

- 使用 VS Code 的 [SARIF Viewer](https://marketplace.visualstudio.com/items?itemName=MS-SarifVSCode.sarif-viewer) 插件查看
- 上传到 GitHub Security 面板进行集中管理
- 使用 `jq` 等工具进行命令行解析

## 🔗 相关资源

- [CodeQL 官方文档](https://codeql.github.com/docs/)
- [CodeQL for Java 教程](https://codeql.github.com/docs/codeql-language-guides/codeql-for-java/)
- [CodeQL 查询示例库](https://github.com/github/codeql)
- [SARIF 规范](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html)

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📄 许可证

本项目采用 MIT 许可证，详情请参阅 [LICENSE](LICENSE) 文件。

---

<p align="center">
  Made with ❤️ for CodeQL learners
</p>
