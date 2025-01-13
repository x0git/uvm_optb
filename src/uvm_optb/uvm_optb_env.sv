/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_env
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Transaction Seed's type SUGGESTED be defined before used.
// 2. DRV_INFO_PATH SUGGESTED be started with '.'.
// 3. Driver's instance SUGGESTED be init before used.
// 4. Input Monitor's instance SUGGESTED be init before used.
// 5. Input Monitor bus's type SUGGESTED be defined before used.
// 6. Output Monitor's instance SUGGESTED be init before used.
// 7. Output Monitor bus's type SUGGESTED be defined before used.
// 8. ScoreBoard's instance SUGGESTED be init before used.
// 9. Reference Model's instance SUGGESTED be init before used.
// 10.Variables         Type                        Comments
//    TEST_CASE_TYPE    parameter string            default:"master", 
//                                                  "master", iagt, oagt, scb, mdl
//                                                  "slave", oagt, scb, mdl
//    DRV_INFO_PATH     parameter string            default:"", the path for driver info
//                                                  SUGGESTED set if needed and started with '.'
//    SEED_TYPE         paremeter type              default:uvm_sequence_item
//                                                  SUGGESTED be set other than uvm_sequence_item.
//    IMON_BUS_TYPE     paremeter type              default:uvm_sequence_item
//                                                  SUGGESTED be set other than uvm_sequence_item.
//    OMON_BUS_TYPE     paremeter type              default:uvm_sequence_item
//                                                  SUGGESTED be set other than uvm_sequence_item.
//    iagt              uvm_optb_agent              default: null, #(AGENT_TYPE_OF_IAGT, DRV_INFO_PATH_OF_IAGT, SEED_TYPE, IMON_BUS_TYPE)
//                                                  init *.seed<SEED_TYPE>, *.drv<DRIVER_TYPE>, *.mon<IMONITOR_TYPE> defined outside of the platform
//    oagt              uvm_optb_agent              default: null, #("output", "", SEED_TYPE, OMON_BUS_TYPE)
//                                                  init *.mon<OMONITOR_TYPE> defined outside of the platform
//    mdl               uvm_optb_reference_model    default: null, #(IMON_BUS_TYPE, OMON_BUS_TYPE)
//                                                  init *.mdl<REFMODEL_TYPE> defined outside of the platform
//    scb               uvm_optb_scoreboard         default: null, #(DRV_INFO_PATH, OMON_BUS_TYPE)
//                                                  init *.scb<SCOREBOARD_TYPE> defined outside of the platform
//    testcase_domain   uvm_domain                  default:null, null "default domain"
//                                                  Access directly.
// 11.Type definition
//      name                definition
//      DRIVER_TYPE         optb_drv_base #(.SEED_TYPE(SEED_TYPE))
//      IMONITOR_TYPE       optb_mon_base #(.MON_BUS_TYPE(IMON_BUS_TYPE))
//      OMONITOR_TYPE       optb_mon_base #(.MON_BUS_TYPE(OMON_BUS_TYPE))
//      REFMODEL_TYPE       optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                          .IMON_BUS_TYPE(OMON_BUS_TYPE))
//      SCOREBOARD_TYPE     optb_scb_base #(.MON_BUS_TYPE(OMON_BUS_TYPE))
//      iagt_type           uvm_optb_agent #(.AGENT_TYPE(AGENT_TYPE_OF_IAGT),
//                                           .DRV_INFO_PATH(DRV_INFO_PATH_OF_IAGT),
//                                           .SEED_TYPE(SEED_TYPE),
//                                           .MON_BUS_TYPE(IMON_BUS_TYPE))
//      oagt_type           uvm_optb_agent #(.AGENT_TYPE("output"),
//                                           .DRV_INFO_PATH(""),
//                                           .SEED_TYPE(SEED_TYPE),
//                                           .MON_BUS_TYPE(OMON_BUS_TYPE))
//      mdl_type            uvm_optb_reference_model #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                                     .OMON_BUS_TYPE(OMON_BUS_TYPE))
//      scb_type            uvm_optb_scoreboard #(.DRV_INFO_PATH(DRV_INFO_PATH),
//                                                .MON_BUS_TYPE(OMON_BUS_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. uvm_optb_agent.sv
// 4. uvm_optb_reference_model.sv
// 5. uvm_optb_scoreboard.sv
// 6. Transaction Seed instance(SEED_TYPE) outside of model
// 7. Driver instance(extends DRIVER_TYPE) outside of model
// 8. Input Monitor instance(extends IMONITOR_TYPE) outside of model
// 9. Output Monitor instance(extends OMONITOR_TYPE) outside of model
// 10. Reference Model instance(extends REFMODEL_TYPE) outside of model
// 11.ScoreBoard instance(extends SCOREBOARD_TYPE) outside of model
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

