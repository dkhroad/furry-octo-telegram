require Logger

defmodule Servy.Handler do

  @pages_path  Path.expand("../../pages",__DIR__) 

  import Servy.Plugins, only: [log: 1, track: 1, rewrite_path: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  
  alias Servy.Conv
  alias Servy.BearController

  def handle(request) do
    request |> parse |> rewrite_path |> log |> route |> track |> format_response
  end

  def route(%Conv{method:  "GET", path: "/pages/" <> file} = conv) do
    @pages_path 
    |> Path.join("#{file}.html")
    |> File.read 
    |> handle_file(conv)
  end

  def route(%Conv{method:  "GET", path: "/bears/new"} = conv) do
    Path.expand("../../pages",__DIR__) 
                |> Path.join("form.html")
                |> File.read 
                |> handle_file(conv)
  end

  def route(%Conv{method:  "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do 
    BearController.create(conv,conv.params)
  end

  def route(%Conv{method:  "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params,"id", id)
    BearController.show(conv,params)
  end

  def route(%Conv{method:  "GET", path: "/bears?id=" <> id} = conv) do
    %Conv{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method:  "DELETE",path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params,"id", id)
    BearController.delete(conv,params)
  end
    
  def route(%Conv{} = conv) do
    %Conv{conv | status: 404, resp_body: "Not found"}
  end

  def format_response(%Conv{} = conv) do 
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)} 

    #{conv.resp_body} 
    """
  end

  def emojify(%{status: 200} = conv) do
    emojies = String.duplicate("🎉",5)
    body = emojies <> "\n" <> conv.resp_body <> "\n" <> emojies
    %{conv | resp_body: body }
  end

  def emojify(conv), do: conv



end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp
request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
resp = Servy.Handler.handle(request)
IO.puts resp
