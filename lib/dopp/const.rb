# frozen_string_literal: true

# File to define module constants.
# 定数定義用ファイル.
module Dopp
  # Version of the application.
  # アプリケーションのバージョン.
  VERSION ||= '0.1.0'.freeze

  # Application name.
  # アプリケーション名.
  APPLICATION ||= self.name.downcase.freeze

  # Line feed code.
  # 改行コード.
  LF ||= "\n".freeze
end

