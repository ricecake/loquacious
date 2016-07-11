%%%-------------------------------------------------------------------
%% @doc loquacious_web public API
%% @end
%%%-------------------------------------------------------------------

-module(loquacious_web_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	case loquacious_web_sup:start_link() of
		{ok, Pid} ->
			Dispatch = cowboy_router:compile([
				{'_', [
					% Static File route
					{"/static/[...]", cowboy_static, {priv_dir, loquacious_web, "static/"}},
					% Dynamic Pages
					{"/", loquacious_web_page, index}
				]}
			]),
			{ok, _} = cowboy:start_http(loquacious_web, 25, [{ip, {127,0,0,1}}, {port, 8686}],
							[{env, [{dispatch, Dispatch}]}]),
			{ok, Pid}
	end.

%%--------------------------------------------------------------------

stop(_State) ->
	ok.

%%====================================================================1
%% Internal functions
%%====================================================================
