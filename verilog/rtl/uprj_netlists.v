// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

// Include caravel global defines for the number of the user project IO pads 
`include "defines.v"
`define USE_POWER_PINS

`ifdef GL
    // Assume default net type to be wire because GL netlists don't have the wire definitions
    `default_nettype wire
    `include "gl/user_project_wrapper.v"
    
`else
    `include "user_project_wrapper.v"    // Caravel wrapper
   // `include "/Users/azhar/test/verilog/rtl/aesctr.v"                 // AES top module
   `include "/Users/azhar/test/verilog/rtl/encryptedctr.v" 
`include "/Users/azhar/test/verilog/rtl/cryptotop.v" 
`include "/User/azhar/test/verilog/rtl/decryptedctr.v" 
// `include "/Users/azhar/test/verilog/rtl/aes.v"                      // AES top module (disabled)
`include "/Users/azhar/test/verilog/rtl/encryptiontop.v"              // AES encryption wrapper
`include "/Users/azhar/test/verilog/rtl/sbox.v"                       // AES S-Box submodule
`include "/Users/azhar/test/verilog/rtl/shiftrows.v"
`include "/Users/azhar/test/verilog/rtl/mixcolumns.v"                 // AES MixColumns submodule
`include "/Users/azhar/test/verilog/rtl/key_expansion.v"              // AES Key Expansion submodule
// `include "sha.v"                                                   // SHA top module (disabled)
`include "/Users/azhar/test/verilog/rtl/sha3_256.v"                   // SHA3-256 submodule
`include "/Users/azhar/test/verilog/rtl/chi.v"
`include "/Users/azhar/test/verilog/rtl/iota.v"
`include "/Users/azhar/test/verilog/rtl/fn_top.v"
`include "/Users/azhar/test/verilog/rtl/padding.v"
`include "/Users/azhar/test/verilog/rtl/pi.v"
`include "/Users/azhar/test/verilog/rtl/rho.v"
`include "/Users/azhar/test/verilog/rtl/theta.v"
`include "/Users/azhar/test/verilog/rtl/top.v"
