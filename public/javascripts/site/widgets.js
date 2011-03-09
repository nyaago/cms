
// 
var widgetEditor = function(attributes) {

  var that = {};
  var attributes = attributes || {};
  
  // 初期化 
  init = function() {
    $('div.widget .widget_title').draggable( {
      start: function(e, ui) {
      },
      stop: function(e, ui) {
      },
      revert: false,
      helper: 'clone'
    });
    $('.widget_area').droppable( {
      accept: 'div.widget .widget_title',
      drop: function(e, ui) {
        var matches = $(this).attr('id').match(/^([a-z]+)_widget_area$/);
        if(!matches) {
          return;
        }
        var area = matches[1];
        var widget = insertToWidgetArea(ui, $('.widget_area_contents', this));
        createWidgetOnDB(widget, area);
      }
    });
    // widget 編集 dialog 表示のリスナーを登録
    $('.widget_area_contents .widget_title').each ( function() {
      var widget = this;
      $(":button", this).click( function() {
        openDialog($(widget));
        });
    } );

  };

  that.attribute = function(key, value) {
    if(value) {
      attributes[key] = value;
    }
    return attributes[key];
  };
  
  // Widget追加リクエストのUR
  that.urlForAdd = function(value) {
    return that.attribute('urlForAdd',value);
  };

  // Widget追加リクエストのUR
  that.urlBaseForEdit = function(value) {
    return that.attribute('urlBaseForEdit',value);
  };

  // Widget追加リクエストのUR
  that.dialogWidth = function(value) {
    return that.attribute('dialogWidth',value);
  };


  // Widget追加リクエストのUR
  that.editButtonText = function(value) {
    return that.attribute('editButtonText',value);
  };



  // Widget area に Widgetを挿入
  // widget - widget 要素 drag イベントのui オブジェクト
  // area - widget を 配置するarea
  // return : 挿入されたwidget要素, data　として positionを設定したもの.
  insertToWidgetArea = function(widget, area) {
    // 
    var inserted = false;
    var insertedAt = 0;
    var newWidget;
    $('.widget_title', area).each( function() {
      
      if($(this).position().top  >  widget.position.top && inserted == false) {
        var position = $('.widget_position', this).first().val();
        newWidget = widget.draggable.clone(false).
                    insertBefore($(this)).
                    data('position', position);
        inserted = true;
//        return false;     // each を抜ける
      }
      else {
        insertedAt += 1;
      }
      
    } );
    if(inserted == false) {
      newWidget = widget.draggable.
                  clone(false).appendTo($(area)).
                  data('position', 0);
    }
    return newWidget;
  };
  

  // widget を サーバーのdb上に登録する.
  // widget - widget の dom 要素(jquery). widget_type　要素を含み,data として position が設定されている必要がある
  // area - widget 表示 area (side | footer)
  createWidgetOnDB = function(widget, area) {
    var position = widget.data('position');
    var widgetType = $('.widget_type', widget).val();
    $.ajax( {
      type: "POST",
      url: that.urlForAdd(),
      dataType: 'json',
      data: {
        'position': position,
        'widget_area': area,
        'widget_type': widgetType
      },
      success: function(data, dataType) {
        // 成功. position と idの hiddenタグを生成
        var id = data.site_widget.id;
        var position = data.site_widget.position;
        var tagName = 'widget_position[' + id + ']';
        var tagId = 'widget_position_' + id;
        $("<input type='hidden' class='widget_position' name='" + 
        tagName + "' id='" + tagId + "' value='" + position + "' />"  ).
          appendTo(widget);
        var tagName = 'widget_id[' + id + ']';
        var tagId = 'widget_id_' + id;
        $("<input type='hidden' class='widget_id' name='" + 
        tagName + "' id='" + tagId + "' value='" + id + "' />"  ).
          appendTo(widget);
        $("<input type='button' value='" +   that.editButtonText + "' />"  ).
          appendTo(widget).
          click( function() {
            openDialog($(widget));
            });
        openDialog(widget);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert('サーバーと接続中にエラーが発生しました');
        widget.remove();
      }
      });
      
  };
  
  // Widget 編集 dialog を表示
  openDialog = function(widget) {
    var id = $('.widget_id', widget).val();
    var url = that.urlBaseForEdit() + $('.widget_type', widget).val().underscore() + '/edit/' + id;
    $.ajax( {
      type: "GET",
      url: url,
      dataType: 'html',
      success: function(data, dataType) {
        $(data).appendTo(widget);
        // dialog の selector を保存しておく
        var dialogSelector = $('.edit_widget', widget);
        // form が submitされないようにしておく.
        $('form', dialogSelector).submit( function() {
          return false;
        });
        // dialog 生成 + 表示
        $('.edit_widget', widget).dialog({
            bgiframe: true,
            autoOpen: true,
            width: that.dialogWidth(),
            modal: false,
            buttons: {
                '更新': function() {
                  url = that.urlBaseForEdit() + $('.widget_type', widget).val().underscore() + '/update/' + id;
                  $.ajax( {
                    type: "POST",
                    url: url,
                    dataType: 'json',
                    data: $('form', dialogSelector).serialize(),
                    success: function(data, dataType) {
                      if(data.widget_id) {
                        dialogSelector.dialog('close');
                      }
                      // TODO error 
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                      // エラー時. 挿入されたwidgetを削除
                      alert('サーバーと接続中にエラーが発生しました');
                    }
                  });
                  
                  
                }
            } // buttons
        }); //  dialog
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert('サーバーと接続中にエラーが発生しました');
      }
    });
  }
  
  
  
  // widget を sort 可能にする
  sortableWidget = function(widget) {
    
  };

  init();
  return that;
};