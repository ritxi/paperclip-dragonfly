require 'dragonfly'
require 'rails'
%w(active_model_extension data_storage model_extension rails version).each{|lib| require File.join %W(paperclip_dragonfly #{lib})}
module PaperclipDragonfly
  mattr_accessor :security_key
  @@security_key = 'wuaki'

  mattr_accessor :protect_from_dos_attacks
  @@protect_from_dos_attacks = true

  mattr_accessor :route_path
  @@route_path = 'media' # /media/añlksdjfalñsdjfalñsdfjlñasdkfj

  mattr_accessor :assets_path
  @@assets_path = :default # ::Rails.root.join('public','assets')

  mattr_accessor :datastorage_type
  @@datastorage_type = 'fs'

  mattr_accessor :custom_path_style
  @@custom_path_style = nil
end