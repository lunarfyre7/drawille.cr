# -*- encoding: utf-8 -*-
require "ncurses"

module Drawille

  class FlipBook
    include Frameable

    def initialize
      clear
    end

    def clear
      @snapshots = Array(Array(Char)).new
      @chars     = Hash(Int32, Hash(Int32, Int32)).new
    end

    def snapshot(canvas)
      @snapshots << canvas.frame
      @chars     =  canvas.chars
    end

    # Block specified
    def play(options= Hash(Symbol, Int32 | Bool).new, &block)
      options = {
        :repeat => false, :fps => 6,
        :min_x => 0, :min_y => 0
      }.merge(options)

      NCurses.init
      begin
        NCurses.crmode
        NCurses.curs_set 0
        repeat(options) do
          loop {
            canvas = yield
            raise "StopIteration" if canvas == nil
            draw(canvas.frame)
          }
        end
      ensure
        NCurses.end_win
      end
    end

    # No block specified
    def play(options= Hash(Symbol, Int32 | Bool).new)
      options = {
        :repeat => false, :fps => 6,
        :min_x => 0, :min_y => 0
      }.merge(options)

      NCurses.init
      begin
        NCurses.crmode
        NCurses.curs_set 0
        repeat(options) do
          each_frame(options) do |frame|
            draw(frame)
            sleep(1.0/options[:fps])
          end
        end
      ensure
        NCurses.end_win
      end
    end

    def repeat(options)
      options[:repeat] ? loop { yield; clear_screen } : yield
    end

    def draw(frame)
      clear_screen
      NCurses.setpos(0, 0)
      # puts frame
      NCurses.addstr(frame)
      NCurses.refresh
    end

    def clear_screen
      NCurses.clear
      # NCurses.refresh
    end
  end
end
