
class KataController < ApplicationController

  def edit
    @id = @title = id
    @manifest = model.kata_manifest(id)
    @events = model.kata_events(id)
    # most recent event
    last = model.kata_event(id, -1)
    polyfill(last)
    @index = last['index']
    @files = last['files']
    @stdout = last['stdout']
    @stderr = last['stderr']
    @status = last['status']
    # settings
    @env = ENV
  end

  # - - - - - - - - - - - - - - - - - -

  def run_tests
    kata = Kata.new(self, id)
    t1 = time.now
    result,files,@created,@deleted,@changed = kata.run_tests(params)
    t2 = time.now

    duration = Time.mktime(*t2) - Time.mktime(*t1)
    @id = id
    @index = index
    @stdout = result['stdout']
    @stderr = result['stderr']
    @status = result['status']
    @log = result['log']
    @outcome = result['outcome']
    @light = {
      'index' => @index,
      'colour' => @outcome,
      'predicted' => params['predicted'],
    }

    @saved = true
    @out_of_sync = false
    begin
      model.kata_ran_tests(@id, @index, files, @stdout, @stderr, @status, {
         duration: duration,
           colour: @outcome,
        predicted: params['predicted']
      })
    rescue ModelService::Error => error
      @saved = false
      $stdout.puts(error.message);
      $stdout.flush
      unless id?(@id)
        raise
      end
      if model.kata_exists?(@id)
        @out_of_sync = true
      end
    end

    respond_to do |format|
      format.js {
        render layout:false
      }
    end
  end

  # - - - - - - - - - - - - - - - - - -

  def revert
    json = source_event(:revert, revert_args)
    model.kata_ran_tests(id, index, @files, @stdout, @stderr, @status, {
      colour: @colour,
      revert: revert_args
    });
    render json: json
  end

  # - - - - - - - - - - - - - - - - - -

  def checkout
    json = source_event(:checkout, checkout_args)
    model.kata_ran_tests(id, index, @files, @stdout, @stderr, @status, {
        colour: @colour,
      checkout: checkout_args
    });
    render json: json
  end

  private

  def source_event(name, value)
    event = model.kata_event(source_id, source_index)
    @files = event['files']
    @stdout = event['stdout']
    @stderr = event['stderr']
    @status = event['status']
    @colour = event['colour']
    {
       files: @files.map{ |filename,file| [filename, file['content']] }.to_h,
      stdout: @stdout,
      stderr: @stderr,
      status: @status,
       light: {
         colour: @colour,
          index: index,
          name => value
       }
    }
  end

  def id
    params[:id]
  end

  def index
    params[:index].to_i + 1
  end

  def checkout_args
    { id:source_id, avatarIndex:source_avatar_index, index:source_index }
  end

  def revert_args
    [ source_id, source_index ]
  end

  def source_id
    params[:src_id]
  end

  def source_index
    params[:src_index].to_i
  end

  def source_avatar_index
    param = params[:src_avatar_index]
    (param != '') ? param.to_i : ''
  end

  # - - - - - - - - - - - - - - - - - -

  def polyfill(event)
    event['stdout'] ||= content('')
    event['stderr'] ||= content('')
    event['status'] ||= ''
  end

  def content(s)
    { 'content' => s, 'truncated' => false }
  end

  # - - - - - - - - - - - - - - - - - -

  def id?(s)
    s.is_a?(String) &&
      s.length === 6 &&
        s.chars.all?{ |ch| ALPHABET.include?(ch) }
  end

  ALPHABET = %w{
    0 1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h   j k l m n   p q r s t u v w x y z
  }.join.freeze

end
