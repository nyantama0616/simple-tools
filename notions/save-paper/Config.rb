require "notion-ruby-client"
require "dotenv"
Dotenv.load File.expand_path(".env", __dir__)

module SavePaper
  module Config
      DATABASE_ID = ENV["DATABASE_ID"]
      Notion.configure do |config|
          config.token = ENV["API_TOKEN"]
      end
  end
end
