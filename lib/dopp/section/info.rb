# frozen_string_literal: true

require 'dopp/util'
require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "information dictionary".
    class Info < Base
      # Application name.
      APPLICATION_NAME ||= ::Dopp::Util.deep_freeze(
        ::Dopp::APPLICATION.dup.concat('-', ::Dopp::VERSION)
      )

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc, attrs = {})
        super(doc)
        # Initialize attributes.
        now_time = time(Time.now)
        attributes[kw(:Creator)] = text(APPLICATION_NAME)
        attributes[kw(:Producer)] = text(APPLICATION_NAME)
        attributes[kw(:CreationDate)] = now_time
        attributes[kw(:ModDate)] = now_time
        self.title = attrs[:title] if attrs[:title]
      end

      # Set title.
      # @param [String] title Title.
      def title=(title)
        check_is_a?(title, String)
        attributes[kw(:Title)] = text(title)
      end
    end
  end
end
