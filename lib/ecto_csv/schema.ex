defmodule EctoCSV.Schema do

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import unquote __MODULE__

      # Set up defaults
      header        true
      separator     ","
      delimiter     "\r\n"
      extra_columns :retain
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
      Module.eval_quoted __ENV__, EctoCSV.Schema.__csv__(@csv_header, @csv_separator, @csv_delimiter, @csv_extra_columns)
    end
  end

  def __csv__(header, separator, delimiter, extra_columns) do
    quote do
      def __csv__(:header),           do: unquote(header)
      def __csv__(:file_has_header?), do: unquote(header != false)
      def __csv__(:headers),          do: __MODULE__.__schema__(:fields) |> Enum.filter(&(&1 != :id))
      def __csv__(:separator),        do: unquote(separator)
      def __csv__(:delimiter),        do: unquote(delimiter)
      def __csv__(:extra_columns),    do: unquote(extra_columns)
    end
  end

  defmacro header(header) do
    quote do
      Module.put_attribute __MODULE__, :csv_header, unquote(header)
    end
  end

  defmacro delimiter(delimiter) do
    unless delimiter == "\n" or delimiter == "\r\n" do
      raise ArgumentError, ~s[delimiter is invalid. It must be either "\\n" or "\\r\\n"]
    end
    
    quote do
      Module.put_attribute __MODULE__, :csv_delimiter, unquote(delimiter)
    end
  end

  defmacro separator(separator) do
    unless is_binary(separator) do
      raise ArgumentError, "separator '#{separator}' is invalid. It must be a string enclosed in double quotes"
    end

    if String.length(separator) > 1 do
      raise ArgumentError, "separator '#{separator}' cannot be more than one character"
    end

    quote do
      Module.put_attribute __MODULE__, :csv_separator, unquote(separator)
    end
  end

  defmacro extra_columns(extra_columns) do
    quote do
      Module.put_attribute __MODULE__, :csv_extra_columns, unquote(extra_columns)
    end
  end
end
