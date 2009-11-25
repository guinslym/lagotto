require 'doi'

desc "Bulk-import DOIs from standard input"
task :doi_import => :environment do
  puts "Reading DOIs from standard input..."
  valid = []
  invalid = []
  duplicate = []
  created = []
  updated = []
  sources = Source.all
  
  while (line = STDIN.gets)
    raw_doi, raw_published_on, raw_title = line.strip.split(" ", 3)
    doi = DOI::from_uri raw_doi.strip
    published_on = Date.parse(raw_published_on.strip) if raw_published_on
    title = raw_title.strip if raw_title
    if (doi =~ DOI::FORMAT) and !published_on.nil? and !title.nil?
      valid << [doi, published_on, title]
    else
      invalid << [raw_doi, raw_published_on, raw_title]
    end
  end
  puts "Read #{valid.size} valid entries; ignored #{invalid.size} invalid entries"
  if invalid.size == 0
    valid.each do |doi, published_on, title| 
      existing = Article.find_by_doi(doi)
      unless existing
        article = Article.create(:doi => doi, :published_on => published_on, 
                       :title => title)
        
        #Create an empty retrieval record for each active source to avoid a problem with
        #joined tables breaking the UI on the front end
        sources.each do |source|
          retrieval = Retrieval.find_or_create_by_article_id_and_source_id(article.id, source.id)
          puts("Retrieval created for #{retrieval.source.name}")
        end
                       
        created << doi
      else
        if existing.published_on != published_on or existing.title != title
          existing.published_on = published_on
          existing.title = title
          existing.save!
          updated << doi
        else
          duplicate << doi
        end
      end
    end
  end
  puts "Saved #{created.size} new articles, updated #{updated.size} articles, ignored #{duplicate.size} other existing articles"
end
