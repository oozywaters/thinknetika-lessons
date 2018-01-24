vowels_hash = {}
vowels = ['a','e','i','o','u']
('a'..'z').each_with_index do |letter, index|
  vowels_hash[letter.to_sym] = index + 1 if vowels.include?(letter)
end

puts vowels_hash
