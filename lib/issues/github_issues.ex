# use a module attribute to fetch the value at compile time

defmodule Issues.GithubIssues do
  @github_url Application.get_env(:issues, :github_url)
  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end
  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  @doc """
      ## Example
      iex> data = [21,1,2,66,7,90]
      iex> Issues.GithubIssues.sort_a_list(data)
      [1,2,7,21,66,90]
  """
  def sort_a_list(l) do
    Enum.sort(l)
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code
      |> check_for_error(),
      body
      |> Poison.Parser.parse!()
    }
  end
  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end