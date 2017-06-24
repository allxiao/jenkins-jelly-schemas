#!/usr/bin/env ruby
# -*- utf-8 -*-

require 'nokogiri'

raise "No directory specified." if ARGV.size < 1
DIRECTORY = ARGV[0]
raise "Argument specified is not a directory." if not File.directory?(DIRECTORY)

FILES = Dir[File.join(DIRECTORY, "*.jelly")]
raise "No jelly file found in directory #{DIRECTORY}" if FILES.size < 1

class Attribute
  attr_accessor :name, :doc, :use
  def self.from_node node
    attrib = Attribute.new
    attrib.name = node['name']
    attrib.doc = node.text
    attrib.use = node['use']
    attrib
  end
end

dirname = File.basename(DIRECTORY)

out = File.open(dirname + '.xsd', 'w')

out.puts <<-HEAD
<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="#{dirname}" elementFormDefault="qualified">
    <xsd:annotation>
        <xsd:documentation>
            TODO: Fill in documenation
        </xsd:documentation>
    </xsd:annotation>
HEAD

FILES.each do |file|
  doc = Nokogiri::XML(open(file).read)

  namespace_map = doc.namespaces.to_a.map(&:reverse).map{|k, v| [k, v[/:([^:]+)$/, 1]]}.to_h

  ns_j = namespace_map['jelly:core'] || 'j'
  ns_st = namespace_map['jelly:stapler'] || 'st'

  puts "Parsing #{file}..."

  name = File.basename(file, '.jelly')
  documentation = doc.css("#{ns_j}|jelly #{ns_st}|documentation").first rescue nil
  tag_doc = documentation.nil? ? "" : documentation
    .children
    .select{|x| Nokogiri::XML::Text === x}
    .map{|x| x.text.strip}
    .reject(&:empty?)
    .first
    .split(/\s*\r?\n\s*/)
    .join("\n                ")
    .encode(xml: :text) rescue ''
  attributes = documentation.nil? ? [] : documentation.css("#{ns_st}|attribute").map{|node| Attribute.from_node(node)}

  out.puts <<-HEAD

    <xsd:element name="#{name}">
        <xsd:annotation>
            <xsd:documentation>
                #{tag_doc}
            </xsd:documentation>
        </xsd:annotation>
        <xsd:complexType mixed="true">
            <xsd:sequence>
                <xsd:any processContents="lax" minOccurs="0" maxOccurs="unbounded"/>
            </xsd:sequence>
  HEAD

  attributes.each do |attrib|
    use = attrib.use.nil? ? "" : " use=\"#{attrib.use}\""
    out.puts <<-ATTR
            <xsd:attribute name="#{attrib.name}"#{use}>
                <xsd:annotation>
                    <xsd:documentation>#{attrib.doc}</xsd:documentation>
                </xsd:annotation>
            </xsd:attribute>
    ATTR
  end

  out.puts <<-TAIL
        </xsd:complexType>
    </xsd:element>
  TAIL
end

out.puts "</xsd:schema>"
