# -*- encoding: utf-8 -*-
module Drawille

  class Canvas
    include Frameable

    getter chars

    def initialize(@chars= Hash(Int32, Hash(Int32, Int32)).new)
      clear
      @snapshots = [Hash(Int32, Hash(Int32, Int32)).new]
    end

    def paint(&block)
      with Brush.new(self) yield
      self
    end

    def clear
      @chars = Hash(Int32, Hash(Int32, Int32)).new { |h,v| h[v] = Hash(Int32, Int32).new(0) }
    end

    def set(x, y)
      x, y, px, py = convert x, y
      @chars[py][px] |= PIXEL_MAP[y % 4][x % 2]
    end

    def unset(x, y)
      x, y, px, py = convert x, y
      @chars[py][px] &= ~PIXEL_MAP[y % 4][x % 2]
    end

    def get(x, y)
      x, y, px, py = convert x, y
      @chars[py][px] & PIXEL_MAP[y % 4][x % 2] != 0
    end

    def []=(x, y, bool)
      bool ? set(x, y) : unset(x, y)
    end

    def toggle(x, y)
      x, y, px, py = convert x, y
      @chars[py][px] & PIXEL_MAP[y % 4][x % 2] == 0 ? set(x, y) : unset(x, y)
    end

    def convert(x, y)
      x = x.round
      y = y.round
      [x, y, (x / 2).floor, (y / 4).floor]
    end
  end
end
