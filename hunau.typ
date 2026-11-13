// ===========================================================================
// Hunau Thesis · Typst
// 湖南农业大学研究生学位论文 Typst 模板
//
// 参考 hunau-thesis（LaTeX）的版式与功能：
//   - 博士 / 学术硕士 / 专业硕士切换
//   - 盲审模式
//   - 封面、扉页、独创性声明
//   - 中英文摘要、目录、插图清单、附表清单、符号说明
//   - 单双页页眉、章内图表公式编号
//   - 中英文双语图表题、三线表、卧排表
//   - 附录编号、致谢、作者简历
// ===========================================================================

#import "lib/units.typ": *

// ---------------------------------------------------------------------------
// 字体
// ---------------------------------------------------------------------------

#let font-serif = ("Times New Roman", "SimSun")
#let font-song = ("Times New Roman", "SimSun")
#let font-sans = ("Times New Roman", "SimHei")
#let font-kai = ("Times New Roman", "Xingkai SC")

#let bluegray = rgb("#61688A")

// ---------------------------------------------------------------------------
// 学位类型
// ---------------------------------------------------------------------------

#let degree-label(degree) = if degree == "doctor" {
  "博士学位论文"
} else if degree == "promaster" {
  "全日制硕士专业学位论文"
} else {
  "硕士学位论文"
}

#let degree-header(degree) = "湖南农业大学" + degree-label(degree)

// ---------------------------------------------------------------------------
// 中文日期
// ---------------------------------------------------------------------------

#let cn-digits = ("〇", "一", "二", "三", "四", "五", "六", "七", "八", "九")

#let cn-year(y) = str(y).clusters().map(c => cn-digits.at(int(c))).join("")

#let cn-month(m) = if m == 10 {
  "十"
} else if m == 11 {
  "十一"
} else if m == 12 {
  "十二"
} else {
  cn-digits.at(m)
}

#let cn-date(d) = cn-year(d.year()) + "年" + cn-month(d.month()) + "月"

// ---------------------------------------------------------------------------
// 盲审与表单
// ---------------------------------------------------------------------------

#let blind-or(blind, value) = if blind { "***" } else { value }

#let underline-field(value, width, size: 12pt) = box(
  align(center, text(size: size, value)),
  width: width,
  stroke: (bottom: 0.5pt),
  inset: (bottom: 2pt),
)

#let signature-line(width) = box(
  width: width,
  stroke: (bottom: 0.5pt),
  inset: (bottom: 2pt),
)

#let date-blank = [
  　#box(width: 1.2cm, stroke: (bottom: 0.5pt)) 年
  #box(width: 1.2cm, stroke: (bottom: 0.5pt)) 月
  #box(width: 1.2cm, stroke: (bottom: 0.5pt)) 日
]

// ---------------------------------------------------------------------------
// 状态与计数器
// ---------------------------------------------------------------------------

#let chapter-no = state("chapter-no", 0)
#let chapter-title = state("chapter-title", "")
#let appendix-mode = state("appendix-mode", none)
#let degree-state = state("degree-state", "master")
#let fig-base = 100000

// 图表编号：章号编码进 figure 计数器（章号 × 1000 + 序号），
// 这样目录重排时不需要读取可变状态，编号也不会错位。
#let fig-label-number(n) = {
  let ch = calc.quo(n, fig-base)
  let seq = calc.rem(n, fig-base)
  if ch >= 1000 {
    numbering("附录1-1", ch - 1000, seq)
  } else {
    numbering("1-1", ch, seq)
  }
}

// ---------------------------------------------------------------------------
// 图表与三线表
// ---------------------------------------------------------------------------

/// 插图（中文图题）。标签写法：#bifigure(...) <fig:name>
#let bifigure(body, cn) = figure(
  body,
  caption: cn,
  supplement: [图],
  numbering: fig-label-number,
  kind: image,
)

/// 插图英文题注，紧跟在 #bifigure 之后使用。
#let figure-en(body) = context {
  let n = counter(figure.where(kind: image)).get().first()
  align(center, text(size: 10.5pt, font: "Times New Roman", cjk-latin-spacing: none)[
    Figure #fig-label-number(n) #body
  ])
}

/// 表格（中文表题）。标签写法：#bitable(...) <tab:name>
#let bitable(body, cn) = figure(
  body,
  caption: cn,
  supplement: [表],
  numbering: fig-label-number,
  kind: table,
)

/// 表格英文题注，紧跟在 #bitable 之后使用。
#let table-en(body) = context {
  let n = counter(figure.where(kind: table)).get().first()
  align(center, text(size: 10.5pt, font: "Times New Roman", cjk-latin-spacing: none)[
    Table #fig-label-number(n) #body
  ])
}

