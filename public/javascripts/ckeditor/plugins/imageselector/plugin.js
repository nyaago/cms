// 画像選択のページを別Windowで表示
function selectImages() {
  window.open('<%= url_for(:controller => :images, :action => :selection_list) %>', 
  '_blank', 'width=' + (window.outerWidth > 400 ? window.outerWidth - 200 : 200) + 
          ', height=' + (window.outerHeight > 300 ?   window.outerHeight - 100 : 200) + 
          ', menubar=no, toolbar=no, scrollbars=yes');
}




CKEDITOR.plugins.add( 'imageselector',
{
	init : function( editor )
	{
		editor.addCommand( 'imageSelector', CKEDITOR.plugins.imageSelector.commands.imageSelector );
		editor.ui.addButton( 'ImageSelector',
			{
				//label : editor.lang.removeFormat,
				label : "画像選択",
				command : 'imageSelector',
        className: "image_selector"
			});
	}
});


CKEDITOR.plugins.imageSelector =
{
	commands :
	{
		imageSelector :
		{
		  exec : function( editor ) {
		    window.open(CKEDITOR.config.imageSelctorUrl, 
        '_blank', 'width=' + (window.outerWidth > 400 ? window.outerWidth - 200 : 200) + 
                ', height=' + (window.outerHeight > 300 ?   window.outerHeight - 100 : 200) + 
                ', menubar=no, toolbar=no, scrollbars=yes');
        
		    //selectImages();
		  }  // exec
    } // imageSelector
  } // command
};


// CKEDITOR.config.imageSelctorUrl = '/site/images/selection_list';
