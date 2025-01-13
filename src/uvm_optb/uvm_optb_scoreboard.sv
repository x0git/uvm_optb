/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_scoreboard
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. DRV_INFO_PATH SUGGESTED be started with '.'.
// 2. Scoreboard's instance should be init before used.
// 3. Scoreboard ref_bus/real_bus's type should be defined before used.
// 4. Scoreboard's info should be SET to Global Driver info before used.
// 5. Variables         Type                Comments
//    DRV_INFO_PATH     parameter string    default:"", the path for driver info
//                                          SUGGESTED set if needed and started with '.'
//    MON_BUS_TYPE      paremeter type      default:uvm_sequence_item
//                                          Should be set other than uvm_sequence_item.
//    scb(protected)    SCOREBOARD_TYPE     default: null, init by call init()
//                                          should be defined outside of the platform.
//    scb.info          optb_string         should be SET before used.
//    testcase_domain   uvm_domain          default:null, null "default domain"
//                                          Access directly.
// 5. Type definition
//      name                definition
//      SCOREBOARD_TYPE     optb_scb_base #(.MON_BUS_TYPE(MON_BUS_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. Scoreboard instance(extends SCOREBOARD_TYPE) outside of model, result = "is_ok" then break the process
//    scoreboard.run(MON_BUS_TYPE tref_mon_bus, MON_BUS_TYPE tmon_bus, input string tinfo, output string result)-one_phase
//    scoreboard.info.str<string>
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

`ifndef UVM_OPTB_SCOREBOARD_SV
`define UVM_OPTB_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_scoreboard
#(parameter string DRV_INFO_PATH = "",//".drv_info_path"
  parameter type MON_BUS_TYPE = uvm_sequence_item)
extends uvm_scoreboard;
`uvm_component_param_utils(uvm_optb_scoreboard #(.DRV_INFO_PATH(DRV_INFO_PATH), .MON_BUS_TYPE(MON_BUS_TYPE)))

typedef optb_scb_base #(.MON_BUS_TYPE(MON_BUS_TYPE)) SCOREBOARD_TYPE;

local const string uvm_optb_name = "uvm_optb_scoreboard";
protected SCOREBOARD_TYPE scb;

uvm_blocking_get_port#(MON_BUS_TYPE) ref_mon_bus_port;
uvm_blocking_get_port#(MON_BUS_TYPE) mon_bus_port;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. Check $SCOREBOARD_TYPE, $MON_BUS_TYPE have been set by USER.
 * 2. set $scb, $ref_mon_bus_port, $mon_bus_port to null.
 * 3. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_scoreboard",
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

    this.scb = null;
    this.ref_mon_bus_port = null;
    this.mon_bus_port = null;

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Set $scb by USER.
 * 2. DO NOT leave them with NULL.
 */
function void init(SCOREBOARD_TYPE scb_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.scb = scb_src;
endfunction:init

/**
 * build_phase
 * 1. Build $ref_mon_bus_port, $mon_bus_port's instances.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.ref_mon_bus_port = new("ref_mon_bus_port", this);
    assert(this.ref_mon_bus_port != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $ref_mon_bus_port is null! new() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

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
 * 1. Check $scb which has been set by USER.
 */
virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (start_of_simulation_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    assert(this.scb != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] should be <init> before used! $scb is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    assert(this.scb.info != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $scb should be SET before used! $scb.info is null!\n",
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
    MON_BUS_TYPE tref_mon_bus;
    MON_BUS_TYPE tmon_bus;
    string tinfo;
    string result;
    string info_str;

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] ((main_phase))@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    info_str = "info_str";
    phase.raise_objection(this);
    fork
        begin:REF_SAMPLE_PART
            forever this.ref_mon_bus_port.get(tref_mon_bus);
        end
        begin:BUS_SAMPLE_PART
            forever this.mon_bus_port.get(tmon_bus);
        end
        begin:INFO_PART
            forever
            begin
                #1step;
                if(info_str != this.scb.info.str)
                begin
                	void'(uvm_config_db#(string)::get(uvm_root::get(),
                                                  	  {"uvm_test_top", this.DRV_INFO_PATH},
                                                      "drv_case_info", tinfo));
                    info_str = this.scb.info.str;
                end
            end
        end
        begin:VERIFY_PART
            forever
            begin
                this.scb.run(.tref_mon_bus(tref_mon_bus),
                             .tmon_bus(tmon_bus),
                             .tinfo(tinfo),
                             .result(result));

                if("is_ok" == result) break;//result = "is_ok" then break the process
            end
            `uvm_info(this.uvm_optb_name,
                      $sformatf("\n@%0t: %s ->> [%s] ((main_phase)) Verification is DONE.\n",
                                $realtime, this.get_full_name(), this.uvm_optb_name),
                      UVM_LOW);
        end
    join_any
    disable REF_SAMPLE_PART;
    disable BUS_SAMPLE_PART;
    disable INFO_PART;
    phase.drop_objection(this);
endtask:main_phase

/**
 * report_phase
 * 1. Report_phase in simulation, it's called by platform automatically.
 * 2. Report the result of uvm_optb platform's running status.
 * 3. The Running Status DOES NOT INCLUDE the verification result of DUT/DUV.
 */
virtual function void report_phase(uvm_phase phase);
    uvm_report_server server;
    int error_num, warning_num, info_num;

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (report_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    server = this.get_report_server();
    error_num = server.get_severity_count(UVM_ERROR);
    warning_num = server.get_severity_count(UVM_WARNING);
    info_num = server.get_severity_count(UVM_INFO);

    `uvm_info({this.uvm_optb_name, "::FinalResult"},
              {{1{"\n"}}, {80{"#"}}, "\n",
               $sformatf("@%0t, <%s> ->> [%s] Reports the Final Result of the Process in uvm_optb: Verifications & Tests FINISH Successfully!!!! Fatal(0), Error(%0d),  Warning(%0d), Info(%0d).",
                         $realtime, this.get_full_name(), this.uvm_optb_name, error_num, warning_num, info_num),
               {1{"\n"}}, {80{"#"}}, {1{"\n"}}},
              UVM_LOW);
endfunction:report_phase

endclass:uvm_optb_scoreboard

`endif
