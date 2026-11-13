// ===========================================================================
// 湖南农业大学研究生学位论文 · Typst 版
//
// 编译：typst compile main.typ
// 选项：degree = "doctor" | "master" | "promaster"
//       blind  = true | false
// ===========================================================================

#import "hunau.typ": *

#show: hunau-thesis.with(
  degree: "promaster",
  blind: false,

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

  abstract-cn: [
    中英文摘要内容应一致，英文摘要放在中文摘要之后，要符合英语语法，语句通顺。硕士论文摘要不超过 500 汉字，博士论文摘要不超过 1000 汉字；内容一般包括：从事这项研究工作的目的和意义；完成的工作；获得的主要结论或提出的主要观点。摘要中一般不用图、表、化学结构式、非公知公用的符号和术语。

    本文围绕油菜表型分析，构建了基于计算机视觉的自动化分析流程，并在多组织、多模态数据上验证了方法的有效性。
  ],
  keywords-cn: ("油菜", "计算机视觉", "深度学习", "表型分析"),

  abstract-en: [
    The Chinese and English abstracts should be consistent, with the English abstract following the Chinese abstract. The English abstract must conform to English grammar and be fluent. Master's thesis abstracts should not exceed 500 Chinese characters, and doctoral dissertation abstracts should not exceed 1000 Chinese characters. The content generally includes: the purpose and significance of the research; the completed work; and the main conclusions or main viewpoints.

    This thesis builds an automated rapeseed phenotyping pipeline based on computer vision and validates it on multi-tissue, multi-modal data.
  ],
  keywords-en: ("Rapeseed", "Computer Vision", "Deep Learning", "Phenotyping"),

  symbols: (
    ("CNN", "卷积神经网络 (Convolutional Neural Network)"),
    ("RGB", "红绿蓝颜色模型 (Red, Green, Blue)"),
    ("VI", "植被指数 (Vegetation Index)"),
    ("LAI", "叶面积指数 (Leaf Area Index)"),
    ("R²", "决定系数 (Coefficient of Determination)"),
    ("Mb", "兆碱基 (Megabase)"),
  ),

  thanks: [
    可以在正文后对下列方面致谢：国家科学基金、资助研究工作的奖学金基金、合作单位、资助或支持的企业、组织或个人；协助完成研究工作和提供便利条件的组织和个人；在研究工作中提出建议和提供帮助的人；给予转载和引用权的资料、图片、文献、研究思想和设想的所有者；其它应感谢的组织和个人。
  ],

  resume: [
    #heading(level: 2, numbering: none, outlined: false)[作者简历]

    个人基本情况，大学起的学习经历和工作经历等。

    #heading(level: 2, numbering: none, outlined: false)[科研成果]

    注明成果名称、发表刊物或出版社名或颁奖单位、时间、本人排名。博士论文还要求攻读学位期间发表的学术论文目录。
  ],
)

#include "chapters/chapter1.typ"
#include "chapters/chapter2.typ"

#heading(level: 1, numbering: none, outlined: true)[参考文献]
#bibliography("references.bib", title: none, style: "gb-7714-2015-numeric")

#appendix(n: 1)
#include "chapters/appendix.typ"
