defmodule PasswordGenerator do
  @alphanumeric "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  @special "!@#^&*();?:"
  
  def generate(length, special \\ false) when is_integer(length) and length > 0 do
      characters = @alphanumeric <> if special, do: @special, else: ""
      password =
        for _ <- 1..length, do: Enum.random(String.codepoints(characters))
        Enum.join(password, "")
  end
end

defmodule PasswordManager do
  @filename "passwords.txt" #File where the last password is saved

  def run do
    IO.puts("How many characters should your password have?")
    number = String.to_integer(String.trim(IO.gets("")))

    IO.puts("Include special characters? (yes/no)")
    special = String.trim(IO.gets(""))

    result =
      case special do
        "yes" -> PasswordGenerator.generate(number, true)
        "no" -> PasswordGenerator.generate(number, false)
        _ -> IO.puts("\e[H\e[2J")
          IO.puts("Error, please respect the syntax... (yes/no)")
          PasswordManager.run()
      end

    IO.puts("--------------------\n      #{result}    \n--------------------")

    IO.puts("Do you want to save it? (yes/no)")
    case IO.gets("") |> String.trim do
      "yes" -> 
        unless File.exists?(@filename) do
          File.write!(@filename, "")
        end
        File.write!(@filename, result)
        IO.puts("Registration in #{@filename}..")
      "no" -> :ok
      _ -> IO.puts("Password not saved, please respect the syntax... (yes/no)")
    end
  end
end

PasswordManager.run()
