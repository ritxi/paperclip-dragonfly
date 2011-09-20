require 'dragonfly'
require 'rails'
%w(active_model_extension data_storage model_extension rails version).each{|lib| require File.join %W(paperclip_dragonfly #{lib})}
%w(fs s3).each{|lib| require File.join %W(paperclip_dragonfly data_storage #{lib})}
module PaperclipDragonfly
  mattr_accessor :security_key
  @@security_key = 'wuaki'

  mattr_accessor :protect_from_dos_attacks
  @@protect_from_dos_attacks = true

  mattr_accessor :route_path
  @@route_path = 'media' # /media/añlksdjfalñsdjfalñsdfjlñasdkfj

  mattr_accessor :assets_path
  @@assets_path = :default # ::Rails.root.join('public','assets')

  mattr_accessor :storage_type
  @@storage_type = 'fs'
end