require 'singleton'
require 'omxplayer/keyboard_shortcuts'

class Omxplayer
  include Singleton
  include KeyboardShortcuts

  attr_reader :filename

  PIPE = '/tmp/omxpipe'
  VERSION = '0.2'

  def initialize
    mkfifo
  end

  def open(filename)
    @filename = filename
    #`killall omxplayer &`
    system "omxplayer -o hdmi #{filename} < #{PIPE} &"
  end

  def status
    "Playing #{filename}"
  end

  def action(key)
    send_to_pipe KEYS.fetch(key.to_sym)
  end

  private

  def mkfifo
    system "mkfifo #{PIPE}" unless File.exists?(PIPE)
  end

  def send_to_pipe(command)
    system "echo -n #{command} > #{PIPE} &"
  end

end