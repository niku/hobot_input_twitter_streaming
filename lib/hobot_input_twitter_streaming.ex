defmodule Hobot.Input.TwitterStreaming do
  @moduledoc """
  Documentation for Hobot.Input.TwitterStreaming.
  """

  use GenServer

  def start_link({_oauth, _param, _topic} = args, options \\ []) do
    GenServer.start_link(__MODULE__, args, options)
  end

  def init({oauth, param, topic}) do
    {:ok, stream} = Task.start_link(__MODULE__, :publish, [oauth, param, topic])
    {:ok, {oauth, param, topic, stream}}
  end

  @doc"""
  Publishes tweets to Hobot's topic.
  """
  @spec publish(keyword(String.t), keyword(String.t), keyword(String.t)) :: no_return
  def publish(oauth, param, topic) do
    param = reject_blank_param(param)

    ExTwitter.configure(:process, oauth)
    for tweet <- ExTwitter.stream_filter(param, :infinity), do: Hobot.publish(topic, tweet)
  end

  @doc"""
  Rejects blank params.

  A blank param means that a value is nil or "" (an empty string).

  ## Examples

      iex> Hobot.Input.TwitterStreaming.reject_blank_param([follow: "somepeople", track: ""])
      [follow: "somepeople"]

      iex> Hobot.Input.TwitterStreaming.reject_blank_param([follow: nil, track: "coolthing"])
      [track: "coolthing"]

      iex> Hobot.Input.TwitterStreaming.reject_blank_param([follow: "somepeople", track: "coolthing"])
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
