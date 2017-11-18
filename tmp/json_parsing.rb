require 'json'
require 'yaml'

root_dir = "/Users/dankleiman/Dropbox/rcrosslinks"
# ---
# title: "Top N Per Group in BigQuery"
# categories:
# - Code
# - BigQuery
# ---

# {"subreddit":"093game","cross_linked_subs":[{"xpost_sub":"livven","count":"4"},{"xpost_sub":"SCP","count":"3"},{"xpost_sub":"creepy","count":"1"},{"xpost_sub":"ProCSS","count":"1"},{"xpost_sub":"gaming","count":"1"}]}
pages = {}
File.open('top-20-agg.json', 'r').each do |line|
  entry = JSON.parse(line)
  subreddit = entry["subreddit"]
  pages[subreddit] = entry["cross_linked_subs"].map { |xpost_hash| xpost_hash["xpost_sub"] }
end

puts "PARSED #{pages.keys.size} SUBREDDITS"

pages.each do |subreddit, crosslinks|
  subreddit_dir = root_dir + "/content/pages/#{subreddit}.md"
  f = File.new(subreddit_dir, 'w+')
  page_info = {}
  page_info["title"] = subreddit
  page_info["crosslinks"] = crosslinks
  f << page_info.to_yaml
  f << '---'
  f.close
end

puts "CREATED #{pages.keys.size} PAGES"

f = File.new("#{root_dir}/data/subreddits.yaml", 'w')
f << pages.keys.to_yaml
f << '---'
f.close

puts "STORED METADATA FOR #{pages.keys.size} SUBREDDITS"