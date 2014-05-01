mediator = require 'mediator'
utils = require 'lib/utils'
View = require 'views/base/view'
common = require 'views/common/utils'
EditPatternModal = require './edit_pattern'
ChooseNewsModal = require './choose_news'


module.exports = class RuleView extends View
  noWrap: true
  getTemplateFunction: ->
    try
      require "./templates/rule/#{@model.get 'type'}"
    catch
      require "./templates/rule/default"

  context: ->
    ptitle: @model.ptitle()

  render: ->
    super
    folder = @$el.find('.foldable').foldable({ remember: false })
    folder.on 'unfold', =>
      @$el.siblings().each (i, item) ->
        $(item).data('folder')?.fold()
    @$el.data 'folder', folder.data('curio.foldable')
    @switchReplyTab()

  fold: ->
    @$el.data('folder').fold()

  unfold: ->
    @$el.data('folder').unfold()

  toggle: ->
    @$el.data('folder').toggle()

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
    common.alert 'comming soon'

  chooseImage: (node) ->
    common.alert 'comming soon'

  renderPatternList: () ->
    html = require('./templates/rule/mod/pattern')(@model.toJSON())
    @$el.find('.pattern-group').replaceWith html
    @renderPtitle()

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
        folder = @$el.data('folder')
        common.notify("#{__('save.success')}!", 'success')
        return if not folder
        # to enable a slide transition, we must assign height
        folder.$el.height(folder.$el.height())
        setTimeout ->
          folder.fold()
          folder.$el.height('auto')
      , 100
    .error (xhr) =>
      @fail(xhr, node)

  deleteRule: (node) ->
    if @model.isNew()
      @$el.next().data('folder')?.unfold()
      return @model.destroy()
    text = __('rule.delete_rule.confirm', @model.ptitle())
    common.confirm text, =>
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
    return if @disposed
    (node or @_last_disabled)?.removeAttr('disabled')
    @$el.removeClass('loading')

  disable: (node) ->
    @_last_disabled = node
    node?.attr('disabled', true)
    @$el.addClass('loading')

  fail: (xhr, node) ->
    err = utils.xhrError(xhr)
    detail = xhr.responseJSON?.detail?[0]
    if detail
      err = "rule.error.#{detail.field}.#{detail.error}"
    view = common.alert(err)
    view.on 'dispose', =>
      @enable(node)

  listen:
    'change:pattern model': 'renderPatternList'
