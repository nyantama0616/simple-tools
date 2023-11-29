module PaperFind
  class Paper
    attr_reader :title, :year, :doi, :authors, :journal, :times_cited, :volume, :issue, :pages, :times_cited, :url
    
    def initialize(title:, year:, doi:, authors:, journal:, times_cited:, volume:, issue:, pages:, url:)
      @title = title
      @year = year
      @doi = doi
      @authors = authors
      @journal = journal
      @times_cited = times_cited
      @volume = volume
      @issue = issue
      @times_cited = times_cited
      @pages = pages
      @url = url
    end
    
    def cited_format
			authors = authors_strs_abbr.first(3)
			authors_str = authors.count > 1 ? "#{authors.first(authors.count - 1).join(", ")} and #{authors[authors.count - 1]}" : authors[0]
			"#{authors_str}: #{@title}, #{@journal}, Vol.#{@volume}, No.#{@issue}, pp.#{@pages} (#{@year})."
		end

    def to_s
      <<~EOS
        Title: #{@title}
        Year: #{@year}
        DOI: #{@doi}
        Authors: #{authors_strs.join(", ")}
        Journal: #{@journal}
        Times cited: #{@times_cited}
        Volume: #{@volume}
        Issue: #{@issue}
        Pages: #{@pages}
        URL: #{@url}
      EOS
    end

    def authors_strs
			@authors.map {|author| "#{author[0]} #{author[1]}"}
		end

		def authors_strs_abbr
			@authors.map {|author| "#{author[1]}, #{author[0][0]}."}
		end
  end
end
