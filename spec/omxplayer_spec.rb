require 'spec_helper'

describe 'Omxplayer instance' do

  describe "audio output modes" do

    before :all do
      @player = Omxplayer.instance
    end

    it 'should default to hdmi if no output mode provided' do
      @player.expects(:system).with {|x| x =~ /-o hdmi/ }.returns true
      @player.expects(:action).returns true
      @player.open 'any-old-file.mp4'
    end

    it 'should accept an alternate output mode' do
      @player.expects(:system).with {|x| x =~ /-o local/ }.returns true
      @player.expects(:action).returns true
      @player.open 'any-old-file.mp4', :audio_output => :local
    end

  end

  describe "building mkfifo" do
    before :each do
      @pipe = Omxplayer::PIPE
      @player = Omxplayer.instance
    end

    after :each do
      @player.send :mkfifo
    end

    it 'will not create mkfifo if file exists' do
      File.expects(:exists?).with(@pipe).returns(true)
      @player.expects(:system).never
    end

    it 'will create mkfifo if file does not exist' do
      File.expects(:exists?).with(@pipe).returns(false)
      @player.expects(:system)
    end
  end

  describe 'get status from ps' do

    before :each do
      @player = Omxplayer.instance
      @player.stubs(:`).returns "01:23:45 /usr/bin/omxplayer.bin -o hdmi /path/to.mp4"
    end

    it 'gets filename' do
      _, _, filename = @player.send :get_status_from_ps
      filename.should == '/path/to.mp4'
    end

    it 'gets time' do
      time, _, _ = @player.send :get_status_from_ps
      time.should == '01:23:45'
    end

    it 'gets audio output mode' do
      _, format, _ = @player.send :get_status_from_ps
      format.should == 'hdmi'
    end

  end

end