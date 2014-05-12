"use strict";

module.exports = function(match) {
  match('', 'home#index')
  match('login', 'login#index')
  match('logout', 'logout#index')

  match('settings', 'settings#index')

  match('messages', 'message#index')

  match('subscribers', 'subscriber#index')
  match('subscriber/:id', 'subscriber#show')

  match('stats', 'stats#index')

  match('channels', 'channel#index')
  match('channel/:id', 'channel#show')

  match('places', 'place#index')
  match('places/create', 'place#create')
  match('place/:id', 'place#show')

  match('autoreply', 'autoreply#index')

  match('super', 'super/home#index')
  match('super/users', 'super/user#index')
  match('super/users/create', 'super/user#create')
  match('super/user/:id', 'super/user#show')

  match('super/medias', 'super/media#index')
  match('super/medias/create', 'super/media#create')
  match('super/media/:id', 'super/media#show')

  match('menu', 'menu#index')
}
