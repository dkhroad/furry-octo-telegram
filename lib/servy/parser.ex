defmodule Servy.Parser do 
  alias Servy.Conv
  def parse(request) do 
    [request_and_headers, body] = request |> String.split("\n\n")
    [request | headers] = String.split(request_and_headers,"\n")
    
    [method,path,_] = String.split(request," ")
    headers = parse_headers(headers,%{})
    params = parse_params(headers["Content-Type"],body)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: params
    }
  end

  defp parse_headers([head | tail],headers) do
    [key,value] = String.split(head,": ")
    headers = Map.put(headers,key,value)
    parse_headers(tail,headers)
  end

  defp parse_headers([],headers), do: headers

  defp parse_params("application/x-www-form-urlencoded",params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  defp parse_params(_,_), do: %{}

end
