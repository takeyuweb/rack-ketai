# -*- coding: utf-8 -*-
require 'tempfile'
require 'singleton'
require 'nkf'
require 'rack/request'
require 'stringio'
require 'ipaddr'
require 'rack/ketai/filter'

unless IPAddr.instance_methods.include?("to_range")
  class IPAddr

    def coerce_other(other)
      case other
      when IPAddr
        other
      when String
        self.class.new(other)
      else
        self.class.new(other, @family)
      end
    end

    # Returns the successor to the ipaddr.
    def succ
      return self.clone.set(@addr + 1, @family)
    end
    
    # Compares the ipaddr with another.
    def <=>(other)
      other = coerce_other(other)
      
      return nil if other.family != @family
      
      return @addr <=> other.to_i
    end
    include Comparable
    
    def to_range
      begin_addr = (@addr & @mask_addr)
      
      case @family
      when Socket::AF_INET
        end_addr = (@addr | (IN4MASK ^ @mask_addr))
      when Socket::AF_INET6
        end_addr = (@addr | (IN6MASK ^ @mask_addr))
      else
        raise "unsupported address family"
      end
      return clone.set(begin_addr, @family)..clone.set(end_addr, @family)
    end
    
  end
end

module Rack::Ketai::Carrier
  class Abstract

    class << self
      def filters
        []
      end

      def valid_addr?(remote_addr)
        cidrs = nil
        begin
          cidrs = self::CIDRS
        rescue NameError
          return nil
        end
        remote = IPAddr.new(remote_addr)
        cidrs.any?{ |cidr| cidr.include?(remote) }
      end
      alias :valid_ip? :valid_addr?
    end

    def initialize(env)
      @env = env
    end
  
    def request
      @request ||= Rack::Request.new(@env)
    end
  
    USER_AGENT_REGEXP = nil

    def filtering(env, options = { }, &block)
      env = options[:disable_filter] ? env : filters(options).inject(env) { |env, filter| filter.inbound(env) }
      ret = block.call(env)
      ret = options[:disable_filter] ? ret : filters(options).reverse.inject(ret) { |r, filter| filter.outbound(*r) }
      ret
    end

    def filters(options = { })
      self.class.filters.collect do |klass|
        klass.new(options)
      end
    end
    
    # 携帯端末か
    def mobile?
      false
    end

    # スマートフォンか
    def smartphone?
      false
    end

    # サブスクライバID
    # 契約者毎にユニーク
    def subscriberid
      nil
    end

    # デバイスID
    # 端末毎にユニーク
    def deviceid
      nil
    end
    
    # 識別情報
    def ident
      subscriberid || deviceid
    end

    # 機種名（略名）
    def name
      nil
    end

    # 位置情報
    def position
      nil
    end

    # ディスプレイ情報
    def display
      Rack::Ketai::Display.new
    end

    # キャリアのIPアドレス帯を利用しているか
    def valid_addr?
      self.class.valid_ip? @env['HTTP_X_FORWARDED_FOR'] || @env['REMOTE_ADDR']
    end
    alias :valid_ip? :valid_addr?

    # キャッシュサイズ
    def cache_size
      nil
    end

    # Cookieのサポート
    def supports_cookie?
      false
    end
  end
end
