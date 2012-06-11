-module(colosimo_main_controller, [Req]).
-compile(export_all).

before_(_) ->
    user_lib:require_login(Req).

index('GET', [], ColosimoUser) ->
  {ok, [{colosimo_user, ColosimoUser}]}.

nope('GET', []) ->
  {ok, []}.

oops('GET', []) ->
  {ok, []}.

about('GET', []) ->
  {ok, []}.
