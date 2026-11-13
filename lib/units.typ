// 基础数值与单位排版
// Typst 没有 siunitx，这里提供课程作业够用的最小实现。

#let group-int(s) = {
  let chars = s.clusters()
  let len = chars.len()
  chars.enumerate().map(((i, c)) => {
    if i > 0 and calc.rem(len - i, 3) == 0 { "," + c } else { c }
  }).join("")
}

/// 千分位数字：123456 -> 123,456；12.5 -> 12.5
#let num(n) = {
  let s = str(n)
  let parts = s.split(".")
  let head = group-int(parts.at(0))
  if parts.len() > 1 { head + "." + parts.at(1) } else { head }
}

/// 数值 + 单位：qty(123456, "株/ha")
#let qty(value, unit) = [#num(value) #h(0.22em)#unit]

/// 数值范围：qty-range(15, 25, "°C")
#let qty-range(a, b, unit) = [#num(a)–#num(b) #h(0.22em)#unit]

/// 带不确定度：qty-pm(165.4, 5.2, "cm")
#let qty-pm(value, err, unit) = [#num(value) ± #num(err) #h(0.22em)#unit]
