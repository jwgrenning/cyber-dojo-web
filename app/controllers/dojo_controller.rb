
require 'Locking'
require 'Folders'

class DojoController < ApplicationController
    
  include Locking
  extend Locking
  include Folders
  extend Folders  
    
  def exists_json
    configure(params)
    @exists = Kata.exists?(params)
    respond_to do |format|
      format.json { render :json => { :exists => @exists, :message => 'Hello' } }
    end    
  end
    
  def resume_avatar_grid
    board_config(params)
    @live_avatar_names = @kata.avatar_names
    @all_avatar_names = Avatar.names    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def index
    # offers configure, start, resume, dashboard, messages
    @title = '@CyberDojo'
    configure(params)
    @kata_name = kata_name
  end
   
  def create
    configure(params)
    Kata.create(params)
    @kata = Kata.new(params) # needed for @kata.name in view
    
    filesets_root = params[:filesets_root]
    @languages = folders_in(filesets_root + '/language').sort
    @language_index = rand(@languages.length)
    
    @exercises = folders_in(filesets_root + '/exercise').sort
    @exercise_index = rand(@exercises.length)
    @instructions = { }
    @exercises.each do |name|
      path = filesets_root + '/' + 'exercise' + '/' + name + '/' + 'instructions'
      @instructions[name] = IO.read(path)
    end
    @title = 'Configure'
  end
  
  def save
    configure(params)
    Kata.configure(params)
    redirect_to :action => :index, 
                :kata_name => kata_name
  end  
    
  #------------------------------------------------
  
  def start
    configure(params)
    if !Kata.exists?(params)
      redirect_to "/dojo/cant_find?kata_name=#{kata_name}"
    else
      kata = Kata.new(params)      
      avatar = start_avatar(kata)
      if avatar == nil
        redirect_to "/dojo/full?kata_name=#{kata.name}"
      else
        redirect_to "/kata/edit?kata_name=#{kata.name}&avatar=#{avatar}"
      end
    end    
  end

  def cant_find
    configure(params)
    @kata_name = kata_name
  end
  
  def full
    configure(params)
    @kata_name = kata_name
  end
    
  #------------------------------------------------
    
  def ifaq
  end

  def conceived
  end
  
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

  def start_avatar(kata)
    io_lock(kata.dir) do
      available_avatar_names = Avatar.names - kata.avatar_names
      if available_avatar_names == [ ]
        avatar_name = nil
      else          
        avatar_name = random(available_avatar_names)
        Avatar.new(kata, avatar_name)
        kata.post_message(avatar_name, "#{avatar_name} has joined the practice-kata")
        avatar_name
      end        
    end      
  end
  
  def random(array)
    array.shuffle[0]
  end
  
end
