defmodule EctoCSV.Schema do

  defmacro __using__(_opts) do
    quote do
      import unquote __MODULE__
      use Ecto.Schema

      # Set up defaults
      header     true
      separator  ","
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
      Module.eval_quoted __ENV__, EctoCSV.Schema.__csv__(@csv_header, @csv_separator)
    end
  end

  def __csv__(header, separator) do
    quote do
      def __csv__(:header),           do: unquote(header)
      def __csv__(:file_has_header?), do: unquote(header != false)
      def __csv__(:headers),          do: __MODULE__.__schema__(:fields) |> Enum.filter(&(&1 != :id))
      def __csv__(:separator),        do: unquote(separator)
    end
  end

  defmacro header(header) do
    quote do
      Module.put_attribute __MODULE__, :csv_header, unquote(header)
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
end
