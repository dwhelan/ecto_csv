defmodule EctoCSV.Schema do

  defmacro __using__(_opts) do
    quote do
      import unquote __MODULE__
      use Ecto.Schema

      # Set up defaults
      header     true
      delimiter  ","
   end
  end

  defmacro csv(do: block) do
    quote do
      unquote(block)
      csv()
    end
  end

  defmacro csv do
    quote do
      Module.eval_quoted __ENV__, EctoCSV.Schema.__csv__(@csv_header, @csv_delimiter)
    end
  end

  def __csv__(header, delimiter) do
    quote do
      def __csv__(:header),           do: unquote(header)
      def __csv__(:file_has_header?), do: unquote(header != false)
      def __csv__(:headers),          do: __MODULE__.__schema__(:fields) |> Enum.filter(&(&1 != :id))
      def __csv__(:delimiter),        do: unquote(delimiter)
    end
  end

  defmacro header(header) do
    quote do
      Module.put_attribute __MODULE__, :csv_header, unquote(header)
    end
  end

  defmacro delimiter(delimiter) do
    unless is_binary(delimiter) do
      raise ArgumentError, "delimiter '#{delimiter}' is invalid. It must be a string enclosed in double quotes"
    end

    if String.length(delimiter) > 1 do
      raise ArgumentError, "delimiter '#{delimiter}' cannot be more than one character"
    end

    quote do
      Module.put_attribute __MODULE__, :csv_delimiter, unquote(delimiter)
    end
  end
end
