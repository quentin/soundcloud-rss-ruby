class SoundcloudRSS
  # application credential for soundcloud API
  CLIENT_ID='f8a39ffd398d3637fafa6131553f6674'
  CLIENT_SECRET='131672295d9638f43e08b33ef0391043'

  # allowed options
  OPTS = {:client_id => "SoundCloud API ID", 
          :client_secret => "SoundCloud API secret", 
          :username => "User name", 
          :password => "User password", 
          :follow_redirection => "",
          :env_prefix => "environment variables prefix",
          :rc_path => "configuration file path"}

  # default options
  DEFAULTS = {
    :client_id => CLIENT_ID,
    :client_secret => CLIENT_SECRET,
    :follow_redirection => 3,
    :env_prefix => "SOUNDRSS_",
    :rc_path => "~/.soundrssrc"
    }

  def rss options = {}
    options = DEFAULTS.merge({
      :title => "SoundCloud Feed",
      :link => "http://www.soundcloud.com",
      :description => "SoundCloud RSS Feed",
      :version => "2.0"
      }).merge(options)

    rss = RSS::Rss.new(options[:version])
    channel = RSS::Rss::Channel.new

    channel.title = options[:title]
    channel.link = options[:link]
    channel.description = options[:description]
      
    @client.get('/me/activities').collection.each do |entry|
      case entry.type
      when 'track'
        i = RSS::Rss::Channel::Item.new
        
        i.title = "new track '#{entry.origin.title}' by #{entry.origin.user.username}"
        i.link = entry.origin.permalink_url
        i.date = Time.parse(entry.created_at)

        # append artwork and original description for the track 
        i.description = "<img src=\"#{entry.origin.artwork_url}\"/><br/>" + entry.origin.description.gsub(/\r\n|\r|\n/,"<br/>")

        # create guid/enclosure for the attached stream url
        if entry.origin.stream_url
          # request HEAD in order to get length/mime data for the stream
          uri = URI(entry.origin.stream_url)
          uri.query = "client_id=#{options[:client_id]}"

          (options[:follow_redirection]+1).times do # prevent infinite http redirection
            req = Net::HTTP.new(uri.host, 80)
            resp = req.request_head(uri.path + "?" + uri.query)
            case resp
            when Net::HTTPSuccess
              length = resp.response['Content-Length']
              mime = resp.response['Content-Type']
              i.guid = RSS::Rss::Channel::Item::Guid.new(true, entry.origin.stream_url)
              i.enclosure = RSS::Rss::Channel::Item::Enclosure.new(uri.to_s, length.to_i, mime)
              break
            when Net::HTTPRedirection
              uri = URI(resp['Location'])
            else
              resp.error!
              break
            end
          end
        end

        channel.items << i
      end
    end

    rss.channel = channel
    rss
  end

  def initialize options = {}
    # options sources by decreasing priority: 
    #   argument options
    #   rc file options 
    #   environment variables options 
    #   default options

    # load options using default and argument options
    @options = DEFAULTS.merge(load_options(DEFAULTS.merge(options))).merge(options)
    @client = Soundcloud.new(@options)
  end

  def load_options options = {}
    opts = {}

    # load options from environment variables
    OPTS.each_key do |optkey|
      envkey = "#{options[:env_prefix]}#{optkey.to_s.upcase}"
      if ENV.has_key? envkey
        opts[optkey] = ENV[envkey]
      end
    end

    # load options from rc file
    rcpath = File.expand_path(options[:rc_path])
    if File.file? rcpath
      File.new(rcpath, "r").each_line do |line|
        if line =~ /\A([^=]+)=(.+)\Z/
          key,val = $1,$2
          key = key.strip.to_sym
          val.strip!
          opts[key] = val if OPTS.has_key?(key)
        end
      end
    end

    opts
  end

end
