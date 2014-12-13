class CrossrefImport < Import

  TYPES_WITH_TITLE = %w(journal-article
                      proceedings-article
                      dissertation
                      standard
                      report
                      book
                      monograph
                      edited-book
                      reference-book
                      dataset)

  # CrossRef types from http://api.crossref.org/types
  TYPE_TRANSLATIONS = {
    "proceedings" => nil,
    "reference-book" => nil,
    "journal-issue" => nil,
    "proceedings-article" => "paper-conference",
    "other" => nil,
    "dissertation" => "thesis",
    "dataset" => "dataset",
    "edited-book" => "book",
    "journal-article" => "article-journal",
    "journal" => nil,
    "report" => "report",
    "book-series" => nil,
    "report-series" => nil,
    "book-track" => nil,
    "standard" => nil,
    "book-section" => "chapter",
    "book-part" => nil,
    "book" => "book",
    "book-chapter" => "chapter",
    "standard-series" => nil,
    "monograph" => "book",
    "component" => nil,
    "reference-entry" => "entry-dictionary",
    "journal-volume" => nil,
    "book-set" => nil
  }

  def parse_data(result)
    # return early if an error occured
    return [] unless result && result["status"] == "ok"

    items = result.fetch('message', {}).fetch('items', nil)
    Array(items).map do |item|
      doi = item.fetch("DOI", nil)
      canonical_url = item.fetch("URL", nil)
      date_parts = item["issued"]["date-parts"][0]
      year, month, day = date_parts[0], date_parts[1], date_parts[2]

      title = case item["title"].length
              when 0 then nil
              when 1 then item["title"][0]
              else item["title"][0].presence || item["title"][1]
              end

      if title.blank? && !TYPES_WITH_TITLE.include?(item["type"])
        title = item["container-title"][0].presence || "No title"
      end
      publisher_id = item.fetch("member", nil)
      publisher_id = publisher_id[30..-1].to_i if publisher_id

      type = item.fetch("type", nil)
      type = TYPE_TRANSLATIONS[type] if type
      work_type_id = WorkType.where(name: type).pluck(:id).first

      csl = {
        "issued" => item.fetch("issued", []),
        "author" => item.fetch("author", []),
        "container-title" => item.fetch("container-title", [])[0],
        "page" => item.fetch("page", nil),
        "issue" => item.fetch("issue", nil),
        "title" => title,
        "type" => type,
        "DOI" => doi,
        "URL" => canonical_url,
        "publisher" => item.fetch("publisher", nil),
        "volume" => item.fetch("volume", nil)
      }

      { doi: doi,
        title: title,
        year: year,
        month: month,
        day: day,
        publisher_id: publisher_id,
        work_type_id: work_type_id,
        csl: csl }
    end
  end
end
