# = SiteAdmin::PasswordController
# Password変更、再発行
class SiteAdmin::PasswordController < SiteAdmin::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site_admin", "password"].freeze
  
  # /password/edit/id
  # password変更ページを表示
  def edit
    
    if current_user.id != params[:id].to_i
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/public/404.html", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    @user = current_user
    respond_to do |format|
      format.html 
      format.xml { render :xml => @user }
    end
  end
  
  # passwordの更新 
  # 再発行後,完了ページへリダイレクト.
  # POST site/password_reissue/update
  # 以下のリクエストパラメータを受ける
  # * id
  # * user[password ]
  # * user[password_confirmation ]
  def update
    if current_user.id != params[:id].to_i
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/public/404.html", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    @user = User.find_by_id(params[:id])
    begin
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      @user.save!(:validate => true)
      respond_to do |format|
        format.html  do 
          flash[:notice] = I18n.t :password_changed, :scope => TRANSLATION_SCOPE
          redirect_to :action => :completed 
        end
        format.xml { render :status => 'OK' }
      end
    rescue
      respond_to do |format|
        format.html { render :action => :edit }
        format.xml { render :status => 'NG' }
      end
    end
  end
  
  # 完了ページを表示
  def completed
  end

  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end


end
