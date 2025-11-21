# Seed real movies by using this API (with open-uri and json ruby libs): "https://tmdb.lewagon.com/movie/top_rated"
require 'open-uri'
require 'json'

puts 'Cleaning up database...'
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

puts 'Creating movies...'
url = 'https://tmdb.lewagon.com/movie/top_rated'
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)
movies['results'].each do |movie|
  Movie.create!(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}",
    rating: movie['vote_average']
  )
end

puts "Created #{Movie.count} movies."


puts 'Creating lists...'
list_names = ['Classic movies', 'Superhero']
list_names.each do |name|
  List.create!(name: name)
end

puts "Created #{List.count} lists."


# Associating movies to lists with bookmarks
puts 'Creating bookmarks...'
List.all.each do |list|
  movies_sample = Movie.order('RANDOM()').limit(5)
  movies_sample.each do |movie|
    Bookmark.create!(
      list: list,
      movie: movie,
      comment: "Great movie!"
    )
  end
end
puts "Created #{Bookmark.count} bookmarks."

puts 'Finished!'
