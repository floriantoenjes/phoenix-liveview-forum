defmodule HelloWeb.NotificationLiveTest do
  use HelloWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Hello.Forum

  @create_attrs %{read: true, resource_name: "some resource_name", target_id: 42, type: 42}
  @update_attrs %{read: false, resource_name: "some updated resource_name", target_id: 43, type: 43}
  @invalid_attrs %{read: nil, resource_name: nil, target_id: nil, type: nil}

  defp fixture(:notification) do
    {:ok, notification} = Forum.create_notification(@create_attrs)
    notification
  end

  defp create_notification(_) do
    notification = fixture(:notification)
    %{notification: notification}
  end

  describe "Index" do
    setup [:create_notification]

    test "lists all notifications", %{conn: conn, notification: notification} do
      {:ok, _index_live, html} = live(conn, Routes.notification_index_path(conn, :index))

      assert html =~ "Listing Notifications"
      assert html =~ notification.resource_name
    end

    test "saves new notification", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.notification_index_path(conn, :index))

      assert index_live |> element("a", "New Notification") |> render_click() =~
               "New Notification"

      assert_patch(index_live, Routes.notification_index_path(conn, :new))

      assert index_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notification-form", notification: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.notification_index_path(conn, :index))

      assert html =~ "Notification created successfully"
      assert html =~ "some resource_name"
    end

    test "updates notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, Routes.notification_index_path(conn, :index))

      assert index_live |> element("#notification-#{notification.id} a", "Edit") |> render_click() =~
               "Edit Notification"

      assert_patch(index_live, Routes.notification_index_path(conn, :edit, notification))

      assert index_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notification-form", notification: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.notification_index_path(conn, :index))

      assert html =~ "Notification updated successfully"
      assert html =~ "some updated resource_name"
    end

    test "deletes notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, Routes.notification_index_path(conn, :index))

      assert index_live |> element("#notification-#{notification.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#notification-#{notification.id}")
    end
  end

  describe "Show" do
    setup [:create_notification]

    test "displays notification", %{conn: conn, notification: notification} do
      {:ok, _show_live, html} = live(conn, Routes.notification_show_path(conn, :show, notification))

      assert html =~ "Show Notification"
      assert html =~ notification.resource_name
    end

    test "updates notification within modal", %{conn: conn, notification: notification} do
      {:ok, show_live, _html} = live(conn, Routes.notification_show_path(conn, :show, notification))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Notification"

      assert_patch(show_live, Routes.notification_show_path(conn, :edit, notification))

      assert show_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#notification-form", notification: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.notification_show_path(conn, :show, notification))

      assert html =~ "Notification updated successfully"
      assert html =~ "some updated resource_name"
    end
  end
end
