#!/usr/bin/ruby
require "net/ftp"

class DeployItem
    attr_accessor :hash
    attr_accessor :fileName
end

def readIntoArray(fileName)
    result = []
    f = File.open(fileName)
    f.each_line {|line|
        item = DeployItem.new
        item.hash = line.slice(0..31)
        item.fileName = line.slice(32..-1).strip

        result.push item
    }

    return result
end

if !ENV["BLOG_FTP_USER"]
    puts("Variable \"BLOG_FTP_USER\" not set!")
    exit 1;
end

if !ENV["BLOG_FTP_PASSWORD"]
    puts("Variable \"BLOG_FTP_PASSWORD\" not set!")
    exit 1;
end

if !ENV["BLOG_FTP_URL"]
    puts("Variable \"BLOG_FTP_URL\" not set!")
    exit 1;
end

if !system("compass compile")
    exit 1
end

if !system("wintersmith build")
    exit 1
end

if !system("find build -type f -print0 | xargs -0 md5 -r > md5sums.txt")
    exit 1
end

origFileName = "md5sums.orig"
newFileName = "md5sums.txt"

if !File.exists?(newFileName)
    puts "#{newFileName} not found!"
    exit 1
end

if File.exists?(origFileName)
    puts "#{origFileName} found. Deleting..."
    File.delete(origFileName)
end

Net::FTP.open(ENV["BLOG_FTP_URL"], ENV["BLOG_FTP_USER"], ENV["BLOG_FTP_PASSWORD"]) do |ftp|
    puts "Loading #{newFileName} from FTP and saving into #{origFileName}"
    begin
        ftp.gettextfile(newFileName, origFileName)
    rescue Exception => e
        puts "#{origFileName} not found on FTP"    
    end
    ftp.close
end

if !File.exists?(origFileName)
    puts "#{origFileName} not found!"
    exit 1
end


origContents = readIntoArray(origFileName)
newContents = readIntoArray(newFileName)
changed = []
deleted = []
added = []

orig_list = []
new_list = []

origContents.each {|orig_file|
    newContents.each {|new_file|
        if new_file.fileName == orig_file.fileName
            if new_file.hash != orig_file.hash
                if new_file.fileName.start_with?("build/")
                    changed.push new_file.fileName.strip.slice("build/".length..-1)
                else
                    changed.push new_file.fileName.strip
                end
            end
        end
    }
}

origContents.each {|orig_file|
    if orig_file.fileName.start_with?("build/")
        orig_list.push orig_file.fileName.strip.slice("build/".length..-1)
    else
        orig_list.push orig_file.fileName.strip
    end
}

newContents.each {|new_file|
    if new_file.fileName.start_with?("build/")
        new_list.push new_file.fileName.strip.slice("build/".length..-1)
    else
        new_list.push new_file.fileName.strip
    end
}

orig_list.each {|item|
    if !new_list.index(item)
        deleted.push item
    end
}

new_list.each {|item|
    if !orig_list.index(item)
        added.push item
    end
}

if changed.length > 0 || added.length > 0 || deleted.length > 0
    Net::FTP.open(ENV["BLOG_FTP_URL"], ENV["BLOG_FTP_USER"], ENV["BLOG_FTP_PASSWORD"]) do |ftp|
        changed.each {|item| 
            src = "build/" + item 
            begin
              puts "removing changed #{item} from FTP"
              ftp.delete(item)
            rescue Exception => e
              puts "#{item} not found on FTP"
            end
            puts "pushing changed #{src} to FTP"
            ftp.putbinaryfile(src, item)
        }

        deleted.each {|item| 
            begin
                puts "removing deleted #{item} from FTP"
                ftp.delete(item)
            rescue Exception => e
              puts "#{item} not found on FTP"
            end
        }

        added.each {|item|
            if item.start_with?("build/")
              src = item
              item = item.slice("build/".length..-1)
            else
              src = "build/" + item
            end
            dir = File.dirname(item)
            begin
              puts "creating directory #{dir}"
              ftp.mkdir(dir)
            rescue 
              puts "#{dir} seems to exist already"
            end
            puts "pushing added #{src} to FTP"
            ftp.putbinaryfile(src, item)
        }

        puts "pushing new #{newFileName} to FTP"
        ftp.puttextfile(newFileName, newFileName)

        ftp.close
    end
else
    puts "Nothing has changed!"
end
