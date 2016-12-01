require 'json'

module FileGeneratorFactory
  def self.generator(type)
    if type === :json
      JsonFileGenerator.new
    else
      TxtFileGenerator.new
    end
  end

  class FileGenerator
    def generate(file_path, data)
      file = File.open(file_path, 'w')
      file.write(data)
      file.close
    end
  end

  class TxtFileGenerator < FileGenerator
    def generate(file_path, data)
      file_data = []

      data.each do |ad|
        file_data << ad[:ad_text] + ' ' + ad[:ad_phones].join(', ')
      end

      data = file_data.join("\n")
      super
    end
  end

  class JsonFileGenerator < FileGenerator
    def generate(file_path, data)
      data = data.to_json
      super
    end
  end
end


if $0 === __FILE__
  data = [
    {ad_text: 'qqqqqqq', ad_phones: ['093506476', '093506474']},
    {ad_text: 'qqqqqqq', ad_phones: ['093506476']}
  ]

  FileGeneratorFactory.generator(:txt).generate('/tmp/test.txt', data)

end
