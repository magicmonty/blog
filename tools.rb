#!/usr/bin/ruby
require "net/ftp"
require 'fileutils'
require 'digest/md5'

class DeployItem
    attr_accessor :hash
    attr_accessor :file_name
end

class Deployer

    def initialize
        @orig_md5_file = "md5sums.orig"
        @new_md5_file = "md5sums.txt"
        @wintersmith = "./node_modules/.bin/wintersmith"

        @orig_contents = []
        @new_contents = []

        @ftp_url = ""
        @ftp_user = ""
        @ftp_password = ""

        @ftp = nil
    end

    def deploy
        return false unless built? && load_md5_from_server

        @orig_contents = read_into_array(@orig_md5_file)
        @new_contents = read_into_array(@new_md5_file)

        return deploy_to_ftp
    end

    def deploy_without_build
        return false unless File.directory?("build") && load_md5_from_server

        @orig_contents = read_into_array(@orig_md5_file)
        @new_contents = read_into_array(@new_md5_file)

        return deploy_to_ftp
    end

    def built?
        return sass_compiled? && site_build? && md5_created?
    end

    private

    def sass_compiled?
        puts "compiling SASS with Compass"
        return system("compass compile")
    end

    def site_build?
        puts "building site..."
        if system("#{@wintersmith} build")
            remove_bundled_js_files
            return true
        end

        puts "error building site #{@wintersmith}"
        return false
    end

    def remove_bundled_js_files
        FileUtils.rm_rf './build/js/lib'
    end

    def md5_created?
        if File.exists?(@new_md5_file)
            File.delete(@new_md5_file)
        end

        begin
            md5sums = ""

            Dir.glob("build/**/*", File::FNM_DOTMATCH).each do |filename|
                next if File.directory?(filename)
                key = Digest::MD5.hexdigest(IO.read(filename)).to_sym
                md5sums += "#{key} #{filename}\n"
            end

            File.open(@new_md5_file, 'w') { |file| file.write(md5sums) }
        rescue Exception => e
            return false
        end

        return File.exists?(@new_md5_file)
    end

    def load_md5_from_server
        return false unless environment_set?

        if File.exists?(@orig_md5_file)
            puts "#{@orig_md5_file} found. Deleting..."
            File.delete(@orig_md5_file)
        end

        begin
            open_ftp

            puts "Loading #{@new_md5_file} from FTP and saving into #{@orig_md5_file}"
            begin
                @ftp.gettextfile(@new_md5_file, @orig_md5_file)
            rescue Exception => e
                puts "#{@orig_md5_file} not found on FTP"
            end

            close_ftp
        rescue Exception => e
            puts e
            return false
        end

        unless File.exists?(@orig_md5_file)
            puts "#{@orig_md5_file} not found!"
        end

        return File.exists?(@orig_md5_file)
    end

    def environment_set?
        environment_set = true

        unless ENV["BLOG_FTP_USER"]
            puts("Variable \"BLOG_FTP_USER\" not set!")
            environment_set = false
        end

        unless ENV["BLOG_FTP_PASSWORD"]
            puts("Variable \"BLOG_FTP_PASSWORD\" not set!")
            environment_set = false
        end

        unless ENV["BLOG_FTP_URL"]
            puts("Variable \"BLOG_FTP_URL\" not set!")
            environment_set = false
        end

        if environment_set
            @ftp_url = ENV["BLOG_FTP_URL"]
            @ftp_user = ENV["BLOG_FTP_USER"]
            @ftp_password = ENV["BLOG_FTP_PASSWORD"]
        end

        return environment_set
    end

    def open_ftp
        @ftp = Net::FTP.open(@ftp_url, @ftp_user, @ftp_password)
    end

    def close_ftp
        @ftp.close
        @ftp = nil
    end

    def read_into_array(file_name)
        result = []

        f = File.open(file_name)
        f.each_line {|line|
            item = DeployItem.new
            item.hash = line.slice(0..31)
            item.file_name = line.slice(32..-1).strip

            result.push item
        }

        return result
    end

    def deploy_to_ftp
        @changed = changed_files
        @added = added_files
        @deleted = deleted_files

        if is_something_to_deploy?
            begin
                open_ftp

                send_changed_files
                remove_deleted_files
                send_added_files

                puts "pushing new #{@new_md5_file} to FTP"
                @ftp.puttextfile(@new_md5_file, @new_md5_file)

                close_ftp
            rescue Exception => e
                puts e
                return false
            end
        else
            puts "Nothing has changed!"
        end

        return true
    end

    def changed_files
        changed = []

        @orig_contents.each {|orig_file|
            @new_contents.each {|new_file|
                if files_different?(new_file, orig_file)
                    changed.push strip_filename(new_file)
                end
            }
        }

        return changed
    end

    def files_different?(new_file, orig_file)
        return new_file.file_name == orig_file.file_name && new_file.hash != orig_file.hash
    end

    def strip_filename(file)
        if file.file_name.start_with?("build/")
            return file.file_name.strip.slice("build/".length..-1)
        else
            return file.file_name.strip
        end
    end

    def added_files
        return get_difference(@new_contents, @orig_contents)
    end

    def get_difference(contents1, contents2)
        difference = []

        c1_stripped = strip_filenames(contents1)
        c2_stripped = strip_filenames(contents2)

        c1_stripped.each {|item|
            unless c2_stripped.index(item)
                difference.push item
            end
        }

        return difference
    end

    def strip_filenames(contents)
        list = []

        contents.each {|file|
            list.push strip_filename(file)
        }

        return list
    end

    def deleted_files
        return get_difference(@orig_contents, @new_contents)
    end

    def is_something_to_deploy?
        @changed.length > 0 || @added.length > 0 || @deleted.length > 0
    end

    def send_changed_files
        @changed.each {|destination|
            delete_item_from_ftp(destination)
            send_item_to_ftp("build/" + destination, destination)
        }
    end

    def delete_item_from_ftp(item)
        begin
            puts "removing #{item} from FTP"
            @ftp.delete(item)
        rescue Exception => e
            puts "#{item} not found on FTP"
        end
    end

    def send_item_to_ftp(local, destination)
        puts "pushing #{local} to FTP"
        @ftp.putbinaryfile(local, destination)
    end

    def remove_deleted_files
        @deleted.each {|item|
            delete_item_from_ftp(item)
        }
    end

    def send_added_files
        @added.each {|destination|
            create_dir_on_ftp(File.dirname(destination))
            send_item_to_ftp("build/" + destination, destination)
        }
    end

    def create_dir_on_ftp(dirname)
        begin
            puts "creating directory #{dirname}"
            @ftp.mkdir(dirname)
        rescue
            puts "#{dirname} seems to exist already"
        end
    end
end
