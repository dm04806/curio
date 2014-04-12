mediator = require 'mediator'
View = require 'views/base/view'
EditPatternModal = require './edit_pattern'
ChooseNewsModal = require './choose_news'


module.exports = class AutoreplyRuleView extends View
  autoRender: true
  noWrap: true
  getTemplateFunction: ->
    try
      require "./templates/rule/#{@model.get 'type'}"
    catch
      require "./templates/rule/default"

  context: ->
    title: "rule.#{@model.get 'name'}.title"

  render: ->
    super
    @$el.find('.foldable').foldable()
    @switchReplyType()

  switchReplyType: () ->
    tab = @$el.find(".reply-types a[data-type=#{@model.get 'replyType'}]")
    target = @$el.find(tab.attr('href'))
    tab.tab('show')
    tab.data('bs.tab').activate(target, target.parent())

  addPattern: (node) ->
    view = new EditPatternModal
    view.on 'confirm', =>
      @model.pushKeywords(view.keywords)
      view.close()

  ##
  # Toggle blur match of pattern
  toggleMatch: (node) ->
    isBlur = node.data('blur')
    blur = not isBlur
    text = if blur then __('rule.blur_match') else __('rule.exact_match')
    node.data('blur', blur).html(text)

    parent = node.closest('.pattern-item').toggleClass('exact-match')

    @model.updateKeyword parent.data('index'), blur: true

  editKeyword: (node) ->
    index = node.closest('.pattern-item').data('index')
    view = new EditPatternModal
      data:
        keyword: @model.get('pattern')[index].text
    view.on 'confirm', =>
      @model.updateKeword index, text: view.val()
      view.close()

  deleteKeyword: (node) ->


  chooseNews: (node) ->
    view = new ChooseNewsModal

  renderPatternList: () ->
    html = require('./templates/rule/mod/pattern')(@model.attributes)
    @$el.find('.pattern-group').replaceWith html

  listen:
    'change:replyType model': 'switchReplyType'
    'change:pattern model': 'renderPatternList'
