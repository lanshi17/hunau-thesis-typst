# Hunau Thesis · Typst

湖南农业大学研究生学位论文的 Typst 版本，参考并吸收了 [hunau-thesis](https://github.com/ethanchen0431/hunau-thesis)（LaTeX 版）的版式与功能：

- 博士 / 学术硕士 / 专业硕士切换
- 盲审模式
- 封面、扉页、独创性声明与授权页
- 中英文摘要、目录、插图清单、附表清单、符号说明
- 单双页页眉、章内图表公式编号
- 中英文双语图表题、三线表、卧排表
- GB/T 7714 参考文献
- 附录编号、致谢、作者简历

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

首次编译会自动下载 `@preview/touying` 之外的依赖（本模板只依赖 Typst 内置能力，无额外包）。

## 文件结构

```text
hunau-thesis-typst/
├── main.typ               # 主文件：论文信息 + 章节顺序
├── hunau.typ              # 模板：页面、封面、页眉页脚、图表与摘要
├── lib/
│   └── units.typ          # 数值千分位、数值 + 单位、范围、不确定度
├── chapters/
│   ├── chapter1.typ       # 绪论示例
│   ├── chapter2.typ       # 图表公式规范示例
│   └── appendix.typ       # 附录示例
├── images/
│   ├── hunau_badge.png    # 封面校徽
│   └── 2/                 # 示例图片
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
blind: true
```

开启后会：

- 封面/扉页的作者、导师、学号、答辩信息替换为 `***`
- 不生成“致谢”页

作者简历中的个人姓名需要自行替换。

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
  [Schematic diagram of rapeseed seed structure],
  chapter: 2,
) <fig:seed>
```

正文引用：

```typst
如图 @fig:seed 所示。
```

说明：

- `chapter:` 必须写当前章号，用于生成“图 2-1”和“Figure 2-1”。
- 图题中文在下方，英文紧随其后（当前实现英文行在中文图题上方，见“已知差异”）。
- 图号按章自动重置，目录/插图清单中的编号也会正确。

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
  [Statistics of agronomic traits of different rapeseed varieties],
  chapter: 2,
) <tab:traits>
```

- `three-line-table` 只负责上下粗线；表头后的细线用 `table.hline(stroke: 0.75pt)`。
- 表内文字默认 10.5pt（五号）。
- 表格引用：`见表 @tab:traits`。

### 卧排表

```typst
#landscape-page[
  #bitable(
    table(columns: (auto, auto, auto, auto), ...),
    [多性状全基因组关联分析显著位点汇总],
    [Summary of significant loci ...],
    chapter: 2,
  ) <tab:landscape>
]
```

`landscape-page` 会切换到横向 A4，保留页码，不显示页眉。

## 公式

```typst
$ L = lambda_("coord") sum_(i=0)^(S^2) (x_i - hat(x)_i)^2 $ <eq:loss>

公式 @eq:loss 为损失函数示例。
```

公式编号按章生成，如 `2-1`。

## 数值与单位

```typst
#qty(300000, "株/ha")        // 300,000 株/ha
#qty-pm(165.4, 5.2, "cm")    // 165.4 ± 5.2 cm
#qty-range(15, 25, "°C")     // 15–25 °C
#num(123456)                 // 123,456
```

需要更复杂的 siunitx 功能时，可在 `lib/units.typ` 中扩展。

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
  [Supplementary sample information],
  appendix: 1,
) <tab:appendix>
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
  ……
],
```

盲审模式下 `thanks` 不输出。

## 字体

模板使用：

```typst
#let font-serif = ("Times New Roman", "SimSun")
#let font-sans  = ("Times New Roman", "SimHei")
#let font-kai   = ("Times New Roman", "Xingkai SC")
```

- macOS：SimSun / SimHei / Xingkai SC 通常可用。
- Windows：如果缺少 `Xingkai SC`，可改为 `"STXingkai"` 或 `"KaiTi"`。
- Linux：建议安装 `Source Han Sans SC` / `Source Han Serif SC`，并相应替换。

字体缺失时 Typst 会回退，版面可能变宽。

## 已知差异（相对 LaTeX 版）

1. **图表编号需要显式 `chapter:`**
   Typst 的 `figure` 计数器在目录重排时会重新求值，为保证插图/附表清单编号正确，`bifigure` / `bitable` 要求传入当前章号。章节顺序变化时记得同步修改。

2. **英文图题位置**
   当前实现中英文图题位于中文图题上方；LaTeX 版是中文在上、英文在下。若需要严格一致，可修改 `hunau.typ` 里的 `bifigure` / `bitable`，把英文行移入 `caption`（代价是插图清单会同时显示英文行）。

3. **前置部分页码**
   封面、扉页、授权页不编号；摘要从 `i` 开始。LaTeX 版扉页为 `I`、授权页为 `III`，Typst 版没有刻意插入空白页。

4. **卧排表页眉**
   横向页面不显示页眉，只保留页码；LaTeX 版对单双页表头朝向有更细的处理。

5. **SI 单位**
   `lib/units.typ` 是轻量实现，覆盖常用数值、范围、不确定度；未实现 siunitx 的全部单位与排版规则。

6. **盲审范围**
   自动隐藏封面/扉页个人信息和致谢；作者简历、正文中的人名需要自行替换。

## 后续可以做的事

- 图表编号改为按章自动捕获，去掉 `chapter:` 参数
- 英文图题移回中文图题下方，同时保持清单只显示中文
- 前置部分严格复刻 LaTeX 版的空白页与罗马页码
- 更完整的 SI 单位与科学计数法
- 自定义插图/附表清单样式
- 增加“成果清单”“参与项目”等常见页面组件
- CI：编译 + 页数 + 字体缺失检查

## 致谢

版式与功能参考：[ethanchen0431/hunau-thesis](https://github.com/ethanchen0431/hunau-thesis)（LaTeX 版）。
