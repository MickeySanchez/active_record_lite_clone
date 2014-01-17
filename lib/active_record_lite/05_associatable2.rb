require_relative '04_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

              # e.g #:home    :human      :house
  def has_one_through(name, through_name, source_name)
    define_method(name) do
    # find object's human
    # use human's assoc_options to get to house
    through_options = # BelongsToOptions for specific human
    end
  end
end
