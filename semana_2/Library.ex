defmodule Library do
  alias Hex.API.User

  defmodule Book do
    defstruct title: "", author: "", isbn: "", available: true
  end

  defmodule User do
    defstruct name: "", id: "", borrowed_books: []
  end

  def add_book(library, %Book{} = book) do
    library ++ [book]
  end

  def add_user(users, %User{} = user) do
    users ++ [user]
  end

  def borrow_book(library, users, user_id, isbn) do
    user = Enum.find(users, &(&1.id == user_id))
    book = Enum.find(library, &(&1.isbn == isbn && &1.available))

    cond do
      user == nil ->
        {:error, "Usuario no encontrado"}

      book == nil ->
        {:error, "Libro no disponible"}

      true ->
        updated_book = %{book | available: false}
        updated_user = %{user | borrowed_books: user.borrowed_books ++ [updated_book]}

        updated_library =
          Enum.map(library, fn
            b when b.isbn == isbn -> updated_book
            b -> b
          end)

        updated_users =
          Enum.map(users, fn
            u when u.id == user_id -> updated_user
            u -> u
          end)

        {:ok, updated_library, updated_users}
    end
  end

  def return_book(library, users, user_id, isbn) do
    user = Enum.find(users, &(&1.id == user_id))
    book = Enum.find(user.borrowed_books, &(&1.isbn == isbn))

    cond do
      user == nil ->
        {:error, "Usuario no encontrado"}

      book == nil ->
        {:error, "Libro no encontrado en los libros prestados del usuario"}

      true ->
        updated_book = %{book | available: true}

        updated_user = %{
          user
          | borrowed_books: Enum.filter(user.borrowed_books, &(&1.isbn != isbn))
        }

        updated_library =
          Enum.map(library, fn
            b when b.isbn == isbn -> updated_book
            b -> b
          end)

        updated_users =
          Enum.map(users, fn
            u when u.id == user_id -> updated_user
            u -> u
          end)

        {:ok, updated_library, updated_users}
    end
  end

  def list_books(library) do
    IO.puts("Libros:")
    Enum.each(library, fn book ->
      print_book(book)
      IO.puts("")
    end)
  end

  def list_available_books(library) do
    IO.puts("Libros:")
    Enum.each(library, fn book ->
      if book.available do
        print_book(book)
      end
      IO.puts("")
    end)
  end

  def print_book(%Book{} = book) do
    IO.puts("Título: #{book.title}")
    IO.puts("Autor: #{book.author}")
    IO.puts("ISBN: #{book.isbn}")
    IO.puts("[#{if book.available, do: "Disponible", else: "No Disponible"}]")
  end

  def list_users(users) do
    users
  end

  def books_borrowed_by_user(users, user_id) do
    user = Enum.find(users, &(&1.id == user_id))
    if user, do: user.borrowed_books, else: []
  end

  def run do
    #library = []
    #users = []
    IO.inspect(initLibrary())
    {library, users} = initLibrary()
    loop(library, users)
  end

  def initLibrary() do
    library = [
      %Book{title: "Don Quijote de la Mancha", author: "Miguel de Cervantes", isbn: "1", available: true},
      %Book{title: "El Señor de los Anillos", author: "J. R. R. Tolkien", isbn: "2", available: true},
      %Book{title: "Las aventuras de Alicia en el país de las maravillas", author: "Lewis Carroll", isbn: "3", available: true},
      %Book{title: "El león, la bruja y el armario", author: "C. S. Lewis", isbn: "4", available: true},
      %Book{title: "El código Da Vinci", author: "Dan Brown", isbn: "5", available: true},
      %Book{title: "El alquimista", author: "Paulo Coelho", isbn: "6", available: true}
    ]
    users = [
      %User{name: "Oscar", id: "1", borrowed_books: []},
      %User{name: "Santiago", id: "2", borrowed_books: []},
      %User{name: "Giovanni", id: "3", borrowed_books: []},
      %User{name: "Camilo", id: "4", borrowed_books: []}
    ]
    {library, users}
  end

  defp loop(library, users) do
    IO.puts("""
    Sistema de prestamo de libros
    1. Agregar libro a la biblioteca
    2. Listar todos los libros
    #. Listar libros disponibles para prestamo
    3. Registrar nuevo usuario
    4. Listar usuarios registrados
    5. Pedir prestado un libro
    6. Devolver libro prestado
    7. Listar libros prestados por un usuario
    8. Salir
    """)

    IO.write("Seleccione una opción: ")
    option = IO.gets("") |> String.trim() |> String.to_integer()

    case option do
      1 ->
        IO.write("Ingrese el título del libro: ")
        title = IO.gets("") |> String.trim()
        IO.write("Ingrese el autor del libro: ")
        author = IO.gets("") |> String.trim()
        IO.write("Ingrese el isbn del libro: ")
        isbn = IO.gets("") |> String.trim()

        library = add_book(library, %Book{title: title, author: author, isbn: isbn, available: true})

        loop(library, users)

      2 ->
        list_books(library)
        loop(library, users)

      3 ->
        IO.write("Ingrese el nombre del usuario: ")
        name = IO.gets("") |> String.trim()
        IO.write("Ingrese el id del usuario: ")
        id = IO.gets("") |> String.trim()
        users = add_user(users, %User{name: name, id: id, borrowed_books: []})
        loop(library, users)

      4 ->
        list_users(users)
        loop(library, users)

      5 ->
        IO.write("Ingrese el id del usuario: ")
        user_id = IO.gets("") |> String.trim()
        IO.write("Ingrese el isbn del libro: ")
        isbn = IO.gets("") |> String.trim()
        {:ok, library, users} = borrow_book(library, users, user_id, isbn)
        loop(library, users)

      6 ->
        IO.write("Ingrese el id del usuario: ")
        user_id = IO.gets("") |> String.trim()
        IO.write("Ingrese el isbn del libro: ")
        isbn = IO.gets("") |> String.trim()
        {:ok, library, users} = return_book(library, users, user_id, isbn)
        loop(library, users)

      7 ->
        IO.write("Ingrese el id del usuario: ")
        user_id = IO.gets("") |> String.trim()
        books_borrowed_by_user(users, user_id)
        loop(library, users)

      8 ->
        IO.puts("¡Adiós!")
        :ok

      _ ->
        IO.puts("Opción no válida.")
        loop(library, users)
    end
  end
end

# Ejecutar el gestor de tareas
Library.run()
