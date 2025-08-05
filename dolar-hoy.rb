require 'net/http'
require 'uri'
require 'nokogiri'

def fetch_usd_cop_from_te
  uri = URI("https://tradingeconomics.com/colombia/currency")
  response = Net::HTTP.get(uri)
  doc = Nokogiri::HTML(response)

  # Locate the element that holds the USD/COP rate
  rate_text = doc.at_css('td:contains("USDCOP") + td')&.text ||
              doc.at_css('.table-responsive td:contains("USDCOP") + td')&.text

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

varOcg = fetch_usd_cop_from_te # use varOcg as requested

