
require 'Files'
require 'Git'
require 'Locking'

class Avatar

  def self.names
    # no two animals start with the same letter
    %w(
        alligator buffalo cheetah deer
        elephant frog gorilla hippo
        koala lion moose panda
        raccoon snake wolf zebra
      )
  end

  def initialize(kata, name) 
    @kata = kata
    @name = name
    if !File.exists? dir
      save(@kata.visible_files, traffic_lights = [ ])
      sandbox.save(@kata.visible_files)
      system(cd_dir('git init --quiet'))
      system(cd_dir("git add #{Traffic_lights_filename}"))
      system(cd_dir("git add #{Visible_files_filename}"))      
      git_commit(@kata.visible_files, tag = 0)
    end
  end
  
  def dir
    @kata.dir + File::SEPARATOR + name
  end
  
  def kata
    @kata
  end
  
  def name
    @name
  end
      
  def save_run_tests(visible_files, traffic_light)    
    traffic_lights = nil
    Locking::io_lock(dir) do
      traffic_lights = locked_read(Traffic_lights_filename)
      traffic_lights << traffic_light
      tag = traffic_lights.length
      traffic_light[:number] = tag
      save(visible_files, traffic_lights)
      git_commit(visible_files, tag)
    end
    traffic_lights
  end

  def visible_files(tag = nil)
    unlocked_read(Visible_files_filename, tag)
  end
  
  def traffic_lights(tag = nil)
    unlocked_read(Traffic_lights_filename, tag)
  end

  def diff_lines(was_tag, now_tag)
    command = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    Git::diff(dir, command)
  end
  
  def sandbox
    Sandbox.new(self)
  end
  
private

  def save(visible_files, traffic_lights)
    Files::file_write(dir, Visible_files_filename, visible_files)
    Files::file_write(dir, Traffic_lights_filename, traffic_lights)
  end

  def git_commit(visible_files, tag)
    command = ""
    visible_files.keys.each do |filename|
      command += "git add sandbox/#{filename};"
    end
    command += "git commit -a -m '#{tag}' --quiet;"
    command += "git tag -m '#{tag}' #{tag} HEAD";    
    system(cd_dir(command))
  end
  
  def unlocked_read(filename, tag)
    Locking::io_lock(dir) { locked_read(filename, tag) }
  end
  
  def locked_read(filename, tag = nil)
    tag ||= most_recent_tag
    Git::show(dir, "#{tag}:#{filename}")
  end
     
  def most_recent_tag
    Git::most_recent_tag(dir)
  end
  
  def cd_dir(command)
    "cd #{dir};" + command
  end
  
  Traffic_lights_filename = 'increments.rb'
  # Used to display the traffic-lights at the bottom of the
  # animals test page, and also to display the traffic-lights for
  # an animal on the dashboard page.
  # It is part of the git repository and is committed every run-test.
  
  Visible_files_filename = 'manifest.rb'
  # Used to retrieve (via a single file access) the visible
  # files needed when resuming an animal.
  # It is part of the git repository and is committed every run-test.
end


