
# On the diff dialog/page to cycle through the avatars.

module RingPicker # mix-in

  module_function

  # - - - - - - - - - - - - - - - -

  def ring_prev_next(kata)
    if kata.group
      active = kata.group
                   .katas
                   .select(&:active?)
                   .sort_by(&:avatar_name)
    else
      active = []
    end

    size = active.size
    i = active.index{ |k| k.avatar_name == kata.avatar_name }
    if i.nil?
      [ nil, nil ]
    else
      [ active[i-1], active[(i+1) % size] ]
    end
  end

end
