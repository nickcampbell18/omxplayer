module Omx
  class Player
    include KeyboardShortcuts

    PIPE = '/tmp/omxpipe'

    def initialize
      mkfifo
    end

    def open(opts={})
      opts = default_options.merge(opts)
      system unix_command_with(opts)
      start
    end

    private

      def unix_command_with(opts)
        ['omxplayer'].tap do |args|
          # Audio device =~ /hdmi|local/
          args << "--adev #{opts[:audio_out]}"
          # Start position in seconds
          args << "--pos #{opts[:start_pos]}"
          args << "\"#{opts[:filename]}\""
          args << "< #{PIPE} &"
        end.join ' '
      end

      def mkfifo
        system "mkfifo #{PIPE}" unless File.exists?(PIPE)
      end

      def send_to_pipe(command)
        system "echo -n #{command} > #{PIPE} &"
      end

      def default_options
        {
          audio_out: 'hdmi',
          start_pos: 0,
        }
      end

  end
end