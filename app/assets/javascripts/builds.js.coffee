# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

shaWasUpdated = false
currentPath = window.location.pathname

$ ->
  status = $('.js-build-status').attr('data-status')
  # if status not set AND not on new_build_path
  if status != "true" && status != "false" && /builds\/\d+/.test(currentPath)
    window.buildPollerId = setInterval ->
      updateBuild()
    , 1000

updateBuild = ->
  $.ajax
    url: $('.js-build-output').attr('data-uri')
    success: (build) ->
      updateFields(build)

updateFields = (build) ->
  buildOutput = $('.js-build-output')
  buildOutput.text(build.output)
  buildOutput[0].scrollTop = buildOutput[0].scrollHeight
  $('.js-build-status').text(build.status_phrase)

  unless shaWasUpdated
    if build.sha isnt null
      $('.js-build-sha').html(build.sha)
      shaWasUpdated = true

  if build.successful isnt null
    $('.js-build-status').attr('data-status', build.successful)
    clearInterval(window.buildPollerId)
    window.buildPollerId = undefined
