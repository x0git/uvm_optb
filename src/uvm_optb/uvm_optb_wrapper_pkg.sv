/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Package Name: uvm_optb_wrapper_pkg
// Class Name: uvm_optb_testcase_wrapper
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Transaction Seed's type SUGGESTED be defined before used.
// 2. Transaction Seed's instance SUGGESTED be init before used.
// 3. DRV_INFO_PATH SUGGESTED be started with '.'.
// 4. Driver's instance SUGGESTED be init before used.
// 5. Input Monitor's instance SUGGESTED be init before used.
// 6. Input Monitor bus's type SUGGESTED be defined before used.
// 7. Output Monitor's instance SUGGESTED be init before used.
// 8. Output Monitor bus's type SUGGESTED be defined before used.
// 9.ScoreBoard's instance SUGGESTED be init before used.
// 10.Reference Model's instance SUGGESTED be init before used.
// 11.Variables         Type                        Comments
//    TEST_CASE_TYPE    parameter string            default:"master", 
//                                                  "master", iagt, oagt, scb, mdl
//                                                  "slave", oagt, oagt, scb, mdl
//    DRV_INFO_PATH     parameter string            default:"", the path for driver info
//                                                  SUGGESTED set if needed and started with '.'
//    DOMAIN_NAME       parameter string            default:"common"
//    SEED_TYPE         paremeter type              default:uvm_sequence_item
//                                                  SUGGESTED be set other than uvm_sequence_item.
//    IMON_BUS_TYPE     paremeter type              default:uvm_sequence_item
//                                                  SUGGESTED be set other than uvm_sequence_item.
//    OMON_BUS_TYPE     paremeter type              default:uvm_sequence_item
//                                                  SUGGESTED be set other than uvm_sequence_item.
//    testcase          uvm_optb_testcase           default: null, #(TEST_CASE_TYPE, DRV_INFO_PATH, DOMAIN_NAME, 
//                                                                   SEED_TYPE, IMON_BUS_TYPE, OMON_BUS_TYPE)
//                                                  init *.seed<SEED_TYPE>, *.drv<DRIVER_TYPE>, *.imon<IMONITOR_TYPE>,
//                                                  *.omon<OMONITOR_TYPE>, *.mdl<REFMODEL_TYPE>, *.scb<SCOREBOARD_TYPE>
//                                                  defined outside of the platform
// 12.Type definition
//      name                definition
//      DRIVER_TYPE         optb_drv_base #(.SEED_TYPE(SEED_TYPE))
//      IMONITOR_TYPE       optb_mon_base #(.MON_BUS_TYPE(IMON_BUS_TYPE))
//      OMONITOR_TYPE       optb_mon_base #(.MON_BUS_TYPE(OMON_BUS_TYPE))
//      REFMODEL_TYPE       optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                          .IMON_BUS_TYPE(OMON_BUS_TYPE))
//      SCOREBOARD_TYPE     optb_scb_base #(.MON_BUS_TYPE(OMON_BUS_TYPE))
//      testcase_type       uvm_optb_testcase #(.TEST_CASE_TYPE(TEST_CASE_TYPE),
//                                              .DRV_INFO_PATH(DRV_INFO_PATH),
//                                              .DOMAIN_NAME(DOMAIN_NAME),
//                                              .SEED_TYPE(SEED_TYPE),
//                                              .IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                              .OMON_BUS_TYPE(OMON_BUS_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. uvm_optb_env.sv
// 4. Transaction Seed instance(SEED_TYPE) outside of model
// 5. Driver instance(extends DRIVER_TYPE) outside of model
// 6. Input Monitor instance(extends IMONITOR_TYPE) outside of model
// 7. Output Monitor instance(extends OMONITOR_TYPE) outside of model
// 8. Reference Model instance(extends REFMODEL_TYPE) outside of model
// 9. ScoreBoard instance(extends SCOREBOARD_TYPE) outside of model
// Revision:
// Date         Version             Author          Comment
// 2025.Jan.01  Revision 0.00       x0git           Frame of Project(Origin)
// Author List:
//  Code                        Information
//  x0git                       virtual.q@outlook.com
// Additional Comments:
// 1. [Freedom] License: Apache License Version 2.0
// 2. [Industry] Compatible Environment List:
// No.      Name         Version             Company
// 000      Vivado       2020.2              Xilinx(AMD)
//////////////////////////////////////////////////////////////////////////////////
*/

