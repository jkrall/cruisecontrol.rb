gem "twitter4r", ">=0.3.0"
require "twitter"
require "time"

class TwitterNotifier

  attr_writer :login, :password

  def initialize(project)
    @project = project

    Twitter::Client.configure do |conf|
      conf.user_agent = 'cruisecontrolrb'
      conf.application_name = 'CruiseControl.rb'
      conf.application_version = 'v1.2.1'
      conf.application_url = 'http://cruisecontrolrb.thoughtworks.com/'
    end

    def build_finished(build)
      return unless @login and build.failed?
      Twitter::Client.new(:login => @login, :password => @password).
        status(:post, "Newly checked in code for #{build.project.name} has failing specs.\nhttps://transfsdev.dyndns.org:9443/builds/TransFS/#{build.label}") rescue nil
    end

    def build_fixed(build, previous_build)
      return unless @login
      Twitter::Client.new(:login => @login, :password => @password).
        status(:post, "The #{build.project.name} code now passes all specs!\nhttps://transfsdev.dyndns.org:9443/builds/TransFS/#{build.label}") rescue nil
    end

  end

end

Project.plugin :twitter_notifier

