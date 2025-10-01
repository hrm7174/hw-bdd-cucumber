require 'date'

Given(/^(?:the )?following movies exist:?$/) do |movies_table|
  movies_table.hashes.each do |attrs|
    if attrs['release_date'].present?
      begin
        attrs['release_date'] = Date.parse(attrs['release_date'])
      rescue ArgumentError
      end
    end
    Movie.create!(attrs)
  end
end

Then(/^(.*) seed movies should exist$/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

Then(/^I should see "(.*)" before "(.*)"(?: in the movie list)?$/) do |e1, e2|
  body = page.body
  expect(body.index(e1)).to be < body.index(e2)
end

When(/^I check the following ratings: (.+)$/) do |rating_list|
  rating_list.split(/\s*,\s*/).each do |r|
    steps %Q{ When I check "ratings_#{r}" }
  end
end

When(/^I uncheck the following ratings: (.+)$/) do |rating_list|
  rating_list.split(/\s*,\s*/).each do |r|
    steps %Q{ When I uncheck "ratings_#{r}" }
  end
end

Then(/^I should see the following movies: (.+)$/) do |movie_list|
  movie_list.split(/\s*,\s*/).each do |title|
    steps %Q{ Then I should see "#{title}" }
  end
end

Then(/^I should not see the following movies: (.+)$/) do |movie_list|
  movie_list.split(/\s*,\s*/).each do |title|
    steps %Q{ Then I should not see "#{title}" }
  end
end

Then(/^I should see only the movies rated: (.+)$/) do |ratings|
  wanted = ratings.split(/\s*,\s*/)
  Movie.where(rating: wanted).pluck(:title).each do |t|
    steps %Q{ Then I should see "#{t}" }
  end
  Movie.where.not(rating: wanted).pluck(:title).each do |t|
    steps %Q{ Then I should not see "#{t}" }
  end
end

Then(/^I should see all the movies$/) do
    rows = page.all('table#movies tbody tr').count
    expect(rows).to eq(Movie.count)
  end
end