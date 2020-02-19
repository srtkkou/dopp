# frozen_string_literal: true

require 'dopp/error'
require 'dopp/type'
require 'dopp/util'

module Dopp
  # Canvas of the page.
  class Canvas
    include ::Dopp::Error
    include ::Dopp::Type

    attr_reader :media_width
    attr_reader :media_height
    attr_writer :state

    def initialize(content)
      check_is_a!(content, ::Dopp::Section::Content)
      @content = content
      @commands = []
      @media_width = content.page.media_width
      @media_height = content.page.media_height
      @state = State.new(self)
    end

    def state
      deep_copy(@state)
    end

    def move_to(mm_x, mm_y)
      @state.cursor_x = mm_x
      @state.cursor_y = mm_y
    end

    def stroke_color=(value)
      @state.stroke_color = value
    end

    def fill_color=(value)
      @state.fill_color = value
    end

    def use_font(font_name, opts = {})
      font = @content.use_font(font_name, opts)
      @state.font_alias = kw(font.alias)
      @state.font_size = opts[:size] if opts[:size]
    end

    # def grid(values, opts = {})
    # end

    # def text_box(value, opts = {})
    # end

    def write(value)
      check_is_a!(@state.font_alias, ::Dopp::Type::KeyWord)
      @commands << 'q'
      @commands << cmd_lrlg(@state.stroke_color)
      @commands << cmd_rg(@state.fill_color)
      @commands << 'BT'
      @commands << "1 0 0 1 #{@state.x} #{@state.y} Tm"
      @commands << "#{@state.font_size} TL"
      @commands << cmd_ltf(@state.font_alias, @state.font_size)
      # Split lines.
      value.each_line do |line|
        @commands << cmd_ltj(line.chomp)
        @commands << 'T*'
      end
      @commands << 'ET'
      @commands << 'Q'
    end

    # Render to stream.
    def render
      stream = @commands.join(LF).concat(LF)
      stream
    end

    private

    # Command "cm". Move cursor position.
    def cmd_cm(x_pt, y_pt)
      String.new('1.0 0.0 0.0 1.0 ').concat(
        x_pt.to_s, ' ', y_pt.to_s, ' cm'
      )
    end

    # Command "rg". Set fill color.
    def cmd_rg(color)
      check_is_a!(color, ::Dopp::Type::Color)
      color.render.concat(' rg')
    end

    # Command "RG". Set stroke color.
    def cmd_lrlg(color)
      check_is_a!(color, ::Dopp::Type::Color)
      color.render.concat(' RG')
    end

    # Command "Tf". Change font.
    def cmd_ltf(font_alias, font_size)
      font_alias.render.concat(
        ' ', font_size.to_s, ' Tf'
      )
    end

    # Command "Tj". Write text.
    def cmd_ltj(value)
      text(value).render.concat(' Tj')
    end

    # Internal state of canvas.
    class State
      include ::Dopp::Type
      include ::Dopp::Util

      attr_reader :x
      attr_reader :y
      attr_accessor :font_alias
      attr_accessor :font_size
      attr_reader :stroke_color
      attr_reader :fill_color

      def initialize(canvas)
        @canvas = canvas
        self.cursor_x = 10
        self.cursor_y = 10
        @font_alias = nil
        @font_size = 12.0
        self.fill_color = '#000000'
        self.stroke_color = '#000000'
      end

      def cursor_x=(value)
        @x = mm_to_pt(value)
      end

      def cursor_y=(value)
        @y = @canvas.media_height - mm_to_pt(value)
      end

      def fill_color=(value)
        @fill_color = color(value)
      end

      def stroke_color=(value)
        @stroke_color = color(value)
      end
    end
  end
end
