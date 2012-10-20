module HtmlHelper
  def stylesheet(filename)
    %Q[<link rel="stylesheet" href="/#{filename}.css" />]
  end

  def javascript(filename)
    %Q[<script type="text/javascript" src="/#{filename}.js"></script>]
  end

  def image(filename, properties={})
    attributes = attributes_from_hash(properties.merge(:src => "/images/#{filename}"))
    %Q[<img #{attributes} />]
  end

  def empty_link(text, properties={})
    attributes = attributes_from_hash(properties.merge(:href => "javascript:void(0);"))
    %Q[<a #{attributes}>#{text}</a>]
  end

  def attributes_from_hash(properties)
    properties.map { |key, value| %Q[#{key}="#{value}"] }.join(" ")
  end
end
