require_relative '../spec_helper'

describe Omx::Player do

  describe 'default options' do
    it 'should set hdmi and start position zero by default' do
      opts = Omx::Player.new.send :default_options
      opts[:audio_out].should == 'hdmi'
      opts[:start_pos].should == 0
    end
  end

  describe 'building the pipe' do

    before :each do
      @pipe = Omx::Player::PIPE
      @player = Omx::Player.new
    end

    it 'will not create pipe if none exists' do
      File.expects(:exists?).with(@pipe).returns(true)
      @player.expects(:system).never
    end

    it 'will create pipe if does not exist' do
      File.expects(:exists?).with(@pipe).returns(false)
      @player.expects(:system)
    end

    after :each do
      @player.send :mkfifo
    end

  end

  describe 'building the unix command' do

    before :each do
      @player = Omx::Player.new
      opts = {filename: 'none.mp4', audio_out: 'hdmi', start_pos: 0}
      @cmd = @player.send :unix_command_with, opts
      @pipe = Omx::Player::PIPE
    end

    it 'should start with omxplayer' do
      @cmd.should match /^omxplayer/
    end

    it 'should generate the args' do
      @cmd.should match /--adev hdmi/
      @cmd.should match /--pos 0/
    end

    it 'should put quotes around the filename' do
      @cmd.should match /"none.mp4"/
    end

    it 'should end with a pipe ampersand' do
      @cmd.should match /< #{@pipe} &$/
    end

    it 'must match this sequence of tokens' do
      # command --args+ filename pipe ampersand
      r = /(?<command>omxplayer) (?<arg>--\w+ \S+\s?){2,} (?<file>"\S+") < (?<pipe>\S+) &/
      @cmd.should match r
    end

  end

  describe 'sending commands to pipe' do
    it 'should send the command as a background process' do
      p = Omx::Player.new
      p.expects(:system).with do |command|
        command =~ /^echo -n . > \S+ &$/
      end
      p.send :send_to_pipe, "."
    end
  end

  describe 'opening a file' do
    it 'should send the start command' do
      p = Omx::Player.new
      p.expects(:start).once
      p.send :open
    end
  end

end