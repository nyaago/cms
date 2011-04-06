// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// 日付けを日本語の書式の文字列へ
Date.prototype.toJapaneseString = function() {
  return this.getFullYear() + "年" + (this.getMonth() + 1) + "月" + this.getDate() + "日" +
                                this.getHours() + "時" + this.getMinutes() + "分" + this.getSeconds() + "秒";
};

// camel => underscore
String.prototype.underscore = function() {
  return this.split(/(?![a-z])(?=[A-Z])/).map( function(word) { 
                                        return word.toLowerCase(); } ).
                                        join('_');
};


Array.prototype.contains = function(value) {
	for(var i in this) {
		if( this.hasOwnProperty(i) && this[i] === value) {
			return true;
		}
	}
	return false;
}