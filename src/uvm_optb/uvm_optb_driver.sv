/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_driver
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. DRV_INFO_PATH SUGGESTED be started with '.'.
// 2. Transaction Seed's type SUGGESTED be defined before used.
// 3. Driver's instance should be init before used and driver.info should be SET.
// 4. Variables         Type                Comments
//    DRV_INFO_PATH     parameter string    default:"", the path for driver info
//                                          SUGGESTED set if needed and started with '.'
//    SEED_TYPE         paremeter type      default:uvm_sequence_item
//                                          SUGGESTED be set other than uvm_sequence_item.
//    drv(protected)    DRIVER_TYPE         default: null
//                                          should be defined outside of the platform.
//    drv.info          optb_string         should be SET when drv defined
//    testcase_domain   uvm_domain          default:null, null "default domain"
//                                          Access directly.
// 5. Type definition
//      name                definition
//      DRIVER_TYPE         optb_drv_base #(.SEED_TYPE(SEED_TYPE))
//      tr_type             uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. optb_pkg.sv/package optb_pkg
// 3. uvm_optb_transaction.sv
// 4. driver instance(extends DRIVER_TYPE) outside of model
//    driver.run(SEED_TYPE tseed, output string tinfo)-one_phase
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

`ifndef UVM_OPTB_DRIVER_SV
`define UVM_OPTB_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_transaction.sv"

import optb_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_driver
#(parameter string DRV_INFO_PATH = "",//".drv_info_path"
  parameter type SEED_TYPE = uvm_sequence_item)
extends uvm_driver #(uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE)));
`uvm_component_param_utils(uvm_optb_driver #(.DRV_INFO_PATH(DRV_INFO_PATH), .SEED_TYPE(SEED_TYPE)))

typedef optb_drv_base #(.SEED_TYPE(SEED_TYPE)) DRIVER_TYPE;
typedef uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE)) tr_type;

local const string uvm_optb_name = "uvm_optb_driver";
protected DRIVER_TYPE drv;
local tr_type tr;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. Check $DRIVER_TYPE has been set by USER.
 * 2. set $drv to null and initial all local vars.
 * 3. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_driver",
             uvm_component parent = null);
    uvm_sequence_item uvm_sequence_item_chk;

    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.drv = null;
    this.tr = new();

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Set $drv by USER.
 * 2. DO NOT leave them with NULL.
 */
function void init(DRIVER_TYPE drv_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.drv = drv_src;
endfunction:init

/**
 * connect_phase
 * 1. Set domain to $testcase_domain.
 */
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (connect_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), phase.get_name(), this.uvm_optb_name),
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
 * 1. Check $drv are set by USER.
 */
virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (start_of_simulation_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    assert(this.drv != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] should be <init> before used! $drv is null!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    assert(this.drv.info != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $drv should be SET before used! $drv.info is null!\n",
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
    string tinfo, tinfo_buf;

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] ((main_phase))@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    tinfo_buf = "tinfo_buf";
    tinfo = "tinfo";

    fork
    begin:DRV_PART
        forever
        begin
            this.seq_item_port.get_next_item(this.tr);

            assert(this.tr != null)
            else `uvm_warning(this.uvm_optb_name,
                              $sformatf("\n@%0t: %s ->> [%s] Generate transaction failed!\n",
                                        $realtime, this.get_full_name(), this.uvm_optb_name));

            `uvm_info(this.uvm_optb_name,
                      $sformatf("\n@%0t: %s ->> [%s] '%s', driver_process starts...\n",
                                $realtime, this.get_full_name(), this.uvm_optb_name, tinfo),
                      UVM_LOW);

            this.drv.run(.tseed(this.tr.seed), .tinfo(tinfo));

            `uvm_info(this.uvm_optb_name,
                      $sformatf("\n@%0t: %s ->> [%s] '%s', driver_process is done.\n",
                                $realtime, this.get_full_name(), this.uvm_optb_name, tinfo),
                      UVM_LOW);

            this.seq_item_port.item_done();
        end
    end
    begin:INFO_PART
        forever
        begin
            #1step;
            if(tinfo != tinfo_buf)
            begin
            	void'(uvm_config_db#(string)::set(uvm_root::get(),
                                              	  {"uvm_test_top", this.DRV_INFO_PATH},
                                              	  "drv_case_info", tinfo));
                tinfo_buf = tinfo;
            end
        end
    end
    join
endtask:main_phase

endclass:uvm_optb_driver

`endif
