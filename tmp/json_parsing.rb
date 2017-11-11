require 'json'
require 'yaml'

root_dir = "/Users/dankleiman/Dropbox/rcrosslinks"
# ---
# title: "Top N Per Group in BigQuery"
# categories:
# - Code
# - BigQuery
# ---
pages = {}
File.open('top-20-2017.json', 'r').each do |line|
  entry = JSON.parse(line)
  subreddit = entry["subreddit"]
  pages[subreddit] ||= []
  pages[subreddit] << entry["xpost_sub"]
end

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