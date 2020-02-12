# frozen_string_literal: true

require 'dopp/error'
require 'dopp/type'
require 'dopp/util'

module Dopp
  class Canvas
    include ::Dopp::Error
    include ::Dopp::Type
    include ::Dopp::Util

    def initialize(content)
      check_is_a!(content, ::Dopp::Section::Content)
      @content = content

      @media_width = content.page.media_width
      @media_height = content.page.media_height

      @pos_x = mm_to_pt(10)
      @pos_y = @media_height - mm_to_pt(10)

      @commands = []
      @shape_queue = ['q']
      @text_queue = ['BT']
      @stroke_color = css_color_to_color('#000000')
      @fill_color = css_color_to_color('#000000')
      @font = nil
      @font_size = 12
    end

    def move_to(x, y)
      @pos_x = mm_to_pt(x)
      @pos_y = @media_height - mm_to_pt(y)
    end

    def stroke_color=(value)
      @stroke_color = css_color_to_color(value)
    end

    def fill_color=(value)
      @fill_color = css_color_to_color(value)
    end

    def use_font(font_name, opts = {})
      @font = @content.use_font(font_name, opts)
      @font_size = opts[:size] if opts[:size]
    end

    def write(value)
      check_is_a!(@font, ::Dopp::Section::Base)
      @commands << 'q'
      @commands << cmd_lrlg(@stroke_color)
      @commands << cmd_rg(@fill_color)
      @commands << 'BT'
      @commands << "1 0 0 1 #{@pos_x} #{@pos_y} Tm"
      @commands << "#{@font_size} TL"
      @commands << cmd_ltf(@font, @font_size)
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
      String.new(color).concat(' rg')
    end

    # Command "RG". Set stroke color.
    def cmd_lrlg(color)
      String.new(color).concat(' RG')
    end

    # Command "Tf". Change font.
    def cmd_ltf(font, size)
      kw(font.alias).render.concat(
        ' ', size.to_s, ' Tf'
      )
    end

    # Command "Tj". Write text.
    def cmd_ltj(value)
      text(value).render.concat(' Tj')
    end
  end
end
