
require 'terminal-table'

hs = %w[ type q1 q2 q3 mean amean var am*v ]

answers = [ -1, 0, 1 ].product([ -1, 0, 1 ], [ -1, 0, 1 ])

answers.each do |a|

  a.unshift(nil) # prepare column for type

  as = a[1, 3].collect(&:to_f)
  mean = as.reduce(&:+) / as.size
  a << mean.round(3)
  a << mean.abs.round(3)
  var = as.collect { |a| (a - mean) ** 2 }.reduce(&:+) / as.size
  a << var.round(3)
  a << (mean.abs * var).round(3)

  a[0] = # determine type
    case a.last
      when 0.00..0.01 then var == 0.0 ? 1 : 5
      when 0.14..0.15 then 2
      when 0.07..0.08 then 3
      when 0.29..0.30 then 4
      else nil
    end
end

mi = hs.index('amean')
vi = hs.index('var')
answers = answers.sort_by { |a| "#{a[vi]}:#{a[mi]}" }

table = Terminal::Table.new(:headings => hs, :rows => answers)
table.style = { alignment: :right }
puts table
p answers.length

