module.exports = (match) ->

  match '', 'home#index'
  match 'login', 'login#index'
  match 'logout', 'logout#index'

  match 'messages', 'messages#index'

  match 'contacts', 'contacts#index'
  match 'contact/:sid', 'contacts#show'

  match 'autoreply', 'autoreply#index'
  match 'autoreply/:sid', 'autoreply#show'
  match 'autoreply/:sid/edit', 'autoreply#edit'

  # Media control pannel
  match 'users', ''

  # Super Admin pannel
  match 'super', 'super/home#index' # super admin backend
  match 'super/users', 'super/user#index'
  match 'super/user/:id', 'super/user#show'
  match 'super/medias', 'super/media#index'
  match 'super/media/:id', 'super/media#show'

