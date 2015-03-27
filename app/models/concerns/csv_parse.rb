module CsvParse
  #input a csv file and output an array of params
  extend ActiveSupport::Concern

  module ClassMethods
    def csv_parse path
      lines = File.readlines(path)
      titles = lines.shift.gsub("\n", '').split('|').map{ |title| title.underscore.strip.gsub(" ", "_") }

      lines.map do |row|
        single_record = {}
        data = row.gsub("\n", '').split('|')
        titles.each do |title|
          single_record[title] = data.shift
        end
        single_record
      end
    end
  end
end
