require 'spec_helper'

describe TextInjector do
  before(:each) do
    @file = "tmp/test.txt"
    FileUtils.cp("spec/fixtures/test.txt", @file)
    @content = "added content"
  end
  after(:each) do
    FileUtils.rm_f(@file)
  end
  let(:injector) do
    TextInjector.new(
      :mute => true,
      :file => @file,
      :tmp_file => @tmp_file,
      :identifier => @identifier,
      :content => @content
    )
  end

  describe "new file" do
    it "should create new file with markers" do
      @file = "tmp/new-file.txt"
      injector.run
      data = IO.read(@file)
      expect(data).to include "added content"
      expect(data).to match(/Begin TextInjector marker for/)
      expect(data).to match(/End TextInjector marker for/)
    end
  end

  describe "existing file" do
    it "should update text" do
      injector.run
      data = IO.read(@file)
      expect(data).to include('added content')

      injector.content = "updated content"
      injector.run
      data = IO.read(@file)
      expect(data).not_to include("added content")
      expect(data).to include("updated content")
    end

    it "should include markers" do
      injector.run
      data = IO.read(@file)
      expect(data).to match(/Begin TextInjector marker for/)
      expect(data).to match(/End TextInjector marker for/)
    end

    it "should use custom-id for markers" do
      @identifier = "custom-id"
      injector.run
      data = IO.read(@file)
      expect(data).to match(/Begin TextInjector marker for custom-id/)
      expect(data).to match(/End TextInjector marker for custom-id/)
      puts data if ENV['DEBUG']
      expect(data).to eq <<-EOL
test file

# Begin TextInjector marker for custom-id
added content
# End TextInjector marker for custom-id
EOL
    end

    it "should create temp file" do
      @tmp_file = true
      injector.run
      expect(File.exist?(injector.tmp_path)).to be(true)
      FileUtils.rm_f(injector.tmp_path)
    end
  end
end