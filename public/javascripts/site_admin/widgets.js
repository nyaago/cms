// Widget 編集 (drag してのwidget の追加、 widget のdialogでの内容編集, dragでの並び変え)
// 
//
// == リクエスト(内容 - URL)
// 
// Widget追加 - <urlForAdd属性値>
// Widget並び変え - <urlForSort属性値>
// Widget編集 - <urlBaseForEdit属性値>/edit/<id値>
// Widget更新 - <urlBaseForEdit属性値>/update/<id値>
// Widget削除 - <urlBaseForEdit属性値>/destroy/<id値>
//
//
// == Html の構造
// 選択可能Widget、選択済みWidgetのエリアの構造は以下のようである必要がある（または、そうなる。）
// タグ階層、タグのid, class, name名称がそうである必要がある。
// 
// 
// === 選択済みのWidgetエリアは以下のような構造のhtmlである必要がある.
// 
// <div class="widget_area" id="side_widget_area"> 
//  <div class="widget_area_title"> 
//    <h4> 
//      (エリア名)
//    </h4> 
//  </div> 
//  .. 各Widget要素は続く ..
// </div>
//
// === 各選択済みWidget 要素は以下のような構造となる - ()内は変数
//
// <div class="widget_title"> 
// <h4 class="widget_human_name">(タイトル)</h4> 
// <input class="widget_position" id="widget_position_(id)" name="widget_position[(id値)]" type="hidden" value="(position値)" /> 
// <input class="widget_id" id="widget_id_(id)" name="widget_id[(id)]" type="hidden" value="(id)" /> 
// <input class="widget_type" id="widget_type_(id)" name="widget_type[(id)]" type="hidden" value="TextWidget" /> 
// <input onclick=";" type="button" value="(ボタンテキスト)" /> 
// </div> 
//
//
// === 選択可能Widget一覧は以下のような構造のhtmlである必要がある. 
// 
// <div id="widgets" > 
// .. 各widget要素が続く 
// </div
//
// === 各選択可能Widget　は以下のような構造である必要がある
// 
// <div class="widget" id="text_widget"> 
//  <div class="widget_title"> 
//  <h4 class="widget_human_name">(Wisget表示名)</h4> 
//  <input class="widget_type" id="widget_type_(任意の正数)" name="widget_type[(任意の正数)]" type="hidden" value="(Wisgetクラス)" /> 
//  </div> 
//  <form accept-charset="UTF-8" action="/site/widgets/index" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="qDXVigHx/CCYvxHiKszAQJReYNklR/dJwNiHdTjIfcU=" /></div> 
//  <div class="widget_content"> 
//    
//  </div> 
// </form>  <div class="widget_description"> 
//  (説明文)
//	</div> 
// </div> 
// 
// === 編集ダイアログのエラー表示部分
// 
// <div id="(idForErrorExplanation属性値)" style="display:none;">
//   <h2 id="(idForErrorCount属性値)"></h2>
//   <ul>
//   </ul>
// </div>
//
// == Option 属性 
// 以下の属性の設定が必須
// siteName: サイト名 (サーバーのSiteモデルのname属性)
// 以下の属性が設定可能 (属性名: 説明 デフォルト)
// urlForAdd:  追加リクエストのurl  "/site/widgets/create",
// urlForSort: 並ぶ替えリクエストのurl  "/site/widgets/sort",
// urlBaseForEdit: 編集のためのurlのベース "/site/",
// dialogWidth: 編集ダイアログの幅 400,
// updateButtonText: 編集ダイアログのupdateボタンのテキスト  "保存",
// deleteButtonText:  編集ダイアログのdeleteボタンのテキスト　"削除",
// editButtonText:  編集ダイアログのを開くボタンのテキスト　"保存",
// closeButtonText:  編集ダイアログのcloseボタンのテキスト　"閉じる",
// msgFailedInConnection: ajax での接続エラーのメッセージ "failed in connecting to server.",
// msgFailedInDeleting: サーバーＤＢ失敗時のメッセージ "failed in deleting.",
// msgErrorCount: エラー件数表示のメッセージ " errors occured.",
// msgNotExists: データがない場合のメッセージ  "failed in deleting.",
// idForErrorExplanation: エラー説明div のid  "error_explanation",
// idForErrorCount: エラー数表示要素のid "error_count",
//
// == 依存関数
// 以下のAPI/関数に依存する
// 
// JQuery core
// jquery UI の うち, draggable, droppable, sortable, dialogを使用する。
// 
// String.prototype.underscore 
//    <= Camel 記法からumderscore記法への変換. see application.js
// 
// == 起動コード例 
//
// // ページload時,
//$(document).ready( function(){
//  // widget編集のためのobjectを生成.
//  var editor = widgetEditor();
//  editor.urlForAdd('/site/widgets/create');
//  editor.urlForSort('/site/widgets/sort');
//  editor.urlBaseForEdit("/site/");
//  editor.updateButtonText("保存");
//  editor.dialogWidth(450);
  
