# -*- encoding: utf-8 -*-

module Drawille

  module Frameable

    PIXEL_MAP = [
      [0x01, 0x08],
      [0x02, 0x10],
      [0x04, 0x20],
      [0x40, 0x80]
    ]

    BRAILLE_CHAR_OFFSET = 0x2800

    def row(y, options)
      row   = @chars[y]
      min   = options[:min_x].as(Int32)
      max   = options[:max_x].as(Int32)
      return "" if min.nil? || max.nil?
      (min..max).reduce("") { |memo, i| memo = memo + to_braille(row.nil? ? 0 : row[i] || 0) }
    end

    def rows(options)
      min   = [(@chars.keys.min || 0), 0].min
      if options.has_key?(:min_y)
        min   = options[:min_y].as(Int32) || [(@chars.keys.min || 0), 0].min
      end
      max   = @chars.keys.max
      if options.has_key?(:max_y)
        max   = options[:max_y].as(Int32) ||  @chars.keys.max
      end
      return Array(Array(Int32)).new if min.nil? || max.nil?
      options[:min_x] ||= [@chars.reduce(Array(Array(Int32)).new) { |m,x| m << x.last.keys }.flatten.min, 0].min
      options[:max_x] ||=  @chars.reduce(Array(Array(Int32)).new) { |m,x| m << x.last.keys }.flatten.max
      (min..max).map { |i| row(i, options) }
    end

    def frame(options= Hash(Symbol, Int32 | Bool).new)
      rows(options).join("\n")
    end

    def char(x, y)
      to_braille @chars[y][x]
    end

    def to_braille(x)
      if x > 0
        (BRAILLE_CHAR_OFFSET + x).unsafe_chr
      else
        " "
      end
    end
  end
end
