# -*- coding: utf-8 -*-
require 'machinist/active_record'
require 'sham'

Sham.login {|index| "account#{index}" }
Sham.password { 'password' }
Sham.password_confirmation { 'password' }
Sham.email { |index| "account#{index}@hogehoge.com" } 

Sham.site_name  { |index| "site#{index}"}
Sham.site_title  {|index| "サイト#{index}"}

Sham.page_name  {|index| "page" + ('a'..'z').to_a[index] }
Sham.article_title  {|index| "記事#{index}"}
Sham.article_content  {|index| "<p>記事#{index}</p>"}


User.blueprint(:admin) do
  login { 'admin' }
  password { 'admin' }
  password_confirmation { 'admin' }
  email { 'nyaago@bf.wakwak.com' }
  is_admin { true }
end

User.blueprint(:site_admin) do
  login { 'site_admin' }
  password { 'site_admin' }
  password_confirmation { 'site_admin' }
  email { 'site_admin@hoge.com' }
  is_site_admin { true }
end


User.blueprint do
  login { Sham.login }
  password { 'password' }
  password_confirmation { 'password' }
  email { Sham.email }
  is_admin { false }
end

Site.blueprint do
  name { Sham.site_name }
  title { Sham.site_title }
  published { true }
  max_mbyte { 10 }
  copyright { Sham.site_name }
  email { Sham.email }
end

Site.blueprint(:moomin) do
  name { 'moomin' }
  title { 'ムーミン' }
  published { true }
  max_mbyte { 10 }
  copyright { 'moomin' }
  email { 'nyaago@bf.wakwak.com' }
end

Site.blueprint(:totoro) do
  name { 'totoro' }
  title { 'トトロ' }
  published { true }
  max_mbyte { 10 }
  copyright { 'moomin' }
  email { 'nyaago69@gmail.com' }
end


PageArticle.blueprint do
  name { Sham.page_name }
  title { Sham.article_title}
  content { Sham.article_content}
  site_id { 1 }
  published { true }
  is_home { false }
end

BlogArticle.blueprint do
  title { Sham.article_title}
  content { Sham.article_content}
  site_id { 1 }
  published { true }
  is_home { false }
end


User.make(:admin)
Site.make(:moomin)
Site.make(:totoro)
#p PageArticle.make
#p BlogArticle.make
#PageArticle.make(:name => 'pagea')
#PageArticle.make(:name => 'pageb')
#PageArticle.make(:name => 'pagec')
#PageArticle.make(:name => 'paged')

