# Omxplayer

Command [omxplayer](https://github.com/huceke/omxplayer) from your ruby application!

This gem uses the system call `mkfifo` to pipe commands into omxplayer. You can play/pause, skip forward and backward and quit the video, as well as pipe in a filename to play.

It also inspects the output from a specialised `ps` command to provide an estimate for how long the current video has been playing.

## Installation

Add this line to your application's Gemfile:

    gem 'omxplayer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omxplayer

## Usage in Sinatra

[See an example with sinatra](https://github.com/nickcampbell18/minion)

    # see omxplayer/keyboard_shortcuts.rb for all commands
    # e.g. http://localhost/player/forward
    get '/player/:action' do
        Omxplayer.instance.action params[:action]
    end
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
