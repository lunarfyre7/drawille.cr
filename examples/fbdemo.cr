require "../src/drawille"

c = Drawille::Canvas.new
f = Drawille::FlipBook.new

c.paint do
  move 100, 100
  down

  36.times do
    right 10
    36.times do
      right 10
      forward 8
    end
    f.snapshot(canvas)
  end

end

f.play({:repeat => true, :fps => 6})
