function [np ns] = topology_decider(topology_type)
global ns np
if topology_type == 'A'
    set_param('all_topologies/Topology_A','commented','off')
    set_param('all_topologies/Topology_BC','commented','on')
    set_param('all_topologies/Topology_DE','commented','on')
    np = 1
    ns = 1
end
if (topology_type == 'B')||(topology_type == 'C')
    set_param('all_topologies/Topology_A','commented','on')
    set_param('all_topologies/Topology_BC','commented','off')
    set_param('all_topologies/Topology_DE','commented','on')
    if topology_type == 'B'
        np = 1
        ns = 2
    end
    if topology_type == 'C'
        np = 2
        ns = 2
    end
    if np ==1
        set_param('all_topologies/Topology_BC/Inverter1','commented','off')
        set_param('all_topologies/Topology_BC/Inverter2','commented','on')
        set_param('all_topologies/Topology_BC/Inverter3','commented','off')
        set_param('all_topologies/Topology_BC/Inverter4','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 1 Load','commented','off')
        set_param('all_topologies/Topology_BC/Inverter 2 Load','commented','on')
        set_param('all_topologies/Topology_BC/Inverter 3 Load','commented','off')
        set_param('all_topologies/Topology_BC/Inverter 4 Load','commented','on')
    end
    if np ==2
        set_param('all_topologies/Topology_BC/Inverter1','commented','off')
        set_param('all_topologies/Topology_BC/Inverter2','commented','off')
        set_param('all_topologies/Topology_BC/Inverter3','commented','off')
        set_param('all_topologies/Topology_BC/Inverter4','commented','off')
        set_param('all_topologies/Topology_BC/Inverter 1 Load','commented','off')
        set_param('all_topologies/Topology_BC/Inverter 2 Load','commented','off')
        set_param('all_topologies/Topology_BC/Inverter 3 Load','commented','off')
        set_param('all_topologies/Topology_BC/Inverter 4 Load','commented','off')
    end
end
if (topology_type == 'D')||(topology_type == 'E')
    set_param('all_topologies/Topology_A','commented','off')
    set_param('all_topologies/Topology_BC','commented','off')
    set_param('all_topologies/Topology_DE','commented','on')
    if topology_type == 'D'
        np = 1
        ns = 1
    end
    if topology_type == 'E'
        np = 2
        ns = 1
    end
    if np == 2
        set_param('all_topologies/Topology_DE/Load 1','commented','off')
        set_param('all_topologies/Topology_DE/Load 2','commented','off')
    end
    if np == 1
        set_param('all_topologies/Topology_DE/Load 1','commented','off')
        set_param('all_topologies/Topology_DE/Load 2','commented','on')
    end
end
