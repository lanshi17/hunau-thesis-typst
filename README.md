# Hunau Thesis · Typst

[![build](https://github.com/lanshi17/hunau-thesis-typst/actions/workflows/ci.yml/badge.svg)](https://github.com/lanshi17/hunau-thesis-typst/actions/workflows/ci.yml)

湖南农业大学研究生学位论文的 Typst 版本，参考并吸收了 [hunau-thesis](https://github.com/ethanchen0431/hunau-thesis)（LaTeX 版）的版式与功能：

- 博士 / 学术硕士 / 专业硕士切换
- 盲审模式
- 封面、扉页、独创性声明与授权页
- 中英文摘要、目录、插图清单、附表清单、符号说明
- 单双页页眉、章内图表公式编号
- 中英文双语图表题、三线表、卧排表
- GB/T 7714 参考文献
- 附录编号、致谢、作者简历、成果清单、参与项目

与 LaTeX 版相比，Typst 版不需要 TeX Live，编译速度快，源码更接近 Markdown。

## 快速开始

安装 Typst（建议 0.13+，本仓库用 0.15.1）：

```bash
brew install typst        # macOS
# 其他平台见 https://typst.app/docs/
```

编译：

```bash
typst compile main.typ
typst watch main.typ      # 保存即重新编译
```

本地检查（编译 + 页数 + 中文字体）：

```bash
bash scripts/check.sh
```

## 文件结构

```text
hunau-thesis-typst/
├── main.typ               # 主文件：论文信息 + 章节顺序
├── hunau.typ              # 模板：页面、封面、页眉页脚、图表与摘要
├── lib/
│   └── units.typ          # 数值千分位、单位、范围、科学计数法、百分比
├── chapters/
│   ├── chapter1.typ       # 绪论示例
│   ├── chapter2.typ       # 图表公式规范示例
│   └── appendix.typ       # 附录示例
├── images/
│   ├── hunau_badge.png    # 封面校徽
│   └── 2/                 # 示例图片
├── scripts/
│   └── check.sh           # 本地编译 + 页数 + 字体检查
├── .github/workflows/
│   └── ci.yml             # GitHub Actions：编译、页数、字体检查
├── references.bib         # 参考文献数据库
├── main.pdf               # 编译产物
└── README.md
```

## 论文信息

所有元数据都在 `main.typ` 的 `#show: hunau-thesis.with(...)` 里：

```typst
#show: hunau-thesis.with(
  degree: "promaster",       // doctor | master | promaster
  blind: false,              // true 开启盲审

  title: [基于微调模型计算机视觉的油菜表型分析研究],
  entitle: [Research on Rapeseed Phenotyping Based on Computer Vision],
  author: [张三],
  studentnumber: [20230001],
  mentor: [李四],
  mentortitle: [教授],
  extramentor: [王五 高级农艺师],
  degreetype: [农业硕士],
  major: [农艺与种业],
  researcharea: [智慧农业],
  fund: [本研究得到国家自然科学基金（编号：12345678）资助。],
  clc: [S123],
  udc: [630],
  secretlevel: [公开],
  defensedate: [2025年1月30日],
  chair: [王教授],
  reviewer: [张教授、李教授、赵教授],
  submitdate: datetime(year: 2025, month: 12, day: 1),
)
```

### 学位类型

| `degree` | 封面/扉页标题 | 信息表字段 |
|---|---|---|
| `doctor` | 博士学位论文 | 研究生姓名、指导教师、学科专业、研究方向 |
| `master` | 硕士学位论文 | 同上 |
| `promaster` | 全日制硕士专业学位论文 | 研究生姓名、指导教师、校外指导教师、学位类型、学科领域、研究方向 |

### 盲审模式

```typst
blind: true,
blind-keywords: ("张三", "李四", "王五", "赵教授"),
```

开启后会：

- 封面/扉页的作者、导师、学号、答辩信息替换为 `***`
- 不生成“致谢”页
- 正文、作者简历中的 `blind-keywords` 自动替换为 `***`

## 摘要与关键词

```typst
abstract-cn: [
  中文摘要正文……
],
keywords-cn: ("油菜", "计算机视觉", "深度学习", "表型分析"),

abstract-en: [
  English abstract……
],
keywords-en: ("Rapeseed", "Computer Vision", "Deep Learning", "Phenotyping"),
```

中文摘要页底部的基金说明来自 `fund`。

## 章节

在 `main.typ` 末尾按顺序引入：

```typst
#include "chapters/chapter1.typ"
#include "chapters/chapter2.typ"
```

章节文件里：

```typst
= 绪论                 // 一级标题：新起一页，显示“第1章 绪论”
== 研究背景与意义       // 二级标题：1.1
=== 作物表型与计算机视觉 // 三级标题：1.1.1
```

- 一级标题自动生成章节页、页眉和目录条目。
- 二级、三级标题自动编号。
- 需要不编号的小节：

```typst
#heading(level: 2, numbering: none)[补充说明]
```

## 图

```typst
#bifigure(
  image("../images/2/2-1.png", width: 13.5cm),
  [油菜种子结构示意图],
) <fig:seed>

#figure-en([Schematic diagram of rapeseed seed structure])
```

正文引用：

```typst
如图 @fig:seed 所示。
```

说明：

- `bifigure` 只负责中文图题和图表编号。
- `figure-en` 紧跟在后面，生成英文题注，显示在中文图题下方。
- 插图清单只收录中文图题，不会把英文行带进去。
- 图号按章自动生成（图 2-1），不需要手动传章号。

## 表

```typst
#bitable(
  three-line-table(
    columns: (auto, auto, auto),
    [*品种*], [*株高*], [*产量*],
    table.hline(stroke: 0.75pt),
    [湘油1号], [165.4], [2450.5],
    [中双11号], [172.1], [2380.1],
  ),
  [不同油菜品种的农艺性状统计],
) <tab:traits>

#table-en([Statistics of agronomic traits of different rapeseed varieties])
```

- `three-line-table` 只负责上下粗线；表头后的细线用 `table.hline(stroke: 0.75pt)`。
- 表内文字默认 10.5pt（五号）。
- 表格引用：`见表 @tab:traits`。
- 附表清单同样只收录中文表题。

### 卧排表

```typst
#landscape-page[
  #bitable(
    table(columns: (auto, auto, auto, auto), ...),
    [多性状全基因组关联分析显著位点汇总],
  ) <tab:landscape>

  #table-en([Summary of significant loci ...])
]
```

`landscape-page` 会切换到横向 A4，带页眉与外侧页码。

## 公式

```typst
$ L = lambda_("coord") sum_(i=0)^(S^2) (x_i - hat(x)_i)^2 $ <eq:loss>

公式 @eq:loss 为损失函数示例。
```

公式编号按章生成，如 `2-1`。

## 数值与单位

```typst
#qty(300000, "株/ha")             // 300,000 株/ha
#qty-pm(165.4, 5.2, "cm")         // 165.4 ± 5.2 cm
#qty-range(15, 25, "°C")          // 15–25 °C
#qty-sci(123456, "bp")            // 1.23 × 10^5 bp
#qty-list((10, 20, 30), "株")     // 10、20、30 株
#qty-per(300000, unit("ha"))      // 300,000 ha⁻¹
#qty-product(3, 4, unit("cm"))    // 3 × 4 cm
#num-range(10, 20)                // 10–20
#angle(45)                        // 45°
#percent(0.425)                   // 42.5%
#num(123456)                      // 123,456
#sci(123456)                      // 1.23 × 10^5
```

`unit()` 支持 cm / mm / m / km / kg / g / ha / Mb / bp / °C / %；特殊单位可直接写字符串，或在 `lib/units.typ` 的 `si-units` 中扩展。

## 参考文献

`main.typ` 中：

```typst
#heading(level: 1, numbering: none, outlined: true)[参考文献]
#bibliography("references.bib", title: none, style: "gb-7714-2015-numeric")
```

正文引用：

```typst
……相关工具链的成熟也降低了分析门槛 @chenTBtoolsIIOneAll2023。
```

Typst 内置 CSL 样式，使用 `gb-7714-2015-numeric` 即可得到国标顺序编码制。

## 附录

```typst
#appendix(n: 1)

#heading(level: 1, numbering: none, outlined: true)[附录1 补充材料]
```

附录中的图表：

```typst
#bitable(
  ...,
  [补充样本信息],
) <tab:appendix>

#table-en([Supplementary sample information])
```

编号会变成“表 附录1-1”“Table 附录1-1”。

## 致谢与作者简历

在 `main.typ` 里通过 `thanks` 和 `resume` 传入：

```typst
thanks: [
  致谢正文……
],
resume: [
  #heading(level: 2, numbering: none, outlined: false)[作者简历]
  ……

  #heading(level: 2, numbering: none, outlined: false)[科研成果]
  #publication-list((
    ("2025", [论文标题], [期刊名称], [第一作者]),
    ("2024", [会议论文标题], [会议名称], [第二作者]),
  ))

  #heading(level: 2, numbering: none, outlined: false)[参与项目]
  #project-list((
    ("项目名称", [项目来源], "2024–2025", [主要参与人]),
  ))

  #heading(level: 2, numbering: none, outlined: false)[获奖情况]
  #award-list((
    ("2025", [奖项名称], [级别], [本人排名]),
  ))

  #heading(level: 2, numbering: none, outlined: false)[学术报告]
  #presentation-list((
    ("2025", [报告题目], [会议名称], [口头报告]),
  ))
],
```

盲审模式下 `thanks` 不输出。

## 清单样式

插图清单和附表清单由 `list-of` 生成，可配置字号与缩进：

```typst
#list-of([插图清单], figure.where(kind: image), size: 10.5pt, indent: 1.5em)
#list-of([附表清单], figure.where(kind: table), size: 10.5pt, indent: 1.5em)
```

需要自定义时，修改 `hunau.typ` 中 `list-of` 的 `show outline.entry` 规则。

## 前置部分页码

模板复刻了 LaTeX 版的 openright 布局：

- 封面：无页码
- 扉页：I
- 独创性声明：III
- 中文摘要：V
- 英文摘要：VII
- 目录：IX
- 插图清单：XI
- 附表清单：XIII
- 符号说明：XV
- 正文：1

中间自动插入空白偶数页，空白页不显示页码。

## 字体

模板默认使用：

```typst
#let font-serif = ("Times New Roman", "SimSun")
#let font-sans  = ("Times New Roman", "SimHei")
#let font-kai   = ("Times New Roman", "Xingkai SC")
```

- macOS：SimSun / SimHei 通常可用；没有 `Xingkai SC` 时可用 `STXingkai` 或 `KaiTi`。
- Windows：SimSun / SimHei 通常可用；`Xingkai SC` 可改为 `STXingkai`。
- Linux / CI：安装 `fonts-noto-cjk`，把字体替换为 `Noto Serif CJK SC` / `Noto Sans CJK SC`。

CI 会自动做这组替换，本地 macOS / Windows 不受影响。

## CI

`.github/workflows/ci.yml` 在每次 push / PR 时：

1. 安装 Typst 0.15.1 与 Noto CJK 字体
2. 严格检查 CJK 字体是否存在
3. 替换为 CI 可用字体
4. `typst compile main.typ`
5. 检查页数（至少 20 页；当前示例 29 页）
6. 用 lychee 检查 README 链接
7. 上传 `main.pdf` 作为 artifact

本地等价检查：

```bash
bash scripts/check.sh
```

## 路线图（已完成）

- [x] 图表编号按章自动生成，去掉 `chapter:` 参数
- [x] 中文图题在上、英文图题在下，清单只收录中文
- [x] 前置部分复刻 LaTeX 版空白页与罗马页码
- [x] SI 单位：数值、范围、不确定度、科学计数法、单位倒数、乘积、百分比、角度
- [x] 自定义插图/附表清单样式（字号、缩进）
- [x] 成果清单、参与项目、获奖情况、学术报告组件
- [x] 盲审模式覆盖正文与作者简历中的人名
- [x] 卧排表页眉与外侧页码
- [x] CI：编译、页数、CJK 字体严格检查、链接检查

## 致谢

版式与功能参考：[ethanchen0431/hunau-thesis](https://github.com/ethanchen0431/hunau-thesis)（LaTeX 版）。
