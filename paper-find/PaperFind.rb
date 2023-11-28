require "net/http"
require "uri"
require "json"

module PaperFind
	class PaperFind
		attr_reader :doi, :result
		def initialize(doi)
			@doi = doi
			fetch
		end

		def authors
			@result && @result[:author].map {|author| "#{author[0]} #{author[1]}"}
		end

		def authors_abbr
			@result && @result[:author].map {|author| "#{author[1]}, #{author[0][0]}."}
		end

		def cited_format
			authors = authors_abbr.first(3)
			authors_str = authors.count > 1 ? "#{authors.first(authors.count - 1).join(", ")} and #{authors[authors.count - 1]}" : authors[0]
			ref_format = "#{authors_str}: #{@result[:title]}, #{@result[:journal]}, Vol.#{@result[:volume]}, No.#{@result[:issue]}, pp.#{@result[:page]} (#{@result[:year]})."
			ref_format
		end

		def puts_result
			@result.each do |key, value|
				puts "#{key}: #{value}"
			end
		end

		private

		def fetch
			url = URI.parse("https://api.crossref.org/works/#{@doi}")
			res = Net::HTTP.get_response(url)

			#論文が見つからなかったら例外を投げる
			if res.code != "200"
				raise "Paper not found, please check your DOI."
			end

			json = JSON.parse(res.body)

			@result = {}

			message = json["message"]
			@result[:title] = message["title"][0]
			@result[:doi] = message["DOI"]
			@result[:journal] = message["short-container-title"][0]
			@result[:author] = message["author"].map {|author| [author["given"], author["family"]]}
			@result[:year] = message["published"]["date-parts"][0][0]
			@result[:url] = message["URL"]
			@result[:volume] = message["volume"]
			@result[:issue] = message["issue"]
			@result[:page] = message["page"]
			@result[:times_cited] = message["is-referenced-by-count"]
		end
	end
end
