require 'cairo'

function conky_main()
  if conky_window==nil then 
		return 
	end
	
  local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, 
																		 conky_window.visual, conky_window.width, conky_window.height)
  local cr=cairo_create(cs)    
  
  local updates=conky_parse('${updates}')
  update_num=tonumber(updates)
	
	local cores_number = get_value("cat /proc/cpuinfo | grep processor | wc -l")
	if update_num==4 then
		cpu_table = {}
		core_table = {{}}
		for i=1,cores_number do
			core_table[i] = {}
		end
		ram_table = {}
		upspeed_table = {}
		downspeed_table = {}
	end
	
	if update_num>5 then
		local x=50
		local y=50
		local width=5
		local radius=30
		local cpu_usage = tonumber(conky_parse("${cpu cpu0}"))
		local cpu_temperature = get_value("cat /sys/class/hwmon/hwmon1/temp1_input") / 1000
		
		-- CPU
		draw_ring(cr, x, y, radius, width, 0, 100, cpu_usage, 90, 270)
		draw_text(cr, x, y, cpu_usage .. "%", 12, 'centred')
 		set_colour(cr, 1, 1, 1, 1)
 		draw_text(cr, x + 40, y - 20, "Temperature:", 12, 'left')
    draw_text(cr, x + 160, y - 20, cpu_temperature .. " °C", 12, 'right')
 		draw_graph(cr, cpu_table, 75, cpu_usage, 100, x + 10, y + 40, 2, 30)
	  set_colour(cr, 1, 1, 0.5, 1)
    draw_text(cr, 0, y - 35, "CPU", 12, 'left')
		
		-- Cores
		for i=1,cores_number do
			y = y + 80
			local core_usage = tonumber(conky_parse("${cpu cpu" .. i .. "}"))
			local core_temperature = get_value("cat /sys/class/hwmon/hwmon1/temp" .. i .. "_input") / 1000
			draw_ring(cr, x, y, radius, width, 0, 100, core_usage, 90, 270)
			draw_text(cr, x, y, core_usage .. "%", 12, 'centred')
			set_colour(cr, 1, 1, 1, 1)
			draw_text(cr, x + 40, y - 20, "Temperature: " .. core_temperature .. " °C", 12, 'left')
			draw_graph(cr, core_table[i], 75, core_usage, 100, x + 10, y + 40, 2, 30)
			draw_text(cr, 0, y - 35, "Core " .. i, 12, 'left')
		end
		
		-- RAM
		y = y + 90
		local ram_total_amount = get_value("free --mebi | awk 'FNR==2 {print $2}'")
		local ram_used_amount = get_value("free --mebi | awk 'FNR==2 {print $3}'")
		local ram_usage_perc = tonumber(string.format("%.1f", ram_used_amount  * 100 / ram_total_amount))

		draw_ring(cr, x, y, radius, width, 0, 100, ram_usage_perc, 90, 270)
		draw_text(cr, x, y, ram_usage_perc .. "%", 12, 'centred')
 		set_colour(cr, 1, 1, 1, 1)
 		draw_text(cr, x + 40, y - 20, "Usage: " .. ram_used_amount .. " MiB / " .. ram_total_amount .. " MiB", 12, 'left')
 		draw_graph(cr, ram_table, 75, ram_usage_perc, 100, x + 10, y + 40, 2, 30)
		draw_text(cr, 0, y - 35, "RAM", 12, 'left')
		
		-- Net
		y = y + 90
		local upspeed = conky_parse("${upspeedf enp5s0}")
		local downspeed = conky_parse("${downspeedf enp5s0}")
		local uploaded = conky_parse("${totalup enp5s0}")
		local downloaded = conky_parse("${totaldown enp5s0}")
		
		draw_graph(cr, upspeed_table, 75, upspeed, 100.0, x - 10, y, 2, 30)
		draw_text(cr, x - 10, y + 15, "Upspeed:", 12, 'left')
		draw_text(cr, x + 140, y + 15, upspeed .. " KiB/s", 12, 'right')
		draw_text(cr, x - 10, y + 30, "Uploaded:", 12, 'left')
		draw_text(cr, x + 140, y + 30, uploaded, 12, 'right')

		draw_graph(cr, downspeed_table, 75, downspeed, 1800.0, x + 160, y, 2, 30)
		draw_text(cr, x + 160, y + 15, "Downspeed:", 12, 'left')
		draw_text(cr, x + 310, y + 15, downspeed .. " KiB/s", 12, 'right')
		draw_text(cr, x + 160, y + 30, "Downloaded:", 12, 'left')
		draw_text(cr, x + 310, y + 30, downloaded, 12, 'right')
		draw_text(cr, 0, y - 35, "NET", 12, 'left')
		
		-- DISK
		y = y + 90
		local boot_used = string.format("%.0f", get_value("df | grep /dev/sda1 | awk '{print $3}'") / 1024)
 		local boot_total = string.format("%.0f", get_value("df | grep /dev/sda1 | awk '{print $2}'") / 1024)
		local boot_perc = string.format("%.1f", boot_used * 100 / boot_total)
 		local home_used = string.format("%.0f", get_value("df | grep /dev/sda3 | awk '{print $3}'") /1024)
 		local home_total = string.format("%.0f", get_value("df | grep /dev/sda3 | awk '{print $2}'") /1024)
		local home_perc = string.format("%.1f", home_used * 100 / home_total) 		
		local root_used = string.format("%.0f", get_value("df | grep /dev/sda2 | awk '{print $3}'") / 1024)
 		local root_total = string.format("%.0f", get_value("df | grep /dev/sda2 | awk '{print $2}'") / 1024)
		local root_perc = string.format("%.1f", root_used * 100 / root_total)
		
 		draw_text(cr, x - 10, y + 15, "/boot", 12, 'left')
		draw_text(cr, x + 100, y + 15, boot_used .. " MiB", 12, 'right')
		draw_text(cr, x + 110, y + 15, "/", 12, 'left')
		draw_text(cr, x + 190, y + 15, boot_total .. " MiB", 12, 'right')
		draw_text(cr, x + 240, y + 15, "(" .. boot_perc .. "%)", 12, 'right')
 		draw_text(cr, x - 10, y + 30, "/home", 12, 'left')
 		draw_text(cr, x + 100, y + 30, home_used .. " MiB", 12, 'right')
		draw_text(cr, x + 110, y + 30, "/", 12, 'left')
		draw_text(cr, x + 190, y + 30, home_total .. " MiB", 12, 'right')
		draw_text(cr, x + 240, y + 30, "(" .. home_perc .. "%)", 12, 'right')
 		draw_text(cr, x - 10, y + 45, "/", 12, 'left')
 		draw_text(cr, x + 100, y + 45, root_used .. " MiB", 12, 'right')
		draw_text(cr, x + 110, y + 45, "/", 12, 'left')
		draw_text(cr, x + 190, y + 45, root_total .. " MiB", 12, 'right')
		draw_text(cr, x + 240, y + 45, "(" .. root_perc .. "%)", 12, 'right')
 		


