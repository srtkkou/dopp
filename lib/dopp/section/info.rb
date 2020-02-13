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
        attributes[:Creator] = text(APPLICATION_NAME)
        attributes[:Producer] = text(APPLICATION_NAME)
        attributes[:CreationDate] = time(Time.now)
        self.title = attrs[:title] if attrs[:title]
      end

      # Set title.
      # @param [String] value Title.
      def title=(value)
        check_is_a!(value, String)
        attributes[:Title] = text(value)
      end

      # Set modification time.
      # @param [Time] value Modification time.
      def mod_date=(value)
        check_is_a!(value, Time)
        attributes[:ModDate] = time(value)
      end
    end
  end
end
