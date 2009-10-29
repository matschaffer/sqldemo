require "rubygems"
require "mechanize"
require "json"

File.open('data.js', 'w') do |data|
  agent = WWW::Mechanize.new

  def get_name item
    item.search('.prodLink').text
  end
  
  def get_price item
    item.search('.PriceDisplay .PriceXLBold').first.text.strip[1..-1].to_f
  end

  def get_rating item
    src = item.search('img').select{ |e| e['src'].include? 'Rating' }.map{ |e| e['src']}.first
    if src && match = src.match(/CustRating\/(.*)\.gif/)
      match[1].gsub('_', '.').to_f
    else
      nil
    end
  end


  proc {
    url = "http://www.walmart.com/search/search-ng.do?ic=96_0&ref=&tab_value=54_All&search_query=Halloween+Costumes&search_constraint=0"
    costumes = []

    agent.get(url).search('.item').each do |item|
      costumes << {:name => get_name(item), :price => get_price(item), :rating => get_rating(item)}
    end
  
    puts "Processed #{costumes.length} costumes"
    data.puts "var costumes = #{costumes.to_json};"
    data.puts
  }[]
  
  proc {
    urls = ["http://www.walmart.com/search/search-ng.do?ic=96_0&ref=+418721.418762&tab_value=1111_All&search_query=candy&search_constraint=0",
            "http://www.walmart.com/search/search-ng.do?ref=+418721.418762&ic=96_96&search_constraint=0&tab_value=1111_All&search_query=candy"]
    candy = []
    urls.each do |url|
      agent.get(url).search('.item').each do |item|
        weight = nil
        name = get_name(item)
        if match = name.match(/^(.*), (.*) oz$/)
          name = match[1]
          weight = match[2].to_f
        end
        candy << {:name => name, :rating => get_rating(item), :weight => weight}
      end
    end
    
    puts "Processed #{candy.length} candies"
    data.puts "var candies = #{candy.to_json};"
    data.puts
  }[]
  
  proc {
    people = []
    Dir['people_pages/*'].each do |file|
      people += Nokogiri(File.read(file)).search('.fullname').map{|e| e.text.strip }.select{|name| !name.empty?}
    end
    
    puts "Processed #{people.length} people"
    data.puts "var people = #{people.to_json};"
    data.puts
  }[]
end

