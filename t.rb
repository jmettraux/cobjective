
require 'terminal-table'

hs = %w[ type q1 q2 q3 mean amean var am*v res ]

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
  a <<
    case mean.round(2)
      when -1.00 then 'p'
      when  1.00 then 'b'
      when  0.00 then a[0] == 1 ? 'm' : 'ask 2qs'
      when -0.67 then 'mp'
      when  0.67 then 'mb'
      else a[0] == 3 ? 'ask q4' : 'ask 2qs'
    end
end

mi = hs.index('mean')
vi = hs.index('var')
answers = answers.sort_by { |a| "#{a[vi]}:#{a[mi]}" }

table = Terminal::Table.new(:headings => hs, :rows => answers)
table.style = { alignment: :right }
puts "\nfirst 3 questions:"
puts table
p answers.length

# type 3 - ask q4

t3hs = %w[ q1 q2 q3 mean amean var am*v q4 mean amean var res ]
t3s =
  answers.select { |a| a[0] == 3 }.collect { |a| a[1..-2] }
t3s =
  t3s.inject([]) { |rs, row| [ -1, 0, 1 ].each { |a| rs << [ *row, a ] }; rs }

t3s.each do |a|

  as = [ *a[0, 3], a[7] ].collect(&:to_f)
  mean = as.reduce(&:+) / as.size
  a << mean.round(3)
  a << mean.abs.round(3)
  var = as.collect { |a| (a - mean) ** 2 }.reduce(&:+) / as.size
  a << var.round(3)
  #a << (mean.abs * var).round(3)

  a <<
    case mean
      when -0.5 then 'mp'
      when  0.5 then 'mb'
      else 'm'
    end
end

table = Terminal::Table.new(:headings => t3hs, :rows => t3s)
table.style = { alignment: :right }
puts "\ntype 3, ask question 4:"
puts table
p t3s.length

