def turkish_str_to_float input
  result = input.gsub('.','').gsub(',', '.')
  result.to_f
end