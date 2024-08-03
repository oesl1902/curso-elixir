defmodule MailServer do
  @moduledoc """
  Módulo que representa una revista que maneja suscriptores y notificaciones de nuevas publicaciones.
  """

  @doc """
  Inicia el proceso de la revista.
  """
  def start do
    spawn(fn -> loop([]) end)
  end

  @doc """
  Registra un nuevo usuario al servidor de correos

  ## Parámetros
  - `mail_server_pid`: PID del proceso del servidor de correos.
  - `mail_username`: nombre del usuario en el servidor de correos.
  - `mail_username`: PID del proceso del usuario.
  """
  def register_user(mail_server_pid, mail_username, mail_user_pid) do
    send(mail_server_pid, {:register_user, mail_username, mail_user_pid})
  end

  @doc """
  Publica un nuevo número de la revista.

  ## Parámetros
  - `mail_server_pid`: PID del proceso del servidor de correos.
  - `message`: Mensaje a enviar
  - `receiver_username`: Nombre del usuario a enviar el mensaje
  """
  def send_mail(mail_server_pid, message, receiver_username) do
    send(mail_server_pid, {:send_mail, message, receiver_username})
  end

  @doc false
  defp loop(mail_users) do
    receive do
      {:register_user, mail_username, mail_user_pid} ->
        IO.puts("New user registered")
        loop([{mail_username, mail_user_pid} | mail_users])

      {:send_mail, message, receiver_username} ->

        receiver_user = Enum.find(mail_users, fn {username, _} ->
          username == receiver_username
        end)

        cond do
          receiver_user == nil ->
            IO.puts("User #{receiver_username} not found")

          true ->
            {_, user_pid} = receiver_user
            IO.puts("Sending message to: #{receiver_username}...")
            :timer.sleep(1000)
            send(user_pid, {:new_message, message})
        end

        loop(mail_users)

      _ ->
        IO.puts("Invalid Message")
        loop(mail_users)
    end
  end
end

defmodule MailUser do
  @moduledoc """
  Módulo que representa a un usuario en el servidor de correos.
  """

  @doc """
  Inicia un proceso de un usuario.

  ## Parámetros
  - `username`: Nombre del usuario.
  """
  def start(username) do
    spawn(fn -> loop(username) end)
  end

  @doc false
  def loop(username) do
    receive do
      {:new_message, message} ->
        IO.puts("#{username} you have received a new message")
        print_message(message)
        loop(username)

      _ ->
        IO.puts("Invalid Message")
        loop(username)
    end
  end

  def print_message({sender, subject, content}) do
    IO.puts("From: #{sender}")
    IO.puts("Subject: #{subject}")
    IO.puts("Content: #{content}")
  end
end

# Ejemplo de uso
# mail_server_pid = MailServer.start()

# mail_user_1 = MailUser.start("oscar123")
# mail_user_2 = MailUser.start("santiago321")

# MailServer.register_user(mail_server_pid, "oscar123", mail_user_1)
# MailServer.register_user(mail_server_pid, "santiago321", mail_user_2)

# MailServer.send_mail(mail_server_pid,{"oscar123","Entregable semana 4", "El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir"}, "santiago321")
# MailServer.send_mail(mail_server_pid,{"santiago321","RE:Entregable semana 4", "Entregable recibido"}, "oscar123")
