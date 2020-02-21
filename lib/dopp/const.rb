# frozen_string_literal: true

# Dopp.
module Dopp
  # Application version.
  VERSION ||= '0.1.0'

  # Application name.
  APP_NAME ||= name.downcase.freeze

  # Line feed code.
  LF ||= "\n"

  # Default PDF version.
  DEFAULT_PDF_VERSION ||= '1.4'

  # Available page sizes.
  # (Width * height in millimeters.)
  PAGE_SIZES ||= {
    A1: [594.0, 841.0], A2: [420.0, 584.0],
    A3: [297.0, 420.0], A4: [210.0, 297.0],
    A5: [148.0, 210.0], A6: [105.0, 148.0],
    B1: [728.0, 1030.0], B2: [515.0, 728.0],
    B3: [364.0, 515.0], B4: [257.0, 364.0],
    B5: [182.0, 257.0], B6: [128.0, 182.0],
    Letter: [215.9, 279.4]
  }.freeze.each_value { |v| v.freeze }
end
