module CsvParse
  #input a csv file and output an array of params
  extend ActiveRecord::Concern
  def csv_parse path
    lines = File.readlines(path)
    titles = lines.shift.gsub("\n", '').split(',').map(&:underscore)

    lines.map do |row|
      single_record = {}
      data = row.gsub("\n", '').split(',')
      titles.each do |title|
        single_record[title] = data.shift
      end
      single_record
    end
  end
end
