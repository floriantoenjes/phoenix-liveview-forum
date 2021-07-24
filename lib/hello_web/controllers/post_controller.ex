defmodule HelloWeb.PostController do
  use HelloWeb, :controller

  alias Hello.Forum
  alias Hello.Forum.Post

  plug :require_existing_author
  plug :authorize_post when action in [:edit, :update, :delete]

  def index(conn, %{"board_id" => board_id, "thread_id" => thread_id}) do
    posts = Forum.list_posts()
    render(conn, "index.html", board_id: board_id, thread_id: thread_id, posts: posts)
  end

  def new(conn, %{"board_id" => board_id, "thread_id" => thread_id}) do
    changeset = Forum.change_post(%Post{})
    render(conn, "new.html", board_id: board_id, thread_id: thread_id, changeset: changeset)
  end

  def create(conn, %{"board_id" => board_id, "thread_id" => thread_id, "post" => post_params}) do
    thread = Forum.get_thread!(thread_id)
    case Forum.create_post(thread, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.board_thread_post_path(conn, :show, board_id, thread_id ,post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"board_id" => board_id, "thread_id" => thread_id, "id" => id}) do
    post = Forum.get_post!(id)
    render(conn, "show.html", board_id: board_id, thread_id: thread_id, post: post)
  end

  def edit(conn, %{"board_id" => board_id, "thread_id" => thread_id, "id" => id}) do
    post = Forum.get_post!(id)
    changeset = Forum.change_post(post)
    render(conn, "edit.html", board_id: board_id, thread_id: thread_id, post: post, changeset: changeset)
  end

  def update(conn, %{"board_id" => board_id, "thread_id" => thread_id, "id" => id, "post" => post_params}) do
    post = Forum.get_post!(id)

    case Forum.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.board_thread_post_path(conn, :show, board_id, thread_id, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"board_id" => board_id, "thread_id" => thread_id, "id" => id}) do
    post = Forum.get_post!(id)
    {:ok, _post} = Forum.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.board_thread_post_path(conn, :index, board_id, thread_id))
  end

  defp require_existing_author(conn, _) do
    author = Forum.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  defp authorize_post(conn, _) do
    post = Forum.get_post!(conn.params["id"])

    if conn.assigns.current_author.id == post.author_id do
      assign(conn, :post, post)
    else
      conn
      |> put_flash(:error, "You can't modify that post")
      |> redirect(to: Routes.board_thread_post_path(conn, :index, post.thread.board.id, post.thread.id))
      |> halt()
    end
  end
end
