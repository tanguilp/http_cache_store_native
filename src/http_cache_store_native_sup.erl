%%%-------------------------------------------------------------------
%% @doc http_cache_store_native top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(http_cache_store_native_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).
%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Children =
        [#{id => http_cache_store_native_table_holder,
           start => {http_cache_store_native_table_holder, start_link, []}},
         #{id => http_cache_store_native_stats,
           start => {http_cache_store_native_stats, start_link, []}},
         #{id => http_cache_store_native_expired_resp_sweeper,
           start => {http_cache_store_native_expired_resp_sweeper, start_link, []}},
         #{id => http_cache_store_native_outdated_lru_sweeper,
           start => {http_cache_store_native_outdated_lru_sweeper, start_link, []}},
         #{id => http_cache_store_native_lru_nuker,
           start => {http_cache_store_native_lru_nuker, start_link, []}},
         #{id => http_cache_store_native_cluster_sup,
           start => {http_cache_store_native_cluster_sup, start_link, []},
           type => supervisor},
         #{id => http_cache_store_native_cluster_mon,
           start => {http_cache_store_native_cluster_mon, start_link, []}}],
    {ok, {{one_for_one, 0, 1}, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
