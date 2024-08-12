list_games			= ["Duel Grid"];
rm_this_game		= [rm_menu_dg]
_array_leng			= array_length(list_games);

sel_menu			= 0;



controll_menu		= function()
{
	var _up, _down, _confirm;
	_up					= keyboard_check_pressed(vk_up);
	_down				= keyboard_check_pressed(vk_down);
	_confirm			= keyboard_check_pressed(vk_enter)
	
	if(_up or _down) 
	{
		sel_menu += _down - _up; // MOVENDO SELEÇÃO PARA CIMA PI BAIXO
		sel_menu = clamp(sel_menu, 0, _array_leng-1) // limitando o valor para n ultrapassar o valor máximo ou mínimo no menu
		
	}
	if(_confirm)
	{
		room_goto(rm_this_game[sel_menu]);		
	}
}	



draw_games_active	= function()
{
	draw_set_font(fnt_menu)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	var _pos_x			= display_get_width()/2;
	var _pos_y			= display_get_height()/2;
	var _color			= c_white;
	var _mouse_pos_x		= device_mouse_x_to_gui(0)
	var _mouse_pos_y		= device_mouse_y_to_gui(0)
	var _confirm			= mouse_check_button_pressed(mb_left);
	

	for(var i = 0; i < _array_leng; i ++)
	{
		var _altu_text		= string_height("I")
		var _multply_pos	= i * _altu_text + 5
		var _larg_text		= string_width(list_games[i])
		var mouse_in_gui	= point_in_rectangle(_mouse_pos_x, _mouse_pos_y, _pos_x - _larg_text/2, _pos_y - (_altu_text/2) + _multply_pos, _pos_x + _larg_text/2, _pos_y + (_altu_text/2) + _multply_pos)
		
		if(mouse_in_gui)
		{
			sel_menu = i;
		
			if(_confirm)
			{
				room_goto(rm_this_game[i]);
			}
			
		}
		if(sel_menu == i) _color = c_red;
		else _color = c_white;
		
		
		draw_set_color(_color)
		draw_text(_pos_x, _pos_y + _multply_pos, list_games[i])	
	}
	draw_set_halign(-1)
	draw_set_valign(-1)
}