desc "Build terminal-notifier"
task :build do
  system [
    "xcodebuild",
    "-project 'terminal-notifier/Terminal Notifier.xcodeproj'",
    "-configuration 'Release'",
    "PRODUCT_NAME='github-notifier'" ].join(" ")
end

desc "Load plist"
task :load do
  require_relative 'conf'
  File.open('henry0312.github.notifier.plist', 'wb') do |f|
    f << plist
  end
  system "ln -svf #{current_path}/henry0312.github.notifier.plist ~/Library/LaunchAgents"
  system "launchctl load ~/Library/LaunchAgents/henry0312.github.notifier.plist"
end

desc "Unload plist"
task :unload do
  system "launchctl unload ~/Library/LaunchAgents/henry0312.github.notifier.plist"
  system "rm -v ~/Library/LaunchAgents/henry0312.github.notifier.plist"
end

desc "Update repository"
task :update do
  system [
    "git pull",
    "git submodule update" ].join(" && ")
end

desc "Create conf.rb"
file "conf.rb" do
  require 'io/console'
  require 'octokit'

  print "Input username: "
  username = STDIN.gets.chomp
  print "Input password: "
  password = STDIN.noecho(&:gets).chomp
  print "\n"

  client = Octokit::Client.new(:login => username, :password => password)
  res = client.create_authorization(:scopes => ["notifications"], :note => "github-notifier")

  File.open("conf.rb", "wb") do |file|
    file.write <<-EOS.undent
      ACCESS_TOKEN = "#{res[:token]}"
      TIME = 5  # minutes
    EOS
  end
end

def current_path
  `pwd`.chomp
end

def ruby_path
  `which ruby`.chomp
end

def plist; <<-EOS.undent
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
      <key>Label</key>
      <string>henry0312.github.notifier</string>
      <key>ProgramArguments</key>
      <array>
          <string>#{ruby_path}</string>
          <string>#{current_path}/github-notifier.rb</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{current_path}</string>
      <key>StartInterval</key>
      <integer>#{TIME*60}</integer>
      <key>StandardOutPath</key>
      <string>#{current_path}/log/stdout.log</string>
      <key>StandardErrorPath</key>
      <string>#{current_path}/log/stderr.log</string>
  </dict>
  </plist>
  EOS
end

# http://qiita.com/Linda_pp/items/53d87e91ae0aa501a9b4
class String
  def undent
    min_space_num = self.split("\n").delete_if{|s| s=~ /^\s*$/ }.map{|s| s[/^\s*/].length }.min
    self.gsub(/^[ \t]{,#{min_space_num}}/, '')
  end
end
