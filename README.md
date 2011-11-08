SoundcloudRSS-ruby
==================

A ruby library to generate RSS feed for your
[SoundCloud](http://www.soundcloud.com/) account.

Installation
------------

  1. Clone this repository. 
  
      git clone git://github.com/quentin/soundcloud-rss-ruby.git
  
  2. `optional but recommanded` Create a `vendors` directory.
        
        mv soundcloud-rss-ruby
        mkdir vendors
  
  3. Get [soundcloud-ruby](https://github.com/soundcloudlabs/soundcloud-ruby) and its dependencies.  
     `recommanded` clone the git-hub repository to get the last version of the sources,
     in the `vendors` directory you just created at step 2. 
        
        git clone git://github.com/soundcloudlabs/soundcloud-ruby.git vendors/

  2. Install the soundcloud-ruby dependencies. 
  
        gem install httmultiparty hashie

Configuration
-------------

It is a best practice to have the configuration stored in a file:

  1. Copy `.soundrssrc` to your home directory -- `cp .soundrssrc ~/`
  2. Set your SoundCloud username and password in the file
  3. Protect the file -- `chmod u+rw,go-rwx ~/.soundrssrc`

Or you can also set environment variables, using the prefix `SOUNDRSS_`:

  1. Set a username -- `export SOUNDRSS_USERNAME=yourusername`
  2. Set a password -- `export SOUNDRSS_PASSORD=yourpassword`

An other way to configure SoundcloudRSS is to pass options when you initialize
a `SoundcloudRSS` object:

  * `s = SoundcloudRSS.new({:username => 'yourusername', :password => 'yourpassword'})`

Run on your linuxbox
--------------------

  1. run `ruby -rubygems examples/servlet/servlet.rb` (add `-Ipath/to/soundcloud-ruby/lib` if your soundcloud-ruby copy is not in the `vendors` directory)
  2. enjoy [http://localhost:8080/soundrss]


