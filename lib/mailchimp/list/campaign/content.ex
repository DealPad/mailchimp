defmodule Mailchimp.Campaign.Content do
  alias Mailchimp.Link
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient

  defstruct [
    :variate_contents,
    :plain_text,
    :html,
    :archive_html,
    :links
  ]

  def new(attributes) do
    %__MODULE__{
      variate_contents: attributes[:variate_contents],
      plain_text: attributes[:plain_text],
      html: attributes[:html],
      archive_html: attributes[:archive_html],
      links: Link.get_links_from_attributes(attributes)
    }
  end

  def update(campaign_id, attrs \\ %{}) do
    {:ok, response} = HTTPClient.put("/campaigns/#{campaign_id}/content", Jason.encode!(attrs))

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def update!(campaign_id, attrs \\ %{}) do
    {:ok, content} = update(campaign_id, attrs)
    content
  end
end
