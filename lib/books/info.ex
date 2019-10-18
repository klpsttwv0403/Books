defmodule Books.Info do
    @moduledoc """
    提供統計閱讀最多的作者資訊與所閱讀過的該作者的作品
    以及格式化輸出閱讀歷史紀錄.

    example output:

    從 2019/03/01 到 2019/10/1，這 215 天中您共閱讀了 8 本書籍。
    
    您的閱讀紀錄(由新到舊)：
    2019/10/01  天氣之子    新海誠
    2019-04-02  哈利波特(2) J.K. Rowling
    2019-04-01  哈利波特(1) J.K. Rowling

    J.K. Rowling 是您閱讀最多的作者，您讀過該作者 2 本書籍

    上次閱讀距今已 14 天，是否有正在閱讀的書籍尚未完成？
    (
        上次閱讀距今已 30 天，是否該找一本書來閱讀了？
        上次閱讀距今已 7 天，如果不知道想讀什麼不如去圖書館晃晃？
    )
    """

    @doc """
    從history取出資訊存在map內

    history_from_newest: 按日期新到舊排序history
    newest: 最新紀錄的日期,
    oldest: 最舊紀錄的日期,
    amount: 總共幾筆紀錄,
    favorite: 最多紀錄的作者,
    favorite_count: 最多紀錄的作者的閱讀數
    """
    def detail(history_info) do
        
        {newest, _, _} = List.last(history_info)
        {oldest, _, _} = List.first(history_info)
        {favorite, favorite_count} = count_favorite(history_info)

        %{
            history_from_newest: Enum.reverse(history_info),
            newest: newest,
            oldest: oldest,
            amount: length(history_info),
            favorite: favorite,
            favorite_count: favorite_count
        }
    end

    @doc """
    格式化輸出，details為map，內容參考detail
    """
    def print_detail(details) do
        "\n從 #{details.oldest} 到 #{details.newest}，這 #{Date.diff(details.newest, details.oldest) + 1} 天中您共閱讀了 #{details.amount} 本書籍"
        <> "\n\n" <>
        "您的閱讀紀錄(由新到舊)："
        <> "\n" <>
        "#{format_history(details.history_from_newest)}"
        <> "\n\n" <>
        "#{details.favorite} 是您閱讀最多的作者，您讀過該作者 #{details.favorite_count} 本書籍"
        <> "\n\n" <>
        "上次閱讀距今已 #{Date.diff(Date.utc_today, details.newest)} 日，#{format_last_reading(Date.diff(Date.utc_today, details.newest))}"
        <> "\n"
    end

    defp count_favorite(history_info) do
        # 計算出現最多次的作者與次數，(尚未實現)若次數相同則皆顯示

        {favorite, freq_list} = 
            history_info
            |> Enum.map(fn {_, _, author} -> author end)
            |> Enum.group_by(&(&1), fn _ -> 1 end)
            |> Enum.max_by(fn {_, freq_list} -> length(freq_list) end)
        {favorite, length(freq_list)}
    end

    defp format_history(history_info) do
        history_info
        |> Enum.map(fn {date, title, author} -> Date.to_string(date) <> "\t" <> String.pad_trailing(title, 38 - String.length(title)) <> "\t" <> author end)
        |> Enum.join("\n")
    end

    defp format_last_reading(last_until_today) do
        cond do
            last_until_today <= 7 ->
                "如果不知道想讀什麼不如去圖書館晃晃？"
            last_until_today <= 14 ->
                "是否有正在閱讀的書籍尚未完成？"
            last_until_today > 14 ->
                "是否該找一本書來閱讀了？"
        end
    end

end