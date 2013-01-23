-module(colosimo_main_controller, [Req]).
-compile(export_all).

before_(ActionName) ->
  {ok, User} = user_lib:require_login(Req),
  % error_logger:info_msg("Found user: ~p~n",[User]),
  {ok, [{current_user, User}]}.

index('GET', []) ->
  {ok, []}.

nope('GET', []) ->
  {ok, []}.

oops('GET', []) ->
  {ok, []}.

about('GET', []) ->
  {ok, []}.
