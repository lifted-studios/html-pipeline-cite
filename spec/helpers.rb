#
# Copyright (c) 2013 by Lifted Studios.  All Rights Reserved.
#

require 'nokogiri'

class String
  # Creates an HTML document fragment out of the string's contents and returns the nodes with the matching tags.
  # 
  # @param [String] tag Tag to search for.
  # @return Set of nodes that match the given tag.
  def node(tag)
    Nokogiri::make("<div>#{self}</div>").xpath(".//#{tag}")
  end
end

# Reads a test data file.
# 
# The path passed to the function is treated as relative to the `spec/data` directory.
# 
# @param path Path to the test file.
# @return Text in the file.
def read_test_file(path)
  path = File.join('spec/data', path)
  IO.read(path)
end
