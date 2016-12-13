require "../src/drawille"
require "ncurses"

class Conway
  @world : Array(Array(Int32))

  OFFSET_MATRIX = [[-1,-1], [0, -1], [1, -1],
                   [-1, 0],          [1,  0],
                   [-1, 1], [0,  1], [1,  1]]

  def initialize(@height : Int32, @width : Int32)
    @height = height
    @width  = width

    @world  = initialize_world { |x, y| rand(0..1) }
  end

  def initialize_world
    Array.new(@width) { |x| Array.new(@height) { |y| yield x, y }}
  end

  def alive_neighbours(x, y)
     OFFSET_MATRIX.reduce(0) do |memo, offset|
       x_offset = x + offset[0]
       y_offset = y + offset[1]

       memo += @world[x_offset][y_offset] if inside_range? x_offset, y_offset
       memo
     end
  end

  def evolve
    next_world = initialize_world { |x, y| 0 }
    each do |x, y|
      alive_neighbours = alive_neighbours x, y
      next_world[x][y] =
        if cell_alive? x, y
          (2..3).includes?(alive_neighbours) ? 1 : 0
        else
          alive_neighbours == 3 ? 1 : 0
        end
    end
    @world = next_world
  end

  def cell_alive?(x, y)
    @world[x][y] == 1
  end

  def inside_range?(x, y)
   (0...@height).includes?(y) && (0...@width).includes?(x)
  end

  def to_canvas
    canvas = Drawille::Canvas.new
    each do |x, y|
      canvas.set(x, y) if @world[x][y] > 0
    end
    canvas
  end

  def each
    (0...@height).each do |y|
      (0...@width).each do |x|
        yield x, y
      end
    end
  end

end

# STDOUT.flush_on_newline = false
NCurses.init

if (height = NCurses.lines) && (width = NCurses.cols)
  conway   = Conway.new((height) * 4, (width) * 2 - 2)
  flipbook = Drawille::FlipBook.new

  flipbook.play do
    canvas = conway.to_canvas
    conway.evolve
    canvas
  end
end
