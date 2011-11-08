SoundcloudRSS-ruby
==================

A ruby library to generate RSS feed for your
[SoundCloud](http://www.soundcloud.com/) account.

Installation
------------

  * Get [soundcloud-ruby](https://github.com/soundcloudlabs/soundcloud-ruby) and its dependencies. 
    I advice you to clone the repository to get the last version of the sources -- `git clone git://github.com/soundcloudlabs/soundcloud-ruby.git`.
    Then install the dependencies -- `gem install httmultiparty hashie`.
  * clone this repository -- `git clone git://github.com/quentin/soundcloud-rss-ruby.git`

Configuration
-------------

It is a best practice to have the configuration stored in a file:

  * copy `.soundrssrc` to your home directory -- `cp .soundrssrc ~/`
  * set your SoundCloud username and password in the file
  * protect the file -- `chmod u+rw,go-rwx ~/.soundrssrc`

Or you can also set environment variables, using the prefix `SOUNDRSS_`:

  * set a username -- `export SOUNDRSS_USERNAME=yourusername`
  * set a password -- `export SOUNDRSS_PASSORD=yourpassword`

An other way to configure SoundcloudRSS is to pass options when you initialize
a `SoundcloudRSS` object:

  * `s = SoundcloudRSS.new({:username => 'yourusername', :password => 'yourpassword'})`

Run on your linuxbox
--------------------

  * run `ruby -rubygems -Ilib -Ipath/to/soundcloud-ruby/lib examples/servlet/servlet.rb`
  * enjoy `http://localhost:8080/soundrss`

