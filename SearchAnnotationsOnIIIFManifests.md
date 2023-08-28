# How to search Github for Annotations on Specific Manifests

This approach assumes that any web annotations published on Github use the IIIF cookbook recipe [Linking Annotations to Manifests](https://iiif.io/api/cookbook/recipe/0306-linking-annotations-to-manifests/).  This approach is currently implemented by AudiAnnotate and by Annona.

Once annotations contain the partOf stanza as described by the recipe similar to the following:
```json
"partOf": [
  {
    "id": "https://iiif.io/api/cookbook/recipe/0306-linking-annotations-to-manifests/manifest.json",
    "type": "Manifest"
  }
]
```
Then the Github search interface and the Github REST API can both be used to find the annotation files that contain that stanza.  

<em>Note that it may take minutes or hours for Github to index newly created annotations; to check if Github has indexed the annotation file, have the file owner search the repo containing that file.  Github displays a message if the repo has not been indexed since the last change (and possibly bumps it up the indexing queue).  This warning message is not displayed if a search is performed across all of Github, or across all of one user's repositories.</em>

## Using The Github search interface

From the [Github search interface](https://github.com/search) use the following query string to find annotation files:

`https://saracarl.github.io/comparison-test/her-kind/manifest.json  partOf language:json`

* `https://saracarl.github.io/comparison-test/her-kind/manifest.json` is the manifest we want to find annotations on
*  The `partOf` syntax limits the response to files that contain references to an item (usually an annotation file)
*  `language:json` may not be absolutely necessary but limits the results to json files


<em>Caveat: There is a chance this approach could return a manifest matching the URI that conatins a partOf statement (pointing to a collection) instead returning an annotation page with annotations targeting the URI.  To avoid false positives, the annotation files themselves must be read.</em>

## Using the Github REST API

The Github REST API works the same way the search interface does.  The following call from a github client connection using the `search_code` method will return an array of results.  (Note that this example uses the Oktokit Ruby client library for the Github API.)
 
response = @github_client.search_code('"partOf" "https://saracarl.github.io/comparison-test/her-kind/manifest.json" language:json')

The Github API will return a search response; you'll need to fetch each item from that response and find the `html_url` value which will contain the Github page for the annotation file returned. 

`html_url = response[:items].first[:html_url]`

To get the raw annotation file to work with programmatically, you'll have to substitute `raw.github.com` for `github.com' and remove the `blob/`: 
`raw_url = html_url.sub('github.com','raw.githubusercontent.com').sub('blob/','')`

Then you can read and parse the annotation file:
```ruby
require 'open-uri'
raw_json = URI.open(raw_url).read
json=JSON.parse(raw_json)
```

## See it in action

Log into [AudiAnnotate](http://audiannotate.brumfieldlabs.com/) using your Github credentials then append your manifest to the following URL:
`http://audiannotate.brumfieldlabs.com/api/search/<manifesturl>`
