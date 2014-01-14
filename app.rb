require "dropbox-api"
require "hashie"
require "redcarpet"
require "sinatra"
require "yaml"

config_file = "config.yml"
Config = Hashie::Mash.new(YAML.load_file(config_file))

Dropbox::API::Config.app_key    = Config.dropbox.app[:key]
Dropbox::API::Config.app_secret = Config.dropbox.app[:secret]
Dropbox::API::Config.mode       = "sandbox"

get "/:note" do
  content = client.download("#{params[:note]}.md")
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
  erb markdown.render(content)
end

helpers do
  def client
    @client ||= Dropbox::API::Client.new(token: Config.dropbox.user[:key], secret: Config.dropbox.user[:secret])
  end
end
