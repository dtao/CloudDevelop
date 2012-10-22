require "pty"

class STDOUTReader
  def self.from_command(cmd)
    output = []

    begin
      PTY.spawn(cmd) do |stdin, stdout, pid|
        begin
          stdin.each { |line| output << line }
        rescue Errno::EIO
          # This probably just means that the process has finished giving output.
        end
      end
    rescue PTY::ChildExited
    end

    output.join("\n")
  end
end
