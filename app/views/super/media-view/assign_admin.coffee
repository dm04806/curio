mediator = require 'mediator'
ModalView = require 'views/common/modal'
User = require 'models/user'

TT_TEMPLATES =
  empty: (opt) ->
    """
    <div class="tt-empty">
      <a target="_blank" href="/super/users/create?name=#{opt.query}">
        #{__('users.create')}
      </a>
    </div>
    """
  suggestion: (d) ->
    "<p>#{d.name or d.uid} (#{d.uid})</p>"


datums = []

updateDatums = (bb) ->
  coll = User.collection params: {limit: 100, fields: 'uid,name,id'}
  coll.fetch().done ->
    datums = coll.map (item) ->
      item.attributes
    bb.index.add(datums)

getBB = ->
  bb = new Bloodhound
    datumTokenizer: (d) -> [d.uid, d.name]
    queryTokenizer: Bloodhound.tokenizers.whitespace
    local: datums
  bb.initialize()
  if not datums.length
    updateDatums bb
  return bb.ttAdapter()

# each time users got update, clear the cache
mediator.subscribe 'users:update', ->
  datums = []


module.exports = class AssignAdmin extends ModalView
  template: require './templates/assign_admin_modal'

  render: ->
    super
    @_duprow = @$el.find('.dup-row').clone().attr('class', 'norm-row')
    if not @$el.find('tr.norm-row').length
      @addRow()

  addRow: () ->
    row = @_duprow.clone().appendTo(@$el.find('tbody'))
    @prepare(row)

  removeRow: (e) ->
    $(e.target).closest('tr').remove()

  prepare: (node) ->
    node.find('.typeahead').typeahead({
      minLenght: 0
      autoselect: true
    }, {
      templates: TT_TEMPLATES
      displayKey: 'uid'
      name: 'users-list'
      source: getBB()
    })
    .on 'typeahead:selected', (e, datum) ->
      $(this).data('datum', datum)
    .on 'focus', (e) ->
      tt = $(this).data('ttTypeahead')
      tt.dropdown.open()
    .on 'blur', (e) ->
      tt = $(this).data('ttTypeahead')
      datum = tt.dropdown.getDatumForCursor() or
              tt.dropdown.getDatumForTopSuggestion()
      if datum
        tt._select(datum)

  clear: ->
    datums = []

  submit: (e) ->
    users = @$el.find('[name=user_id]')
    roles = @$el.find('[name=role]').map(-> @value).toArray()
    media_id = @model.id
    added = {}
    admins = []
    users.each (i) ->
      datum = $(this).data('datum')
      if datum and roles[i] and datum.id not of added
        added[datum.id] = true
        datum.role = roles[i]
        admins.push datum
    $(e.target).attr('disabled', true)
    @model.save({ admins: admins }).done =>
      @$el.modal('hide')
    .error (xhr) =>
      @$el.modal('hide')
      mediator.execute 'ajax-error', xhr

  events:
    'click .btn-primary': 'submit'
    'click .tt-empty': 'clear'
    'click .delete': 'removeRow'
    'click .add': 'addRow'