//  editor.msgFailedInConnection("サーバー接続中にエラーが発生しました.");
//  editor.msgFailedInDeleting("削除に失敗しました."),
//  editor.msgErrorCount("件のエラーがあります"),
//  editor.msgNotExists("操作対象のデータが存在しません.");
//  editor.editButtonText("編集");
//  editor.deleteButtonText("削除");
//  editor.closeButtonText("閉じる");
//});


var widgetEditor = function(attributes) {

  var that = {};
  var attributes = attributes || {};
  var defaultAttributes = {
    urlForAdd: "/site/widgets/create",
    urlForSort: "/site/widgets/sort",
    urlBaseForEdit: "/site/",
    dialogWidth: 400,
    updateButtonText: "保存",
    deleteButtonText: "削除",
    editButtonText: "保存",
    closeButtonText: "閉じる",
    msgFailedInConnection: "failed in connecting to server.",
    msgFailedInDeleting: "failed in deleting.",
    msgErrorCount: " errors occured.",
    msgNotExists: "failed in deleting.",
    idForErrorExplanation: "error_explanation",
    idForErrorCount: "error_count",
  };
  
  // default 属性と コンストラクタ引数で渡された属性をmerge
  attributes = (function() {
    var result = {};
    
    for (i = 0; i < arguments.length; i++) {
      for(name in arguments[i])  {
        result[name] = arguments[i][name];
      }
    }
    return result;
  })(defaultAttributes, attributes);
  
  
  // 初期化 
  init = function() {
    
    
    $('.widget .widget_title').draggable( {
      start: function(e, ui) {
      },
      stop: function(e, ui) {
      },
      revert: false,
      helper: 'clone'
    });
    $('.widget_area').droppable( {
      accept: '.widget .widget_title',
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
    // widget - sort
    $('.widget_area_contents').sortable(
      {update: function(event, ui) {
        updatePositionOnDB(this);
      }
      });
    $('.widget_area_contents').disableSelection();


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

  // Widget並び変えリクエストのUR
  that.urlForSort = function(value) {
    return that.attribute('urlForSort',value);
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

  // Widget更新ボタンのテキスト
  that.updateButtonText = function(value) {
    return that.attribute('updateButtonText',value);
  };

  // Widget削除ボタンのテキスト
  that.deleteButtonText = function(value) {
    return that.attribute('deleteButtonText',value);
  };

  // Widget編集の閉じるボタンのテキスト
  that.closeButtonText = function(value) {
    return that.attribute('closeButtonText',value);
  };

  // 
  that.msgFailedInConnection = function(value) {
    return that.attribute('msgFailedInConnection',value);
  };

  // 
  that.msgFailedInDeleting = function(value) {
    return that.attribute('msgFailedInDeleting',value);
  };

  // 
  that.msgErrorCount = function(value) {
    return that.attribute('msgErrorCount',value);
  };

  // 
  that.msgNotExists = function(value) {
    return that.attribute('msgNotExists',value);
  };

  that.idForErrorExplanation = function(value) {
    return that.attribute('idForErrorExplanation',value);
  };

  that.idForErrorCount = function(value) {
    return that.attribute('idForErrorCount',value);
  };

  that.siteName = function(value) {
    return that.attribute('siteName',value);
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
        return false;     // each を抜ける
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
  // widget - widget の dom 要素(jquery). widget_type　要素を含み,
  //          data として position が設定されている必要がある
  // area - widget 表示 area (side | footer)
  createWidgetOnDB = function(widget, area) {
    var position = widget.data('position');
    var widgetType = $('.widget_type', widget).val();
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax( {
      type: "POST",
      url: that.urlForAdd(),
      dataType: 'json',
      data: {
        'authenticity_token': csrfToken,
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
        $("<input type='button' value='" +   that.editButtonText() + "' />"  ).
          appendTo(widget).
          click( function() {
            openDialog($(widget));
            });
        openDialog(widget);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(that.msgFailedInConnection());
        widget.remove();
      }
      });
      
  };
  
  // Widget 編集 dialog を表示
  openDialog = function(widget) {
    var id = $('.widget_id', widget).val();
    var url = that.urlBaseForEdit()  + that.siteName() + '/'+ $('.widget_type', widget).val().underscore() + 
                                        '/edit/' + id;
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
        var updateButtonText = that.updateButtonText();
        var deleteButtonText = that.deleteButtonText();
        var dialogObject = $('.edit_widget', widget).dialog({
            bgiframe: true,
            autoOpen: true,
            width: that.dialogWidth(),
            modal: false,
            title: $('.widget_human_name', widget).text(),
            buttons: [
              {
                text : that.updateButtonText(),
                click: function() {
                  var csrfToken = $('meta[name="csrf-token"]').attr('content');
                  url = that.urlBaseForEdit()  + that.siteName() + '/' + $('.widget_type', widget).val().underscore() + 
                                                '/update/' + id;
                  var csrfToken = $('meta[name="csrf-token"]').attr('content');
                  $.ajax( {
                    type: "POST",
                    url: url,
                    dataType: 'json',
                    data: $('form', dialogSelector).serialize() + '&authenticity_token=' + csrfToken,
                    success: function(data, dataType) {
                      if(data.widget_id) {
                        dialogSelector.dialog('close');
                      }
                      // error がある場合
                      else {
                        if($("#" + that.idForErrorExplanation())) {
                          $("#" + that.idForErrorExplanation()).css("display", "block");
                          $('ul li', "#" + that.idForErrorExplanation() ).remove();
                          for(var i in data){
                            $('ul', "#" + that.idForErrorExplanation() ).append(
                              "<li>" + data[i] + "</li>");
                          }
                          if($("#" + that.idForErrorCount(), "#" + that.idForErrorExplanation())) {
                            $("#" + that.idForErrorCount(), "#" + 
                                        that.idForErrorExplanation()).text(
                                        "" + data.length + that.msgErrorCount());
                          }
                        }
                      }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                      // エラー時. 挿入されたwidgetを削除
                      alert(that.msgFailedInConnection());
                    }
                  }); // ajax 
                } // on click
              }, // update button
              {
                text : that.deleteButtonText(),
                click : function() {
                  var csrfToken = $('meta[name="csrf-token"]').attr('content');
                  url = that.urlBaseForEdit()  + that.siteName()+ '/' + $('.widget_type', widget).val().underscore() + 
                                                '/destroy/' + id;
                  $.ajax( {
                    type: "POST",
                    url: url,
                    dataType: 'json',
                    data: $('form', dialogSelector).serialize() + '&authenticity_token=' + csrfToken,
                    success: function(data, dataType) {
                      if(data.widget_id) {
                        dialogSelector.dialog('close');
                        // widget エリアからの削除
                        removeFromWidgetArea(widget);
                      }
                      // error がある場合
                      else {
                        if($("#" + that.idForErrorExplanation())) {
                          $("#" + that.idForErrorExplanation()).css("display", "block");
                          $('ul li', "#" + that.idForErrorExplanation() ).remove();
                          if($("#" + that.idForErrorCount(), "#" + that.idForErrorExplanation())) {
                            $("#" + that.idForErrorCount(), "#" + that.idForErrorExplanation()).text(
                                        that.msgFailedInDeleting());
                          }
                          $('ul', "#" + that.idForErrorExplanation() ).append(
                            "<li>" + that.msgNotExists() + "</li>");
                        }
                      }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                      // エラー時. 挿入されたwidgetを削除
                      alert(that.msgFailedInConnection());
                    }
                  }); // ajax
                } // on click
              },  // update button
              {
                text : that.closeButtonText(),
                click : function() {
                  dialogSelector.dialog('close');
                }
              }  // close button
            ] // buttons
        }); //  dialog
        
        
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(that.msgFailedInConnection());
      }
    });
  };
  
  // （選択済み)widget エリアからの削除
  removeFromWidgetArea = function(widget) {
    widget.remove();
  };

  // 選択済み widget エリアでの並び変え操作をサーバーへ反映させる
  updatePositionOnDB  = function(areaElem) {
    var matches = $(areaElem).attr('id').match(/^([a-z]+)_widget_area_contents$/);
    if(!matches) {
      return;
    }
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    var area = matches[1];
    var widgets = [];
    $(".widget_id", areaElem).each ( function() {
      widgets.push($(this).val());
    }
    );
    $.ajax( {
      type: "POST",
      url: that.urlForSort(),
      dataType: 'json',
      data: { 
        'authenticity_token': csrfToken,
        order: widgets.join(','),
        area: area
      },
      success: function(data, dataType) {
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(that.msgFailedInConnection());
      }
    });
  }

  init();
  return that;
};