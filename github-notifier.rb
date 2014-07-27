require 'octokit'
require 'shellwords'
require_relative 'conf'

def notify(message:, title: "", subtitle: "", group: nil, open: "")
  cmd = [
    "./github-notifier.app/Contents/MacOS/github-notifier",
    "-appIcon GitHub-Mark-32px.png",
    "-message #{message.sub(/^([\[<])/){"\\" + $1}.shellescape}"
  ]
  cmd << "-title #{title.shellescape}" unless title.empty?
  cmd << "-subtitle #{subtitle.shellescape}" unless subtitle.empty?
  cmd << "-group #{group}" unless group.nil?
  cmd << "-open #{open}" unless open.empty?
  system cmd.join(" ")
end

time = Time.at(Time.new - TIME*60)

begin
  client = Octokit::Client.new(:access_token => ACCESS_TOKEN)
  client.notifications({all: true, since: time.utc.iso8601}).each do |res|
    html_url = res[:subject].rels[:latest_comment].get.data[:html_url]
    case res[:subject][:type]
    when "Issue", "PullRequest"
      group = res[:subject].rels[:self].get.data[:id]
    when "Commit"
      group = res[:subject].rels[:self].get.data[:sha]
    end

    notify(message: res[:subject][:title],
           title: res[:repository][:full_name],
           subtitle: res[:subject][:type],
           group: group,
           open: html_url)
  end
rescue => e
  #notify(message: e.message, title: "Error")
  STDERR.puts Time.now
  STDERR.puts e.message
  STDERR.puts e.backtrace
  exit(false)
end
