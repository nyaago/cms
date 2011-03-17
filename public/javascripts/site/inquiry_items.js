// InquiryItem 編集 (drag してのinquiry_item の追加、 inquiry_item のdialogでの内容編集, dragでの並び変え)
// 
//
// == リクエスト(内容 - URL)
// 
// InquiryItem追加 - <urlForAdd属性値>
// InquiryItem並び変え - <urlForSort属性値>
// InquiryItem編集 - <urlBaseForEdit属性値>/edit/<id値>
// InquiryItem更新 - <urlBaseForEdit属性値>/update/<id値>
// InquiryItem削除 - <urlBaseForEdit属性値>/destroy/<id値>
//
//
// == Html の構造
// 選択可能InquiryItem、選択済みInquiryItemのエリアの構造は以下のようである必要がある（または、そうなる。）
// タグ階層、タグのid, class, name名称がそうである必要がある。
// 
// 
// === 選択済みのInquiryItemエリアは以下のような構造のhtmlである必要がある.
// 
// <div class="selected_inquiry_items" id="selected_inquiry_items"> 
//  <div class="selected_inquiry_items_title"> 
//    <h4> 
//      (エリア名)
//    </h4> 
//  </div> 
//  .. 各InquiryItem要素は続く ..
// </div>
//
// === 各選択済みInquiryItem 要素は以下のような構造となる - ()内は変数
//
// <div class="inquiry_item_title"> 
// <h4 class="inquiry_item_human_name">(タイトル)</h4> 
// <input class="inquiry_item_position" id="inquiry_item_position_(id)" name="inquiry_item_position[(id値)]" type="hidden" value="(position値)" /> 
// <input class="inquiry_item_id" id="inquiry_item_id_(id)" name="inquiry_item_id[(id)]" type="hidden" value="(id)" /> 
// <input class="inquiry_item_type" id="inquiry_item_type_(id)" name="inquiry_item_type[(id)]" type="hidden" value="TextInquiryItem" /> 
// <input onclick=";" type="button" value="(ボタンテキスト)" /> 
// </div> 
//
//
// === 選択可能InquiryItem一覧は以下のような構造のhtmlである必要がある. 
// 
// <div id="inquiry_items" > 
// .. 各inquiry_item要素が続く 
// </div
//
// === 各選択可能InquiryItem　は以下のような構造である必要がある
// 
// <div class="inquiry_item" id="text_inquiry_item"> 
//  <div class="inquiry_item_title"> 
//  <h4 class="inquiry_item_human_name">(Wisget表示名)</h4> 
//  <input class="inquiry_item_type" id="inquiry_item_type_(任意の正数)" name="inquiry_item_type[(任意の正数)]" type="hidden" value="(Wisgetクラス)" /> 
//  </div> 
//  <form accept-charset="UTF-8" action="/site/inquiry_items/index" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="qDXVigHx/CCYvxHiKszAQJReYNklR/dJwNiHdTjIfcU=" /></div> 
//  <div class="inquiry_item_content"> 
//    
//  </div> 
// </form>  <div class="inquiry_item_description"> 
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
//
// 以下の属性が設定可能 (属性名: 説明 デフォルト)
// urlForAdd:  追加リクエストのurl  "/site/inquiry_items/create",
// urlForSort: 並ぶ替えリクエストのurl  "/site/inquiry_items/sort",
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
//  // inquiry_item編集のためのobjectを生成.
//  var editor = inquiryItemEditor();
//  editor.urlForAdd('/site/inquiry_items/create');
//  editor.urlForSort('/site/inquiry_items/sort');
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


