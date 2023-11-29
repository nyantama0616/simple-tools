require "net/http"
require "uri"
require "json"
require_relative "./Paper"

module PaperFind
	class PaperFind
		attr_reader :doi, :paper_info
		def initialize(doi)
			fetch doi
		end

		private

		def fetch(doi)
			url = URI.parse("https://api.crossref.org/works/#{doi}")
			res = Net::HTTP.get_response(url)

			#論文が見つからなかったら例外を投げる
			if res.code != "200"
				raise "Paper not found, please check your DOI."
			end

			json = JSON.parse(res.body)

			result = {}

			message = json["message"]
			result[:title] = message["title"][0]
			result[:doi] = message["DOI"]
			result[:journal] = message["short-container-title"][0]
			result[:authors] = message["author"].map {|author| [author["given"], author["family"]]}
			result[:year] = message["published"]["date-parts"][0][0]
			result[:url] = message["URL"]
			result[:volume] = message["volume"]
			result[:issue] = message["issue"]
			result[:pages] = message["page"]
			result[:times_cited] = message["is-referenced-by-count"]

			@paper_info = Paper.new(**result)
		end
	end
end
