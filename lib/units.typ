// 基础数值与单位排版
// Typst 没有 siunitx，这里提供学位论文常用的最小实现。

#let group-int(s) = {
  let chars = s.clusters()
  let len = chars.len()
  chars.enumerate().map(((i, c)) => {
    if i > 0 and calc.rem(len - i, 3) == 0 { "," + c } else { c }
  }).join("")
}

/// 千分位数字：123456 -> 123,456；-12.5 -> -12.5
#let num(n) = {
  let s = str(n)
  let neg = s.starts-with("-")
  let body = if neg { s.slice(1) } else { s }
  let parts = body.split(".")
  let head = group-int(parts.at(0))
  let out = if parts.len() > 1 { head + "." + parts.at(1) } else { head }
  if neg { "-" + out } else { out }
}

#let normalize(v, e) = if v != 0 and calc.abs(v) >= 10 {
  normalize(v / 10, e + 1)
} else if v != 0 and calc.abs(v) < 1 {
  normalize(v * 10, e - 1)
} else {
  (v, e)
}

/// 科学计数法：sci(123456) -> 1.23 × 10^5
#let sci(value, digits: 2) = {
  if value == 0 { return [0] }
  let (m, e) = normalize(value, 0)
  let m = calc.round(m, digits: digits)
  [#num(m) × 10^#e]
}

/// 数值 + 单位：qty(123456, "株/ha")
#let qty(value, unit) = [#num(value) #h(0.22em)#unit]

/// 数值 + 单位，科学计数法：qty-sci(123456, "m")
#let qty-sci(value, unit, digits: 2) = [#sci(value, digits: digits) #h(0.22em)#unit]

/// 数值范围：qty-range(15, 25, "°C")
#let qty-range(a, b, unit) = [#num(a)–#num(b) #h(0.22em)#unit]

/// 带不确定度：qty-pm(165.4, 5.2, "cm")
#let qty-pm(value, err, unit) = [#num(value) ± #num(err) #h(0.22em)#unit]

/// 一组带同一单位的数值：qty-list((1, 2, 3), "cm") -> 1、2、3 cm
#let qty-list(values, unit) = {
  let parts = values.map(v => num(v))
  [#parts.join([、]) #h(0.22em)#unit]
}

/// 百分比：percent(0.425) -> 42.5%
#let percent(value, digits: 1) = {
  let v = calc.round(value * 100, digits: digits)
  [#num(v)%]
}
