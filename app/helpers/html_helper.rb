module HtmlHelper
  def stylesheet(filename)
    %Q[<link rel="stylesheet" href="/#{filename}.css" />]
  end

  def javascript(filename)
    %Q[<script type="text/javascript" src="/#{filename}.js"></script>]
  end

  def empty_link(text, properties={})
    %Q[<a #{attributes_from_hash(properties.merge(:href => "javascript:void(0);"))}>#{text}</a>]
  end

  def attributes_from_hash(properties)
    properties.map { |key, value| %Q[#{key}="#{value}"] }.join(" ")
  end
end
