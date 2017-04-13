defmodule Hobot.In.TwitterStreaming do
  @moduledoc """
  Documentation for Hobot.In.TwitterStreaming.
  """

  @doc"""
  Publishes tweets to Hobot's topic.
  """
  @spec publish() :: no_return
  def publish do
    oauth = Application.fetch_env!(:hobot_in_twitter_streaming, :oauth)
    param =
      Application.fetch_env!(:hobot_in_twitter_streaming, :param)
      |> reject_blank_param
    topic = Application.fetch_env!(:hobot_in_twitter_streaming, :topic)

    ExTwitter.configure(:process, oauth)
    for tweet <- ExTwitter.stream_filter(param, :infinity), do: Hobot.publish(topic, tweet)
  end

  @doc"""
  Rejects blank params.

  A blank param means that a value is nil or "" (an empty string).

  ## Examples

      iex> Hobot.In.TwitterStreaming.reject_blank_param([follow: "somepeople", track: ""])
      [follow: "somepeople"]

      iex> Hobot.In.TwitterStreaming.reject_blank_param([follow: nil, track: "coolthing"])
      [track: "coolthing"]

      iex> Hobot.In.TwitterStreaming.reject_blank_param([follow: "somepeople", track: "coolthing"])
      [follow: "somepeople", track: "coolthing"]

  """
  @spec reject_blank_param(keyword(String.t) | keyword(nil)) :: keyword(String.t)
  def reject_blank_param(param) do
    for {k, v} <- param,
        not (is_nil(v) or (v === "")) do
      {k, v}
    end
  end
end
