require_relative '../spec_helper'

describe Omx::Status do

  before :all do
    @status = Omx::Status
  end

  describe 'matching the params' do

    before :each do
      @status.reload!.stubs(:status_command).returns "12:43 /usr/bin/omxplayer.bin --adev hdmi \"file.mp4\" < /tmp/omxpipe"
    end

    it 'should gather the time' do
      @status.running_time.should == '12:43'
    end

    it 'should gather the filename' do
      @status.filename.should == 'file.mp4'
    end

    it 'should gather the audio mode' do
      @status.audio_out.should == 'hdmi'
    end

  end

end