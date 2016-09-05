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
  require 'highline'
  require 'octokit'

  cli = HighLine.new
  endpoint = cli.ask("Input API endpoint: ") { |q| q.default = "https://api.github.com" }
  username = cli.ask("Input Username: ")
  password = cli.ask("Input Password: ") { |q| q.echo = false }
  interval = cli.ask("Input Time Interval (minutes): ", Integer) { |q| q.default = "5" }
  #client_id = cli.ask("Input Client ID: ")
  #client_secret = cli.ask("Input Client Secret: ")

  Octokit.configure do |c|
    c.api_endpoint = endpoint
  end
  client = Octokit::Client.new(:login => username, :password => password)
  res = client.create_authorization({
    #:idempotent => true,
    #:client_id => client_id,
    #:client_secret => client_secret,
    :scopes => ["notifications"],
    :note => "github-notifier",
    :note_url => "https://github.com/henry0312/github-notifier",
  })

  File.open("conf.rb", "wb") do |file|
    file.write <<-EOS.undent
      API_ENDPOINT = "#{endpoint}"
      ACCESS_TOKEN = "#{res[:token]}"
      INTERVAL = #{interval}  # minutes
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
      <integer>#{INTERVAL*60}</integer>
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
