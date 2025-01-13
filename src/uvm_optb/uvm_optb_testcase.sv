/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_testcase
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
// 9. ScoreBoard's instance SUGGESTED be init before used.
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
//    env               uvm_optb_env                default: null, #(TEST_CASE_TYPE, DRV_INFO_PATH, SEED_TYPE, IMON_BUS_TYPE, OMON_BUS_TYPE)
//                                                  init *.seed<SEED_TYPE>, *.drv<DRIVER_TYPE>, *.imon<IMONITOR_TYPE>,
//                                                  *.omon<OMONITOR_TYPE>, *.mdl<REFMODEL_TYPE>, *.scb<SCOREBOARD_TYPE>
//                                                  defined outside of the platform
//    testcase_domain   uvm_domain                  default:null, null "default domain"
//                                                  Access directly.
// 12.Type definition
//      name                definition
//      DRIVER_TYPE         optb_drv_base #(.SEED_TYPE(SEED_TYPE))
//      IMONITOR_TYPE       optb_mon_base #(.MON_BUS_TYPE(IMON_BUS_TYPE))
//      OMONITOR_TYPE       optb_mon_base #(.MON_BUS_TYPE(OMON_BUS_TYPE))
//      REFMODEL_TYPE       optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                          .IMON_BUS_TYPE(OMON_BUS_TYPE))
//      SCOREBOARD_TYPE     optb_scb_base #(.MON_BUS_TYPE(OMON_BUS_TYPE))
//      env_type            uvm_optb_env #(.TEST_CASE_TYPE(TEST_CASE_TYPE),
//                                         .DRV_INFO_PATH(DRV_INFO_PATH),
//                                         .SEED_TYPE(SEED_TYPE),
//                                         .IMON_BUS_TYPE(IMON_BUS_TYPE),
//                                         .OMON_BUS_TYPE(OMON_BUS_TYPE))
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
//  x0git                       @404 NOT FOUND
// Additional Comments:
// 1. [Freedom] License: LGPLv3
// 2. [Business] Warning: For Technical and Acadamic Exchanges.
// 3. [Industry] Compatible Environment List:
// No.      Name         Version             Company
// 000      Vivado       2020.2              Xilinx(AMD)
//////////////////////////////////////////////////////////////////////////////////
*/

`ifndef UVM_OPTB_TESTCASE_SV
`define UVM_OPTB_TESTCASE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_env.sv"

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_testcase
#(parameter string TEST_CASE_TYPE = "master",//"master":iagt enable, "slave":iagt disable
  parameter string DRV_INFO_PATH = "",//".drv_info_path"
  parameter string DOMAIN_NAME = "common",
  parameter type SEED_TYPE = uvm_sequence_item,
  parameter type IMON_BUS_TYPE = uvm_sequence_item,
  parameter type OMON_BUS_TYPE = uvm_sequence_item)
