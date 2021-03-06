EventsEmitter = require( 'events' )
Pagination = require( './index' )
PaginationView = require( './view' )

###
 * #PaginationCtrl
 * Creates a pagination element and controls it.
 *
 * ## Events
 *
 * | CONSTANT.argument  | Description |
 * |--------------------| -------------|
 * | CHANGE | When page number is changed by user |
 * | CHANGE.current  | New page number |
 * | CHANGE.last | Number of last page |
###
class PaginationCtrl extends EventsEmitter

  CHANGE: 'syn.grid.pagination.ctrl.change'

  ###
   * Pagination.CHANGE handler: emits change event
  ###
  _onPageChange: ( current, last ) =>
    @emit( @CHANGE, current, last )

  ###
   * Button click handler: sets new page
  ###
  _onButtonClick: ( page ) =>
    @pagination.current( page )

  ###
   * @constructor
   * @param  {jqLite} @element Target element
   * @param  {Object} options = {} Pagination options
  ###
  constructor: ( @element, options = {} ) ->
    @setOptions( options )

  ###
   * Sets view and appends it to @element
   * @returns {PaginationCtrl} `this`
  ###
  init: ->
    # Creates pagination elements only if pagination in not "false"
    return if @_options is false
    @view = new PaginationView( @pagination )
    @view.on( @view.CLICK, @_onButtonClick )
    @element.append( @view.element )
    return this

  ###
   * Sets a pagination object
   * @param {Object} options Options expected by Pagination
   * @returns {PaginationCtrl} `this`
  ###
  setOptions: ( @_options ) ->
    @pagination = new Pagination( @_options )
    @pagination?.on( @pagination.CHANGE, @_onPageChange )
    return this

  ###
   * Sets total rows
   * @param {number} count
  ###
  setCount: ( count ) ->
    @pagination.rowsCount( count )
    return this

  ###
   * Returns rows to skip
   * @returns {number}
  ###
  getSkipped: ->
    @pagination.current() * @pagination.rowsPerPage()

  ###
   * Returns rows to display per page
   * @returns {number}
  ###
  getLimit: ->
    @pagination.rowsPerPage()

  ###
   * Removes appended elements and events
  ###
  destroy: ->
    @pagination.removeListener( @pagination.CHANGE, @_onPageChange )
    return if !@view
    @view.element.remove()
    @view
      .removeListener( @view.CLICK, @_onButtonClick )
      .destroy()



module.exports = PaginationCtrl
