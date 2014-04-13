ModalView = require 'views/common/modal'

KEYBOARD = require 'lib/keyboard'

newKeywordTag = (word) ->
  node = $('<span class="tag"></span>')
  node.text(word)
  node.data('word', word)
  node.append('<a class="cancel">&times;</a>')
  node

module.exports = class EditPatternModal extends ModalView
  template: require './templates/edit_pattern'

  initialize: ->
    super
    @keywords = []
    # keyword not existing, then we are adding
    @isAddMode = 'keyword' not of @data

  render: ->
    super
    @$inputer = @$el.find('textarea')

  context: ->
    title: if @isAddMode then 'rule.add_keyword' else 'rule.edit_keyword'

  pushItem: () ->
    return if not @isAddMode
    p = $.trim(@val())
    if not p
      return
    @keywords.push p
    @val('')
    @$el.find('.keywords-list').append(newKeywordTag(p))

  onKeydown: (e) ->
    return if not @isAddMode
    if e.which == KEYBOARD.ENTER
      e.preventDefault()
      @pushItem()

  removeItem: (e) ->
    e.preventDefault()
    node = $(e.target).closest('.tag')
    word = node.data('word')
    node.remove()
    @keywords = @keywords.filter (item) ->
      item != word
    @$inputer.focus()

  val: (args...) ->
    @$inputer.val(args...)

  events:
    'keydown textarea': 'onKeydown'
    'click .cancel': 'removeItem'

  listen:
    'confirm': 'pushItem'


