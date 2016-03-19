
require 'terminal-table'

hs = %w[ q1 q2 q3 mean amean ]

answers = [ -1, 0, 1 ].product([ -1, 0, 1 ], [ -1, 0, 1 ])

answers.each do |a|
  af = a.collect(&:to_f)
  as = a.size.to_f
  mean = af.reduce(&:+) / as
  a << mean.round(3)
  a << mean.abs.round(3)
end

table = Terminal::Table.new(:headings => hs, :rows => answers)
table.style = { alignment: :right }
puts table
p answers.length

