# -*- coding: utf-8 -*-

# ディスプレイ情報クラス

module Rack::Ketai
  class Display

    attr_reader :colors, :width, :height

    def initialize(data = { }) # :nodoc:
      @colors = data[:colors].to_i == 0 ? nil : data[:colors].to_i
      @width = data[:width].to_i == 0 ? nil : data[:width].to_i
      @height = data[:height].to_i == 0 ? nil : data[:height].to_i
    end
  end
end
