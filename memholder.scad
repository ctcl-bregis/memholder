// Memory Module Holder for 3D Printing
// memholder v2.0 - January 7, 2023
// CrazyblocksTechnologies Computer Laboratories 2022-2023
// -- LICENSE --
// To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. 
// This software is distributed without any warranty. You should have received a copy of the CC0 Public Domain Dedication along with this software. 
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

// == START CONFIGURATION SECTION ==

// -- Module parameters --

// How many modules
mem_count = 10; // [1:1:128]

// PRESETS - Predefined presets for different types of modules
// 0 - Standard DIMM with heatsink up to 9mm width and 136mm length
// 1 - Standard DIMM without heatsink up to 5mm width and 136mm length
// 2 - Standard SODIMM (laptop memory) without heatsink up to 5mm width and up to 70mm length
// 3 - Apple Mac Pro 1,1 large heatsink FBDIMM up to 25mm width and 136mm length
// 4 - MiniDIMM/MiniRDIMM up to 8mm width and 84mm length

mem_preset = 0; // [0: Standard DIMM (desktop memory), 1: Standard DIMM without heatsink, 2: Standard SODIMM (laptop memory) and UniDIMM, 3: Apple Mac Pro 1.1 FBDIMMs, 4: MiniDIMM/MiniRDIMM]
 
// Each list is in the order of [max pcb length, max module width, max pcb thickness]
mem_preset_defs = [[137, 9, 2], [137, 5, 2], [70, 5, 2], [137, 25, 2], [84, 7.6, 2]];
 
mem_pcb_length = mem_preset_defs[mem_preset][0];
mem_width_total = mem_preset_defs[mem_preset][1];
mem_pcb_width = mem_preset_defs[mem_preset][2];

// -- Base parameters --

// Width for walls on side of memory module - unit: mm
base_side_width = 4; // [1:0.2:6]
// Extra width of walls on the sides - unit: mm
base_side_width_ext = 3; // [1:0.2:6] 
// Height of walls for memory modules  - unit: mm
base_side_height = 9; // [5:1:50]
// Base height - unit: mm
base_height = 1; // [1:0.1:3]
// Width of brace on the length side
base_length_brace_width = 1.5; // [1:0.1:4]
// Height of brace on the length side
base_length_brace_height = 10; // [1:0.1:20]

// -- Stack feature parameters --
// Enable posts for stacking memory holders
post_enable = true;
// Width to add around post
post_ext_wall = 2; // [1,0.1,5];
// Size of post
post_size_len = 8; // [1,0.1,10];
post_size_wid = 8; // [1,0.1,10];
// Base height of post
post_base_height = 35;
// Extending height of post
post_ext_height = 5;
// Size to remove from both length and width on the extending post to be able to fit
post_tolerance = 1.5;

post_ext_wall_height = 10;

// calculate from above to know how far to move the holder
post_total_len = post_size_len + (post_ext_wall * 2);
post_total_wid = post_size_wid + (post_ext_wall * 2);

// == END CONFIGURATION SECTION ==

// Draw brace
// Module length side
translate([0, post_total_len, 0]) {
    cube([base_length_brace_width, mem_pcb_length + (base_side_width + base_side_width_ext), base_length_brace_height]);
    translate([(mem_width_total * mem_count) + base_length_brace_width, 0, 0]) {
        cube([base_length_brace_width, mem_pcb_length + (base_side_width + base_side_width_ext), base_length_brace_height]);
    }
}

