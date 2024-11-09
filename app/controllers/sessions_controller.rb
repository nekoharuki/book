class SessionsController < ApplicationController
  def create
    # OmniAuthから認証情報を取得
    auth = request.env["omniauth.auth"]

    # 認証情報を使用してユーザーを検索または作成
    user = User.from_omniauth(auth)

    # ユーザーが保存されているか確認
    if user.persisted?
      # セッションにユーザーIDを保存
      session[:user_id] = user.id

      # ログイン成功のメッセージを設定
      flash[:notice] = "ログインしました"

      # アイテム一覧ページにリダイレクト
      redirect_to items_path
    else
      # ユーザーが保存されていない場合、バリデーションエラーを確認
      flash[:alert] = "ログインに失敗しました: #{user.errors.full_messages.join(", ")}"

      # ログインページにリダイレクト
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to root_path
  end
end
