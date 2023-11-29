require_relative "../../util/Logger"

module SavePaper
  class PaperSaver
    include Util::Logger

    @@INBOX_TAG_ID = "af5ea646371348d9b1471ad889a5bd7e"
    @@TEMPLATE_ID = "da0dd24479044ed59c8f6ba45da528e0"

    def initialize
      @client = Notion::Client.new
      @database = @client.database(database_id: Config::DATABASE_ID) # 今のところ多分いらない
    end

    def save(paper)
      if exist?(paper.doi)
        log_failure "The paper already exists. DOI: #{paper.doi}"
        return
      end

      properties = properties(paper)

      @client.create_page(
        parent: {
          database_id: @database.id
        },
        properties: properties,
        children: template
      )

      log_success "Successfully saved the paper. Title: #{paper.title}"
    end

    private

    def properties(paper)
      properties = {
        Title: {
            title: [
              {
                text: {
                  content: paper.title
                }
              }
            ]
          },
        DOI: {
            rich_text: [
              {
                text: {
                  content: paper.doi
                }
              }
            ]
          },
        Journal: {
            rich_text: [
              {
                text: {
                  content: paper.journal
                }
              }
            ]
          },
        Authors: {
            rich_text: [
              {
                text: {
                  content: paper.authors_strs.join(", ")
                }
              }
            ]
          },
        Year: {
            number: paper.year
          },
        URL: {
            url: paper.url
          },
        "Times cited" => {
            number: paper.times_cited
          },
        Worth: {
          number: 2
        },
        Tag: {
          relation: [
            {
              id: @@INBOX_TAG_ID
            }
          ]
        }
      }
    end
    
    def template
      block_children = @client.block_children(block_id: @@TEMPLATE_ID)
      block_children.results
    end

    # 同一のDOIの論文が既に保存されているかどうかを返す
    def exist?(doi)
      sorts = [
        {
          property: "DOI",
          direction: "ascending"
        }
      ]

      filter = {
        'or': [
          {
            'property': 'DOI',
            'rich_text': {
              'equals': doi
            }
          },
        ]
      }

      query = @client.database_query(
        database_id: @database.id,
        sorts: sorts,
        filter: filter
      )

      query.results.count > 0
    end
  end
end
