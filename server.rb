require "nokogiri"
require "open-uri"
require "sinatra"
require "slim"
 
get "/" do
  @class = "home"
  slim :home
end

get "/wiki/:id" do
  doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/" + URI::encode(params[:id])));
  @title = doc.xpath("//h1[@id='firstHeading']")
  @titleText = doc.xpath("//h1[@id='firstHeading']").text
  @content = doc.xpath("//div[@id='mw-content-text']")
  @class = "page"
  @termbox = @title.text
  slim :search
end

get "/search" do
  redirect to("/") , 301
end

post "/search" do
  if (params["search"].empty?)
    redirect to("/") , 301
  else
    redirect to("/search/" + params["search"]) , 301
  end
end

get "/search/:text" do
  doc = Nokogiri::HTML(open("http://en.wikipedia.org/w/index.php?search=" + URI::encode(params[:text])));
  @title = doc.xpath("//h1[@id='firstHeading']")
  @titleText = doc.xpath("//h1[@id='firstHeading']").text
  @content = doc.xpath("//div[@id='mw-content-text']")
  @class = "search"
  @termbox = params[:text]
  slim :search
end

get "/about" do
  @class = "about"
  slim :about
end
