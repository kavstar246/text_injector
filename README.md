# Text Injector

Injects text to a file with markers around the text so it can update it again.

## Installation

Add this line to your application's Gemfile:

    gem 'text_injector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text_injector

## Usage

<pre>
injector = TextInjector.new(
  :file => "/tmp/test.txt",
  :content => "added content"
)
injector.run # first run

injector = TextInjector.new(
  :file => "/tmp/test.txt",
  :content => "updated content"
)
injector.run # second run
</pre>

Before:

<pre>
test file
</pre>

After first run:

<pre>
test file
# Begin TextInjector marker for
added content
# End TextInjector marker for
</pre>

After second run:

<pre>
test file
# Begin TextInjector marker for
updated content
# End TextInjector marker for
</pre>


## Contributing

1. Fork it ( http://github.com/tongueroo/text_injector/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
