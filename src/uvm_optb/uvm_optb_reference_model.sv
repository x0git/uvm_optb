/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_reference_model
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Reference model's instance should be init before used.
// 2. Reference model input bus's type should be defined before used.
// 3. Reference model output bus's type should be defined before used.
// 4. Variables         Type                Comments
//    IMON_BUS_TYPE     paremeter type      default:uvm_sequence_item
//                                          Should be set other than uvm_sequence_item.
//    OMON_BUS_TYPE     paremeter type      default:uvm_sequence_item
//                                          Should be set other than uvm_sequence_item.
//    mdl(protected)    REFMODEL_TYPE       default: null
//                                          should be defined outside of the platform.
//    testcase_domain   uvm_domain          default:null, null "default domain"
//                                          Access directly.
// 5. Type definition
//      name                definition
//      REFMODEL_TYPE       optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                          .OMON_BUS_TYPE(OMON_BUS_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. Reference model instance(extends REFMODEL_TYPE) outside of model
//    model.run(IMON_BUS_TYPE timon_bus, OMON_BUS_TYPE tomon_bus)
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

`ifndef UVM_OPTB_REFERENCE_MODEL_SV
`define UVM_OPTB_REFERENCE_MODEL_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_reference_model
#(parameter type IMON_BUS_TYPE = uvm_sequence_item,
  parameter type OMON_BUS_TYPE = uvm_sequence_item)
extends uvm_component;
`uvm_component_param_utils(uvm_optb_reference_model #(.IMON_BUS_TYPE(IMON_BUS_TYPE), .OMON_BUS_TYPE(OMON_BUS_TYPE)))

typedef optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
                        .OMON_BUS_TYPE(OMON_BUS_TYPE)) REFMODEL_TYPE;

local const string uvm_optb_name = "uvm_optb_reference_model";
protected REFMODEL_TYPE mdl;

uvm_blocking_get_port #(IMON_BUS_TYPE) imon_bus_port;
uvm_analysis_port #(OMON_BUS_TYPE) omon_bus_port;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. Check $REFMODEL_TYPE, $IMON_BUS_TYPE, $OMON_BUS_TYPE have been set by USER.
 * 2. Set $drv, $imon_bus_port, $omon_bus_port to null.
 * 3. Set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_reference_model",
             uvm_component parent = null);
    IMON_BUS_TYPE imod_bus_type_chk;
    OMON_BUS_TYPE omod_bus_type_chk;
    uvm_sequence_item uvm_sequence_item_type_chk;

    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    assert($typename(imod_bus_type_chk) != $typename(uvm_sequence_item_type_chk)) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $IMON_BUS_TYPE has not been SET! -- Different From 'uvm_sequence_item'\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    assert($typename(omod_bus_type_chk) != $typename(uvm_sequence_item_type_chk)) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $OMON_BUS_TYPE has not been SET! -- Different From 'uvm_sequence_item'\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    this.mdl = null;
    this.imon_bus_port = null;
    this.omon_bus_port = null;

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Set $mdl by USER.
 * 2. DO NOT leave them with NULL.
 */
function void init(REFMODEL_TYPE mdl_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.mdl = mdl_src;
endfunction:init

/**
 * build_phase
 * 1. Set up $imon_bus_port, $omon_bus_port's instances and check.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    imon_bus_port = new("imon_bus_port", this);
    assert(this.imon_bus_port != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $imon_bus_port is null! new() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    omon_bus_port = new("omon_bus_port", this);
    assert(this.omon_bus_port != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $omon_bus_port is null! new() failed.\n",
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
 * 1. Check $mdl which has been set by USER.
 */
virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (start_of_simulation_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    assert(this.mdl != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] should be <init> before used! $mdl is null!\n",
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
    IMON_BUS_TYPE timon_bus;
    OMON_BUS_TYPE tomon_bus;

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] ((main_phase))@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    tomon_bus = new();

    forever
    begin
        this.imon_bus_port.get(timon_bus);
        this.mdl.run(.timon_bus(timon_bus), .tomon_bus(tomon_bus));
        this.omon_bus_port.write(tomon_bus);
    end
endtask:main_phase

endclass:uvm_optb_reference_model

`endif
