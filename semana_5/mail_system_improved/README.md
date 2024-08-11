# MailSystemImproved

Este proyecto contiene el último entregable del curso de programación con Elixir.

## Compilación

User el comando en el directorio semana_5/mail_system_improved/
```
iex -S mix
```

## Ejecución

Para iniciar el servidor de correos:

```elixir
iex> MailServer.start_server()
```

Para crear un nuevo usuario y registrarlo en el servidor de correos:
```elixir
iex> user1 = MailUser.new("nombreusuario","Nombre Apellido")
```

Para crear un nuevo mensaje para que pueda ser enviado a través del servidor de correos:
```elixir
iex> message1 = MailMessage.new("usuarioRemitente","usuarioDestinatario","Asunto","Contenido del mensaje")
```

Para enviar un mensaje a través del servidor de correos:
```elixir
iex> MailUser.send_message(message1)
```

Ejemplo:
```elixir
iex> MailServer.start_server()

iex> user1 = MailUser.new("oscar123","Oscar Eduardo Sanchez")
iex> user2 = MailUser.new("santiago123","Santiago Posada")
iex> user3 = MailUser.new("johnd02","John Doe")

iex> message1 = MailMessage.new("oscar123","santiago123","Entregable semana 5","El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir")
iex> MailUser.send_message(message1)

iex> message2 = MailMessage.new("santiago123","oscar123","RE:Entregable semana 5","Entregable recibido")
iex> MailUser.send_message(message2)

iex> message3 = MailMessage.new("johnd02","santiago123","Duda entregable","Hola, dónde puedo encontrar ejemplos")
iex> MailUser.send_message(message3)

iex> message4 = MailMessage.new("santiago123","johnd02","RE:Duda entregable","Hola, en el repo https://github.com/santiagoposadag/Curso_BCB_Elixir_semana5-pt1")
iex> MailUser.send_message(message4)
```

