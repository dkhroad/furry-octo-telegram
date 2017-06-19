defmodule Servy.BearController do
  
  alias Servy.Conv
  alias Servy.WildThings
  alias Servy.Bear

  def bear_item(bear) do 
    "<li>name: #{bear.name} - type #{bear.type}</li>"
  end

  def index(%Conv{} = conv) do 
    items = WildThings.list_bears() 
            |> Enum.filter(&Bear.is_grizzly/1) 
            |> Enum.sort(&Bear.order_asc_by_name/2) 
            |> Enum.map(&bear_item/1)
            |> Enum.join
    %Conv{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv,%{"id" => id} = params) do
    bear = WildThings.get_bear(id)
    IO.inspect bear
    %Conv{conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
  end

  def create(conv,%{"type" => type, "name" => name}= params) do 
    %Conv{conv | status: 201, 
                 resp_body: "Created a #{type} bear named #{name}!" }
  end

  def delete(%Conv{} = conv,_params) do
    %Conv{conv | status: 403, resp_body: "Deleting a bear is forbidden"}
  end
end
