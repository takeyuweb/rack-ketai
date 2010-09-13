# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), '../../../vendor/datum_conv/lib/datum_conv'))

module Rack::Ketai
  class Position

    class << self
      # Position.dms2d([35, 00, 35.6])
      # Position.dms2d("+35.00.35.600")
      def dms2d(dms)
        if dms.is_a?(String)
          if dms =~ /^(\+|\-)?(\d+)\.(\d+)\.(\d+\.\d+)$/
            dms = ["#{$1}#{$2}".to_i, $3.to_i, $4.to_f]
          else
            raise ArgumentError, "Invalid dms format."
          end
        end
        
        di, dm, ds = dms
        
        return di.to_i + dm.to_f/60 + ds.to_f/3600
      end

      # 度表記を度分秒に変換
      def d2dms(d)
        di = d.to_i
        dd = (d.to_f - di)
        dm = (dd * 60)
        ds = (dd * 60 - dm.to_i) * 60
        dsd = (dd * 60 * 60 - dm.to_i * 60 - ds.to_i) * 60
        
        [di, dm.to_i, "#{ds.to_i}.#{dsd.to_i}".to_f]
      end
    end

    # Position.new(:lat => 135.69322222222, :lng => 35.009888888889)
    # Position.new(:lat => [35, 0,35.6], :lng => [135, 41, 35.6])
    # Position.new(:lat => "35.00.35.600", :lng => "135.41.35.600")
    def initialize(options = { })
      @lat = options[:lat].kind_of?(Numeric) ? options[:lat] : self.class.dms2d(options[:lat])
      @lng = options[:lng].kind_of?(Numeric) ? options[:lng] : self.class.dms2d(options[:lng])
    end

    def lat(datum = :wgs84)
      latlng(datum)[0]
    end

    def lng(datum = :wgs84)
      latlng(datum)[1]
    end

    def latlng(datum = :wgs84)
      case datum.to_sym
      when :tokyo97
        DatumConv.jgd2tky(@lat,@lng)
      when :wgs84
        [@lat, @lng]
      else
        [nil, nil]
      end
    end
    
  end
end
