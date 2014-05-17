require 'bundler'

Bundler.require(:default)

class Link < ActiveRecord::Base
  validates_presence_of :url
  validates_uniqueness_of :url, :uid
  before_create :fix_url
  before_create :generate_uid

  private

  def fix_url
    self.url = "http://#{url}" if url[%r{^http(s)*://}].nil?
  end

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
    html :index
  end
  
  post '/new' do
    json link: Link.find_or_create_by(url: params[:url])
  end

  get %r{^/(\w{6})$} do
    link = Link.find_by_uid(params[:captures].first)
    not_found if link.nil?
    redirect Link.find_by!(uid: params[:uid]).url
  end

  not_found do
    html '404'
  end

  error do
    html '500'
  end

  after do
    ActiveRecord::Base.connection.close
  end

  helpers do
    def html(view)
      send_file "public/#{view.to_s}.html"
    end
  end
end

App.run! if __FILE__ == $0
