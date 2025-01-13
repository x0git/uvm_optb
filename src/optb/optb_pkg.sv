/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Package Name: optb_pkg
// Class Name: optb_object/optb_drv_base/optb_mon_base/optb_mdl_base/optb_scb_base
// Project Name: Open Platform for Test Bench
// Target Devices: ANY
// Tool Versions: develop tools, Systemverilog supported
// Description:
// 1. optb_*_base class(minimum range)
// 2.   *           abbr                comments
//      drv         driver              test-driver-signal generator
//      mon         monitor             bus sample
//      mdl         reference model     input->Expecte Output
//      scb         scoreboard          verification result generator
// Revision:
// Date         Version             Author          Comment
// 2025.Jan.01  Revision 0.00       x0git           Frame of Project(Origin)
// Author List:
//  Code                        Information
//  x0git                       virtual.q@outlook.com
// Copyright Information:
// Copyright 2025 L.X.
// Additional Comments:
// 1. [Freedom] License: BSD-3-Clause                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
//////////////////////////////////////////////////////////////////////////////////
*/

`ifndef OPTB_PKG_SV
`define OPTB_PKG_SV

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

package optb_pkg;
////////////////////
////paragraph: optb_object_root
`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class optb_object;
function new(); endfunction:new
endclass:optb_object

class optb_string extends optb_object;
    string str;
    function new(input string str_src = ""); super.new(); this.str = str_src; endfunction
endclass

////////////////////
////paragraph: driver
class optb_drv_base
#(parameter type SEED_TYPE = optb_object)
extends optb_object;
    SEED_TYPE seed;
    optb_string info;
    //
    function new(); super.new(); this.seed = null; this.info = new(); endfunction:new
    virtual task run(SEED_TYPE tseed = null, output string tinfo = ""); endtask:run
endclass:optb_drv_base

////paragraph: monitor
class optb_mon_base
#(parameter type MON_BUS_TYPE = optb_object)
extends optb_object;
    MON_BUS_TYPE mon_bus;
    //
    function new(); super.new(); this.mon_bus = new(); endfunction:new
    virtual task run(MON_BUS_TYPE tmon_bus = null); endtask:run//per_sample/per_tick
endclass:optb_mon_base

////paragraph: referecemodel
class optb_mdl_base
#(parameter type IMON_BUS_TYPE = optb_object,
  parameter type OMON_BUS_TYPE = optb_object)
extends optb_object;
    IMON_BUS_TYPE imon_bus;
    OMON_BUS_TYPE omon_bus;
    //
    function new(); super.new(); this.imon_bus = null; this.omon_bus = new(); endfunction:new
    virtual task run(IMON_BUS_TYPE timon_bus = null, OMON_BUS_TYPE tomon_bus = null); endtask:run//per_tick
endclass:optb_mdl_base

////paragraph: scoreboard
class optb_scb_base
#(parameter type MON_BUS_TYPE = optb_object)
extends optb_object;
    MON_BUS_TYPE ref_mon_bus;
    MON_BUS_TYPE mon_bus;
    optb_string info;
    //
    function new(); super.new(); this.ref_mon_bus = null; this.mon_bus = null; this.info = new(); endfunction:new
    virtual task run(MON_BUS_TYPE tref_mon_bus = null, MON_BUS_TYPE tmon_bus = null, input string tinfo = "", output string result = "is_ok"); endtask:run//process end control
endclass:optb_scb_base

endpackage:optb_pkg

`endif
