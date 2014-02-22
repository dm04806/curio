module.exports = function(match) {
  match('', 'home#index')
  match('login', 'login#index')
  match('logout', 'logout#index')
  match('users', '')
  match('messages', 'message#index')
  match('subscribers', 'subscriber#index')
  match('subscriber/:id', 'subscriber#show')
  match('stats', 'stats#index')
  match('channels', 'channel#index')
  match('channel/:id', 'channel#show')
  match('autoreply', 'autoreply#index')
  match('autoreply/:id', 'autoreply#show')
  match('autoreply/:id/edit', 'autoreply#edit')
  match('super', 'super/home#index')
  match('super/users', 'super/user#index')
  match('super/user/:id', 'super/user#show')
  match('super/medias', 'super/media#index')
  return match('super/media/:id', 'super/media#show')
}