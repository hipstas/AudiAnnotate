class ApiController < ApplicationController
  require 'open-uri'
  before_action :connect

  def search
    # search accepts a parameter which should be the manifest to query for
    manifest_id = params[:manifest_id]
    manifest_id.sub!(':/', '://')
    manifest_id.sub!(':///', '://')

    query = "\"partOf\" \"#{manifest_id}\"  language:json"
    search_results = []
    response = @github_client.search_code(query)
    response[:items].each do |item|
      html_url = item[:html_url]
      raw_url = html_url.sub('github.com','raw.githubusercontent.com').sub('blob/','')
      raw_json = URI.open(raw_url).read
      json=JSON.parse(raw_json)

      # now create a response from the results
      collection_item = {
        'context' => json['@context'],
        'id' => json['id'],
        'type' => json['type']
      }
      if json['label']
        collection_item['label'] = json['label']
      end
      search_results << collection_item
    end
    render json: search_results
  end
end
