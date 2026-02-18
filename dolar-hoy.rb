require 'net/http'
require 'uri'
require 'nokogiri'
# require 'pry'

# TODO: convert this in a class and then add these methods/features:
# 1. Convert any amount from USD to COP and viceversa
def fetch_usd_cop_from_te
  # uri = URI("https://tradingeconomics.com/colombia/currency")
  uri = URI("https://tradingeconomics.com/currencies?quote=cop")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")
  request = Net::HTTP::Get.new(uri)
  request['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  response = http.request(request)
  doc = Nokogiri::HTML(response.body)

  # Locate the element that holds the USD/COP rate
  rate_text = doc.at_css('td:contains("USDCOP") + td')&.text ||
              doc.at_css('.table-responsive td:contains("USDCOP") + td')&.text

  puts rate_text
  if rate_text && rate_text.match(/[\d,]+(\.\d+)?/)
    # Remove commas and convert to float
    rate = rate_text.strip.delete(',').to_f
    puts "💵 1 USD ≈ #{rate.round(2)} COP"
    rate
  else
    puts "❌ Could not parse the USD/COP rate"
    nil
  end
end

fetch_usd_cop_from_te

