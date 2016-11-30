require 'rest-client'

class HttpClient
  USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'
  ]

  def self.get_page(url, logger)
    logger.debug("Loading page #{url}")

    RestClient.get(url, headers={
      'User-Agent' => USER_AGENTS.sample
      }).body
  rescue RestClient::RequestFailed => e
    code = e.response.code
    body = code == 404 ? '' : e.response.body

    logger.error("HTTP error :: #{url} <#{code}> :: '#{body}'")
    nil
  rescue SocketError
    nil
  end

  def self.page_exists?(url)
    RestClient.head(url).headers[:content_length].to_i > 0
  rescue RestClient::RequestFailed => e
    false
  rescue SocketError
    nil
  end

  def self.clear_url(url)
    url.split('#')[0]
  end
end