extends uvm_test;
`uvm_component_param_utils(uvm_optb_testcase #(.TEST_CASE_TYPE(TEST_CASE_TYPE),
                                               .DRV_INFO_PATH(DRV_INFO_PATH),
                                               .DOMAIN_NAME(DOMAIN_NAME),
                                               .SEED_TYPE(SEED_TYPE),
                                               .IMON_BUS_TYPE(IMON_BUS_TYPE),
                                               .OMON_BUS_TYPE(OMON_BUS_TYPE)))

typedef optb_drv_base #(.SEED_TYPE(SEED_TYPE)) DRIVER_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(IMON_BUS_TYPE)) IMONITOR_TYPE;
typedef optb_mon_base #(.MON_BUS_TYPE(OMON_BUS_TYPE)) OMONITOR_TYPE;
typedef optb_mdl_base #(.IMON_BUS_TYPE(IMON_BUS_TYPE),
                        .OMON_BUS_TYPE(OMON_BUS_TYPE)) REFMODEL_TYPE;
typedef optb_scb_base #(.MON_BUS_TYPE(OMON_BUS_TYPE)) SCOREBOARD_TYPE;

typedef uvm_optb_env #(.TEST_CASE_TYPE(TEST_CASE_TYPE),
                       .DRV_INFO_PATH(DRV_INFO_PATH),
                       .SEED_TYPE(SEED_TYPE),
                       .IMON_BUS_TYPE(IMON_BUS_TYPE),
                       .OMON_BUS_TYPE(OMON_BUS_TYPE)) env_type;

local const string uvm_optb_name = "uvm_optb_testcase";
protected env_type env;

protected SEED_TYPE seed;
protected DRIVER_TYPE drv;
protected IMONITOR_TYPE imon;
protected OMONITOR_TYPE omon;
protected REFMODEL_TYPE mdl;
protected SCOREBOARD_TYPE scb;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. set $env, $seed, $drv, $imon, $omon, $mdl, $scb to null.
 * 2. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_testcase",
             uvm_component parent = null);
    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.env = null;
    this.seed = null;
    this.drv = null;
    this.imon = null;
    this.omon = null;
    this.mdl = null;
    this.scb = null;

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Set $seed, $drv, $imon, $omon, $mdl, $scb by USER.
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

    this.seed = seed_src;
    this.drv = drv_src;
    this.imon = imon_src;
    this.omon = omon_src;
    this.mdl = mdl_src;
    this.scb = scb_src;
endfunction:init

/**
 * build_phase
 * 1. Build $env's instance.
 * 2. set up testcase_domain if not "common", and init env.testcase_domain.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.env = env_type::type_id::create("env", this);
    assert(this.env != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $env is null! create() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    if(this.DOMAIN_NAME != "common") this.testcase_domain = new(this.DOMAIN_NAME);
    this.env.testcase_domain = this.testcase_domain;
    assert((this.testcase_domain != null) || (this.DOMAIN_NAME == "common")) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $testcase_domain IS null when DOMAIN_NAME<%s|null> is NOT \"common\"! create() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name, this.DOMAIN_NAME));
        $finish;
    end

    assert((this.testcase_domain == null) || (this.DOMAIN_NAME != "common")) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $testcase_domain is NOT null when DOMAIN_NAME<%s|%s> IS \"common\"!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name, this.DOMAIN_NAME, this.testcase_domain.get_name()));
        $finish;
    end
endfunction:build_phase

/**
 * connect_phase
 * 1. init $env.
 * 2. new() when $drv.info == null and set $scb.info = $drv.info when $scb.info is null.
 * 3. check $drv.info == $scb.info.
 * 4. set domain to $testcasedomain.
 */
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (connect_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

   `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s::tips] Testcase must be instantializer and <init>, before run_test() is called, .\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    if(this.drv.info == null) 
    begin
        this.drv.info = new();
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] $drv.info is null and new()!\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name),
                  UVM_LOW);
        assert(this.drv.info != null) else
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $drv.info is null! new() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
    end

    if(this.scb.info == null)
    begin
        this.scb.info = this.drv.info;
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] $scb.info is null and is set to $drv.info!\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name),
                  UVM_LOW);
        assert(this.scb.info != null) else
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $scb.info is null! set to $drv.info failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
    end

    assert(this.drv.info == this.scb.info) else
    begin
      `uvm_fatal(this.uvm_optb_name,
                 $sformatf("\n@%0t: %s ->> [%s] $drv.info should be same as $scb.info! $drv.info != $scb.info!\n",
                           $realtime, this.get_full_name(), this.uvm_optb_name));
      $finish;
    end

    this.env.init(.seed_src(this.seed),
                  .drv_src(this.drv),
                  .imon_src(this.imon),
                  .omon_src(this.omon),
                  .mdl_src(this.mdl),
                  .scb_src(this.scb));

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
 * report_phase
 * 1. Report when testcase is done.
 */
virtual function void report_phase(uvm_phase phase);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (report_phase)@<phase:%s> is called.",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    `uvm_info(this.uvm_optb_name,
              $sformatf("%0t: <%s> ->> [%s] TESTCASE %s is DONE!",
                        $realtime, this.get_full_name(), this.uvm_optb_name, this.DRV_INFO_PATH.tolower()),
              UVM_LOW);
endfunction:report_phase

endclass:uvm_optb_testcase

`endif
