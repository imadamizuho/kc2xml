# -*- coding: utf-8 -*-

# kc2xml.rb ver 0.20 [2011.8.26]

require 'nokogiri'

module KC2XML

def KC2XML.parse(file)
  xml = Nokogiri::XML::Document.new
  xml.encoding = 'UTF-8'
  xml << doc = xml.create_element('document')
  sen = chu = tag = tok = tokid = nil
  lines = open(file, 'r:eucjp-ms:utf-8'){|f| f.readlines}
  lines.each do |line|
    head, body = line.strip.split(' ', 2)
    case head
    when '#'
      attr = Hash.new
      sid, info = body.split(' ', 2)
      k, v = sid.split(':')
      attr[k] = v
      attr['info'] = info
      sen = xml.create_element('sentence', attr)
      doc << sen
      tokid = 0
    when '*'
      items = body.split(' ')
      attr = Hash.new
      attr['id'] = items[0]
      attr['link'] = items[1][0 .. -2]
      attr['rel'] = items[1][-1]
      chu = xml.create_element('chunk', attr)
      sen << chu
    when '+'
      items = body.split(' ', 3)
      attr = Hash.new
      attr['id'] = items[0]
      attr['link'] = items[1][0 .. -2]
      attr['rel'] = items[1][-1]
      tag = xml.create_element('tag', attr)
      tag.add_child items[2] if items[2]
      chu << tag
    when 'EOS'; # nothing to do
    else
      items = body.split(' ')
      attr = Hash.new
      attr['id'] = tokid
      attr['read'] = items[0]
      attr['base'] = items[1]
      attr['pos'] = items[2 .. 3].delete_if{|s| s == '*'}.join('-')
      attr['ctype'] = items[4]
      attr['cform'] = items[5]
      tok = xml.create_element('tok', head, attr)
      (tag or chu) << tok
      tokid += 1
    end
  end
  return doc.to_xml
end

def KC2XML.auto_conv(dir = '.', code = 'utf-8')
  Dir.mkdir('./xml') unless FileTest.directory?('./xml')
  Dir.mkdir("./xml/syn") unless FileTest.directory?("./xml/syn")
  Dir.mkdir("./xml/rel") unless FileTest.directory?("./xml/rel")
  for subdir in ['syn', 'rel']
    files = Dir.glob(File.join(dir, "dat/#{subdir}/*.KNP"))
    files.each do |file|
      STDERR.print file
      des = "./xml/#{subdir}/#{File.basename(file, '.KNP')}.xml"
      STDERR.puts ' -> ' + des
      open(des, 'w', :encoding => code){|f| f.puts parse(file)}
    end
  end
end

end

KC2XML.auto_conv *ARGV[0, 2] if $0 == __FILE__


# 修正履歴
# 2013.03.25 ver 0.21
#  - sentenceタグの属性をS-IDに限定。他はinfo属性として文字列で残す。
#    (一部のファイルが破損していたので)
# 2011.08.26 ver 0.20
#  - nokogiriを使って全面的に書き直し
#  - sentenceタグの属性は特に調整していない(今後はnokogiri使うつもりなので)
#  - 全角ダッシュの問題はeucjp-ms使ったら解決した。
# 2010.08.30 ver 0.10
#  - Ruby1.9で動くように全面的に書き直し
# 2008.06.02 ver 0.03
#  - MSXMLでparse Errorしないように調整
#    (sentenceタグの属性をS-ID、KNP、MOD、MEMOに限定)
#  - posが「判定詞-*」とかなってたのを「判定詞」に修正
#  - kconvをiconvに差し替え（全角ダッシュがうまく変換されてなかったので）
# 2008.02.18 ver 0.02 tokの属性がずれていたのを修正
# 2008.02.13 ver 0.01