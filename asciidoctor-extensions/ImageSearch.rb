require 'json'
require 'mini_magick'
require 'fileutils'

def oldsearchImage searchkey
    output=""
    file = File.open("asciidoctor-extensions/imagedb", "r")
    hash=JSON.load(file)
    searchkey.slice!("image: ")
    myitem=hash.fetch(searchkey)
    output= processHash myitem
    return output
end

def oldprocessHash myhash
    output=""
    myhash.each_pair do |key, value|
	output+=%("#{key}":)
        if value.instance_of? Array
          puts "Array found: #{value}"
          output+="["
          value.each {|elem| 
            output+=processHash(elem)
            puts "elem: #{elem}"
            puts "processed: #{processHash(elem)}"
          }
          output+="]"
        elsif value.instance_of? Hash
          output+="{"
          output+=processHash(value)
          output+="},"
        else
          output+=%("#{value}",)
        end
    end
    output.chomp!(',')
    return output
end

def processHash myhash
  return myhash.to_s.gsub(/=>/,":")
end

def handleImage pathstring, target
  path=pathstring.slice(/image:(.*)\[\]/,1)
  hash=createMetaFromPath path
  hashstring=processHash hash
  FileUtils.cp path, "H5PFactory/#{target}/content/images"
  
  return hashstring
end

def createMetaFromPath path
  image=MiniMagick::Image.open path
  #puts image
  title=path.slice(/\/(\w*)\.\w*/, 1)
  data=Hash.new
  params=Hash.new
  file=Hash.new
  metadata=Hash.new
    data["params"]=params
      params["contentName"]="Image"
      params["file"]=file
        file["path"]=%(images/#{path.slice(/\/(\w*\.\w*)/, 1)}) #extract filename from path (search for pattern filename.suffix)
        file["mime"]=image.mime_type
        file["width"]=image.width
        file["height"]=image.height
      params["alt"]=title
      params["title"]=title
    data["metadata"]=metadata
      metadata["title"]=title
    data["library"]="H5P.Image 1.1"
  return data
end
