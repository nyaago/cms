# = SiteAdmin::InformationsController
# 管理者からのお知らせ表示の　controller
class SiteAdmin::InformationsController < SiteAdmin::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site_admin", "informations"].freeze

  # GET /informations/1
  # GET /informations/1.xml
  # 記事詳細表示
  def show
    flash[:notice] = ''
    @information = Information.where("id = :id", :id => params[:id]).first
    if @information.nil?
      flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @information }
    end
  end
  
  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  
  
end