/// 三线表骨架；表头后请自行插入 table.hline(stroke: 0.75pt)
#let three-line-table(columns: 1fr, ..cells) = table(
  columns: columns,
  inset: (x: 0.15cm, y: 0.18cm),
  stroke: none,
  table.hline(stroke: 1.5pt),
  ..cells,
  table.hline(stroke: 1.5pt),
)

// ---------------------------------------------------------------------------
// 页眉页脚
// ---------------------------------------------------------------------------

#let front-footer = context {
  block(width: 100%, align(center, text(size: 9pt, counter(page).display())))
}

#let outer-footer = context {
  let p = counter(page).get().first()
  block(
    width: 100%,
    align(
      if calc.odd(p) { right } else { left },
      text(size: 9pt, counter(page).display()),
    ),
  )
}

#let main-header(degree) = context {
  let p = counter(page).get().first()
  let on-chapter-page = query(heading.where(level: 1))
    .filter(h => h.location().page() == here().page())
    .len() > 0
  if on-chapter-page {
    none
  } else {
    block(
      width: 100%,
      align(
        center,
        text(
          size: 9pt,
          font: font-song,
          if calc.odd(p) { chapter-title.get() } else { degree-header(degree) },
        ),
      ),
    )
    v(0.08cm)
    line(length: 100%, stroke: 0.5pt)
    v(0.04cm)
    line(length: 100%, stroke: 0.5pt)
  }
}

/// 卧排表页：横向 A4，带页眉与外侧页码。
#let landscape-page(body) = page(
  width: 29.7cm,
  height: 21cm,
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3.0cm, right: 3.0cm),
  header: none,
  footer: outer-footer,
  footer-descent: 1.75cm,
)[
  #context {
    align(center, text(size: 9pt, font: font-song, degree-header(degree-state.get())))
    v(0.08cm)
    line(length: 100%, stroke: 0.5pt)
    v(0.04cm)
    line(length: 100%, stroke: 0.5pt)
  }
  #v(0.8cm)
  #body
]

// ---------------------------------------------------------------------------
// 封面 / 扉页 / 独创性声明
// ---------------------------------------------------------------------------

