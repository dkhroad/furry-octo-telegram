defmodule Servy.Parser do 
  alias Servy.Conv
  def parse(request) do 
    [request_and_headers, body] = request |> String.split("\n\n")
    [request | headers_lines] = String.split(request_and_headers,"\n")
    
    [method,path,_] = String.split(request," ")
    headers = parse_headers(headers_lines)
    # headers = parse_headers(headers_lines,%{})
    params = parse_params(headers["Content-Type"],body)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: params
    }
  end

  defp parse_headers(header_lines) do 
    Enum.reduce(header_lines,%{},fn(header_line,headers_so_far) -> 
     [key,value] = String.split(header_line,": ")
     Map.put(headers_so_far,key,value)
    end)
  end

  defp parse_params("application/x-www-form-urlencoded",params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  defp parse_params(_,_), do: %{}

end
