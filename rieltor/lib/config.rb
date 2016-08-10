require 'british'
require 'json'

class Config

  DEFAULT_CONFIG = {
    bad_words: []
  }

  include British::Initialisable

  attr_reader :config

  def initialise(config_path)
    File.write(config_path, DEFAULT_CONFIG.to_json) unless File.exists?(config_path)
    @config = JSON.parse(File.read(config_path), {symbolize_names: true})
  end
end
