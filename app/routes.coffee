module.exports = (match) ->

  __ = global?.__ or (t) -> t

  match '', 'home#index'
  match 'login', 'login#index', name: __('login')
  match 'logout', 'logout#index', name: __('logout')

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
  match 'super/users', 'super/user#index', name: __('Users')
  match 'super/user/:id', 'super/user#show', name: __('User'),
        constraints: {id: /\w+$/}