#let cover-info(
  degree,
  blind,
  author,
  mentor,
  mentortitle,
  extramentor,
  degreetype,
  major,
  researcharea,
  size: 12pt,
) = {
  set text(size: size)
  let rows = if degree == "promaster" {
    (
      ([研究生姓名], underline-field(blind-or(blind, author), 5.5cm)),
      ([指导教师], underline-field(blind-or(blind, [#mentor #mentortitle]), 5.5cm)),
      ([校外指导教师], underline-field(blind-or(blind, extramentor), 5.5cm)),
      ([学位类型], underline-field(degreetype, 5.5cm)),
      ([学科领域], underline-field(major, 5.5cm)),
      ([研究方向], underline-field(researcharea, 5.5cm)),
    )
  } else {
    (
      ([研究生姓名], underline-field(blind-or(blind, author), 6cm)),
      ([指导教师], underline-field(blind-or(blind, [#mentor #mentortitle]), 6cm)),
      ([学科专业], underline-field(major, 6cm)),
      ([研究方向], underline-field(researcharea, 6cm)),
    )
  }
  block(
    breakable: false,
    table(
      columns: (auto, auto),
      align: (right, center),
      stroke: none,
      inset: (x: 0.35cm, y: 0.2cm),
      ..rows.flatten(),
    ),
  )
}

#let cover-page(
  degree,
  blind,
  title,
  author,
  mentor,
  mentortitle,
  extramentor,
  degreetype,
  major,
  researcharea,
  submitdate,
) = page(header: none, footer: none, numbering: none)[
  #v(2.9cm)
  #align(center, image("images/hunau_badge.png", width: 10.45cm))
  #v(1.5cm)
  #align(center, text(font: font-song, size: 26pt, tracking: 0.55em, degree-label(degree)))
  #v(1.5cm)
  #align(center, text(font: font-sans, size: 22pt, weight: "bold", title))
  #v(2.4cm)
  #align(center, cover-info(
    degree,
    blind,
    author,
    mentor,
    mentortitle,
    extramentor,
    degreetype,
    major,
    researcharea,
    size: 14pt,
  ))
  #v(1.6cm)
  #align(center, text(font: font-song, size: 15pt, cn-date(submitdate)))
]

// 空白页：用于复刻 LaTeX 版的 openright 前置部分。
#let blank-page() = page(header: none, footer: none, numbering: none)[#v(1fr)]


#let title-page(
  degree,
  blind,
  title,
  entitle,
  author,
  studentnumber,
  mentor,
  mentortitle,
  extramentor,
  degreetype,
  major,
  researcharea,
  clc,
  udc,
  secretlevel,
  defensedate,
  chair,
  reviewer,
  submitdate,
) = page(header: none, footer: front-footer, numbering: "i")[
  #v(0.3cm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.2cm,
    row-gutter: 0.5cm,
    [分类号 #underline-field(clc, 3.5cm)],
    [密　级 #underline-field(secretlevel, 3.5cm)],
    [U D C #underline-field(udc, 3.5cm)],
    [单位代码 #underline-field([10537], 3.5cm)],
  )
  #v(1.0cm)
  #align(center, text(font: font-kai, size: 42pt)[湖南农业大学])
  #v(0.35cm)
  #align(center, text(font: font-song, size: 26pt, tracking: 0.45em, degree-label(degree)))
  #v(0.6cm)
  #align(center, text(font: font-sans, size: 22pt, weight: "bold", title))
  #v(0.3cm)
  #align(center, text(font: font-sans, size: 18pt, weight: "bold", entitle))
  #v(0.5cm)
  #align(center, cover-info(
    degree,
    blind,
    author,
    mentor,
    mentortitle,
    extramentor,
    degreetype,
    major,
    researcharea,
  ))
  #v(0.3cm)
  #align(center, block(breakable: false, table(
    columns: (auto, auto, auto, auto),
    align: (right, center, right, center),
    stroke: none,
    inset: (x: 0.25cm, y: 0.2cm),
    [论文答辩日期], underline-field(blind-or(blind, defensedate), 4cm),
    [答辩委员会主席], underline-field(blind-or(blind, chair), 3.5cm),
    [论文评阅人], table.cell(colspan: 3, underline-field(blind-or(blind, reviewer), 9.8cm)),
  )))
  #v(1fr)
  #align(center, text(font: font-song, size: 15pt, cn-date(submitdate)))
]

#let authorization-page() = page(header: none, footer: front-footer, numbering: "i")[
  #v(0.4cm)
  #align(center, text(font: font-sans, size: 16pt, weight: "bold")[独 创 性 声 明])
  #v(0.7cm)
  #text(size: 12pt)[
    本人声明所呈交的论文是我个人在指导教师指导下进行的研究工作及取得的研究成果。尽我所知，除了文中特别加以标注和致谢的地方外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得湖南农业大学或其它教育机构的学位或证书而使用过的材料。与我一同工作的同志对本研究所做的任何贡献均已在论文中作了明确的说明并表示了谢意。
  ]
  #v(1.4cm)
  #grid(
    columns: (1fr, 1fr),
    [研究生签名：#signature-line(3.5cm)],
    [时间：#date-blank],
  )
  #v(2.4cm)
  #align(center, text(font: font-sans, size: 16pt, weight: "bold")[关于论文使用授权的说明])
  #v(0.7cm)
  #text(size: 12pt)[
    本人完全了解湖南农业大学有关保留、使用学位论文的规定，即：学校有权保留送交论文的复印件和磁盘，允许论文被查阅和借阅，可以采用影印、缩印或扫描等复制手段保存、汇编学位论文。同意湖南农业大学可以用不同方式在不同媒体上发表、传播学位论文的全部或部分内容，并同意将由此产生的收益捐赠给学校教育基金会用于发展研究生教育。
  ]
  #v(0.4cm)
  #text(font: font-sans, size: 12pt)[（保密的学位论文在解密后应遵守此协议）]
  #v(1.4cm)
  #grid(
    columns: (1fr, 1fr),
    [研究生签名：#signature-line(3.5cm)],
    [时间：#date-blank],
  )
  #v(0.6cm)
  #grid(
    columns: (1fr, 1fr),
    [指导教师签名：#signature-line(3.5cm)],
    [时间：#date-blank],
  )
]

// ---------------------------------------------------------------------------
// 摘要与前置清单
// ---------------------------------------------------------------------------

#let front-heading(title, outlined: true) = heading(
  level: 1,
  numbering: none,
  outlined: outlined,
)[#title]

/// 插图/附表清单：可配置字号与缩进。
#let list-of(title, target, size: 10.5pt, indent: 1.5em) = {
  front-heading(title)
  show outline.entry: set text(size: size, cjk-latin-spacing: none)
  outline(title: none, target: target, indent: indent)
}

/// 成果清单：entries = ((年份, 成果名称, 期刊/会议, 本人排名), ...)
#let publication-list(entries) = {
  set par(first-line-indent: 0pt, spacing: 0.5em)
  if entries.len() == 0 {
    text(fill: bluegray)[暂无。]
  } else {
    for (year, title, venue, ranking) in entries {
      grid(
        columns: (1.6cm, 1fr),
        column-gutter: 0.4cm,
        align: (left + top, left + top),
        text(size: 10.5pt, fill: bluegray)[#year],
        [
          #text(weight: "bold", size: 10.5pt)[#title]
          #linebreak()
          #text(size: 10.5pt)[#venue]#h(0.6em)#text(size: 10.5pt, fill: bluegray)[#ranking]
        ],
      )
      v(0.18cm)
    }
  }
}

/// 获奖情况：entries = ((年份, 奖项名称, 级别, 本人排名), ...)
#let award-list(entries) = {
  set par(first-line-indent: 0pt, spacing: 0.5em)
  if entries.len() == 0 {
    text(fill: bluegray)[暂无。]
  } else {
    for (year, name, level, ranking) in entries {
      grid(
        columns: (1.6cm, 1fr),
        column-gutter: 0.4cm,
        align: (left + top, left + top),
        text(size: 10.5pt, fill: bluegray)[#year],
        [
          #text(weight: "bold", size: 10.5pt)[#name]
          #linebreak()
          #text(size: 10.5pt)[#level]#h(0.6em)#text(size: 10.5pt, fill: bluegray)[#ranking]
        ],
      )
      v(0.18cm)
    }
  }
}

/// 学术报告：entries = ((年份, 报告题目, 会议/单位, 报告类型), ...)
#let presentation-list(entries) = {
  set par(first-line-indent: 0pt, spacing: 0.5em)
  if entries.len() == 0 {
    text(fill: bluegray)[暂无。]
  } else {
    for (year, title, venue, kind) in entries {
      grid(
        columns: (1.6cm, 1fr),
        column-gutter: 0.4cm,
        align: (left + top, left + top),
        text(size: 10.5pt, fill: bluegray)[#year],
        [
          #text(weight: "bold", size: 10.5pt)[#title]
          #linebreak()
          #text(size: 10.5pt)[#venue]#h(0.6em)#text(size: 10.5pt, fill: bluegray)[#kind]
        ],
      )
      v(0.18cm)
    }
  }
}

/// 参与项目：entries = ((项目名称, 项目来源, 起止时间, 本人角色), ...)
#let project-list(entries) = {
  set par(first-line-indent: 0pt, spacing: 0.4em)
  if entries.len() == 0 {
    text(fill: bluegray)[暂无。]
  } else {
    for (name, source, period, role) in entries {
      grid(
        columns: (1fr, auto),
        column-gutter: 0.4cm,
        align: (left + top, right + top),
        [
          #text(weight: "bold")[#name]
          #linebreak()
          #text(size: 10.5pt, fill: bluegray)[#source]
        ],
        [
          #text(size: 10.5pt, fill: bluegray)[#period]
          #linebreak()
          #text(size: 10.5pt)[#role]
        ],
      )
      v(0.18cm)
    }
  }
}

