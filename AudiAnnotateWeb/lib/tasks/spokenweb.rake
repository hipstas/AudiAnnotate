namespace :spokenweb do
  desc "Import spokenweb data from a JSON file passed as an argument"
  task :import, [:file] => :environment do |task, args|
    file = args[:file]
    if file.nil?
      puts "Please specify a file to import."
      exit
    end
    # does the file exist?
    if !File.exist?(file)
      puts "File #{file} does not exist."
      exit
    end
    # read a Github username and repo from the environment
    user_name = ENV['GITHUB_USER']
    repo_name = ENV['GITHUB_REPO']

    # read the file
    json = File.read(file)
    # parse the file
    collection = JSON.parse(json)
    
    # the collection is an array of hashes
    collection.each_with_index do |item,i|
#      break if i == 12
      item_title = item["Item_Description"]["title"].chomp.strip
      sound_recordings = item['Digital_File_Description'].select{|e| e['content_type']=="Sound Recording"}
      sound_recordings.each do |sound_recording|
        # handle multiple recordings
        if sound_recordings.count > 1
          title = "#{item_title} (#{sound_recording['id']})"
        else
          title = item_title
        end
        duration = sound_recording['duration']
        file_url = sound_recording['file_url']
        notes = sound_recording['notes'] # this contains timestamped summaries
        contents = sound_recording['contents'] # this contains a timestamped transcription and speaker info

        # split the contents into stanzas (separated by blank lines)
        stanzas = contents.split(/\n\s*\n/)
        # drop the first element (the mp3 name)
        stanzas = stanzas.drop(1)
        contents_annotations = []
        # parse each stanza -- speaker, timestamp, text
        stanzas.each do |stanza|
          # split the stanza into lines
          lines = stanza.split(/\n/)
          if lines.count == 3
            # the first line is the speaker
            speaker = lines[0]
            # the second line is the timestamp
            timestamp = lines[1]
            # the last line is the text
            text = lines[2]
            # convert wiki markup to html
            text.gsub!(/\[\s*(http.*?)\]/, '<sup><a href="\1">w</a></sup>')
            contents_annotations << {speaker: speaker, timestamp: timestamp, text: text}
          end
        end

        # split the notes into elements
        entries = notes.split(/\n/)
        description = entries.shift
        notes_annotations = []
        entries.each do |entry|

          # check for blank lines
          if entry.strip.length > 0
            # break out of the loop if the entry contains the word "END"
            break if entry.match(/END OF RECORDING/i)

            # split the entry into timestamp and text
            timestamp, text = entry.split(/\s+/, 2)
            # remove hyphens and other non-digit characters from the end of the timestamp
            timestamp.gsub!(/[^0-9]$/, '')
            if text && timestamp.match(/^[0-9:]+$/)
              index_terms = []
              # extract "[INDEX ...]" from the text
              if md = text.match(/\[INDEX.+\]/)
                index = md[0]
                # strip off the "[INDEX: " and "]" from the index
                index.gsub!(/\[index:?\s*/i, '')
                index.gsub!(/\.*\]/, '')
                # remove anything after a semicolon -- these are publication details
                index.gsub!(/;.*$/, '')
                # split the index terms, which are separated by a comma and space, but do not split on commas within parentheses
                index_terms = index.split(/,\s*(?![^(]*\))/)

                # remove the index from the text
                text.gsub!(/\[INDEX.+\]/i, '')
              end
              # add the annotation to the array
              notes_annotations << {timestamp: timestamp, text: text, index_terms: index_terms}
            end
          end
        end
        # only take actions if we have enough information
        if title && duration && file_url && contents_annotations.count > 0 && notes_annotations.count > 0
          print "Title: #{title}\tDuration: #{duration}\n"
          # mimic the item controller create action to create the item
          github_token = File.read(File.join(Rails.root, 'tmp', 'github_token'))

          # create an item from the variables we have read from the recording
          @item = Item.new(
            user_name,
            repo_name,
            title,
            file_url,
            duration_to_seconds(duration),
            nil,
            nil,
            nil)
          
          @item.save(github_token)    
          

          # now add our annotations -- the item controller does this in two actions
          # it uploads the file and parks it, then reads from an item configuration created by the UI to process it
          # if we write our annotation arrays out as CSV files, we can use the same code
          # first, write the contents annotations to a CSV file
          contents_file = File.open('contents.csv', 'w')
          contents_annotations.each do |annotation|
            contents_file.print "#{annotation[:speaker]}\t#{annotation[:timestamp]}\t#{annotation[:text]}\n"
          end
          contents_file.close

          parkable_annotation_file = AnnotationFile.new(
            @item.canvases.first,
            'contents',
            contents_file
          )
          parkable_annotation_file.park(github_token)

          annotation_file = AnnotationFile.from_file(
            @item.canvases.first, 
            'contents', 
            'contents.csv')
          config = {
            layer_col: 0,
            index_col: 0, # no index column for contents
            text_col: 2,
            start_col: 1,
            end_col: 1,
            headers: false
          }

          annotation_file.save(github_token, config)            


          # now write the notes annotations to a CSV file
          notes_file = File.open('notes.csv', 'w')
          notes_annotations.each do |annotation|
            notes_file.print "#{annotation[:timestamp]}\t#{annotation[:text]}\t#{annotation[:index_terms].join('|')}\n"
          end
          notes_file.close

          parkable_annotation_file = AnnotationFile.new(
            @item.canvases.first,
            'notes',
            notes_file
          )
          parkable_annotation_file.park(github_token)


          annotation_file = AnnotationFile.from_file(
            @item.canvases.first, 
            'TOC', 
            'notes.csv')
          config = {
            layer_col: nil,
            index_col: nil, # ignore terms for performance reasons (was 2)
            text_col: 1,
            start_col: 0,
            end_col: 0,
            headers: false
          }

          annotation_file.save(github_token, config)            

        else
          print "ERROR: #{title}\tDuration: #{duration}\tFile URL: #{file_url}\n"
        end
      end

    end

  end

  def duration_to_seconds(duration)
    md = duration.match(/(\d+):(\d+):(\S+)/)
    if md
      duration = md[1].to_f * 60 * 60
      duration += md[2].to_f * 60
      duration += md[3].to_f
    elsif md = duration.match(/(\d+):(\S+)/)
      duration = md[1].to_f * 60
      duration += md[2].to_f 
    end
    duration  
  end



end