var inquiryItemEditor = function(attributes) {

  var that = {};
  var attributes = attributes || {};
  var defaultAttributes = {
    urlForAdd: "/site/inquiry_items/create",
    urlForSort: "/site/inquiry_items/sort",
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
    $('.inquiry_item .inquiry_item_title').draggable( {
      start: function(e, ui) {
      },
      stop: function(e, ui) {
      },
      revert: false,
      helper: 'clone'
    });
    $('.selected_inquiry_items').droppable( {
      accept: '.inquiry_item .inquiry_item_title',
      drop: function(e, ui) {
        var inquiry_item = insertToInquiryItemArea(ui, $('.selected_inquiry_items_contents', this));
        createInquiryItemOnDB(inquiry_item);
      }
    });
    // inquiry_item 編集 dialog 表示のリスナーを登録
    $('.selected_inquiry_items_contents .inquiry_item_title').each ( function() {
      var inquiry_item = this;
      $(":button", this).click( function() {
        openDialog($(inquiry_item));
        });
    } );
    // inquiry_item - sort
    $('.selected_inquiry_items_contents').sortable(
      {update: function(event, ui) {
        updatePositionOnDB(this);
      }
      });
    $('.selected_inquiry_items_contents').disableSelection();

  };


  that.attribute = function(key, value) {
    if(value) {
      attributes[key] = value;
    }
    return attributes[key];
  };
  
  // InquiryItem追加リクエストのUR
  that.urlForAdd = function(value) {
    return that.attribute('urlForAdd',value);
  };

  // InquiryItem並び変えリクエストのUR
  that.urlForSort = function(value) {
    return that.attribute('urlForSort',value);
  };

  // InquiryItem追加リクエストのUR
  that.urlBaseForEdit = function(value) {
    return that.attribute('urlBaseForEdit',value);
  };

  // InquiryItem追加リクエストのUR
  that.dialogWidth = function(value) {
    return that.attribute('dialogWidth',value);
  };


  // InquiryItem追加リクエストのUR
  that.editButtonText = function(value) {
    return that.attribute('editButtonText',value);
  };

  // InquiryItem更新ボタンのテキスト
  that.updateButtonText = function(value) {
    return that.attribute('updateButtonText',value);
  };

  // InquiryItem削除ボタンのテキスト
  that.deleteButtonText = function(value) {
    return that.attribute('deleteButtonText',value);
  };

  // InquiryItem編集の閉じるボタンのテキスト
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



  // InquiryItem area に InquiryItemを挿入
  // inquiry_item - inquiry_item 要素 drag イベントのui オブジェクト
  // area - inquiry_item を 配置するarea
  // return : 挿入されたinquiry_item要素, data　として positionを設定したもの.
  insertToInquiryItemArea = function(inquiry_item, area) {
    // 
    var inserted = false;
    var insertedAt = 0;
    var newInquiryItem;
    $('.inquiry_item_title', area).each( function() {
      
      if($(this).position().top  >  inquiry_item.position.top && inserted == false) {
        var position = $('.inquiry_item_position', this).first().val();
        newInquiryItem = inquiry_item.draggable.clone(false).
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
      newInquiryItem = inquiry_item.draggable.
                  clone(false).appendTo($(area)).
                  data('position', 0);
    }
    return newInquiryItem;
  };
  

  // inquiry_item を サーバーのdb上に登録する.
  // inquiry_item - inquiry_item の dom 要素(jquery). inquiry_item_type　要素を含み,
  //          data として position が設定されている必要がある
  // area - inquiry_item 表示 area (side | footer)
  createInquiryItemOnDB = function(inquiryItem) {
    var position = inquiryItem.data('position');
    var inquiryItemType = $('.inquiry_item_type', inquiryItem).val();

    $.ajax( {
      type: "POST",
      url: that.urlForAdd(),
      dataType: 'json',
      data: {
        'position': position,
        'inquiry_item_type': inquiryItemType
      },
      success: function(data, dataType) {
        // 成功. position と idの hiddenタグを生成
        var id = data.site_inquiry_item.id;
        var position = data.site_inquiry_item.position;
        var tagName = 'inquiry_item_position[' + id + ']';
        var tagId = 'inquiry_item_position_' + id;
        $("<input type='hidden' class='inquiry_item_position' name='" + 
        tagName + "' id='" + tagId + "' value='" + position + "' />"  ).
          appendTo(inquiryItem);
        var tagName = 'inquiry_item_id[' + id + ']';
        var tagId = 'inquiry_item_id_' + id;
        $("<input type='hidden' class='inquiry_item_id' name='" + 
        tagName + "' id='" + tagId + "' value='" + id + "' />"  ).
          appendTo(inquiryItem);
        $("<input type='button' value='" +   that.editButtonText() + "' />"  ).
          appendTo(inquiryItem).
          click( function() {
            openDialog($(inquiryItem));
            });
        openDialog(inquiryItem);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたinquiry_itemを削除
        alert(that.msgFailedInConnection());
        inquiryItem.remove();
      }
      });
      
  };
  
  // InquiryItem 編集 dialog を表示
  openDialog = function(inquiryItem) {
    var id = $('.inquiry_item_id', inquiryItem).val();
    var url = that.urlBaseForEdit() + $('.inquiry_item_type', inquiryItem).val().underscore() + 
                                        '/edit/' + id;
    $.ajax( {
      type: "GET",
      url: url,
      dataType: 'html',
      success: function(data, dataType) {
        $(data).appendTo(inquiryItem);
        // dialog の selector を保存しておく
        var dialogSelector = $('.edit_inquiry_item', inquiryItem);
        // form が submitされないようにしておく.
        $('form', dialogSelector).submit( function() {
          return false;
        });
        // dialog 生成 + 表示
        var updateButtonText = that.updateButtonText();
        var deleteButtonText = that.deleteButtonText();
        var dialogObject = $('.edit_inquiry_item', inquiryItem).dialog({
            bgiframe: true,
            autoOpen: true,
            width: that.dialogWidth(),
            modal: false,
            title: $('.inquiry_item_human_name', inquiryItem).text(),
            close: function(){
            		$(this).dialog("destroy");
            	},
            buttons: [
              {
                text : that.updateButtonText(),
                click: function() {
                  url = that.urlBaseForEdit() + $('.inquiry_item_type', inquiryItem).val().underscore() + 
                                                '/update/' + id;
                  $.ajax( {
                    type: "POST",
                    url: url,
                    dataType: 'json',
                    data: $('form', dialogSelector).serialize(),
                    success: function(data, dataType) {
                      if(data.inquiry_item) {
                        dialogSelector.dialog('close');
                        $('.inquiry_item_human_name', inquiryItem).text(data.inquiry_item.title);
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
                      // エラー時. 挿入されたinquiry_itemを削除
                      alert(that.msgFailedInConnection());
                    }
                  }); // ajax 
                } // on click
              }, // update button
              {
                text : that.deleteButtonText(),
                click : function() {
                  url = that.urlBaseForEdit() + $('.inquiry_item_type', inquiryItem).val().underscore() + 
                                                '/destroy/' + id;
                  $.ajax( {
                    type: "POST",
                    url: url,
                    dataType: 'json',
                    data: $('form', dialogSelector).serialize(),
                    success: function(data, dataType) {
                      if(data.inquiry_item_id) {
                        dialogSelector.dialog('close');
                        // inquiry_item エリアからの削除
                        removeFromInquiryItemArea(inquiryItem);
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
                      // エラー時. 挿入されたinquiry_itemを削除
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
        // エラー時. 挿入されたinquiry_itemを削除
        alert(that.msgFailedInConnection());
      }
    });
  };
  
  // （選択済み)inquiry_item エリアからの削除
  removeFromInquiryItemArea = function(inquiryItem) {
    inquiryItem.remove();
  };

  // 選択済み inquiry_item エリアでの並び変え操作をサーバーへ反映させる
  updatePositionOnDB  = function(areaElem) {
    var inquiryItems = [];
    $(".inquiry_item_id", areaElem).each ( function() {
      inquiryItems.push($(this).val());
    }
    );
    $.ajax( {
      type: "POST",
      url: that.urlForSort(),
      dataType: 'json',
      data: { 
        order: inquiryItems.join(',')
      },
      success: function(data, dataType) {
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたinquiry_itemを削除
        alert(that.msgFailedInConnection());
      }
    });
  }

  init();
  return that;
};