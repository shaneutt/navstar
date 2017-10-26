-module(navstar_l4lb_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link([Enabled]) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Enabled]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
get_children(false) ->
    [];
get_children(true) ->
    [
        ?CHILD(navstar_l4lb_network_sup, supervisor),
        ?CHILD(navstar_l4lb_mesos_poller, worker),
        ?CHILD(navstar_l4lb_k8s_poller, worker),
        ?CHILD(navstar_l4lb_metrics, worker),
        ?CHILD(navstar_l4lb_lashup_publish, worker)
    ].

init([Enabled]) ->
    {ok, { {one_for_one, 5, 10}, get_children(Enabled)} }.

