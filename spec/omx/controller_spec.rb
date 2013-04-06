require_relative '../spec_helper'

describe Omx::Controller do

  before :each do
    @c = Omx::Controller.new %w{/tmp/file.mp4 /tmp/music.mp3}
  end

  describe '#react_to' do

    it 'will push entries onto the queue' do
      @c.react_to({'action' => '<<', 'filename' => '/tmp/one.mp4'})
      @c.q.last.should == '/tmp/one.mp4'
    end

    it 'will remove entries from the queue' do
      @c.react_to({'action' => 'delete', 'filename' => '/tmp/file.mp4'})
      @c.q.should_not include '/tmp/file.mp4'
    end

    it 'will clear the queue' do
      @c.react_to({'action' => 'clear'})
      @c.q.should == []
    end

    it 'can switch output mode' do
      @c.react_to({'action' => 'change_output', 'option' => 'local'})
      @c.output_mode.should == 'local'
    end

  end

  it 'returns a json response' do
    Omx::Status.expects(:to_h).returns({'abc' => 'def'})
    res = @c.as_json
    res['queue'].should == @c.q
    res['output_mode'].should == @c.output_mode
    res['now_playing']['abc'].should == 'def'
  end

end