-- 		draw_graph(cr, downspeed_table, 75, downspeed, 1800.0, x + 160, y, 2, 30)
-- 		draw_text(cr, x + 160, y + 15, "Downspeed:", 12, 'left')
-- 		draw_text(cr, x + 310, y + 15, downspeed .. "KiB/s", 12, 'right')
-- 		draw_text(cr, x + 160, y + 30, "Downloaded:", 12, 'left')
-- 		draw_text(cr, x + 310, y + 30, downloaded, 12, 'right')
 		draw_text(cr, 0, y - 35, "DISCS", 12, 'left')


		
  end
end

function get_value(command_string)
	local handle = io.popen(command_string)
	local value = tonumber(handle:read("*a"))
	handle:close()
	return value
end

function compute_colours(percentage)
	local red, green, blue, alpha
	if tonumber(percentage) <= 50 then
		red = percentage * 5.1 
		green = 255
	else
		red = 255
		green = (100 - percentage) * 5.1
	end
	
	red = red / 255
	green = green / 255
	blue = 0
	alpha = 1
	return red, green, blue, alpha
end

function draw_ring(cr, x, y, radius, width, 
									 min_value, max_value, cur_value, 
									 starting_angle, ending_angle)
	cairo_set_line_width(cr, width)
	set_colour(cr, 0.5, 0.5, 0.5, 0.5)
	cairo_arc(cr, x, y, radius,
 						starting_angle * math.pi / 180,
 						(starting_angle + ending_angle) * math.pi / 180)
	cairo_stroke(cr)

  if cur_value < min_value then
    cur_value = min_value
  end

	local end_angle = (cur_value - min_value) * ending_angle / (max_value - min_value)
	set_colour(cr, compute_colours((cur_value - min_value) * 100 / (max_value - min_value)))
	cairo_set_line_width(cr, width)
	cairo_arc(cr, x, y, radius, 
						starting_angle * math.pi / 180, 
						(starting_angle + end_angle) * math.pi / 180)
	cairo_stroke(cr)
