require "dropbox-api"
require "redcarpet"
require "sinatra"

if ENV["KEEPALIVE_URL"] != ""
  Thread.new do
    require "parse"
    require "uri"

    while true
      Net::HTTP.get(URI.parse(ENV["KEEPALIVE_URL"]))
      sleep 30
    end
  end
end

Dropbox::API::Config.app_key    = ENV["DROPBOX_APP_KEY"]
Dropbox::API::Config.app_secret = ENV["DROPBOX_APP_SECRET"]
Dropbox::API::Config.mode       = "sandbox"

get "/:note" do
  content = client.download("#{params[:note]}.md")
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
  erb markdown.render(content)
end

helpers do
  def client
    @client ||= Dropbox::API::Client.new(token: ENV["DROPBOX_USER_KEY"], secret: ENV["DROPBOX_USER_SECRET"])
  end
end
