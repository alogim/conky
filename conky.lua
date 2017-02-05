-- vim: ts=4 sw=4 noet ai cindent syntax=lua
--[[
Conky, a system monitor, based on torsmo

Any original torsmo code is licensed under the BSD license

All code written since the fork of torsmo is licensed under the GPL

Please see COPYING for details

Copyright (c) 2004, Hannu Saransaari and Lauri Hakkarainen
Copyright (c) 2005-2012 Brenden Matthews, Philip Kovacs, et. al. (see AUTHORS)
All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

conky.config = {
    alignment = 'top_right',
    background = true, -- To start conky with xfce
    border_width = 1,
    cpu_avg_samples = 2,
	default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    draw_borders = true,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    use_xft = true,
    font = 'Droid Sans Mono:size=8',
    gap_x = 5,
    gap_y = 5,
    minimum_height = 5,
	minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_stderr = false,
    extra_newline = false,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'override',
		own_window_transparent = true,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    show_graph_scale = false,
    show_graph_range = false,
    double_buffer = true
}

conky.text = [[
${alignc}${color yellow}$nodename - $sysname $kernel
$color$hr
${color yellow}Uptime:$color $uptime
$color$hr
${alignc}${color yellow}RAM
Used $color$mem ${color yellow}of $color$memmax ${color yellow}($color$memfree ${color yellow}free)
 $color${membar 6,335} ${alignr}$memperc%
 ${memgraph 30}
$color$hr
${alignc}${color yellow}CPU
${color yellow}Name: $color${execi 1000 cat /proc/cpuinfo | grep "model 
name" | sed -e 's/model name.*: //' | uniq}
${color yellow}Frequency: $color$freq MHz
${color yellow}Core 1 $color- ${cpu cpu1}% -               ${color yellow}Core 2 $color- ${cpu cpu2}%
 $color${cpubar cpu1 5,175} ${alignr}${cpubar cpu2 5,175}
 $color${cpugraph cpu1 30,175} ${alignr}${cpugraph cpu2 30,175}
${color yellow}Core 3 $color- ${cpu cpu3}%                 ${color yellow}Core 4 $color- ${cpu cpu4}%
 $color${cpubar cpu3 5,175} ${alignr}${cpubar cpu4 5,175}
 $color${cpugraph cpu3 30,175} ${alignr}${cpugraph cpu4 30,175}
$hr
${alignc}${color yellow}File systems
 / -> Used $color${fs_used /}${color yellow} of $color${fs_size /} ${color yellow}($color${fs_free 
/}${color yellow} free) 
 $color${fs_bar 5,335 /}${alignr}${fs_used_perc /}%${color yellow}
 /boot -> Used $color${fs_used /boot}${color yellow} of $color${fs_size /boot} ${color 
yellow}($color${fs_free /boot}${color yellow} free) 
 $color${fs_bar 5,335 /boot}${alignr}${fs_used_perc /boot}%${color yellow}
 /home -> Used $color${fs_used /home}${color yellow} of $color${fs_size /home} ${color 
yellow}($color${fs_free /home}${color yellow} free) 
 $color${fs_bar 5,335 /home}${alignr}${fs_used_perc /home}%
$hr
${alignc}${color yellow}Networking
 Downspeed: $color${downspeedf enp5s0} KiB/s      ${color yellow}Upspeed: $color${upspeedf 
enp5s0} KiB/s
 ${downspeedgraph enp5s0 30,175} ${alignr}${upspeedgraph enp5s0 30,175}${color yellow} 
 Downloaded: $color${totaldown enp5s0}        ${color yellow}Uploaded: $color${totalup 
enp5s0} 
$hr
${color yellow}${alignc}Processes (CPU)
${color}Name              PID    CPU    MEM $color 
${color red}${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1} 
${color orange}${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2} 
${color green}${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3} 
${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4} 
${top name 5} ${top pid 5} ${top cpu 5} ${top mem 5} 
${top name 6} ${top pid 6} ${top cpu 6} ${top mem 6} 
${top name 7} ${top pid 7} ${top cpu 7} ${top mem 7} 
${top name 8} ${top pid 8} ${top cpu 8} ${top mem 8} 
${top name 9} ${top pid 9} ${top cpu 9} ${top mem 9} 
${top name 10} ${top pid 10} ${top cpu 10} ${top mem 10}
$color$hr
${color yellow}${alignc}Processes (MEM)
${color}Name              PID    CPU    MEM $color
${color red}${top_mem name 1} ${top_mem pid 1} ${top_mem cpu 1} ${top_mem mem 1}
${color orange}${top_mem name 2} ${top_mem pid 2} ${top_mem cpu 2} ${top_mem mem 2}
${color green}${top_mem name 3} ${top_mem pid 3} ${top_mem cpu 3} ${top_mem mem 3}
${top_mem name 4} ${top_mem pid 4} ${top_mem cpu 4} ${top_mem mem 4}  
${top_mem name 5} ${top_mem pid 5} ${top_mem cpu 5} ${top_mem mem 5}  
${top_mem name 6} ${top_mem pid 6} ${top_mem cpu 6} ${top_mem mem 6}
${top_mem name 7} ${top_mem pid 7} ${top_mem cpu 7} ${top_mem mem 7}
${top_mem name 8} ${top_mem pid 8} ${top_mem cpu 8} ${top_mem mem 8}
${top_mem name 9} ${top_mem pid 9} ${top_mem cpu 9} ${top_mem mem 9}
${top_mem name 10} ${top_mem pid 10} ${top_mem cpu 10} ${top_mem mem 10}
$color$hr
]]