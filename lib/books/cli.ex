defmodule Books.CLI do

    alias Books.Parser
    alias Books.Info

    def main(args) do
        # get file path from command line arguments
        {:ok, path} = parse_args(args)

        # get file content from file path
        {:ok, data} = open_file(path)

        # build record struct from file content
        {:ok, history_info} = Parser.parse(data)

        # gather information and formatting print out message.
        history_info
        |> Info.detail
        |> Info.print_detail
        |> IO.puts

    end

    defp parse_args([history_file]) do
        # history_file: a string wrapping in list
        # ex: ["history.csv"]

        if File.exists?(history_file) do
            {:ok, history_file}
        else
            {:error, "file doesn't exist."}
        end
    end

    defp open_file(path) do
        # path: string
        # ex: "history.csv"

        {:ok, data} = File.read(path)
        {:ok, data}
    end

end