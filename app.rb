require 'bundler'

Bundler.require(:default)

class Link < ActiveRecord::Base
  validates_presence_of :url
  validates_uniqueness_of :url, :uid
  before_create :generate_uid

  private

  def generate_uid
    Enumerator.new do |y|
      loop do
        y << 6.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
      end
    end.each do |uid|
      self.uid = uid and break unless Link.exists?(uid: uid)
    end
  end
end

class App < Sinatra::Base
  Tilt.register Tilt::ERBTemplate, 'html.erb'

  get '/' do
    erb :index
  end
  
  post '/new' do
    json link: Link.find_or_create_by(url: params[:url])
  end

  get '/:uid' do
    redirect Link.find_by!(uid: params[:uid]).url
  end

  after do
    ActiveRecord::Base.connection.close
  end
end

App.run! if __FILE__ == $0
