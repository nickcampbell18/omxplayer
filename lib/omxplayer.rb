require 'singleton'
require 'omxplayer/keyboard_shortcuts'

class Omxplayer
  include Singleton
  include KeyboardShortcuts

  PIPE = '/tmp/omxpipe'
  VERSION = '0.0.7'

  def initialize
    mkfifo
  end

  def open(filename)
    @filename = filename
    `killall omxplayer`
    `omxplayer -o hdmi #{filename} < #{PIPE} &`
  end

  def status
    "Playing #{@filename}"
  end

  private

  def mkfifo
    system "mkfifo #{PIPE}" unless File.exists?(PIPE)
  end

  def send_to_pipe(command)
    `echo -n #{command} > #{PIPE}`
  end

end