# frozen_string_literal: true

require 'dopp/document'
require 'dopp/font/ja'
require 'dopp/font/en'

doc = Dopp::Document.new(
  title: 'TEST',
  page_size: :B5, landscape: true
)
doc.pdf_version = '1.7'
doc.page_layout = :TwoPageLeft
doc.page_mode = :UseThumbs
p1 = doc.add_page(
  page_size: :A4, landscape: false
)
# p1.use_font('courier')
# p1.write("HELLO\nWORLD")

#p1.move_to(10, 40)
#p1.fill_color = '#ff0000'
p1.use_font('MS明朝')
p1.text_area("ああ\nおはよう\n\nございます")

=begin
p2 = doc.add_page
#p2.rotate = 90
p2.stroke_color = '#0000ff'
p2.move_to(10, 70)
p2.use_font('明朝', bold: true, italic: true)
p2.write("いい\nこんにちは")
=end

File.open('test.pdf', 'wb') do |f|
  rendered = doc.render
  f.write rendered
end
