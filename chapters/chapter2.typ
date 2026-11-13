#import "../hunau.typ": bifigure, bitable, three-line-table, landscape-page
#import "../lib/units.typ": num, qty, qty-range, qty-pm

= 图表与公式的格式规范

本章说明学位论文中图、表、公式的排版要求，并结合样例展示。

== SI 国际单位制符号的使用

文中的量和单位应执行国家标准。本模板提供 `lib/units.typ` 中的轻量工具：

- 一般数值：油菜种植密度为 #qty(300000, "株/ha")。
- 带不确定度：株高测量结果为 #qty-pm(165.4, 5.2, "cm")。
- 数值范围：温度变化范围为 #qty-range(15, 25, "°C")。
- 大数分组：本研究共采集了 #num(123456) 个数据点。

== 插图的格式要求与样例

=== 插图一般规范

插图应具有自明性，图题置于图下居中，并采用中英文对照。图 @fig:std_example 展示了标准单图排版。

#bifigure(
  image("../images/2/2-1.png", width: 13.5cm),
  [油菜种子结构示意图],
  [Schematic diagram of rapeseed seed structure],
  chapter: 2,
) <fig:std_example>

=== 结构示意图

结构示意图应标注关键器官或部位，如图 @fig:scale_example 所示。

#bifigure(
  image("../images/2/2-2.png", width: 11.0cm),
  [油菜花器与角果结构示意图],
  [Schematic diagram of rapeseed flower and silique structure],
  chapter: 2,
) <fig:scale_example>

== 表格的格式要求与样例

表格采用三线表，表题位于表上方居中，并采用中英文对照。表 @tab:phenotype 给出了不同油菜品种的农艺性状统计。

#bitable(
  three-line-table(
    columns: (auto, auto, auto, auto, auto),
    [*品种*], [*株高*], [*分枝数*], [*单株角果数*], [*千粒重*],
    table.hline(stroke: 0.75pt),
    [湘油1号], [#num(165.4) ± #num(5.2)], [#num(8.5) ± #num(1.2)], [#num(320.5) ± #num(25.4)], [#num(3.85) ± #num(0.12)],
    [中双11号], [#num(172.1) ± #num(4.8)], [#num(9.1) ± #num(0.8)], [#num(345.2) ± #num(18.6)], [#num(4.02) ± #num(0.15)],
    [华油杂62], [#num(168.9) ± #num(6.1)], [#num(8.8) ± #num(1.5)], [#num(338.7) ± #num(31.2)], [#num(3.95) ± #num(0.18)],
  ),
  [不同油菜品种的农艺性状统计],
  [Statistics of agronomic traits of different rapeseed varieties],
  chapter: 2,
) <tab:phenotype>

== 卧排表

当表格列数较多时，可以使用卧排表。模板会切换到横向页面并保留页码。

#landscape-page[
  #bitable(
    table(
      columns: (auto, auto, auto, auto, auto, auto, auto),
      inset: (x: 0.12cm, y: 0.18cm),
      stroke: none,
      table.hline(stroke: 1.5pt),
      [*Trait*], [*Marker*], [*Chr.*], [*Pos. (Mb)*], [*P-value*], [*MAF*], [*Gene ID*],
      table.hline(stroke: 0.75pt),
      [Plant Height], [bn-A03-4521], [A03], [14.52], [#num(1.2e-7)], [0.35], [BnaA03g12340],
      [Oil Content], [bn-C05-8910], [C05], [28.91], [#num(3.4e-9)], [0.42], [BnaC05g56780],
      [Flowering Time], [bn-A10-1122], [A10], [5.67], [#num(5.6e-8)], [0.28], [BnaA10g09870],
      [Pod Length], [bn-C02-3344], [C02], [41.23], [#num(2.1e-6)], [0.31], [BnaC02g23450],
      table.hline(stroke: 1.5pt),
    ),
    [多性状全基因组关联分析显著位点汇总],
    [Summary of significant loci from multi-trait genome-wide association studies],
    chapter: 2,
  ) <tab:landscape>
]

== 公式的格式要求与样例

公式应另起一行居中排版，编号按章编排。公式 @eq:yolo 为损失函数示例。

$ L = lambda_("coord") sum_(i=0)^(S^2) sum_(j=0)^B (x_i - hat(x)_i)^2 + sum_(i=0)^(S^2) (p_i - hat(p)_i)^2 $ <eq:yolo>

其中，$x_i, y_i$ 代表边界框中心坐标。

== 本章小结

本章展示了 SI 单位、插图、三线表、卧排表和公式的规范写法。所有图表题均支持中英文双语，编号按章自动生成。
