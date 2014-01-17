require_relative '04_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

              # e.g #:home    :human      :house
  def has_one_through(name, through_name, source_name)
    define_method(name) do
    # find object's human
    # use human's assoc_options to get to house
    # through_options = self.send(through_name).assoc_options
    # source_options = through_options.model_class.assoc_options
    end
  end
end
