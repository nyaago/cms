module Site::ArticlesHelper
  
  def new_article_path
    url_for( :action => :new )
  end
  
  def articles_path
    if params[:action] == 'new'
      url_for( :action => 'create')
    else
      url_for(:action => 'index')
    end
  end

  def article_path(id)
    if params[:action] == 'edit'
      url_for(:action => 'update', :id => params[:id])
    else
      url_for(:action => 'show', :id => params[:id])
    end
  end

end
