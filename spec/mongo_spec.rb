require 'rubygems'
require 'mongo'
require 'baconmocha'

$: << File.dirname(__FILE__) + '/../lib'
require 'heroku'
require 'heroku/command'
require 'heroku/command/mongo'

describe Heroku::Command::Mongo do
  before do
    @mongo = Heroku::Command::Mongo.new ['--app', 'myapp']
    @mongo.stubs(:app).returns('myapp')
  end

  it "rejects urls without host" do
    @mongo.expects(:error)
    @mongo.send(:make_uri, 'test')
  end

  it "rescues URI parsing errors" do
    @mongo.expects(:error)
    @mongo.send(:make_uri, 'test:')
  end

  it "fixes mongohq addresses so it can connect from outside EC2" do
    uri = @mongo.send(:make_uri, 'mongo://root:secret@aws.mongohq.com/mydb')
    uri.host.should == 'genesis.mongohq.com'
  end
end