`ifndef UVM_OPTB_WRAPPER_PKG_SV
`define UVM_OPTB_WRAPPER_PKG_SV

package uvm_optb_wrapper_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_testcase.sv"
import optb_pkg::*;

class uvm_optb_testcase_wrapper
#(parameter string TEST_CASE_TYPE = "master",//"master":iagt enable, "slave":iagt disable
  parameter string DRV_INFO_PATH = "",//".drv_info_path"
  parameter string DOMAIN_NAME = "common",
  parameter type SEED_TYPE = uvm_sequence_item,
  parameter type IMON_BUS_TYPE = uvm_sequence_item,
  parameter type OMON_BUS_TYPE = uvm_sequence_item);

typedef optb_drv_base #(.SEED_TYPE(SEED_TYPE)) DRIVER_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(IMON_BUS_TYPE)) IMONITOR_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(OMON_BUS_TYPE)) OMONITOR_TYPE;
typedef optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
                        .OMON_BUS_TYPE(OMON_BUS_TYPE)) REFMODEL_TYPE;
typedef optb_scb_base #(.MON_BUS_TYPE(OMON_BUS_TYPE)) SCOREBOARD_TYPE;

typedef uvm_optb_testcase #(.TEST_CASE_TYPE(TEST_CASE_TYPE),
                            .DRV_INFO_PATH(DRV_INFO_PATH),
                            .DOMAIN_NAME(DOMAIN_NAME),
                            .SEED_TYPE(SEED_TYPE),
                            .IMON_BUS_TYPE(IMON_BUS_TYPE),
                            .OMON_BUS_TYPE(OMON_BUS_TYPE)) testcase_type;

protected testcase_type testcase;

function new(input string name = "uvm_optb_testcase",
             SEED_TYPE seed_src = null,
             DRIVER_TYPE drv_src = null,
             IMONITOR_TYPE imon_src = null,
             OMONITOR_TYPE omon_src = null,
             REFMODEL_TYPE mdl_src = null,
             SCOREBOARD_TYPE scb_src = null);
    this.testcase = new(.name(name), .parent(null));

    $display({$sformatf("WRP_INFO %s(%0d) @ %0t: %s [uvm_optb_testcase_wrapper]\n@%0t: %s ",
                        `__FILE__, `__LINE__, $realtime, this.testcase.get_full_name(),
                        $realtime, this.testcase.get_full_name()),
             "->> [uvm_optb_testcase_wrapper] (new) is called.\n"});

    this.testcase.init(.seed_src(seed_src),
                       .drv_src(drv_src),
                       .imon_src(imon_src),
                       .omon_src(omon_src),
                       .mdl_src(mdl_src),
                       .scb_src(scb_src));
endfunction:new

function void init(SEED_TYPE seed_src,
                   DRIVER_TYPE drv_src,
                   IMONITOR_TYPE imon_src,
                   OMONITOR_TYPE omon_src,
                   REFMODEL_TYPE mdl_src,
                   SCOREBOARD_TYPE scb_src);
    $display({$sformatf("WRP_INFO %s(%0d) @ %0t: %s [uvm_optb_testcase_wrapper]\n@%0t: %s ",
                        `__FILE__, `__LINE__, $realtime, this.testcase.get_full_name(),
                        $realtime, this.testcase.get_full_name()),
             "->> [uvm_optb_testcase_wrapper] (init) is called.\n"});

    this.testcase.init(.seed_src(seed_src),
                       .drv_src(drv_src),
                       .imon_src(imon_src),
                       .omon_src(omon_src),
                       .mdl_src(mdl_src),
                       .scb_src(scb_src));
endfunction:init

endclass:uvm_optb_testcase_wrapper

endpackage

`endif
