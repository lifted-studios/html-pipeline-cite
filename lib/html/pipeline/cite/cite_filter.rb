# 
# Copyright (c) 2012-2013 by Lifted Studios.  All Rights Reserved.
# 

require 'html/pipeline'
require 'nokogiri'

module HTML
  class Pipeline
    # An `HTML::Pipeline` filter that collects references in the text and inserts a table of footnotes where instructed.
    # 
    # Example:
    # 
    #     <ref>This is a footnote</ref>
    # 
    # Becomes:
    # 
    #     <sup class="reference" id="wiki-cite_ref-1">[<a href="#wiki-cite_note-1">1</a>]</sup>
    # 
    # It will show up as a bracketed, superscripted and anchored number at that location in the text.  Then when 
    # `<references/>` is placed in the text, an ordered list of the references and their text will be placed at that
    # location.  The example above would generate a list that looks like this:
    # 
    #     <ol>
    #       <li id="wiki-cite_note-1"><b><a href="#wiki-cite_ref-1">^</a></b> This is a footnote.</li>
    #     </ol>
    # 
    class CiteFilter < Filter
      # ID of the note
      NOTE = 'wiki-cite_note'

      # ID of the ref
      REF = 'wiki-cite_ref'

      # Replaces ref and references tags with the appropriate HTML and returns the result.
      # 
      # @return [Nokogiri::HTML::DocumentFragment] Updated HTML document fragment.
      def call
        refs = replace_refs
        replace_references(refs)

        doc
      end

      private

      # Creates the link text for the ref node.
      # 
      # @param [Integer] index Index of the item.
      # @return [String] Link text for the ref node replacement.
      def create_ref_link(index)
        %Q([<a href="##{NOTE}-#{index}">#{index}</a>])
      end

      # Creates the HTML to replace the ref node in the document.
      # 
      # @param [Nokogiri::XML::Node] node  Node in the document we are working with.
      # @param [Integer]             index Index of the item.
      # @return [Nokogiri::XML::Node] Node to replace the `ref` node.
      def create_ref_node(node, index)
        ref_node = node.document.create_element('sup', :class => 'reference', :id => "#{REF}-#{index}")
        ref_node.inner_html = create_ref_link(index)
        ref_node
      end

      # Creates the list items text.
      # 
      # @param [Array] refs Text to place in the list items.
      # @return [String] List items text.
      def create_references_list_items(refs)
        refs.each_with_index.reduce('') do |inner_html, args|
          note = args.first
          num = args[1] + 1
          inner_html << %Q(<li id="#{NOTE}-#{num}"><b><a href="##{REF}-#{num}">^</a></b> #{note}</li>\n)
        end
      end

      # Replaces ref tags with the appropriate HTML and returns the set of reference texts.
      #
      # @return [Array] List of texts from the `ref` tags.
      def replace_refs
        doc.xpath('.//ref').each_with_index.map do |node, index|
          text = node.inner_html

          ref_node = create_ref_node(node, index + 1)
          node.replace(ref_node)

          text
        end
      end

      # Replaces references tags with the appropriate HTML.
      # 
      # @param [Array] refs List of reference texts.
      # @return [nil]
      def replace_references(refs)
        set = doc.xpath('.//references')

        if set
          inner_html = create_references_list_items(refs)
          replace_references_node(set, inner_html)
        end

        nil
      end

      # Replaces the references nodes with the ordered list.
      # 
      # @param [Nokogiri::XML::NodeSet] set        Set of `references` nodes.
      # @param [String]                 inner_html Inner HTML to use for the list.
      # @return [nil]
      def replace_references_node(set, inner_html)
        set.each do |references_node|
          ol_node = references_node.document.create_element "ol"
          ol_node.inner_html = inner_html
          references_node.parent.replace(ol_node)
        end

        nil
      end
    end
  end
end