// Draw memory holder
// Move everything else because of brace and posts if enabled
translate([base_length_brace_width, post_total_len, 0]) { 
    // No extra supports if memory module count is within 1 to 8
    if (mem_count > 0 && mem_count < 8) {
        for (a = [0 : 1 : 1]) {
            translate([((mem_width_total * mem_count) - mem_width_total) * a, 0, 0]) {
                cube([mem_width_total, mem_pcb_length + (base_side_width + base_side_width_ext), base_height]);
            }
        }
    }

    if (mem_count > 5) {
        for (a = [0 : 1 : floor(mem_count / 8) + 1]) {
            translate([(((mem_width_total * mem_count) - mem_width_total) / (floor(mem_count / 6) + 1)) * a, 0, 0]) {
                cube([mem_width_total, mem_pcb_length + (base_side_width + base_side_width_ext), base_height]);
            }
        }
    }

    // Module width side
    cube([mem_width_total * mem_count, base_side_width + base_side_width_ext ,base_height]);

    translate([0, mem_pcb_length, 0]) {
        cube([mem_width_total * mem_count, base_side_width + base_side_width_ext ,base_height]);
    }

    // Walls
    // Close side
    cube([(mem_width_total * mem_count), base_side_width_ext, base_height + base_side_height]);
    for (a = [0 : 1 : mem_count - 1]) {
        translate([(mem_width_total * a), base_side_width_ext, base_height]) {
            cube([(mem_width_total / 2) - (mem_pcb_width / 2) , base_side_width, base_side_height]);
            translate([mem_width_total / 2 + mem_pcb_width / 2,0,0]) {
                cube([(mem_width_total / 2) - (mem_pcb_width / 2) , base_side_width, base_side_height]);
            }
        }
    }

    // Far side
    translate([0, mem_pcb_length + base_side_width, 0]) {
        cube([(mem_width_total * mem_count), base_side_width_ext, base_height + base_side_height]);
    }
    for (a = [0 : 1 : mem_count - 1]) {
        translate([(mem_width_total * a), mem_pcb_length, base_height]) {
            cube([(mem_width_total / 2) - (mem_pcb_width / 2) , base_side_width, base_side_height]);
            translate([mem_width_total / 2 + mem_pcb_width / 2,0,0]) {
                cube([(mem_width_total / 2) - (mem_pcb_width / 2) , base_side_width, base_side_height]);
            }
        }
    }
}

// Draw posts
if (post_enable) {
     // Close side width, close side length
     difference() {
         cube([post_total_len, post_total_wid, post_ext_wall_height]);
         translate([post_ext_wall, post_ext_wall, 0]) {
             cube([post_size_len, post_size_wid, post_ext_height]);
         }
     }    
     translate([post_ext_wall + (post_tolerance / 2), post_ext_wall + (post_tolerance / 2), base_side_height]) {
         cube([post_size_len - post_tolerance, post_size_wid - post_tolerance, post_ext_height + (post_base_height - base_side_height)]);
     }
    
     translate([((mem_width_total * mem_count) + base_length_brace_width) - (post_total_wid - base_length_brace_width),0,0]) {
         difference() {
             cube([post_total_len, post_total_wid, post_ext_wall_height]);
             translate([post_ext_wall, post_ext_wall, 0]) {
                 cube([post_size_len, post_size_wid, post_ext_height]);
             }
         }    
         translate([post_ext_wall + (post_tolerance / 2), post_ext_wall + (post_tolerance / 2), post_ext_wall_height]) {
             cube([post_size_len - post_tolerance, post_size_wid - post_tolerance, post_ext_height + (post_base_height - post_ext_wall_height)]);
         }
     }
    
    translate([0,mem_pcb_length + post_total_len + base_side_width_ext + base_side_width,0]) {
        difference() {
            cube([post_total_len, post_total_wid, post_ext_wall_height]);
            translate([post_ext_wall, post_ext_wall, 0]) {
                cube([post_size_len, post_size_wid, post_ext_height]);
            }
        }    
        translate([post_ext_wall + (post_tolerance / 2), post_ext_wall + (post_tolerance / 2), post_ext_wall_height]) {
            cube([post_size_len - post_tolerance, post_size_wid - post_tolerance, post_ext_height + (post_base_height - post_ext_wall_height)]);
        }
    
        translate([((mem_width_total * mem_count) + base_length_brace_width) - (post_total_wid - base_length_brace_width),0,0]) {
            difference() {
                cube([post_total_len, post_total_wid, post_ext_wall_height]);
                translate([post_ext_wall, post_ext_wall, 0]) {
                    cube([post_size_len, post_size_wid, post_ext_height]);
                }
            }    
            translate([post_ext_wall + (post_tolerance / 2), post_ext_wall + (post_tolerance / 2), post_ext_wall_height]) {
                cube([post_size_len - post_tolerance, post_size_wid - post_tolerance, post_ext_height + (post_base_height - post_ext_wall_height)]);
            }
       }   
    }
}