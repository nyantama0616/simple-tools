=begin

引数に論文のDOI渡すだけで論文情報取得できる
example:
	ruby main.rb 10.1002/dev.20059
	ruby main.rb 10.1002/dev.20059 --cite #引用時用のフォーマットで出力

=end

require_relative "./PaperFind"
require_relative "./ArgManager"
require_relative "../notions/save-paper/PaperSaver"

module PaperFind
	args = ArgManager.arranged_args(ARGV)

	paper_find = PaperFind.new(args[:origin][0])
	
	if (args[:cite])
		puts paper_find.paper_info.cited_format
	else
		puts paper_find.paper_info.to_s
	end

	if args[:save]
		paper_saver = SavePaper::PaperSaver.new
		paper_saver.save(paper_find.paper_info)
	end
end
