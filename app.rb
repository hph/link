require 'bundler'

Bundler.require(:default)

class Link < ActiveRecord::Base
  has_many :hits
  validates_presence_of :url
  validates_uniqueness_of :url, :uid
  before_create :fix_url
  before_create :generate_uid

  private

  def fix_url
    self.url = "http://#{url}" if url[%r{^http(s)*://}].nil?
  end

  def generate_uid
    loop do
      self.uid = 6.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
      break unless Link.exists?(uid: uid)
    end
  end
end

class Hit < ActiveRecord::Base
  belongs_to :article
  validates_presence_of :ip_address
end

class App < Sinatra::Base
  get '/' do
    html :index
  end
  
  post '/new' do
    json link: Link.find_or_create_by(url: params[:url])
  end

  get %r{^/(\w{6})$} do
    link = Link.find_by_uid(params[:captures].first)
    if link.nil?
      not_found
    else
      link.hits.create(ip_address: request.ip)
      redirect link.url
    end
  end

  not_found { html '404' }

  error { html '500' }

  after { ActiveRecord::Base.connection.close }

  helpers do
    def html(view)
      send_file File.join('public', "#{view.to_s}.html")
    end
  end
end

App.run! if __FILE__ == $0
