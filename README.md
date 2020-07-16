 # WAIWAI
 
 URL:https://waiwaisgr3u.herokuapp.com/
 
 テストアカウント 
　　</br>login-email：test@com
　　</br>password：111111

 ![トップページ](https://github.com/T-SGR3u/waiwai/blob/master/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-07-15%201.13.08.png)
 
## 概要
本アプリはおすすめしたい飲食店をカードとして簡単に投稿でき、さらに登録時の住所からGoogle Mapでお店の位置情報を示すことができます。
気軽に投稿して、自分が好きな店を共有し合いましょう!
</br>※注意点
</br>
ユーザー登録していない場合は、一覧ページ及び詳細ページしか閲覧することができません。
投稿・お気に入りクリック・コメントをしたい場合は、ぜひログインを。

## 機能紹介
### 投稿カードについて
#### 投稿 〜 一覧表示 〜 詳細ページ
"NEW POST!"から投稿したカードはトップページに一覧表示されます（8枚/ページ）。一覧に表示されるカードの内容は写真・評価・タグ・住所・点数です。

<img src="https://github.com/T-SGR3u/waiwai/blob/master/card.png" width="200" height="300">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/T-SGR3u/waiwai/blob/master/index_all.png" width="600" height="400"> 

カードの詳細を確認したい場合は、カードの画像をクリックすると詳細ページに遷移します。お気に入りボタン（ハート）も搭載しており、一覧ページもしくは詳細ページからクリック可能です。

<img src="https://github.com/T-SGR3u/waiwai/blob/master/show.png" width="700" height="400"> 

#### タグ機能
カードに表示されているタグをクリックすることで、同名のタグが紐づいているカードだけを表示させることができる"タグ検索機能"を搭載しています。
一覧ページからは名前及び住所の検索(Ransack)も可能にしているため、タグと検索を組み合わせて情報を絞り込めます。


<img src="https://github.com/T-SGR3u/waiwai/blob/master/tag_index.png"> 

### GoogleMapについて
投稿時に登録する住所を"geocoder"の機能で緯度・経度を割り出して,一覧ページのマップにスポットとしてマークすることができます。</br>
(※デフォルトで中心地は大阪に設定しています)</br>
スポットをクリックすると登録時の名前と評価が表示され、さらにクリックすると詳細ページに遷移します。詳細ページには登録スポットを中心としたマップになるよう調節しています（上記の詳細ページ図を参照）

<img src="https://github.com/T-SGR3u/waiwai/blob/master/map.png">

### my pageについて
マイページをクリックすると、自身が投稿したカード、お気に入り（ハート）をクリックしたカード、コメントした内容を一覧表示させることができます。

<img src="https://github.com/T-SGR3u/waiwai/blob/master/my_page.png">

## 開発環境
- Ruby
- Ruby on Rails
- Bootstrap
- Java script(jquery)

## こだわり設計
### Google Map API
- gmap4rails
- geocoder</br>

上記gemを利用して、GoogleMapの表示及び登録住所からマップにマーカーを設置。

```
*application.html.haml

!!!
%html
  %head
    %meta{:content => "text/html; charset=UTF-8", "http-equiv" => "Content-Type"}/
    %title Waiwai
    = csrf_meta_tags
    = csp_meta_tag
    = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_include_tag 'application', 'data-turbolinks-track': 'reload'
    %script{:src => "//maps.google.com/maps/api/js?key=#{Rails.application.credentials[:GOOGLE_MAP_KEY]}"}
    %script{:src => "//cdn.rawgit.com/mahnunchik/markerclustererplus/master/dist/markerclusterer.min.js"}
  %body

```

```
*index.html.haml

%div{:style => "width: 100%;"}
  #map{:style => "width: 100%; height: 400px;"}

  :javascript
    handler = Gmaps.build('Google');
    handler.buildMap({ 
      provider: {mapTypeId: 'roadmap'},
      internal: {id: 'map'}
    }, 
      function(){
        markers = handler.addMarkers(#{raw @hash.to_json});
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
        handler.getMap().setCenter(new google.maps.LatLng(34.68639, 135.52));
        handler.getMap().setZoom(8);
      });
```
```
*posts.controller

  def map_action
    @hash = Gmaps4rails.build_markers(@posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow render_to_string(partial: "posts/infowindow", locals: { post: post })
    end
  end
```

### お気に入り機能
各カード及び詳細ページに搭載されているハートをクリックすることで、お気に入りのON/OFFを切り替えることができます。</br>
※ON:赤、OFF:黒
さらに、ハートマークの横にはカウント機能があり、各ユーザーがクリックすると数字が加算されます。
このお気に入り機能をAjaxを利用してリロード無しで切り替わるようにしています。

```
*index.html.haml
 .btn-group.bg-success
   .card-btn{id:"likes_buttons_#{post.id}"}
     = render partial: "likes/like", locals: {post: post}
   .text-white.ml-4.pt-2
     user : 
     = post.user.name
```
```
*_like.html.haml

-if user_signed_in?
  -if current_user.already_liked?(post)
    %button.btn.btn
      .d-flex.form-inline.justify-content-center
        = link_to post_like_path(post,post.id),class:"already-heart-btn ml-4" ,method: :delete ,remote: true do
          =icon("fa","heart")
        .heart-count.ml-3
          =post.likes.count
  -else
    %button.btn.btn
      .d-flex.form-inline.justify-content-center
        = link_to post_likes_path(post) ,class:"heart-btn ml-4" ,method: :post ,remote: true do
          = icon("fa","heart")
        .heart-count.ml-3
          =post.likes.count
-else
  %button.btn.btn
    .d-flex.form-inline.justify-content-center
      = icon("fa","heart")
      .heart-count.ml-3
        =post.likes.count
```
部分テンプレート(_like.html.haml)を利用し、renderでハートのON/OFFが切り替わるようにしています。
リンクに"remote: true"を追加することで、likes_controllerにjs形式のリクエストを送信しています。

```
*likes_controller

class LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.create(post_id: params[:post_id])
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
    @like.destroy
  end

end
```

```
*create.js.erb

$('#likes_buttons_<%= @post.id %>').html("<%= j(render partial: 'likes/like', locals: {post: @post}) %>");
```

```
*destroy.js.erb

$('#likes_buttons_<%= @post.id %>').html("<%= j(render partial: 'likes/like', locals: {post: @post}) %>");
```



