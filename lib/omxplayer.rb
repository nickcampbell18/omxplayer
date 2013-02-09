require 'singleton'
require 'omxplayer/keyboard_shortcuts'

class Omxplayer
  include Singleton
  include KeyboardShortcuts

  attr_reader :filename

  PIPE = '/tmp/omxpipe'
  VERSION = '0.3.2'

  def initialize
    mkfifo
  end

  def open(filename)
    @filename = filename
    #`killall omxplayer &`
    system "omxplayer -o hdmi #{filename} < #{PIPE} &"
    action(:start)
  end

  def status
    time, file = get_status_from_ps
    "#{time} #{file}"
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

  def get_status_from_ps
    # The [/] excludes self matches http://serverfault.com/q/367921
    status = `ps ax -o etime,args | grep [/]usr/bin/omxplayer.bin`
    # matches time, filename
    match = /([\d:.]+).*hdmi (.*)/.match(status)
    match ? match.captures : [nil, nil]
  end

end
