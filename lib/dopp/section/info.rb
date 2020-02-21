# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "information dictionary".
    class Info < Base
      # Application name.
      CREATOR ||= [APP_NAME, VERSION].join('-').freeze

      # Initialize.
      # @param [::Dopp::Document::Structure]
      #   structure PDF document structure.
      def initialize(structure, attrs = {})
        super(structure)
        # Initialize attributes.
        attributes[:Creator] = text(CREATOR)
        attributes[:Producer] = text(CREATOR)
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
