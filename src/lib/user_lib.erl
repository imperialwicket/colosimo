-module(user_lib).
-compile(export_all).

hash_password(Password)->
    bcrypt:hashpw(Password, bcrypt:gen_salt()).

require_login(Req) ->
    case Req:cookie("colosimo_user_id") of
        undefined -> {ok, []};
        Id ->
            case boss_db:find(Id) of
                undefined -> {ok, []};
                ColosimoUser ->
                    case ColosimoUser:session_identifier() =:= Req:cookie("session_id") of
                        false -> {ok, []};
                        true -> {ok, ColosimoUser}
                    end
            end
     end.

