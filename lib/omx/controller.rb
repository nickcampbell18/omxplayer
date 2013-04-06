require 'eventmachine'
require 'em-websocket'
require 'oj'

require_relative '../omx/status'

module Omx
  class Controller

    attr_reader :q, :output_mode

    def initialize(queue=[], output_mode='hdmi', player=Omx::Player.new)
      @q = queue
      @output_mode = output_mode
      @player = player
    end

    def as_json
      {
        'queue' => @q,
        'output_mode' => @output_mode,
        'now_playing' => Omx::Status.to_h
      }
    end

    def react_to(opts)

      # Try and run the action on this controller first.
      if respond_to? opts['action'].to_s
        return if send opts['action'], opts['option']
      end

      # Run commands on the player itself
      if @player.respond_to? opts['action'].to_s
        return if @player.send opts['action']
      end

      # Finally, try and run it directly from the array
      if @q.respond_to? opts['action'].to_s
        return if @q.send opts['action'], opts['filename']
      end

    end

    def clear(*args)
      @q.clear
    end

    def change_output(mode)
      {'mode' => "#{@output_mode = mode}"}
    end

    def play_next_if_needed
      {'play' => @q.shift} if @q.any? && !Omx::Status.reload!.playing?
    end

  end
end

EM.run {

  @controller = Omx::Controller.new %w{many files are here obviously}

  serv = EM::WebSocket.run(host: '0.0.0.0', port: ENV['SOCKET_PORT']) do |server|

    deliver = lambda {|hash| server.send Oj.dump(hash) }

    server.onopen { deliver.call({:something => :epic})  }

    server.onmessage { |msg|
      deliver.call begin
        @controller.react_to Oj.strict_load msg
        @controller.as_json
      rescue Exception => e
        {'error' => e.message}
      end
    }

    EM.add_periodic_timer(1) {
      if res = @controller.play_next_if_needed
        deliver.call res
      end
    }

  end

} if ENV['SOCKET_PORT']