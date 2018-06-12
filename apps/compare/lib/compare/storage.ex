defmodule Compare.Storage do
  @moduledoc """
  Storage handles all filesystem operations for the application
  """

  @root "data"

  @doc """
  Checks if the file exists
  """
  def exists?(user) do
    File.exists?(construct_path(user))
  end

  @doc """
  Saves user data to the file system
  """
  def persist(file_data, user) do
    File.mkdir_p(@root)
    File.write(construct_path(user), file_data)
  end

  @doc """
  Reads user data from the file system
  """
  def read(user) do
    File.read(construct_path(user))
  end

  defp construct_path(user) do
    Path.join([@root, user])
  end
end
