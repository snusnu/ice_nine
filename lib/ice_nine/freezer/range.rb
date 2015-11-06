# encoding: utf-8

module IceNine
  class Freezer

    # Skip freezing Range objects on 1.8.7 for now
    class Range < NoFreeze; end

  end # Freezer
end # IceNine