#let abstract-cn-page(body, keywords, fund) = {
  front-heading([摘　要])
  body
  v(0.6cm)
  text(font: font-sans, weight: "bold")[关键词：]
  keywords.join("；")
  if fund != none {
    v(1fr)
    text(size: 9pt, fund)
  }
}

#let abstract-en-page(body, keywords) = {
  front-heading([ABSTRACT])
  body
  v(0.6cm)
  text(weight: "bold")[Key words: ]
  keywords.join("; ")
}

#let symbols-page(symbols) = if symbols.len() > 0 {
  front-heading([符号说明])
  table(
    columns: (4cm, 1fr),
    inset: (x: 0.2cm, y: 0.15cm),
    stroke: none,
    table.hline(stroke: 1pt),
    [*符号*], [*说明*],
    table.hline(stroke: 0.5pt),
    ..symbols.map(((k, v)) => (k, v)).flatten(),
    table.hline(stroke: 1pt),
  )
}

// ---------------------------------------------------------------------------
// 附录
// ---------------------------------------------------------------------------

#let appendix(n: 1) = {
  appendix-mode.update(n)
  counter(figure.where(kind: image)).update((1000 + n) * fig-base)
  counter(figure.where(kind: table)).update((1000 + n) * fig-base)
}

// ---------------------------------------------------------------------------
// 主题入口
// ---------------------------------------------------------------------------

