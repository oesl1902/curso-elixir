defmodule MailMessage do

  @moduledoc """
  Mensaje del servidor de correos
  """

  @enforce_keys [:to, :subject, :content]
  defstruct [:from, :to, :subject, :content]

  @doc """
  Crea un nuevo mensaje para ser enviado en el servidor de correos.

  ## Parameters
  - `from`: String, username del usuario remitente (requerido)
  - `to`: String, username del usuario destinatario (requerido)
  - `subject`: String, Asunto del correo (requerido)
  - `content`: String, Contenido del correo (requerido)

  ## Returns
  - `%MailMessage{}`: Una nuevo struct del MailMessage

  ## Examples
      iex> message1 = MailMessage.new("oscar123","santiago123","Entregable semana 5","El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir")
      %MailMessage{
        from: "oscar123",
        to: "santiago123",
        subject: "Entregable semana 5",
        content: "El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir"
      }

      iex> message2 = MailMessage.new("santiago123","oscar123","RE:Entregable semana 5","Entregable recibido")
      %MailMessage{
        from: "santiago123",
        to: "oscar123",
        subject: "RE:Entregable semana 5",
        content: "Entregable recibido"
      }
  """
  def new(from, to, subject, content) do
    struct!(__MODULE__, [from: from, to: to, subject: subject, content: content])
  end


  @doc """
  Crea un nuevo mensaje para ser enviado en el servidor de correos.

  ## Parameters
  - `to`: String, username del usuario destinatario (requerido)
  - `subject`: String, Asunto del correo (requerido)
  - `content`: String, Contenido del correo (requerido)

  ## Returns
  - `%MailMessage{}`: Una nuevo struct del MailMessage

  ## Examples
      iex> message1 = MailMessage.new("santiago123","Entregable semana 5","El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir")
      %MailMessage{
        from: nil,
        to: "santiago123",
        subject: "Entregable semana 5",
        content: "El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir"
      }

      iex> message2 = MailMessage.new("oscar123","RE:Entregable semana 5","Entregable recibido")
      %MailMessage{
        from: nil,
        to: "oscar123",
        subject: "RE:Entregable semana 5",
        content: "Entregable recibido"
      }
  """
  def new(to, subject, content) do
    struct!(__MODULE__, [to: to, subject: subject, content: content])
  end
end

defimpl String.Chars, for: MailMessage do
  def to_string(message) do
    """
    De: #{message.from}
    Para: #{message.to}
    Asunto: #{message.subject}
    Contenido: #{message.content}
    """
  end
end
