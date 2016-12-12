require "../src/drawille"

c = Drawille::Canvas.new

180.times do |x|
    c.set(x, (10 + Math.sin(x * 10 * (Math::PI * 2) / 180.0) * 10).to_i)
end

print(c.frame())
