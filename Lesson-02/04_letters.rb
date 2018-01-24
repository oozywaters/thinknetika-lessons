vowels_hash = {}
('a'..'z').each_with_index do |letter, index|
  if letter.start_with?('a','e','i','o','u')
    vowels_hash[letter.to_sym] = index + 1
  end
end

puts vowels_hash
