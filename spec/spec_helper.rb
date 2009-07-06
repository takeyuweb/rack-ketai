require 'pp'
[ STDOUT, STDERR ].each {  |io| io.sync = true }

require 'rack/mock'

$LOAD_PATH.unshift File.dirname(File.dirname(__FILE__)) + '/lib'
require 'rack/ketai'
