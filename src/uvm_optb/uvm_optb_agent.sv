/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_agent
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Transaction Seed's type SUGGESTED be defined before used.
// 2. DRV_INFO_PATH SUGGESTED be started with '.'.
// 3. Driver's instance SUGGESTED be init before used.
// 4. Transaction Seed's instance SUGGESTED be init before used.
// 5. Monitor's instance SUGGESTED be init before used.
// 6. Monitor bus(translate from Monitor)'s type SUGGESTED be defined before used.
// 7. Variables         Type                Comments
//    AGENT_TYPE        parameter string    default:"input"
//                                          "input" - with driver
//                                          "output" - without driver
//    DRV_INFO_PATH     parameter string    default:"", the path for driver info
//                                          SUGGESTED set if needed and started with '.'
//    SEED_TYPE         paremeter type      default:uvm_sequence_item
//                                          SUGGESTED be set other than uvm_sequence_item.
//    MON_BUS_TYPE      paremeter type      default:uvm_sequence_item
//                                          SUGGESTED be set other than uvm_sequence_item.
//    sqr               uvm_optb_sequencer  default: null, #(SEED_TYPE)
//                                          init *.seed<SEED_TYPE> defined outside of the platform
//    drv               uvm_optb_driver     default: null, #(DRV_INFO_PATH, SEED_TYPE) 
//                                          init *.drv<DRIVER_TYPE> defined outside of the platform
//    mon               uvm_optb_monitor    default: null, #(MON_BUS_TYPE) 
//                                          init *.mon<MONITOR_TYPE> defined outside of the platform
//    testcase_domain   uvm_domain          default:null, null "default domain"
//                                          Access directly.
// 8. Type definition
//      name                definition
//      DRIVER_TYPE         optb_drv_base #(.SEED_TYPE(SEED_TYPE))
//      MONITOR_TYPE        optb_mon_base #(.MON_BUS_TYPE(MON_BUS_TYPE))
//      sqr_type            uvm_optb_sequencer #(.SEED_TYPE(SEED_TYPE))
//      drv_type            uvm_optb_driver #(.DRV_INFO_PATH(DRV_INFO_PATH),
//                                            .SEED_TYPE(SEED_TYPE))
//      mon_type            uvm_optb_monitor #(.MON_BUS_TYPE(MON_BUS_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. uvm_optb_sequencer.sv
// 4. uvm_optb_driver.sv
// 5. uvm_optb_monitor.sv
// 6. Transaction Seed instance(SEED_TYPE) outside of model
// 7. Driver instance(extends DRIVER_TYPE) outside of model
// 8. Monitor instance(extends MONITOR_TYPE) outside of model
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

`ifndef UVM_OPTB_AGENT_SV
`define UVM_OPTB_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_sequencer.sv"
`include "uvm_optb_driver.sv"
`include "uvm_optb_monitor.sv"

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_agent
#(parameter string AGENT_TYPE = "input",//"input" with drv&seq / "output" without drv&seq
  parameter string DRV_INFO_PATH = "",//".drv_info_path"
  parameter type SEED_TYPE = uvm_sequence_item,
  parameter type MON_BUS_TYPE = uvm_sequence_item)
extends uvm_agent;
`uvm_component_param_utils(uvm_optb_agent #(.AGENT_TYPE(AGENT_TYPE), .DRV_INFO_PATH(DRV_INFO_PATH),
                                            .SEED_TYPE(SEED_TYPE), .MON_BUS_TYPE(MON_BUS_TYPE)))

typedef optb_drv_base #(.SEED_TYPE(SEED_TYPE)) DRIVER_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(MON_BUS_TYPE)) MONITOR_TYPE;

typedef uvm_optb_sequencer #(.SEED_TYPE(SEED_TYPE)) sqr_type;
typedef uvm_optb_driver #(.DRV_INFO_PATH(DRV_INFO_PATH),
                          .SEED_TYPE(SEED_TYPE)) drv_type;
typedef uvm_optb_monitor #(.MON_BUS_TYPE(MON_BUS_TYPE)) mon_type;

local const string uvm_optb_name = "uvm_optb_agent";
sqr_type sqr;
drv_type drv;
mon_type mon;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. set $sqr, $drv, $mon to null.
 * 2. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_agent",
             uvm_component parent = null);
    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.sqr = null;
    this.drv = null;
    this.mon = null;

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Init $sqr(when AGENT_TYPE = "input"), $drv(when AGENT_TYPE = "input"), $mon by USER.
 * 2. DO NOT leave them with NULL according to the AGENT_TYPE.
 */
function void init(SEED_TYPE seed_src,
                   DRIVER_TYPE drv_src,
                   MONITOR_TYPE mon_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    if(this.AGENT_TYPE == "input")
    begin
        assert(this.sqr != null) this.sqr.init(seed_src);
        else
        begin
            `uvm_fatal(this.uvm_optb_name,
                       $sformatf("\n@%0t: %s ->> [%s] $sqr is null! Please call <init> in connect_phase.\n",
                                 $realtime, this.get_full_name(), this.uvm_optb_name));
            $finish;
        end

        assert(this.drv != null) this.drv.init(drv_src);
        else
        begin
            `uvm_fatal(this.uvm_optb_name,
                       $sformatf("\n@%0t: %s ->> [%s] $drv is null! Please call <init> in connect_phase.\n",
                                 $realtime, this.get_full_name(), this.uvm_optb_name));
            $finish;
        end
    end

    assert(this.mon != null) this.mon.init(mon_src);
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $mon is null! Please call <init> in connect_phase.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:init

/**
 * build_phase
 * 1. Create $sqr(when AGENT_TYPE == "input"), $drv(when AGENT_TYPE == "input"), $mon's instances and check.
 * 2. init $sqr, $drv, $mon's testcase_domain.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    if(this.AGENT_TYPE == "input")
    begin
        this.sqr = sqr_type::type_id::create("sqr", this);
        assert(this.sqr != null) else
        begin
            `uvm_fatal(this.uvm_optb_name,
                       $sformatf("\n@%0t: %s ->> [%s] $sqr is null! create() failed.\n",
                                 $realtime, this.get_full_name(), this.uvm_optb_name));
            $finish;
        end
        this.sqr.testcase_domain = this.testcase_domain;

        this.drv = drv_type::type_id::create("drv", this);
        assert(this.drv != null) else
        begin
            `uvm_fatal(this.uvm_optb_name,
                       $sformatf("\n@%0t: %s ->> [%s] $drv is null! create() failed.\n",
                                 $realtime, this.get_full_name(), this.uvm_optb_name));
            $finish;
        end
        this.drv.testcase_domain = this.testcase_domain;
    end

    this.mon = mon_type::type_id::create("mon", this);
    assert(this.mon != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $mon is null! create() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
    this.mon.testcase_domain = this.testcase_domain;
endfunction:build_phase

/**
 * connect_phase
 * 1. connect $sqr.seq_item_export and $drv.seq_item_port(when AGENT_TYPE == "input").
 * 2. set_domain to $testcase_domain.
 */
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (connect_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    if(this.AGENT_TYPE == "input")
    begin
        this.drv.seq_item_port.connect(this.sqr.seq_item_export);
    end

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

endclass:uvm_optb_agent

`endif
