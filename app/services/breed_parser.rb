class BreedParser
  def initialize
    @_breed_list = Breed.all.pluck(:name).map(&:downcase)
  end

  def parse_from_tweet(text)
    breeds = []
    possibilities = text.split(',')[0..3]

    possibilities.each do |chunk|
      chunk = preprocess(chunk)
      break if !chunk || chunk.empty? || chunk.length < 3
      chunks = chunk.split("&amp;").map(&:strip)
      found = []
      chunks.each do |chunk|
        break if chunk.empty?
        found << breed_list.find_all do |breed|
          breed.include?(chunk.downcase) || breed.include?(chunk[0..-2].downcase) && ((chunk[0..-2].length.to_f)/breed.length > 0.3)
        end
      end
      found.flatten!
      if found.empty?
        if chunk.downcase.include? "mix"
          breeds += ["mix"]
          ind = chunk.downcase.index("mix")
          chunk=chunk[0..ind-1].strip
          if chunk.include? "/"
            chunks = chunk.split("/").map(&:strip)
            chunks.each do |chunk|
              found = breed_list.find_all do |breed|
                (breed.include? (chunk.downcase) || breed.include?(chunk[0..-2].downcase)) && ((chunk[0..-2].length.to_f)/breed.length > 0.3)
              end
              breeds += found unless found.empty?
            end
          else
            found = breed_list.find_all do |breed|
              breed.include? (chunk.downcase) || breed.include?(chunk[0..-2].downcase) && ((chunk[0..-2].length.to_f)/breed.length > 0.3)
            end
            breeds += found unless found.empty?
          end
        end
      else
        breeds += found
      end
    end
    return breeds.uniq.join(", ") unless breeds.empty?
    "DID NOT PARSE: #{possibilities}"
  end


  private
    def breed_list
      @_breed_list
    end

    def preprocess(chunk)
      chunk = chunk.gsub(/g[\w-]*doodle/i,"Golden Retriever/Poodle Mix")
      ind = chunk.index("-")
      chunk = chunk[0..ind-1].strip if ind
      ind = chunk.index("(")
      chunk = chunk.gsub(/\(.+\)/,"").strip
      chunk = chunk[0..ind-1].strip if ind
      return nil if chunk.include?("://")
      chunk = chunk.gsub(/St\./i,"Saint")
      chunk = chunk.gsub(/GSD/i,"German Shepherd Dog")
      chunk = chunk.gsub(/Olde English Bulldogge/i,"English Bulldog")
      chunk = chunk.gsub(/bmd/i,"Bernese Mountain Dog")
      chunk = chunk.gsub(/gsp/i,"German Shorthaired Pointer")
      chunk = chunk.gsub(/ckcs/i,"Cavalier King Charles Spaniel")
      chunk = chunk.gsub(/bullmastiff/i,"Bull Mastiff")
      chunk = chunk.gsub(/labradoodle/i,"Lab/Poodle Mix")
      chunk = chunk.gsub(/yorkipoo/i,"Yorkshire Terrier/Poodle Mix")
      chunk = chunk.gsub(/maltipoo/i,"Maltese Dog/Poodle Mix")
      chunk = chunk.gsub(/aussie/i,"Australian Shepherd")
      chunk = chunk.gsub(/sheltie/i,"Shetland Sheepdog")
      chunk = chunk.gsub(/rough collie/i,"Collie")
      chunk = chunk.gsub(/bearded collie/i,"Collie")
      chunk = chunk.gsub(/wire hair fox terrier/i,"Wire Fox Terrier")
      chunk = chunk.gsub(/puggle/i, "Pug/Beagle Mix")
      chunk = chunk.gsub(/yorkie/i, "Yorkshire Terrier")
      chunk = chunk.gsub(/huskies/i, "Husky")
      chunk = chunk.gsub(/b collie/i, "Border Collie")
      chunk = chunk.gsub(/acd/i, "Australian Cattle Dog")
      chunk = chunk.gsub(/jrt/i, "Jack Russell Terrier")
      chunk = chunk.gsub(/pom/i, "Pomeranian")
      chunk = chunk.gsub(/Kleine/i, "Small")
    end
end
