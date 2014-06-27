ModalView = require 'views/common/modal'
utils = require 'lib/utils'
Channel = require 'models/channel'
ChannelListView = require './channel_list'


module.exports = class ChooseChannelView extends ModalView
  template: require './templates/choose_channel'

  render: ->
    super
    @listView = new ChannelListView
      container: @$('.place-channels')
      model: @model

  disable: ->
    @$('button,input').attr('disabled', true)

  enable: ->
    @$('button,input').removeAttr('disabled')

  getChannels: ->
    @listView.getChannels()


  addNew: (e) ->
    e?.preventDefault()
    e?.stopPropagation()
    inp = @$('input[name=scene_id]')
    val = inp.val()
    if not $.trim(val)
      @msg('place.channel.empty_scene_id')
      return
    @disable()
    Channel.findOrCreate(val)
      .done (item) =>
        @listView.addItem(item)
        inp.val('')
      .error (xhr) =>
        err = utils.xhrError(xhr)
        @msg(err)
      .always =>
        setTimeout =>
          @enable()
        , 500

  events:
    'click a': (e) ->
      e.stopPropagation()
      e.preventDefault()
    'submit form': 'addNew'

