require Logger

defmodule Servy.Plugins do

  alias Servy.Conv

  def log(%Conv{} = conv), do: IO.inspect conv

  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warn "Warning #{path} is on the loose"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex,path)
    rewrite_path_captures(conv,captures)
  end

  def rewrite_path(%Conv{} = conv), do: conv
  
  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %Conv{conv | path: "#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv,nil), do: conv

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %Conv{conv | path: "#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv,nil), do: conv
end
