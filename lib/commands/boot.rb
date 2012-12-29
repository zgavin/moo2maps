# Set up gems listed in the Gemfile.
ROOT_DIR = File.expand_path('../../../', __FILE__)
$LOAD_PATH.unshift File.join ROOT_DIR,'lib'

begin
  ENV['BUNDLE_GEMFILE'] = File.join ROOT_DIR, 'Gemfile'
  require 'bundler'
  Bundler.require
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end

require 'yaml'
require 'active_support/core_ext'

Encoding.default_external = Encoding::BINARY
Encoding.default_internal = Encoding::BINARY

YAML::ENGINE.yamler = 'syck'

class Module  
  alias_method :const_missing_old, :const_missing    
  def const_missing name 
    @looked_for ||= {}

    raise "Class not found: #{name}" if @looked_for[name]
    
    @looked_for[name] = true

    namespace = self.name.split('::').map(&:underscore).push name.to_s.underscore
    
    files = Dir[File.join ROOT_DIR,'lib','**','*.rb']
    
    filename = nil
    
    filename = files.find do |file| file.ends_with? "#{File.join *namespace}.rb" end or namespace.shift until namespace.empty? or filename
      
    (filename ||= name.to_s).chomp '.rb'
    
    require filename
    
    const_get(name) or raise "Class not found: #{name}" 
  end  
end 