`ifndef UVM_OPTB_ENV_SV
`define UVM_OPTB_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_agent.sv"
`include "uvm_optb_reference_model.sv"
`include "uvm_optb_scoreboard.sv"

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_env
#(parameter string TEST_CASE_TYPE = "master",//"master":iagt enable, "slave":iagt disable
  parameter string DRV_INFO_PATH = "",//".drv_info_path"
  parameter type SEED_TYPE = uvm_sequence_item,
  parameter type IMON_BUS_TYPE = uvm_sequence_item,
  parameter type OMON_BUS_TYPE = uvm_sequence_item)
extends uvm_env;
`uvm_component_param_utils(uvm_optb_env #(.TEST_CASE_TYPE(TEST_CASE_TYPE),
                                          .DRV_INFO_PATH(DRV_INFO_PATH),
                                          .SEED_TYPE(SEED_TYPE),
                                          .IMON_BUS_TYPE(IMON_BUS_TYPE),
                                          .OMON_BUS_TYPE(OMON_BUS_TYPE)))

typedef optb_drv_base #(.SEED_TYPE(SEED_TYPE)) DRIVER_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(IMON_BUS_TYPE)) IMONITOR_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(OMON_BUS_TYPE)) OMONITOR_TYPE;
typedef optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
                        .OMON_BUS_TYPE(OMON_BUS_TYPE)) REFMODEL_TYPE;
typedef optb_scb_base #(.MON_BUS_TYPE(OMON_BUS_TYPE)) SCOREBOARD_TYPE;

localparam AGENT_TYPE_OF_IAGT = (TEST_CASE_TYPE == "master") ? "input" : "output";
localparam DRV_INFO_PATH_OF_IAGT = (TEST_CASE_TYPE == "master") ? DRV_INFO_PATH : "";

typedef uvm_optb_agent #(.AGENT_TYPE(AGENT_TYPE_OF_IAGT),
                         .DRV_INFO_PATH(DRV_INFO_PATH_OF_IAGT),
                         .SEED_TYPE(SEED_TYPE),
                         .MON_BUS_TYPE(IMON_BUS_TYPE)) iagt_type;
typedef uvm_optb_agent #(.AGENT_TYPE("output"),
                         .DRV_INFO_PATH(""),
                         .SEED_TYPE(SEED_TYPE),
                         .MON_BUS_TYPE(OMON_BUS_TYPE)) oagt_type;
typedef uvm_optb_reference_model #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
                                   .OMON_BUS_TYPE(OMON_BUS_TYPE)) mdl_type;
typedef uvm_optb_scoreboard #(.DRV_INFO_PATH(DRV_INFO_PATH),
                              .MON_BUS_TYPE(OMON_BUS_TYPE)) scb_type;

local const string uvm_optb_name = "uvm_optb_env";
protected iagt_type iagt;
protected oagt_type oagt;
protected mdl_type mdl;
protected scb_type scb;

protected uvm_tlm_analysis_fifo #(IMON_BUS_TYPE) iagt2mdl_fifo;
protected uvm_tlm_analysis_fifo #(OMON_BUS_TYPE) oagt2scb_fifo, mdl2scb_fifo;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. set $iagt, $oagt, $mdl, $scb to null.
 * 2. set $iagt2mdl_fifo, $oagt2scb_fifo, $mdl2scb_fifo to null.
 * 3. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_env",
             uvm_component parent = null);
    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.iagt = null;
    this.oagt = null;
    this.mdl = null;
    this.scb = null;
    this.iagt2mdl_fifo = null;
    this.oagt2scb_fifo = null;
    this.mdl2scb_fifo = null;

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. init $iagt, $oagt, $mdl, $scb by USER.
 * 2. DO NOT leave them with NULL.
 */
function void init(SEED_TYPE seed_src,
                   DRIVER_TYPE drv_src,
                   IMONITOR_TYPE imon_src,
                   OMONITOR_TYPE omon_src,
                   REFMODEL_TYPE mdl_src,
                   SCOREBOARD_TYPE scb_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    assert(this.iagt != null) this.iagt.init(.seed_src(seed_src),
                                             .drv_src(drv_src),
                                             .mon_src(imon_src));
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $iagt is null! Please call <init> in connect_phase.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    assert(this.oagt != null) this.oagt.init(.seed_src(null),
                                             .drv_src(null),
                                             .mon_src(omon_src));
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $oagt is null! Please call <init> in connect_phase.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    assert(this.mdl != null) this.mdl.init(.mdl_src(mdl_src));
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $mdl is null! Please call <init> in connect_phase.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    assert(this.mdl != null) this.scb.init(.scb_src(scb_src));
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $scb is null! Please call <init> in connect_phase.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:init

/**
 * build_phase
 * 1. Set up $iagt, $oagt, $mdl, $scb's instances and check.
 * 2. Set up $iagt2mdl_fifo, $oagt2scb_fifo, $mdl2scb_fifo's instances and check.
 * 3. init $iagt, $oagt, $mdl, $scb, .testcase_domain.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.iagt = iagt_type::type_id::create("iagt", this);
    assert(this.iagt != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $iagt is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
    this.iagt.testcase_domain = this.testcase_domain;

    this.oagt = oagt_type::type_id::create("oagt", this);
    assert(this.oagt != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $oagt is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
    this.oagt.testcase_domain = this.testcase_domain;

    this.mdl = mdl_type::type_id::create("mdl", this);
    assert(this.mdl != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $mdl is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
    this.mdl.testcase_domain = this.testcase_domain;

    this.scb = scb_type::type_id::create("scb", this);
    assert(this.scb != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $scb is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
    this.scb.testcase_domain = this.testcase_domain;

    this.iagt2mdl_fifo = new("iagt2mdl_fifo", this);
    assert(this.iagt2mdl_fifo != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $iagt2mdl_fifo is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    this.oagt2scb_fifo = new("oagt2scb_fifo", this);
    assert(this.oagt2scb_fifo != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $oagt2scb_fifo is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    this.mdl2scb_fifo = new("mdl2scb_fifo", this);
    assert(this.mdl2scb_fifo != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $mdl2scb_fifo is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:build_phase

/**
 * connect_phase
 * 1. Build connections:
 *    iagt |mon_bus_port|--iagt2mdl_fifo-->|imon_bus_port| mdl
 *    mdl |omon_bus_port|--mdl2scb_fifo-->|ref_mon_bus_port| scb
 *    oagt |mon_bus_port|--oagt2scb_fifo-->|mon_bus_port| scb
 * 2. set domain to $testcase_domain.
 */
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (connect_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.iagt.mon.mon_bus_port.connect(this.iagt2mdl_fifo.analysis_export);
    this.mdl.imon_bus_port.connect(this.iagt2mdl_fifo.blocking_get_export);
    this.mdl.omon_bus_port.connect(this.mdl2scb_fifo.analysis_export);
    this.scb.ref_mon_bus_port.connect(this.mdl2scb_fifo.blocking_get_export);
    this.oagt.mon.mon_bus_port.connect(this.oagt2scb_fifo.analysis_export);
    this.scb.mon_bus_port.connect(this.oagt2scb_fifo.blocking_get_export);

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

endclass:uvm_optb_env

`endif
