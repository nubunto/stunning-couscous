defmodule Collector.Parser do
  def parse(data) do
    # data = to_char_list(data)
    # %Collector.Message{version: Enum.take(data, 2), message: data}
    data = :binary.bin_to_list(data)
    %Collector.Message{}
    |> parsep(data, :version, 0, 2)
    |> parsep(data, :nsu, 2, 6)
    |> parsep(data, :terminal, 8, 8)
    |> parsep(data, :external_device, 16, 2)
    |> parsep(data, :origin_destiny, 18, 1)
    |> parsep(data, :tid, 19, 20)
    |> parsep(data, :filler, 39, 11)
    |> parsep(data, :message_length, 50, 4)
    |> parsep(data, :message, 54, 4042)
  end

  defp parsep(map, data, :message_length, start, count) do
    case data |> Enum.slice(start, count) |> List.to_string() |> Integer.parse(10) do
      {message_length, _} -> Map.put(map, :message_length, message_length)
      _                   -> Map.put(map, :message_length, 0)
    end
  end

  defp parsep(map, data, :origin_destiny, start, count) do
    case Enum.slice(data, start, count) do
      '1' -> Map.put(map, :origin_destiny, :received)
      '2' -> Map.put(map, :origin_destiny, :sent)
      '3' -> Map.put(map, :origin_destiny, :receive_send)
      _  -> Map.put(map, :origin_destiny, :unknown)
    end
  end

  defp parsep(map, data, :external_device, start, count) do
    case Enum.slice(data, start, count) do
      '01' -> Map.put(map, :external_device, :ecommerce)
      '02' -> Map.put(map, :external_device, :hsm)
      '20' -> Map.put(map, :external_device, :visa)
      '21' -> Map.put(map, :external_device, :mastercard)
      '22' -> Map.put(map, :external_device, :elo)
      '23' -> Map.put(map, :external_device, :diners)
      '24' -> Map.put(map, :external_device, :amex)
      '40' -> Map.put(map, :external_device, :mov)
      _  -> Map.put(map, :external_device, :unknown)
    end
  end

  defp parsep(map, data, key, start, count) do
    Map.put(map, key, Enum.slice(data, start, count))
  end
end
