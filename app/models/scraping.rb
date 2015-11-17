class Scraping
  def self.movie_urls
    agent = Mechanize.new
    links = []

    link = "/now/"
    while true do
      page = agent.get("http://eiga.com" + link)
      elements = page.search('.m_unit h3 a')
      elements.each do |element|
        links << element.get_attribute('href')
      end

      link = page.at('.next_page')[:href]
      break unless link
    end

    links.each do |link|
      get_product(link)
    end
  end

  def self.get_product(link)
    agent = Mechanize.new
    page = agent.get("http://eiga.com" + link)
    title = page.at('h1').inner_text
    image_url = page.at('.pictBox img')[:src] if page.at('.pictBox img')
    director = page.at('.staffBox span').inner_text if page.at('.staffBox span')
    detail = page.at('.outline p').inner_text if page.at('.outline p')
    open_date = page.at('.opn_date strong').inner_text if page.at('.opn_date strong')
    product = Product.where(title: title, image_url: image_url, director: director, detail: detail, open_date: open_date).first_or_initialize
    product.save
  end
end