#let hunau-thesis(
  degree: "master",
  blind: false,
  blind-keywords: (),
  title: [],
  entitle: [],
  author: [],
  studentnumber: [],
  mentor: [],
  mentortitle: [],
  extramentor: [],
  degreetype: [],
  major: [],
  researcharea: [],
  fund: none,
  clc: [],
  udc: [],
  secretlevel: [],
  defensedate: [],
  chair: [],
  reviewer: [],
  submitdate: datetime.today(),
  abstract-cn: [],
  keywords-cn: (),
  abstract-en: [],
  keywords-en: (),
  symbols: (),
  thanks: none,
  resume: none,
  body,
) = {
  set document(title: "湖南农业大学研究生学位论文")
  degree-state.update(degree)
  let blind-pattern = if blind and blind-keywords.len() > 0 {
    blind-keywords.join("|")
  } else {
    "__HunauNeverMatch__"
  }
  show regex(blind-pattern): "***"
  set page(
    paper: "a4",
    margin: (top: 3.0cm, bottom: 2.5cm, left: 2.6cm, right: 2.6cm),
    header-ascent: 1.5cm,
    footer-descent: 1.75cm,
    numbering: none,
  )
  set text(font: font-serif, size: 12pt, lang: "zh", region: "cn")
  set par(
    justify: true,
    leading: 0.8em,
    first-line-indent: (amount: 2em, all: true),
  )
  set heading(numbering: (..n) => if n.len() == 1 {
    numbering("第1章", n.at(0))
  } else if n.len() == 2 {
    numbering("1.1", ..n)
  } else {
    numbering("1.1.1", ..n)
  })
  set math.equation(numbering: n => context {
    if appendix-mode.get() != none {
      numbering("附录1-1", appendix-mode.get(), n)
    } else {
      numbering("1-1", chapter-no.get(), n)
    }
  })
  show table: set text(size: 10.5pt)

  show heading.where(level: 1): it => {
    if it.numbering != none {
      let ch = counter(heading).get().first()
      chapter-no.update(ch)
      chapter-title.update(it.body)
      counter(figure.where(kind: image)).update(ch * fig-base)
      counter(figure.where(kind: table)).update(ch * fig-base)
    }
    pagebreak(weak: true)
    v(0.2cm)
    align(center, text(
      font: font-sans,
      size: 16pt,
      weight: "bold",
      cjk-latin-spacing: none,
      it,
    ))
    v(0.6cm)
  }
  show heading.where(level: 2): it => {
    v(0.5cm)
    text(font: font-song, size: 14pt, weight: "bold", cjk-latin-spacing: none, it)
    v(0.3cm)
  }
  show heading.where(level: 3): it => {
    v(0.4cm)
    text(font: font-sans, size: 12pt, weight: "bold", cjk-latin-spacing: none, it)
    v(0.2cm)
  }
  show figure.caption: it => align(center, text(cjk-latin-spacing: none, it))

  // 封面（无页码）
  cover-page(
    degree,
    blind,
    title,
    author,
    mentor,
    mentortitle,
    extramentor,
    degreetype,
    major,
    researcharea,
    submitdate,
  )
  blank-page()

  // 前置部分：罗马页码，每个部分从奇数页开始
  set page(numbering: "i", header: none, footer: front-footer)
  counter(page).update(1)
  title-page(
    degree,
    blind,
    title,
    entitle,
    author,
    studentnumber,
    mentor,
    mentortitle,
    extramentor,
    degreetype,
    major,
    researcharea,
    clc,
    udc,
    secretlevel,
    defensedate,
    chair,
    reviewer,
    submitdate,
  )
  blank-page()
  authorization-page()
  blank-page()
  abstract-cn-page(abstract-cn, keywords-cn, fund)
  blank-page()
  abstract-en-page(abstract-en, keywords-en)
  blank-page()
  front-heading([目　录], outlined: false)
  outline(title: none, depth: 3, indent: 2em)
  blank-page()
  list-of([插图清单], figure.where(kind: image))
  blank-page()
  list-of([附表清单], figure.where(kind: table))
  if symbols.len() > 0 {
    blank-page()
    symbols-page(symbols)
  }
  blank-page()

  // 主体部分：阿拉伯页码
  counter(heading).update(0)
  set page(numbering: "1", header: main-header(degree), footer: outer-footer)
  counter(page).update(1)
  body

  // 结尾部分
  if not blind and thanks != none {
    front-heading([致　谢])
    thanks
  }
  if resume != none {
    front-heading([作者简历及在读期间科研成果])
    resume
  }
}
