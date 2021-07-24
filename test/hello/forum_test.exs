defmodule Hello.ForumTest do
  use Hello.DataCase

  alias Hello.Forum

  describe "boards" do
    alias Hello.Forum.Board

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_board()

      board
    end

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Forum.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Forum.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      assert {:ok, %Board{} = board} = Forum.create_board(@valid_attrs)
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      assert {:ok, %Board{} = board} = Forum.update_board(board, @update_attrs)
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_board(board, @invalid_attrs)
      assert board == Forum.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Forum.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Forum.change_board(board)
    end
  end

  describe "boards" do
    alias Hello.Forum.Board

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_board()

      board
    end

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Forum.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Forum.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      assert {:ok, %Board{} = board} = Forum.create_board(@valid_attrs)
      assert board.name == "some name"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      assert {:ok, %Board{} = board} = Forum.update_board(board, @update_attrs)
      assert board.name == "some updated name"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_board(board, @invalid_attrs)
      assert board == Forum.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Forum.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Forum.change_board(board)
    end
  end

  describe "threads" do
    alias Hello.Forum.Thread

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def thread_fixture(attrs \\ %{}) do
      {:ok, thread} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_thread()

      thread
    end

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert Forum.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Forum.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      assert {:ok, %Thread{} = thread} = Forum.create_thread(@valid_attrs)
      assert thread.title == "some title"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{} = thread} = Forum.update_thread(thread, @update_attrs)
      assert thread.title == "some updated title"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_thread(thread, @invalid_attrs)
      assert thread == Forum.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Forum.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Forum.change_thread(thread)
    end
  end

  describe "posts" do
    alias Hello.Forum.Post

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Forum.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forum.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Forum.create_post(@valid_attrs)
      assert post.content == "some content"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Forum.update_post(post, @update_attrs)
      assert post.content == "some updated content"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_post(post, @invalid_attrs)
      assert post == Forum.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Forum.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forum.change_post(post)
    end
  end

  describe "members" do
    alias Hello.Forum.Member

    @valid_attrs %{role: "some role", signature: "some signature"}
    @update_attrs %{role: "some updated role", signature: "some updated signature"}
    @invalid_attrs %{role: nil, signature: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Forum.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Forum.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Forum.create_member(@valid_attrs)
      assert member.role == "some role"
      assert member.signature == "some signature"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Forum.update_member(member, @update_attrs)
      assert member.role == "some updated role"
      assert member.signature == "some updated signature"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_member(member, @invalid_attrs)
      assert member == Forum.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Forum.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Forum.change_member(member)
    end
  end
end
