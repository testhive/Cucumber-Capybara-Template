def turkish_str_to_float input
  result = input.gsub('.','').gsub(',', '.')
  result.to_f
end

def safe_visit url
  begin
    visit url
  rescue Exception => e
    p "An error occured while visiting: #{e}"
    visit url
  end
end