module Util
  module Logger
    def log_success(message)
      puts "=== #{message} ==="
    end

    def log_warn(message)
      puts ">>> #{message} <<<"
    end

    def log_failure(message)
      puts "!!! #{message} !!! from #{caller[0]}"
    end
  end
end
