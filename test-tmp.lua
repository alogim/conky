--this is a lua script for use in conky
require 'cairo'

function conky_main()
  if conky_window == nil then
    return
  end
  local cs = cairo_xlib_surface_create(conky_window.display,
                                       conky_window.drawable,
                                       conky_window.visual,
                                       conky_window.width,
                                       conky_window.height)
  cr = cairo_create(cs)

  function compute_colours(percentage)
		if tonumber(percentage) <= 50 then
			red = percentage * 5.12 
			green = 255
		else
			red = 255
			green = (100 - percentage) * 5.12
		end
		
		red = red / 255
		green = green / 255
		blue = 0
		return red, green, blue
	end
  
	--SETTINGS
	--rings size
	cpu_ring_center_x = 200
	cpu_ring_center_y = 200
	cpu_ring_radius = 20
	cpu_ring_width = 5
	
	cpu_1_ring_center_x = 200
	cpu_1_ring_center_y = 200
	cpu_1_ring_radius = 26
	cpu_1_ring_width = 5
	
	cpu_2_ring_center_x = 200
	cpu_2_ring_center_y = 200
	cpu_2_ring_radius = 32
	cpu_2_ring_width = 5
	
	cpu_3_ring_center_x = 200
	cpu_3_ring_center_y = 200
	cpu_3_ring_radius = 38
	cpu_3_ring_width = 5
	
	cpu_4_ring_center_x = 200
	cpu_4_ring_center_y = 200
	cpu_4_ring_radius = 44
	cpu_4_ring_width = 5

	--indicator value settings
	cpu_usage_perc = conky_parse("${cpu cpu0}")
	cpu_1_usage_perc = conky_parse("${cpu cpu1}")
	cpu_2_usage_perc = conky_parse("${cpu cpu2}")
	cpu_3_usage_perc = conky_parse("${cpu cpu3}")
	cpu_4_usage_perc = conky_parse("${cpu cpu4}")

	max_value = 100
	
	cairo_set_line_width(cr, cpu_ring_width)
	end_angle = cpu_usage_perc * (360 / max_value)

	r, g, b = compute_colours(cpu_usage_perc)
	cairo_set_source_rgba(cr, r, g, b, 1)
	cairo_arc(cr, 
						cpu_ring_center_x, 
						cpu_ring_center_y,
						cpu_ring_radius,
						(-90) * (math.pi / 180),
						(end_angle - 90) * (math.pi / 180))
	cairo_stroke(cr)
	
	cairo_set_line_width(cr, cpu_1_ring_width)
	end_angle_1 = cpu_1_usage_perc * (360 / max_value)

	r1, g1, b1 = compute_colours(cpu_1_usage_perc)
	cairo_set_source_rgba(cr, r1, g1, b1, 1)
	cairo_arc(cr,
						cpu_1_ring_center_x,
						cpu_1_ring_center_y,
						cpu_1_ring_radius,
						(-90) * (math.pi / 180),
						(end_angle_1 - 90) * (math.pi / 180))
	cairo_stroke(cr)
	
	cairo_set_line_width(cr, cpu_2_ring_width)
	end_angle_2 = cpu_2_usage_perc * (360 / max_value)
	
	r2, g2, b2 = compute_colours(cpu_2_usage_perc)
	cairo_set_source_rgba(cr, r2, g2, b2, 1)
	cairo_arc(cr,
						cpu_2_ring_center_x,
						cpu_2_ring_center_y,
						cpu_2_ring_radius,
						(-90) * (math.pi / 180),
						(end_angle_2 - 90) * (math.pi / 180))
	cairo_stroke(cr)
	
	cairo_set_line_width(cr, cpu_3_ring_width)
	end_angle_3 = cpu_3_usage_perc * (360 / max_value)
	
	r3, g3, b3 = compute_colours(cpu_3_usage_perc)
	cairo_set_source_rgba(cr, r3, g3, b3, 1)
	cairo_arc(cr,
						cpu_3_ring_center_x,
						cpu_3_ring_center_y,
						cpu_3_ring_radius,
						(-90) * (math.pi / 180),
						(end_angle_3 - 90) * (math.pi / 180))
	cairo_stroke (cr)
	
	cairo_set_line_width(cr, cpu_4_ring_width)
	end_angle_4 = cpu_4_usage_perc * (360 / max_value)
	
	r4, g4, b4 = compute_colours(cpu_4_usage_perc)
	cairo_set_source_rgba(cr, r4, g4, b4, 1)
	cairo_arc(cr,
						cpu_4_ring_center_x,
						cpu_4_ring_center_y,
						cpu_4_ring_radius,
						(-90) * (math.pi / 180),
						(end_angle_4 - 90) * (math.pi / 180))
	cairo_stroke(cr)
	
	-- RAM
	xpos = 187
	ypos = 205
	text = cpu_usage_perc .. "%"
	cairo_move_to(cr, xpos, ypos)
	cairo_show_text(cr, text)

  cairo_destroy(cr)
  cairo_surface_destroy(cs)
  cr = nil
end
