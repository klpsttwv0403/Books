defmodule Books.Parser do
    @moduledoc """
    分隔符為半形逗號的csv parser
    """

    @doc """
    data: a text file may contain many lines
    return a list of tuples (one tuple = one line in csv file)
    """
    def parse(data) do
        records = String.split(data, "\n", trim: true)
        history_info = parse_records(records)

        {:ok, history_info}
    end

    defp parse_records(records) do
        # records: a list of strings (line)
        # return a list of tuples
        
        records
        |> Enum.map(fn record -> String.split(record, ",") end)
        |> Enum.map(&create_history_info/1)
    end

    defp create_history_info([date, title, author]) do
        # convert date from String to Date data.
        # then build a tuple

        {string_to_date(date), title, author}
    end

    defp string_to_date(date) do
        # convert date from String to Date data.
        # ex: "2019-04-02" -> ~D[2019-04-02]

        [year, month, day] = 
            date
            |> String.split("-")
            |> Enum.map(&String.to_integer/1)
        
        {:ok, date_struct} = Date.new(year, month, day)
        date_struct
    end
end