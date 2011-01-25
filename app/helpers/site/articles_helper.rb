module Site::ArticlesHelper
  
  def articles_path(args = {})
    url_for( :controller => "articles", :action => 'index', 
    :page => if !params[:page].blank?  then params[:page]  else 1 end,
    :sort => if !args[:sort].blank?  then args[:page]  else 'heading_level' end,
    :direction => if !args[:sort].blank?  then 
      if !params[:direction].blank? and  params[:direction] == 'asc'
        'desc'
      else
        'asc'
      end
    else 
      'asc' 
    end
     )
  end

  def article_path(id)
    url_for(:action => 'show', :id => params[:id])
  end

  def update_article_path(article)
    if(params[:action] == 'edit')
      url_for( :action => :update , :id => article.id,
       :page => if !params[:page].blank?  then params[:page]  else 1 end)
    else
      url_for( :action => :create , 
       :page => if !params[:page].blank?  then params[:page]  else 1 end)
    end
  end

  def new_article_path(args = {})
    url_for( :action => :new , 
     :page => if !params[:page].blank?  then params[:page]  else 1 end)
  end
  
  def edit_article_path(article, args = {})
    url_for(:action => 'edit', :id => article.id, 
     :page => if !params[:page].blank?  then params[:page]  else 1 end)
  end

  def show_article_path(article, args = {})
    url_for(:action => 'show', :id => article.id,
     :page => if !params[:page].blank?  then params[:page]  else 1 end)
  end

  def destroy_article_path(article, args = {})
    url_for(:action => 'destroy', :id => article.id,
     :page => if !params[:page].blank?  then params[:page]  else 1 end)
  end
  
  def heading_level_name_with_id(id)
    Category::HeadingLevel.name_with_id(id)
  end


end