end

function set_colour(cr, red, green, blue, alpha)
  cairo_set_source_rgba(cr, red, green, blue, alpha)
end

function draw_text(cr, x, y, text, font_size, layout)
	local extents = cairo_text_extents_t:create()
	tolua.takeownership(extents)
	
	cairo_select_font_face(cr, "Ubuntu", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
 	cairo_set_font_size(cr, font_size)
 	cairo_text_extents(cr, text, extents)
	
	local x_text=x
	local y_text=y
	if layout=='centred' then
		x_text = x - (extents.width / 2 + extents.x_bearing)
		y_text = y - (extents.height / 2 + extents.y_bearing)
	elseif layout=='left' then
		x_text = x
		y_text = y
	elseif layout=='right' then
	  x_text = x - (extents.width + extents.x_bearing)
		y_text = y
	end
	 	
	cairo_move_to (cr, x_text, y_text)
 	cairo_show_text (cr, text)
	cairo_stroke(cr)
end

function draw_graph(cr, data, table_length, value, 
										max_value, x, y, width, height)
	setup_table(data, table_length, value)
	cairo_set_line_width(cr, width)
  for i=1,table_length do
    bar_height = (height / max_value) * data[i]
    cairo_move_to(cr, x + (width / 2) + ((i - 1) * width), y)
    cairo_rel_line_to(cr, 0, bar_height * -1)
    cairo_stroke (cr)
  end    
end

function setup_table(table, table_length, value) 
	for i=1,tonumber(table_length) do
 		if table[i+1]==nil then
 			table[i+1]=0 
 		end
 		table[i]=table[i+1]
 		if i==table_length then
 			table[table_length] = value
 		end
	end
end











-- require 'cairo'
--
-- function conky_get_core_percentage()
--   return conky_parse("${cpu cpu0}")
-- end
--
-- function conky_main()
--   if conky_window == nil then
--     return
--   end
--   local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
--   cr = cairo_create(cs)
--  
--   	--SETTINGS
-- 	local cpu_ring_center_x = 50
-- 	local cpu_ring_center_y = 50
-- 	local cpu_ring_radius = 30
-- 	local cpu_ring_width = 5
-- 	local cores_number = get_cores_number()
-- 	local cpu_usage_percentage
-- 	local font_size = 13
-- 	local cpu_min_temperature = get_min_cpu_temperature()
--   local cpu_max_temperature = get_max_cpu_temperature()
--   local cpu_core_cur_temperature
--   local total_ram = get_total_ram()
--
--   -- Draw cpu total usage in percentage
-- 	--draw_ring(cpu_ring_center_x, cpu_ring_center_y, cpu_ring_radius, cpu_ring_width, 
--   --          0, 100, cpu_usage_percentage)
-- 	--draw_ring_text(cpu_ring_center_x, cpu_ring_center_y, cpu_usage_percentage .. "%", font_size)
--
--   for i=1,cores_number do
--     -- Core usage percentage ring
--     cpu_usage_percentage = tonumber(conky_parse("${cpu cpu" .. i .. "}"))
--     draw_ring(cpu_ring_center_x, cpu_ring_center_y, cpu_ring_radius, cpu_ring_width, 0, 100, cpu_usage_percentage)
--     draw_ring_text(cpu_ring_center_x, cpu_ring_center_y, cpu_usage_percentage .. "%", font_size)
--     draw_ring_text(cpu_ring_center_x + cpu_ring_radius / 2 - 7, cpu_ring_center_y + cpu_ring_radius - 7 , "Core " .. i, font_size)
--     -- Core temperature
--     cpu_core_cur_temperature = get_cur_cpu_core_temperature(i+1)
--     draw_ring(cpu_ring_center_x + 100, cpu_ring_center_y, cpu_ring_radius, cpu_ring_width, cpu_min_temperature, cpu_max_temperature, cpu_core_cur_temperature)
--     draw_ring_text(cpu_ring_center_x + 100, cpu_ring_center_y, cpu_core_cur_temperature .. " °C", font_size)
--     draw_ring_text(cpu_ring_center_x + 100 + cpu_ring_radius, cpu_ring_center_y + cpu_ring_radius - 7, "Temperature", font_size)
--     cpu_ring_center_y = cpu_ring_center_y + 80
--   end
--
--   -- RAM
--   local min_ram = 0
--   local conky_max_ram = get_total_ram()
--   local cur_ram = get_available_ram()
--
--   draw_ring(cpu_ring_center_x, cpu_ring_center_y, cpu_ring_radius, cpu_ring_width, min_ram, max_ram, max_ram - cur_ram)
--   draw_ring_text(cpu_ring_center_x, cpu_ring_center_y, max_ram - cur_ram, font_size)
--   draw_ring_text(cpu_ring_center_x + cpu_ring_radius / 2 - 5, cpu_ring_center_y + cpu_ring_radius - 8, "RAM", font_size)
--
--   -- GRAPHICS CARD
-- 	local vga_min_temperature = get_min_vga_temperature()
--   local vga_max_temperature = get_max_vga_temperature()
--   local vga_cur_temperature = get_cur_vga_temperature()
-- 	draw_ring(cpu_ring_center_x, cpu_ring_center_y + 80, cpu_ring_radius, cpu_ring_width, vga_min_temperature, vga_max_temperature, vga_cur_temperature)
--   draw_ring_text(cpu_ring_center_x, cpu_ring_center_y + 80, vga_cur_temperature .. " °C", font_size)
-- 	draw_ring_text(cpu_ring_center_x + 10, cpu_ring_center_y + 80 + cpu_ring_radius - 7, "VGA", font_size)
--   cpu_ring_center_y = cpu_ring_center_y + 80
-- 	
-- 	-- NETWORK
--   local download_speed = get_download_speed()
--   local total_down = get_total_down()
--   local upload_speed = get_upload_speed()
--   local total_up = get_total_up()
--   set_colour(1.0, 0.5, 0.0, 1.0)
--   draw_ring_text(cpu_ring_center_x + 60, cpu_ring_center_y + 80, "DOWNLOAD", 13)
--   draw_ring_text(cpu_ring_center_x, cpu_ring_center_y + 103, "Current speed", 13)
--   draw_ring_text(cpu_ring_center_x, cpu_ring_center_y + 116, download_speed .. " KiB/s", 13)
--   draw_ring_text(cpu_ring_center_x + 120, cpu_ring_center_y + 103, "Total downloaded", 13)
--   draw_ring_text(cpu_ring_center_x + 120, cpu_ring_center_y + 116, total_down, 13)
--
--   draw_ring_text(cpu_ring_center_x + 60, cpu_ring_center_y + 140, "UPLOAD", 13)
--   draw_ring_text(cpu_ring_center_x, cpu_ring_center_y + 163, "Current speed", 13)
--   draw_ring_text(cpu_ring_center_x, cpu_ring_center_y + 176, upload_speed .. " KiB/s", 13)
--   draw_ring_text(cpu_ring_center_x + 120, cpu_ring_center_y + 163, "Total uploaded", 13)
--   draw_ring_text(cpu_ring_center_x + 120, cpu_ring_center_y + 176, total_up, 13)
--
--   cairo_destroy(cr)
--   cairo_surface_destroy(cs)
--   cr = nil
-- end
--
-- function get_cores_number()
-- 	local handle = io.popen("cat /proc/cpuinfo | grep processor | wc -l")
-- 	local core_number = tonumber(handle:read("*a"))
-- 	handle:close()
-- 	return core_number
-- end
--
-- function get_min_cpu_frequency()
-- 	local handle = io.popen("cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq")
-- 	local min_frequency = tonumber(handle:read("*a"))
-- 	handle:close()
-- 	return min_frequency
-- end
--
-- function get_max_cpu_frequency()
-- 	local handle = io.popen("cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq")
-- 	local max_frequency = tonumber(handle:read("*a"))
-- 	handle:close()
-- 	return max_frequency
-- end
--
-- function get_total_ram()
--   return tonumber(conky_parse("${mem}"))
-- end
--
-- function get_cur_cpu_core_frequency(core_number)
--  	local handle = io.popen("cat /sys/devices/system/cpu/cpu" .. core_number .. "/cpufreq/cpuinfo_cur_freq")
--  	local cur_frequency = tonumber(handle:read("*a"))
--  	handle:close()
--  	return cur_frequency
-- end
--
-- function get_max_cpu_temperature()
--   local handle = io.popen("cat /sys/class/hwmon/hwmon1/temp1_max")
--   local core_temperature = tonumber(handle:read("*a"))
--   handle:close()
--   return core_temperature / 1000
-- end
--
-- function get_min_cpu_temperature()
--   local handle = io.popen("cat /sys/class/hwmon/hwmon1/temp1_crit_alarm")
--   local core_temperature = tonumber(handle:read("*a"))
--   handle:close()
--   return core_temperature / 1000
-- end
--
-- function get_cur_cpu_core_temperature(core_number)
--   local handle = io.popen("cat /sys/class/hwmon/hwmon1/temp" .. core_number .. "_input")
-- 	local core_temperature = tonumber(handle:read("*a"))
-- 	handle:close()
-- 	return core_temperature / 1000
-- end
--
-- function get_total_ram()
--   local handle = io.popen("awk '/MemTotal/ {print $2}' /proc/meminfo")
--   local total_ram = tonumber(handle:read("*a"))
--   handle:close()
--   return total_ram
-- end
--
-- function get_available_ram()
--   local handle = io.popen("awk '/MemAvailable/ {print $2}' /proc/meminfo")
--   local available_ram = tonumber(handle:read("*a"))
--   handle:close()
--   return available_ram
-- end
--
-- function get_min_vga_temperature()
-- 	return 0
-- end
--
-- function get_cur_vga_temperature()
--   local handle = io.popen("cat /sys/class/hwmon/hwmon0/temp1_input")
-- 	local vga_temperature = tonumber(handle:read("*a"))
-- 	handle:close()
-- 	return vga_temperature / 1000
-- end
--
-- function get_max_vga_temperature()
--   local handle = io.popen("cat /sys/class/hwmon/hwmon0/temp1_crit")
-- 	local vga_temperature = tonumber(handle:read("*a"))
-- 	handle:close()
-- 	return vga_temperature / 1000
-- end
--
-- function get_download_speed()
--   return tonumber(conky_parse("${downspeedf enp5s0}"))
-- end
--
-- function get_total_down()
--   return conky_parse("${totaldown enp5s0}")
-- end
--
-- function get_upload_speed()
--   return tonumber(conky_parse("${upspeedf enp5s0}"))
-- end
--
-- function get_total_up()
--   return conky_parse("${totalup enp5s0}")
-- end
