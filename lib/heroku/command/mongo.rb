module Heroku::Command
  class Mongo < BaseWithApp
    def initialize(*args)
      super

      require 'mongo'
    rescue LoadError
      error "Install the Mongo gem to use mongo commands:\nsudo gem install mongo"
    end

    def push
      display "THIS WILL REPLACE ALL DATA for #{app} ON #{heroku_mongo_uri.host} WITH #{local_mongo_uri.host}"
      display "Are you sure? (y/n) ", false
      return unless ask.downcase == 'y'
      transfer(local_mongo_uri, heroku_mongo_uri)
    end

    def pull
      display "Replacing the #{local_mongo_uri.path[1..-1]} db at #{local_mongo_uri.host} with #{heroku_mongo_uri.host}"
      display "Are you sure? (y/n) ", false
      return unless ask.downcase == 'y'
      transfer(heroku_mongo_uri, local_mongo_uri)
    end

    protected
      def transfer(from, to)
        origin = make_connection(from)
        dest   = make_connection(to)

        origin.collections.each do |col|
          next if col.name =~ /^system\./

          display "Syncing #{col.name} (#{col.size})...", false
          dest.drop_collection(col.name)
          dest_col = dest.create_collection(col.name)
          col.find().each do |record|
            dest_col.insert record
          end
          display " done"
        end

        display "Syncing indexes...", false
        dest_index_col = dest.collection('system.indexes')
        origin_index_col = origin.collection('system.indexes')
        origin_index_col.find().each do |index|
          if index['_id']
            index['ns'] = index['ns'].sub(origin_index_col.db.name, dest_index_col.db.name)
            dest_index_col.insert index
          end
        end
        display " done"
      end

      def heroku_mongo_uri
        if @remote_uri.nil?
          config = heroku.config_vars(app)
          url    = config['MONGO_URL'] || config['MONGOHQ_URL']
          error("Could not find the MONGO_URL for #{app}") unless url
          @remote_uri = make_uri(url)
        end
        @remote_uri
      end

      def local_mongo_uri
        if @local_uri.nil?
          url = ENV['MONGO_URL'].blank? ? "mongodb://localhost:27017/#{app}" : ENV['MONGO_URL'].dup
          @local_uri = make_uri(url)
        end
        @local_uri
      end

      def make_uri(url)
        url.gsub!('local.mongohq.com', 'mongohq.com')
        uri = URI.parse(url)
        raise URI::InvalidURIError unless uri.host
        uri
      rescue URI::InvalidURIError
        error("Invalid mongo url: #{url}")
      end

      def make_connection(uri)
        connection = ::Mongo::Connection.new(uri.host, uri.port)
        db = connection.db(uri.path.gsub(/^\//, ''))
        db.authenticate(uri.user, uri.password) if uri.user
        db
      rescue ::Mongo::ConnectionFailure
        error("Could not connect to the mongo server at #{uri}")
      end

      Help.group 'Mongo' do |group|
        group.command 'mongo:push', 'push the local mongo database'
        group.command 'mongo:pull', 'pull from the production mongo database'
      end
  end
end
