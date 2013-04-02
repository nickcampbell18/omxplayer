require 'singleton'
require 'omxplayer/keyboard_shortcuts'

class Omxplayer
  include Singleton
  include KeyboardShortcuts

  attr_reader :filename

  PIPE = '/tmp/omxpipe'
  VERSION = '0.5.0'

  def initialize
    mkfifo
  end

  def open(filename, opts={})
    @filename = filename
    audio_out = opts[:audio_output] || 'hdmi'
    system "omxplayer -o #{audio_out} \"#{filename}\" < #{PIPE} &"
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
    # matches time, audio_out(hdmi/local), filename
    match = /([\d:.]+) \/usr\/bin\/omxplayer.bin -o (\w+) (.*)/.match(status)
    match ? match.captures : [nil, nil, nil]
  end

end
