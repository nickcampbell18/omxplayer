require_relative '../spec_helper'

class Container
  def send_to_pipe; true; end
  include Omx::KeyboardShortcuts
end

describe "KeyboardShortcuts" do

  before :all do
    @obj = Container.new
  end

  it 'should define common functions on inclusion' do
    @obj.should respond_to :start
    @obj.should respond_to :quit
    @obj.should respond_to :play
    @obj.should respond_to :toggle_subs
  end

end