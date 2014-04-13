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
    folder = @$el.find('.foldable').foldable({ remember: false })
    folder.on 'unfold', =>
      @$el.siblings().each (i, item) ->
        $(item).data('folder').fold()
    @$el.data 'folder', folder.data('curio.foldable')
    @switchReplyTab()

  fold: ->
    @$el.data('folder').fold()

  unfold: ->
    @$el.data('folder').unfold()

  switchReplyTab: () ->
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

  renderPtitle: () ->
    @$el.find('.ptitle').html(@model.ptitle())

  saveRule: (node) ->
    if not @model.get('pattern')?.length
      common.alert('rule.error.pattern.is required')
      return
    @disable(node)
    @syncReply()
    @model.save().done =>
      setTimeout =>
        @enable(node)
        # to enable a slide transition
        folder = @$el.data('folder')
        folder.$el.height(folder.$el.height())
        setTimeout ->
          folder.fold()
          folder.$el.height('auto')
      , 100
    .error (xhr) =>
      @fail(xhr, node)

  deleteRule: (node) ->
    if @model.index < 0
      @$el.next().data('folder')?.unfold()
      return @dispose()
    view = common.confirm __('rule.delete_rule.confirm', @model.ptitle())
    view.on 'confirm', =>
      view.close()
      @disable(node)
      @model.destroy().done =>
        @dispose()
      .error (xhr) =>
        @fail(xhr, node)

  # Sync reply content
  syncReply: () ->
    pane = @$el.find('.tab-pane.active')
    type = pane.data('type')
    if type == 'text'
      @model.set 'handler', pane.find('textarea').val()

  enable: (node) ->
    (node or @_last_disabled)?.removeAttr('disabled')
    @$el.removeClass('loading')

  disable: (node) ->
    @_last_disabled = node
    node?.attr('disabled', true)
    @$el.addClass('loading')

  fail: (xhr, node) ->
    msg = utils.xhrError(xhr)
    detail = xhr.responseJSON?.detail?[0]
    if detail
      msg = "rule.error.#{detail.field}.#{detail.error}"
    view = common.alert(msg or 'error.general')
    view.on 'dispose', =>
      @enable(node)

  listen:
    'change:pattern model': 'renderPatternList'
    'change:name model': 'renderPtitle'
