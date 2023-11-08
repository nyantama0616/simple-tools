=begin

引数に論文のDOI渡すだけで論文情報取得できる
example:
    ruby main.rb 10.1002/dev.20059

=end

require "net/http"
require "uri"
require "json"

doi = ARGV[0]
url = URI.parse("https://api.crossref.org/works/#{doi}")
res = Net::HTTP.get_response(url)

#論文が見つからなかったらexit
if res.code != "200"
    puts <<~EOS
        Correct DOI??
        response code: #{res.code}
        #{res.body}
    EOS
    exit
end

json = JSON.parse(res.body)

info = {}

message = json["message"]
info[:title] = message["title"][0]
info[:doi] = message["DOI"]
# info[:journal] = message["publisher"]
info[:journal] = message["short-container-title"][0]
info[:author] = message["author"].map {|author| [author["given"], author["family"]]}
info[:year] = message["published"]["date-parts"][0][0]
info[:url] = message["URL"]
info[:volume] = message["volume"]
info[:issue] = message["issue"]
info[:page] = message["page"]
info[:times_cited] = message["is-referenced-by-count"]

info.each do |key, value|
    puts "#{key}: #{value}"
end

# 引用時のためのフォーマットに変換
authors = info[:author].map {|author| "#{author[1]}, #{author[0][0]}."}.first(3)
authors_str = authors.count > 1 ? "#{authors.first(authors.count - 1).join(", ")} and #{authors[authors.count - 1]}" : authors[0]
ref_format = "#{authors_str}: #{info[:title]}, #{info[:journal]}, Vol.#{info[:volume]}, No.#{info[:issue]}, pp.#{info[:page]} (#{info[:year]})."
puts ref_format

# puts message
