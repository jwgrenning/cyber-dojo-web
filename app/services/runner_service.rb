require_relative 'http_helper'

class RunnerService

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def sha(runner_choice)
    http(runner_choice).get(__method__)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_new(image_name, id, starting_files)
    if stateful?(id)
      args = {
            image_name:image_name,
                    id:id,
        starting_files:starting_files
      }
      http('stateful').post_hash(__method__, args)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_old(image_name, id)
    if stateful?(id)
      args = { image_name:image_name, id:id }
      http('stateful').post_hash(__method__, args)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def run_cyber_dojo_sh(image_name, id, max_seconds, delta, files)
    new_files = files.select { |filename|
      delta[:new].include?(filename)
    }
    deleted_files = Hash[
      delta[:deleted].map { |filename| [filename, ''] }
    ]
    changed_files = files.select { |filename|
      delta[:changed].include?(filename)
    }
    unchanged_files = files.select { |filename|
      delta[:unchanged].include?(filename)
    }

    args = {
             image_name:image_name,
                     id:id,
              new_files:new_files,
          deleted_files:deleted_files,
          changed_files:changed_files,
        unchanged_files:unchanged_files,
            max_seconds:max_seconds
    }

    # Get runner-choice from html <input> and not kata's
    # manifest which would make a slower saver-service call.
    runner_choice = @externals.params['runner_choice']
    
    tuple = http(runner_choice).post_hash(:run_cyber_dojo_sh, args)

    [tuple['stdout'],
     tuple['stderr'],
     tuple['status'],
     tuple['colour'],
     tuple['new_files'],
     tuple['deleted_files'],
     tuple['changed_files']
   ]
  end

  private # = = = = = = = = = = = = = = = = = = = = =

  def http(runner_choice)
    case runner_choice
    when 'stateless'
      HttpHelper.new(@externals, self, 'runner-stateless', 4597)
    when 'stateful'
      HttpHelper.new(@externals, self, 'runner-stateful',  4557)
    end
  end

  def stateful?(id)
    @externals.katas[id].manifest.runner_choice == 'stateful'
  end

end
