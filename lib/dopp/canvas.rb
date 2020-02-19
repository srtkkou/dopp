# frozen_string_literal: true

require 'dopp/error'
require 'dopp/type'
require 'dopp/util'
require 'dopp/shape/color'

module Dopp
  # Canvas of the page.
  class Canvas
    include ::Dopp::Error
    include ::Dopp::Type
    include ::Dopp::Util

    # Internal state of the canvas.
    Memento ||= Struct.new(
      :x, :y, :font_alias, :font_size,
      :stroke_color, :fill_color,
      keyword_init: true
    )

    attr_accessor :memento

    def initialize(content)
      check_is_a!(content, ::Dopp::Section::Content)
      @content = content
      @commands = []
      @media_width = content.page.media_width
      @media_height = content.page.media_height
      # Initialize memento.
      @memento = Memento.new(
        x: mm_to_pt(10),
        y: @media_height - mm_to_pt(10),
        font_alias: nil,
        font_size: 12.0,
        stroke_color: ::Dopp::Shape::Color.new('#000000'),
        fill_color: ::Dopp::Shape::Color.new('#000000')
      )
    end

    def move_to(x, y)
      @memento.x = mm_to_pt(x)
      @memento.y = @media_height - mm_to_pt(y)
    end

    def stroke_color=(value)
      @memento.stroke_color = ::Dopp::Shape::Color.new(value)
    end

    def fill_color=(value)
      @memento.fill_color = ::Dopp::Shape::Color.new(value)
    end

    def use_font(font_name, opts = {})
      font = @content.use_font(font_name, opts)
      @memento.font_alias = kw(font.alias)
      @memento.font_size = opts[:size] if opts[:size]
    end

    def grid(values, opts = {})
    end

    def text_box(value, opts = {})
    end

    def write(value)
      check_is_a!(@memento.font_alias, ::Dopp::Type::KeyWord)
      @commands << 'q'
      @commands << cmd_lrlg(@memento.stroke_color)
      @commands << cmd_rg(@memento.fill_color)
      @commands << 'BT'
      @commands << "1 0 0 1 #{@memento.x} #{@memento.y} Tm"
      @commands << "#{@memento.font_size} TL"
      @commands << cmd_ltf(@memento.font_alias, @memento.font_size)
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
      check_is_a!(color, ::Dopp::Shape::Color)
      color.render.concat(' rg')
    end

    # Command "RG". Set stroke color.
    def cmd_lrlg(color)
      check_is_a!(color, ::Dopp::Shape::Color)
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
  end
end
