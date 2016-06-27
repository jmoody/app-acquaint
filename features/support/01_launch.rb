require "calabash-cucumber/launcher"

module Calabash::Launcher
  @@launcher = nil

  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new
  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end
end

Before do |scenario|
  launcher = Calabash::Launcher.launcher
  options = {
    :inject_dylib => Acquaint::Dylib.dylib
  }

  launcher.relaunch(options)
end

After do |scenario|

end

