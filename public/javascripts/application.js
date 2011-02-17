// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// 日付けを日本語の書式の文字列へ
Date.prototype.toJapaneseString = function() {
  return this.getFullYear() + "年" + (this.getMonth() + 1) + "月" + this.getDate() + "日" +
                                this.getHours() + "時" + this.getMinutes() + "分" + this.getSeconds() + "秒";
};
