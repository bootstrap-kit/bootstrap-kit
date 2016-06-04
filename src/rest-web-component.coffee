WebComponent = require './web-component'

# Public: Provide a {WebComponent} managing REST data
#
# You will usually rather derive an object from this class, but you can
# create an abstract {RestWebComponent} object, with following code:
# ```coffee
#   component = new RestWebComponent updateURL: 'http://localhost:3001/foo'
# ```
#
# This code shows the basic
module.exports =
class RestWebCopmonent extends WebComponent
  # Public: get URL for updating the data
  #
  # Override this in derived objects, for returning a computed URL
  getUpdateURL: ->
    @options.updateURL

  # Public: set URL for updating the data
  setUpdateURL: (url) ->
    @options.updateURL = url

  # Public: get HTTP Method
  #
  # Called from {::updateFromHost} to get HTTP Method for getting data.
  getHTTPMethod: ->
    @options.method or 'get'

  # Public: set HTTP Method
  #
  # Sets the method, which is returned by default {::getHTTPMethod} function
  setHTTPMethod: (method) ->
    @options.method = method

  # Public: get parameters for updating data from host
  #
  # Override this method to pass parameters to server
  #
  # Returns an {Object}, which is used by {::updateFromHost} as data passed
  # to Server.
  getParams: ->
    {}

  # Extended: update data from host
  #
  # This function gets data from host and starts updating data by calling
  # {WebComponent::updateData}
  updateFromHost: ->
    $.get @getUpdateURL(), @getParams(), (data) =>
      @updateData(data)
    .fail (res, textStatus, error) =>
      @setView """
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
          <h4><i class="icon fa fa-ban"></i> #{res.status} #{res.statusText}!</h4>
          Could not get <a href="#{url}">#{url}</a>
        </div>
      """

      console.log "Details", res, textStatus, error

  # Public: Start updating data regularly
  #
  # - `interval` {Integer} update interval in milliseconds (default: 10000)
  # - `options` {Object}
  #   * `now` if set to `false` do not update at call of this function
  #
  # Returns ID returned by `setInterval()` function
  startUpdating: (interval, opts={}) ->
    unless interval?
      interval = @interval or 10000

    @endUpdating()

    if opts.now isnt false
      @updateFromHost()

    @updateInterval = setInterval (=> @updateFromHost()), interval

  # Public: End updating data regularly
  endUpdating: ->
    return unless @updateInterval?
    clearInterval @updateInterval
    @updateInterval = null
