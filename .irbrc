require "irb/completion"
require "irb/ext/save-history"
require "benchmark"

begin
  require "awesome_print"
rescue LoadError => e
  puts %Q[
Caught a LoadError: could not load 'awesome_print'",

#{e}

Use bundler (recommended) or uninstall awesome_print.

# Use bundler (recommended)
$ bundle update
$ bundle exec calabash-ios console

# Uninstall awesome_print and reinstall calabash-cucumber
$ gem update --system
$ gem uninstall -Vax --force --no-abort-on-dependent awesome_print
$ gem install calabash-cucumber

]
  exit(1)
end

AwesomePrint.irb!

ARGV.concat ["--readline", "--prompt-mode", "simple"]

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = ".irb-history"

begin
  require "pry"
  Pry.config.history.should_save = true
  Pry.config.history.should_load = true
  Pry.config.history.file = ".pry-history"
  require "pry-nav"
rescue LoadError => _

end

def embed(x,y=nil,z=nil)
  puts "Screenshot at #{x}"
end

require "calabash-cucumber"

IRB.conf[:AUTO_INDENT] = true

IRB.conf[:PROMPT][:CALABASH_IOS] = {
  :PROMPT_I => "calabash-ios #{Calabash::Cucumber::VERSION}> ",
  :PROMPT_N => "calabash-ios #{Calabash::Cucumber::VERSION}> ",
  :PROMPT_S => nil,
  :PROMPT_C => "> ",
  :AUTO_INDENT => false,
  :RETURN => "%s\n"
}

IRB.conf[:PROMPT_MODE] = :CALABASH_IOS

require "calabash-cucumber/operations"
extend Calabash::Cucumber::Operations

require "calabash-cucumber/console_helpers"
include Calabash::Cucumber::ConsoleHelpers
Calabash::Cucumber::ConsoleHelpers.start_readline_history!

def preferences
  Calabash::Cucumber::Preferences.new
end

def disable_usage_tracking
  preferences.usage_tracking = "none"
  puts "Calabash will not collect usage information."
  "none"
end

def enable_usage_tracking(level="system_info")
  preferences.usage_tracking = level
  puts "Calabash will collect statistics using the '#{level}' rule."
  level
end

puts_console_details
puts_message_of_the_day


printf 'loading features/support/dylib.rb...'
load('features/support/dylib.rb')
puts 'done'

DYLIB = Acquaint::Dylib.dylib
RunLoop::log_info2("Using dylib => '#{DYLIB}'")

APP = "Acquaint.Native/Acquaint.Native.iOS/bin/iPhoneSimulator/Debug/AcquaintNativeiOS.app"
RunLoop.log_info2("Using app => '#{APP}'")

def start_app(options={})
  default_options = {
		:inject_dylib => DYLIB,
    :app => APP
  }
  merged_options = default_options.merge(options)
  start_test_server_in_background merged_options
end

