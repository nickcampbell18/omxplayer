require 'singleton'
require 'omxplayer/keyboard_shortcuts'

class Omxplayer
  include Singleton
  include KeyboardShortcuts

  PIPE = '/tmp/omxpipe'
  VERSION = '0.0.3'

  def initialize
    mkfifo
  end

  def open(filename)
    @filename = filename
    `omxplayer -o hdmi #{filename} < #{PIPE} &`
    #@player = `omxplayer -o hdmi #{filename} < #{PIPE} &`
  end

  def status
    "Playing #{@filename}"
  end

  private

  def mkfifo
    File.delete(PIPE) if File.exists?(PIPE)
    `mkfifo #{PIPE}`
  end

  def send_to_pipe(command)
    `echo -n #{command} > #{PIPE}`
  end

end