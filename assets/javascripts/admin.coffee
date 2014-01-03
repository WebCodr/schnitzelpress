Schnitzelpress = window.Schnitzelpress ||= {}

angular.module('Schnitzelpress.Services.State', []).factory('$state',
  ->
    currentState = null

    {
      set: (state) ->
        currentState = state if state != undefined

      is: (state) ->
        currentState == state
    }
)

app = angular.module('Schnitzelpress', [
  'Schnitzelpress.Services.State'
])
