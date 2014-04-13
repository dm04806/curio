mediator = require 'mediator'
utils = require 'lib/utils'
View = require 'views/base/view'
common = require 'views/common/utils'
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
    ptitle: @model.ptitle()
    index: @model.index

  render: ->
    super
    @$el.find('.foldable').foldable remember: false
    @switchReplyType()

  switchReplyType: () ->
    tab = @$el.find(".reply-types a[data-type=#{@model.get 'replyType'}]")
    return if not tab.length
    target = @$el.find(tab.attr('href'))
    tab.tab('show')
    tab.data('bs.tab').activate(target, target.parent())

  getPatternItem: (node) ->
    node.closest('.pattern-item')

  ##
  # Toggle blur match of pattern
  toggleMatch: (node) ->
    isBlur = node.data('blur')
    blur = not isBlur
    text = if blur then __('rule.blur_match') else __('rule.exact_match')
    node.data('blur', blur).html(text)
    $item = @getPatternItem(node).toggleClass('exact-match')
    @model.updateKeyword $item.data('index'), blur: blur

  addKeyword: (node) ->
    view = new EditPatternModal
    view.on 'confirm', =>
      @model.pushKeywords(view.keywords)
      view.close()

  editKeyword: (node) ->
    index = @getPatternItem(node).data('index')
    view = new EditPatternModal
      data:
        keyword: @model.get('pattern')[index].text
    view.on 'confirm', =>
      @model.updateKeyword index, text: view.val()
      view.close()

  deleteKeyword: (node) ->
    $item = @getPatternItem(node)
    index = $item.data('index')
    @model.removeKeyword $item.data('index')


  chooseNews: (node) ->
    view = new ChooseNewsModal

  renderPatternList: () ->
    html = require('./templates/rule/mod/pattern')(@model.toJSON())
    @$el.find('.pattern-group').replaceWith html

  saveRule: (node) ->
    @disable(node)
    @model.destroy().done =>
      @enable(node)
      @$el.find('.foldable').foldable('toggle')
    .error (xhr) =>
      @fail(xhr, node)

  deleteRule: (node) ->
    view = common.confirm __('rule.delete_rule.confirm', @model.ptitle())
    view.on 'confirm', =>
      view.close()
      @disable(node)
      @model.destroy().done =>
        @dispose()
      .error (xhr) =>
        @fail(xhr, node)

  enable: (node) ->
    (node or @_last_disabled)?.removeAttr('disabled')
    @$el.removeClass('loading')

  disable: (node) ->
    @_last_disabled = node
    node?.attr('disabled', true)
    @$el.addClass('loading')

  fail: (xhr, node) ->
    msg = utils.xhrError(xhr)
    view = common.alert(msg or 'error.general')
    view.on 'dispose', =>
      @enable(node)

  listen:
    'change:replyType model': 'switchReplyType'
    'change:pattern model': 'renderPatternList'
