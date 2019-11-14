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
  system "git pull"
end

desc "Create github.yml"
file "github.yml" do
  require 'yaml'

  endpoint, username, password = input
  res = create_authorization(
    endpoint: endpoint,
    username: username,
    password: password
  )

  YAML.dump(
    [{"API_ENDPOINT" => endpoint,
      "ACCESS_TOKEN" => res[:token],
      "USER" => username}],
    File.open("github.yml", "wb")
  )
end

desc "Add an endpoint"
task :add do
  require 'yaml'

  endpoint, username, password = input
  res = create_authorization(
    endpoint: endpoint,
    username: username,
    password: password
  )

  endpoints = YAML.load_file('github.yml')
  endpoints << {"API_ENDPOINT" => endpoint,
                "ACCESS_TOKEN" => res[:token],
                "USER" => username}

  YAML.dump(endpoints, File.open("github.yml", "wb"))
end

def input
  require 'highline'

  cli = HighLine.new
  endpoint = cli.ask("Input API endpoint: ") { |q| q.default = "https://api.github.com" }
  username = cli.ask("Input Username: ")
  password = cli.ask("Input Password: ") { |q| q.echo = false }
  #client_id = cli.ask("Input Client ID: ")
  #client_secret = cli.ask("Input Client Secret: ")

  return endpoint, username, password
end

def create_authorization(endpoint:, username:, password:)
  require 'octokit'

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

  return res
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
