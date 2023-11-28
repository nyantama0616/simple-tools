#コマンドライン引数を管理するモジュール

module PaperFind
  module ArgManager
    def self.arranged_args(argv)
      args = {
        origin: argv.clone,
        cite: false
      }
      
      while true
        flag = false
          
        args[:origin].each.with_index do |arg, i|
          if args[:origin][i][0, 2] == "--"
            flag = true
            handle_arg_option(args, i)
            break
          end
        end
          
        break if !flag
      end

      args
    end

    private

    def self.handle_arg_option(args, i)
        case args[:origin][i]
        when "--cite"
            args[:origin].delete_at(i)
            args[:cite] = true
        else
            raise "Invalid option: #{args[:origin][i]}"
        end
    end
  end
end
