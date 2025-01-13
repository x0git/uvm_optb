/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_monitor
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Monitor's instance should be init before used.
// 2. Monitor bus's type should be defined before used.
// 3. Variables         Type                Comments
//    MON_BUS_TYPE      paremeter type      default:uvm_sequence_item
//                                          should be set other than uvm_sequence_item.
//    mon(protected)    MONITOR_TYPE        default: null
//                                          should be defined outside of the platform.
//    testcase_domain   uvm_domain          default:null, null "default domain"
//                                          Access directly.
// 4. Type definition
//      name                definition
//      MONITOR_TYPE        optb_mon_base #(.MON_BUS_TYPE(MON_BUS_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. Monitor instance(MONITOR_TYPE) outside of model
//    monitor.run(MON_BUS_TYPE tmon_bus);
// Revision:
// Date         Version             Author          Comment
// 2025.Jan.01  Revision 0.00       x0git           Frame of Project(Origin)
// Author List:
//  Code                        Information
//  x0git                       @404 NOT FOUND
// Additional Comments:
// 1. [Freedom] License: LGPLv3
// 2. [Business] Warning: For Technical and Acadamic Exchanges.
// 3. [Industry] Compatible Environment List:
// No.      Name         Version             Company
// 000      Vivado       2020.2              Xilinx(AMD)
//////////////////////////////////////////////////////////////////////////////////
*/

`ifndef UVM_OPTB_MONITOR_SV
`define UVM_OPTB_MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_monitor
#(parameter type MON_BUS_TYPE = uvm_sequence_item)
extends uvm_monitor;
`uvm_component_param_utils(uvm_optb_monitor #(.MON_BUS_TYPE(MON_BUS_TYPE)))

typedef optb_mon_base #(.MON_BUS_TYPE(MON_BUS_TYPE)) MONITOR_TYPE;

local const string uvm_optb_name = "uvm_optb_monitor";
protected MONITOR_TYPE mon;
uvm_analysis_port #(MON_BUS_TYPE) mon_bus_port;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. Check $MONITOR_TYPE, $MON_BUS_TYPE have been set by USER.
 * 2. set $mon, $mon_bus_port to null.
 * 3. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_monitor",
             uvm_component parent = null);
    MON_BUS_TYPE mon_bus_type_chk;
    uvm_sequence_item uvm_sequence_item_chk;

    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    assert($typename(mon_bus_type_chk) != $typename(uvm_sequence_item_chk)) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $MON_BUS_TYPE has not been SET! -- Different From 'uvm_sequence_item'\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    this.mon = null;
    this.mon_bus_port = null;

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Set $mon by USER.
 * 2. DO NOT leave them with NULL.
 */
function void init(MONITOR_TYPE mon_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.mon = mon_src;
endfunction:init

/**
 * build_phase
 * 1. Set up $mon_bus_port's instance and check.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.mon_bus_port = new("mon_bus_port", this);
    assert(this.mon_bus_port != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $mon_bus_port is null! new() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:build_phase

/**
 * connect_phase
 * 1. set domain to $testcase_domain.
 */
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (connect_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    if(this.testcase_domain != null)
    begin
        this.set_domain(this.testcase_domain);
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] set_domain@<%s>\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name, this.testcase_domain.get_name()),
                  UVM_LOW);
    end
    else
    begin
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] set_domain@<%s>\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name, "default"),
                  UVM_LOW);
    end
endfunction:connect_phase

/**
 * start_of_simulation_phase
 * 1. Check $mon are set by USER.
 */
virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (start_of_simulation_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    assert(this.mon != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] should be <init> before used! $mon is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:start_of_simulation_phase

/**
 * main_phase
 * 1. Main_phase in simulation, it's called by platform automatically.
 * 2. DO NOT TOUCH!!
 */
virtual task main_phase(uvm_phase phase);
    MON_BUS_TYPE tmon_bus;

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] ((main_phase))@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    tmon_bus = new();

    forever
    begin
        this.mon.run(.tmon_bus(tmon_bus));
        this.mon_bus_port.write(tmon_bus);
    end
endtask:main_phase

endclass:uvm_optb_monitor

`endif
